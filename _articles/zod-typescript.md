---
title: Using Zod & TypeScript for more than user input validation
date: '2023-03-08'
excerpt: >-
  If you have ever created an API or a form accepting user input, you know what
  data validation is, and how tedious it can be. Fortunately, libraries can help
  us, such as Yup or Zod. But recently, I realized that these libraries allow
  patterns that go much farther than input validation. In this post, I’ll show
  you why I now use them in most of my TypeScript projects.
cover: /assets/posts/zod-typescript/cover.webp
---

If you have ever created an API or a form accepting user input, you know what data validation is, and how tedious it can be. Fortunately, libraries can help us, such as Yup or Zod. But recently, I realized that these libraries allow patterns that go much farther than input validation. In this post, I’ll show you why I now use them in most of my TypeScript projects.

My examples will show how to use [Zod](https://zod.dev/) as it’s the one I prefer, but everything should work the same with Yup or io-ts. Each library has its syntax, advantages and drawbacks, but what matters most here is the patterns. I won’t present Zod in detail, my point is more to give examples of use cases. Plus, [its documentation](https://zod.dev/) is terrific!

## Validating user input

Let’s start with the basics, i.e. what validation libraries are usually used for. If you have an API endpoint accepting a request body (called on a form submission for instance), you know you can’t rely on what is in this body, even if you developed the call to this API.

When you get the body of your request, its type will likely be `unknown` or `any` (depending on the framework you use for your API; I use Next.js). Using a validation *schema*, we can not only validate that the data is conform to this schema, but also get as a result the data typed correctly:

```ts
const inputSchema = z.object({
  name: z.string(),
})

export async function POST(request: Request) {
  const rawInput = await request.json()
  //    ☝️ const rawInput: unknown 🤔
  const input = inputSchema.parse(rawInput)
  //    ☝️ const input: { name: string } 🤩
  return NextResponse.json({ greeting: `Hello ${input.name}!` })
}
```

See how `rawInput` is `unknown` but `input` is of type `{ name: string }`? It turns out they are the exact same variable! Just, `input` has the right type.

If `rawInput` isn’t conform to the validation schema, an error will be raised. In such an example where you perform the validation in an API endpoint, you’ll likely want to return a response with status 422 instead:

```ts
export async function POST(request: Request) {
  const rawInput = await request.json()
  //    ☝️ const rawInput: unknown 🤔
  const result = inputSchema.safeParse(rawInput)
  if (!result.success) {
    return NextResponse.json({ error: 'Invalid input' }, { status: 422 })
  }
  const input = result.data
  //    ☝️ const input: { name: string } 🤩
  return NextResponse.json({ greeting: `Hello ${input.name}!` })
}
```

This first use case probably didn’t surprised you, but I think the two other ones are much more interesting!

## Validating what’s returned by an external API

When you want to call an API written by someone else (a public API for instance), in the best case scenario the API provides a client for your platform, or at least its type (with OpenAPI, GraphQL…). But most of the time, you have nothing but the API documentation.

So you have to rely on what the API is supposed to return. You have to create the right types (unless you want to deal with `any` values everywhere, loosing advantages of TypeScript), and maybe validate by yourself that the data is conform to what you expect.

What if we consider this API call result the same as a user input? It’s data we can’t control directly, but we want to validate it and get the right data types as an output. So let’s use Zod again!

We can create a schema that will contain only the values we need. If for instance we want to call the Reddit API to get the list of posts in a subreddit, we can create this schema that contains for each post its title, score, and creation date. (The full result contains many more attributes.)

```ts
const redditResultSchema = z.object({
  kind: z.literal('Listing'),
  data: z.object({
    children: z.array(
      z.object({
        data: z.object({
          title: z.string(),
          score: z.number(),
          created: z.number().transform((c) => new Date(c * 1000)),
        }),
      })
    ),
  }),
})
```

Notice how we:
- validate the attribute `kind` at the object root, that is supposed to contain `Listing`. This might seem useless, but it lets us check that we get the right kind of response from Reddit;
- apply a transformation to the `created` post attribute. It’s originally a timestamp that we convert to a date. I think it’s best to avoid embedding complex business logic in the schema, but a basic transformation is okay in my humble opinion.

Now, from an `unknown` result returned by `fetch`, we can validate this result and get a correctly typed result:

```ts
async function logRedditPosts() {
  const res = await fetch('https://www.reddit.com/r/nextjs.json')
  const rawResult = await res.json()
  //    ☝️ const rawResult: unknown (or any)
  const result = redditResultSchema.parse(rawResult)
  //    ☝️ const result: { kind: "Listing";
  //                      data: { children: Array<{ data: { ... } }> } 🤩
  for (const child of result.data.children) {
    const { title, score, created } = child.data
    console.log(`[${score}] ${title} (${created.toLocaleDateString()})`)
  }
}
```

*Note: does your `fetch` return `any` instead of `unknown`? That’s because you aren’t using [ts-reset](https://github.com/total-typescript/ts-reset) yet 😉.*

You might be skeptical about the point of validating data from an API call. There is no chance that Reddit API returns data that is not conform to its documentation, right?

That might be true! Yet:
- maybe sometimes it will return unexpected data,
- maybe you made an assumption about the data that is not valid in certain cases,
- even if the data is valid, at least now you have a correctly-typed result!

What’s more important: if for any reason the data is not what you expect, **it will fail immediately**! And you want it to fail as soon as possible, so you can quickly identify the problem. You don’t want it to fail after you processed the data, inserted it in a database, sent emails to clients, etc.

## Validating configuration with environment variables

It is pretty common to use environment variables for configuration. Usually, when working locally you have a `.env` file containing the variables and their values, then in production these variables are set by different means (a UI on your hosting dashboard for instance).

This is what configuration using environment variables might look like:

```sh
# .env
BASE_URL=http://localhost:4000
NUMBER_RETRIES=5
STRIPE_TOKEN=a_very_secret_token
```

Then when you want to use these variables, you can write for instance `process.env.BASE_URL`. The problem is that you don’t know if:
- the variable is defined, and
- if it contains a valid value.

You can validate the values using classic `if` blocks and regular expressions for instance, but it looks like a perfect additional use case for validation using Zod!

The trick consists in creating a file, for instance _config.ts_, that will export an object with all configuration variables. But before returning this object, we’ll use a schema to validate it, and give it the correct type:

```ts
// src/config.ts
import { z } from 'zod'

const configSchema = z.object({
  BASE_URL: z.string().url().default('http://localhost:4000'),
  NUMBER_RETRIES: z
    .string().transform(Number)
    .refine((n) => !Number.isNaN(n)),
  STRIPE_TOKEN: z.string().min(10),
})

const result = configSchema.safeParse(process.env)
if (!result.success) {
  console.error(result.error)
  throw new Error('Invalid configuration')
}

export const config = result.data
```

Again, we want the program to fail as soon as possible if the configuration is incorrect (for instance, if our `STRIPE_TOKEN` is not defined, or if its value is too short).

As expected, when using the exported object `config`, we get the right types for our configuration variables:

```ts
import { config } from './config'

function logConfig() {
  console.log(config)
  //          ☝️ const config: { BASE_URL: string;
  //                            NUMBER_RETRIES: number;
  //                            STRIPE_TOKEN: string } 🤩
}
```

***

These are just examples of use cases for Zod, and without a doubt we’ll find new ones.

Zod adds a nice layer to TypeScript when dealing with data you can’t control. Instead of relying blindly on the data you get hoping for the best, you control it as soon as you can, throw an error if you have to, and get a nicely-typed result otherwise.

If you know other cool use cases, please tell me, and I’ll add them to this post 😊.

_Cover photo by [Giorgio Trovato](https://unsplash.com/@giorgiotrovato)_
