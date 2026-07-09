---
title: 'Back to basics with Node.js and Express, the time of a side project'
date: '2020-11-09'
excerpt: >-
  Although I love React and am more used to single-page applications (SPA), I
  decided to leave them aside the time of a side project and to use plain old
  Node.js, Express, Pug, and MongoDB. And that felt good!
cover: /assets/posts/back-to-basics-node-express/cover.jpg
lang: en
tags:
  - dev
---

Although I love React and am more used to single-page applications (SPA), I
decided to leave them aside the time of a side project and to use plain old
Node.js, Express, Pug, and MongoDB. And that felt good!

## But why?

Ok, a little context. I am a front-end developer, and React is my expertise. I
created several SPAs with it in the last years, for work and side projects. I
also worked with Node.js and Express a few years ago, so using them in a project
today might feel like going backward for me.

Yet, I wanted to use Node.js and Express for my project, for one main reason: I
wanted to make a minimum viable product very quickly. And I had the feeling that
bootstrapping a web app with Node.js (including authentication, database access,
etc.) takes way less time than with React. I wasn’t disappointed.

The result: in roughly a weekend of work, I had a first usable version of my
project. A week later, I published it online, posted it on HackerNews, and got a
few thousands of unique visitors. The project? A place to share and discover
side projects: [🤘 My Side Project Rocks](https://mysideproject.rocks).

![My Side Project Rocks!](/assets/posts/back-to-basics-node-express/screenshot1.png)

## Ok for Node, but why not a more modern framework?

First I thought about using [Hapi](https://hapi.dev/) or
[Nest](https://nestjs.com/). Nest seemed a little too “backend” for me
(remember, I’m a front-end developer, so I like light tools, although Nest is
probably a good choice for a robust backend). Hapi seemed very cool, but after
playing a little with it I remembered that my goal was to stay with tools I knew
already. Plus, I wanted to delegate authentication to the great
[Auth0](https://auth0.com/), and they provide a lib for Express, not for Hapi,
which would have meant additional work for me.

## So, Express, and what else?

So yes, my web app is a plain old [**Express**](https://expressjs.com/)
application. I rediscovered how routes are created, how you can create
middlewares to perform some checks or hydrate some data in the request object.
It now feels dirty to me, and not very TypeScript-compliant (so after a short
try, I just decided to keep JavaScript), but very efficient in term of effort
spent.

To store the data, again I didn’t go very far and chose
[**MongoDB**](https://www.mongodb.com/). I created a free account on
[their cloud solution](https://cloud.mongodb.com/), perfect for development and
early-stage projects (and way more convenient than installing a local database).
Now I think maybe a relational database would be more relevant, but for an MVP,
MongoDB does the job.

To generate the HTML content, I used the [**Pug**](https://pugjs.org/) template
engine. I wasn’t used to its weird syntax anymore, but it came back quickly. I
also discovered the [**TailwindCSS**](https://tailwindcss.com/) framework, which
was the only new thing I accepted to learn for this project. I was very
skeptical at first, but wow it is crazy! A small learning curve, but now writing
plain old CSS feels so boring to me!

## And no client-side JavaScript at all?

Almost none! The only JavaScript I have in the client is for basic features for
which reloading the page would make the user experience painful:

- Uploading images: with JavaScript you can have a nice preview instead of the
  ugly default file input.
- Upvoting: you don’t want to leave the page when you upvote a project; it made
  sense to perform an Ajax call.

It goes without saying, these features are quite simple to implement with
vanilla JavaScript, so no React, and not even some transpilation. Just
vanilla-JS.

Also, I used a tool a colleague told me about a few years ago:
[**Turbolinks**](https://github.com/turbolinks/turbolinks). A single script
added to the page, and the browser will switch from a page to another without
reloading the full page. Still seems kind of black magic to me, but it works
very well.

## Any problem with this architecture?

Most of what I wanted to do was easily doable with my Node/Express architecture.
If you look inside, there is nothing very extraordinary, nothing that a
developer who just learned Node wouldn’t be able to achieve.

I had some issues with very basic stuff though, probably because I haven’t built
a non-SPA app in a long time. For instance: how can I display dates on the page
with the user timezone settings? Unless the user signed in and set up his
timezone, I can’t think of any clean way to do so. If you have some idea, please
tell me 😅

## What about the future of your web app?

Clearly, among the choices I made to prototype quickly, some are not the best
choices if I want my app to scale (and it’s okay). For instance, most of the
content doesn’t change often, so it would make sense to serve it from a CDN.
Hosting a Node web app costs a few bucks a month where hosting a React app is
basically free (I mean for a small project of course).

If I had to do it again, I would probably make the same choices. It was very
nice, and I was very efficient, able to focus on the feature, and not the
technical implementation details.

Now, the same web app could have been written with React and a bit of
serverless. This is an architecture I’d like to have more experience in, so
maybe for my next side project 😉
