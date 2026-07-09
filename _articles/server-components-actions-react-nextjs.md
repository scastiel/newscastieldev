---
title: Intro to React Server Components and Actions with Next.js
date: '2023-07-03'
excerpt: >-
  React is living something these days. Although it was created as a client UI
  library, it can now be used to generate almost everything from the server. And
  we get a lot from this change, especially when coupled with Next.js. Let’s use
  Server Components and Actions to build something fun: a guestbook.
---

React is living something these days. Although it was created as a client UI library, it can now be used to generate almost everything from the server. And we get a lot from this change, especially when coupled with Next.js.

In this short tutorial, we’ll use **React Server Components** and **Server Actions** to build something from the early '00s: a guestbook!

_I bootstrapped a Next.js app with TypeScript and the app router. As I don’t want to care about the CSS, I used [Water.css](https://watercss.kognise.dev/). And to store the messages, I went with [Vercel KV](https://vercel.com/blog/vercel-storage#vercel-kv-a-durable-redis-database) (which may not be the right tool for this kind of use case, but is plenty enough for the purpose of this post). The complete source code of the demo project is [available on GitHub](https://github.com/scastiel/server-components-actions-demo)._

## Fetching the messages from a Server Component

Let’s start with displaying the existing messages. With a classic React component, we’d have to declare a local state, perform a `fetch` request in a `useEffect`, etc. With Next.js’ server-side rendering, we could declare a `getServerSideProps` function to fetch the messages first.

With server components, we can fetch the messages from the component itself:

```tsx
export async function MessageList() {
  const messages = await fetchMessages()

  return (
    <>
      <h2>Last Messages</h2>
      {messages.map(({ id, name, content, date }) => (
        <blockquote key={id}>
          <div>{content}</div>
          <small>{`–${name}, ${formatDate(date)}`}</small>
        </blockquote>
      ))}
    </>
  )
}
```

Looks odd to you? It should! The component is declared `async`, and fetches data from its body, without any `useEffect`?

This is what server components let us do. As a server component can be rendered only on the server, we can perform asynchronous operations such as querying a database, making HTTP requests, or even read from the filesystem.

As a consequence, notice how the component is easy to read, even by someone who’s not as familiar with React as you are. We fetch the data, and we display it. That’s it.

**What if fetching the messages takes a few seconds?** Does it mean that the page will take that much time to load? Fortunately, no. We can take advantage of React’s `Suspense` to display a nice loading message while the component is still fetching the data.

In the page displaying messages, we can wrap our `MessageList` component with `Suspense`, with a fallback message.

```tsx
export default function MessagesPage() {
  return (
    <>
      {/* ... */}
      <Suspense fallback={<p>Loading messages…</p>}>
        <MessageList />
      </Suspense>
    </>
  )
}
```

For a deeper dive in Server Components and Suspense, have a look at my previous post [Display a view counter on your blog with React Server Components](/view-counter-react-server-components).

So this is how we can read data from a server component, but is there something similar for writing data so we can post new messages as easily?

## Submitting forms with Server Actions

Server components let us fetch data without having to set up a flow with `useEffect`. We can do something similar to submit data from a form, thanks to Server Actions.

Let’s start with this basic form:

```tsx
export function MessageForm() {
  return (
    <form>
      <h2>New Message</h2>

      <label htmlFor="name">Your name:</label>
      <input type="text" id="name" name="name" required minLength={3} />

      <label htmlFor="content">Your message:</label>
      <textarea id="content" name="content" required minLength={3} />

      <button type="submit">Send</button>
    </form>
  )
}
```

As you can see, there is nothing fancy here: two fields, a button, and some validation attributes.

To submit this form, we usually have two options:

- use the `action` attribute to use an API endpoint handling the form data,
- manually make a `fetch` request to call this API endpoint.

In the first scenario, the page would reload when the user submits the form, which is something we may want to avoid. The second scenario is the one we tend to prefer in React apps, but is a bit more complex to set up.

With server actions, we can get the best of both worlds. We can create a function that will be called **on the server** when the form is submitted:

```tsx
async function submitMessageForm(formData: FormData) {
  'use server'

  await postMessage({
    content: formData.get('content'),
    name: formData.get('name'),
  })
}
```

By adding `'use server'` in the function body, we declare it as a **server action**. We can then associate it with the form by using the `action` attribute:

```tsx
return (
  <form action={submitMessageForm}>
```

Note: to use server actions in a Next.js project, you need to enable them in your _next.config.js_ file:

```js
experimental: { serverActions: true },
```

What about form data validation? We declared some validation attributes on the form itself, but as always it doesn’t prevent us of validating the data on the server:

```tsx
// Validation example using a Zod schema
const message = formDataSchema.parse({
  content: formData.get('content'),
  name: formData.get('name'),
})

await postMessage(message)
```

Finally, we can make another nice improvement to our server action. By adding a call to Next.js’ `revalidatePath` function, we can tell the app that some resources need to be reloaded. Said differently, we can **refresh the messages** displayed on the page after we created the new one:

```tsx
await postMessage(message)
revalidatePath('/') // assuming the messages are displayed at root
```

Here is what our form looks like now:

<video controls>
  <source src="/assets/posts/server-components-actions-react-nextjs/guestbook-1.mp4" type="video/mp4" />
</video>

We can see that the message is added to the list without needing to refresh the page. But the form is not reset after being submitted, which can be a little annoying.

Additionally, you probably noticed that the form validation is quite minimalist: we use the HTML validation attributes for the client validation, and a Zod schema for the server one. How nice would it be to use the same validation on both sides?

Good news: it is not because we use server actions that we can’t use cool client features to handle forms. Let’s see how.

## Improving the form with client features

So far, our form doesn’t use any client feature. Actually, it is still a server component (that can be used with JavaScript disabled). To add some cool features to it, let’s start by making it a client component.

This means:

- adding the `'use client'` directive at the top of the file,
- moving the server action to a new _actions.ts_ file, as we can’t declare server actions in client files.

To improve our form, I will use the [react-hook-form](https://react-hook-form.com/) library. Here is how to use it on our form:

```tsx
export function MessageForm() {
  const { register, handleSubmit } = useForm<MessageFormData>({
    shouldUseNativeValidation: true,
    resolver: zodResolver(formDataSchema),
  })

  return (
    <form onSubmit={handleSubmit((data) => submitMessageForm(data))}>
      <h2>New Message</h2>

      <label htmlFor="name">Your name:</label>
      <input type="text" id="name" {...register('name')} />

      <label htmlFor="content">Your message:</label>
      <textarea id="content" {...register('content')} />

      <button type="submit">Send</button>
    </form>
  )
}
```

By using `register` on each field of the form, we let the library handle the form local state and validation. Note that:

- we use the existing Zod schema to define the validation rules (thanks to the [Zod resolver](https://github.com/react-hook-form/resolvers#Zod) for _react-hook-form_),
- by setting `shouldUseNativeValidation: true`, we rely on the browser API to display the validation errors in the form (a feature I love!).

We need to change a bit the server action to comply with the new way data is sent by react-hook-form (a plain object instead of a `FormData` object):

```tsx
export async function submitMessageForm(formData: MessageFormData) {
  formDataSchema.parse(formData)
  await postMessage(formData)
  revalidatePath('/')
}
```

**Important note:** we may think that because we call the function directly from the form, we don’t have to care about validating the form data (the parameter). **We do need to care about it!** Although Next.js handles it for us, there is still an HTTP request made to an API endpoint to call the server action. And it is very easy to make this call manually with invalid data.

This is why we still check that the data is conform with the Zod schema at the top of the function, even if TypeScript lets us think the data is already a `MessageFormData`. But at least, we can use the same validation logic both on the client and the server.

So now we handle the validation a bit better. We can still even improve the form.

First, let’s reset the form after it is submitted. _react-hook-form_ provides a `reset` function that we can call right after calling the server action (which returns a promise):

```tsx
export function MessageForm() {
  const {
    // ...
    reset,
  } = useForm<MessageFormData>(/* ... */)

  return (
    <form
      onSubmit={handleSubmit(async (data) => {
        await submitMessageForm(data)
        reset()
      })}
    >
```

Final improvement: if the submission takes a couple of seconds, it is a good practice to tell the user the form is being submitted, and prevent them from clicking the submit button again. And again, _react-hook-form_ provides the information we need: an `isSubmitting` flag:

```tsx
export function MessageForm() {
  const {
    // ...
    formState: { isSubmitting },
  } = useForm<MessageFormData>(/* ... */)

  return (
    {/* ... */}
      <button type="submit" disabled={isSubmitting}>
        {isSubmitting ? 'Sending…' : 'Send'}
      </button>
    {/* ... */}
  )
}

```

Now, thanks to client features, we handle validation the same way on the client and the server, we tell the user the form is being submitted, and reset the form when it is done. Tiny improvements but great for the user experience, as well as the developer experience.

Here is how our final guestbook looks like:

<video controls>
  <source src="/assets/posts/server-components-actions-react-nextjs/guestbook-2.mp4" type="video/mp4" />
</video>

To be fair, these last improvements we made come with a cost: it isn’t possible anymore to use the form without having JavaScript enabled. I’ll let you decide whether it is worth it or not.

---

So, in the end, what do Server Actions offer us, and how do they compare to Server Components?

- **Server Components** let us **fetch data** without creating an additional endpoint and calling it from the client,
- **Server Actions** let us **post data** without creating an additional endpoint and calling it from the client.

What I love about server component and actions is that they hide some logic, without making anything _magic_, and make the code way easier to understand. To me, they even make it easier to learn React, a point of view I developed in my post [A better learning path for React with server components](/better-learning-path-react).

It’s a bit early to say they will change the way we build web apps on the long term, but I would take that bet!
