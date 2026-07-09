---
title: A better learning path for React with server components
date: '2023-05-26'
excerpt: >-
  What if we took advantage of React Server Components not only to improve how
  we use React, but also how we help people learn it from the beginning?
cover: /assets/posts/better-learning-path-react/cover.jpg
---

I’ve always loved sharing my knowledge. When I love a language, library or framework, more than exploring every tiny detail of it, I think about how I can help people learn it and like it as much as I do.

This is why a while ago I wrote a book in French about React, then a course about React hooks, and finally an ebook about Next.js last fall (see the [books](/books) page).

But the world of programming is evolving fast, and the recent new features in React and Next.js shuffle everything. Not in a way that everything you know already is now wrong, but because you can do much more than before, and learn things completely differently.

With the recently-introduced [React Server Components](https://nextjs.org/docs/getting-started/react-essentials) (RSC), it is now possible to create components that will be rendered on the server. My goal here is not to explain how to use them or what new features they bring, but to propose a new way of learning React they enable.

<aside>

PS: I am now offering a workshop called [Learn React the Modern Way](/react-workshop) teaching React the way I propose here. If you prefer, there is also an [online course](https://learn.scastiel.dev) 😉.

</aside>

Here is the way we use to teach/learn React and Next.js:

1. Start with React’s client features to build a Single Page Application: local state, effects…
2. Continue with Next.js to create full-stack apps, with Server-Side Rendering
3. Pursue with React Server Components to add more logic on the backend

This is how most people went from client-only React to RSC, because Next.js was created after React, and RSC only became real a few months ago.

**What if we took advantage of React Server Components not only to improve how we use React, but also how we help people learn it from the beginning?**

Think about it. Why not starting with React Server Components, then moving to client features?

It could look like this:

1. Learn Next.js as a full-stack framework, using React as a rendering engine
2. Discover React’s client features to add interactivity to your pages

In the first part of the journey, you could learn how to create React components on the server, and fetching data directly from inside the component.

```js
export default async PostsPage() {
  const posts = await fetchPosts()

  return (
    <ul>
      {posts.map((post) => (
        <li key={post.id}>{post.title}</li>
      ))}
    </ul>
  )
}
```

If you aren’t used to React Server Components, this piece of code might seem weird. But for someone who doesn’t know React yet, the logic is quite easy to understand. You fetch posts, then you display them.

Using a plain client component, you’d have to create a state with `useState`, then fetch the posts inside a `useEffect`. Explaining everything you need to understand the code would take much longer.

And don’t get me wrong: it’s important to know how to perform a request from a client component. Just, maybe a bit later, when you learn React’s client features. But you can already learn so much without hearing the word “hook”: components, JSX, conditionals & iterations, styling, routing, fetching data…

I understand this path I’m proposing can seem counter-intuitive. And to be honest, it’s still a bit early to know for sure whether it’s better than the _classic_ way. I am glad to see that [I’m not the only one](https://twitter.com/shadcn/status/1660338653305114625) thinking it might be:

[![@shadcn: “An interesting side effect of RSC is that React is now actually easier to teach/learn. If you’ve used React for a while, yes it requires a mental model switch. But for beginners, it makes so much sense: fetch data, render and style it - all in one place. If you need to do something in the browser, "use client". This is what made PHP so great as a first language and I think React is going to be just as easy.”](/assets/posts/better-learning-path-react/tweet_.webp)](https://twitter.com/shadcn/status/1660338653305114625)

I just finished designing a workshop called [Learn React the Modern Way](/react-workshop) to help beginners learn React and Next.js, and will experiment this new path. I strongly believe it will make the learning journey way easier for people who know HTML, CSS and JavaScript.

Can’t wait to keep you posted about how it goes 😊

_Cover photo by [Matt Duncan](https://unsplash.com/@foxxmd)._
