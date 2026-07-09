---
title: This blog is proudly powered by Gatsby (with some super powers)
date: '2019-09-25'
excerpt: >-
  This blog has been using Gastby for a year now. Before that I used a home-made
  tool I was proud of, but it was very minimalistic. Switching to Gastby was a
  very interesting thing to do, it’s a fantastic tool, but let’s be honest, it’s
  quite hard to use. I made a lot of improvements on the codebase of this blog
  these past few days, here is a small feedback.
cover: /assets/posts/this-blog-is-proudly-powered-by-gatsby/cover.webp
lang: en
tags:
  - dev
---

This blog has been using [Gastby](https://www.gatsbyjs.org/) for a year now.
Before that I used a [home-made tool](/assets/posts/2016-10-27-first-post/) I was proud
of, but it was very minimalistic. Switching to Gastby was a very interesting
thing to do, it's a fantastic tool, but let's be honest, it's quite hard to use.
I made a lot of improvements on the codebase of this blog these past few days,
here is a small feedback.

<div markdown="1" style="margin: 2rem auto; max-width: 20rem">

![Gatsby logo](/assets/posts/this-blog-is-proudly-powered-by-gatsby/Gatsby_Logo.svg)

</div>

## What is Gatsby anyway?

Gatsby defines itself as a “framework based on React that helps developers build
blazing fast websites and apps”. Said differently, it's a static website
generator. This means you create your content, run a command, and the tool
bundles everything to create a series of file you just have to deploy on any
static web host. The result is a very fast Progressive Web App (PWA) that can be
used without JavaScript.

With Gatsby you use React to build your pages and layouts. You design your
website as you want, create as many components as you want. You basically start
from scratch. Unless you prefer using one of the
[many available starters](https://www.gatsbyjs.org/starters/?v=2) of course. I
prefered not using one, I think it's a better way to understand how Gatsby
works.

## Why Gatsby for a blog?

Using Gatsby for a blog can seem a little overkill.
[Jekyll](https://jekyllrb.com/) looks a lot easier to use and could fulfill all
of the needs you have for a simple blog. But using React gives a lot of
flexibility for the design. Plus I love React, obviously 😁

Of course the most important is that you don't have to write your posts using
React. Same as with other blog systems, you can write them using Markdown. You
can even use a CMS or any other remote service to fetch your posts, but I'm very
happy to write my posts in simple Markdown files, and commit and push them to
make them public.

One other thing that is great is that there exist a lot of plugins for Gatsby,
and some are very relevant for a blog. Here are some I use on this blog:

- [gatsby-plugin-feed](https://www.gatsbyjs.org/packages/gatsby-plugin-feed/) to
  add a RSS feed,
- [gatsby-plugin-manifest](https://www.gatsbyjs.org/packages/gatsby-plugin-manifest/)
  to configure a manifest file,
- [gatsby-plugin-offline](https://www.gatsbyjs.org/packages/gatsby-plugin-offline/)
  to make your blog available offline thanks to service workers,
- [gatsby-plugin-sitemap](https://www.gatsbyjs.org/packages/gatsby-plugin-sitemap/)
  to generate a sitemap for better SEO.

All of these plugins require no configuration (or very little for manifest),
they just work as is.

## Level up using TypeScript

[Gatsby uses GraphQL](https://www.gatsbyjs.org/docs/graphql-concepts/) to fetch
data from the sources you configured (Markdown, CMS, etc.). This is great
because it means you can write queries to fetch exactly the data you want,
neither more nor less. But it also means that you'll have several objects of
different types to deal with: posts, pages, metadata, etc. A type system will
make everything a lot easier, and good news: Gatsby works very well with
[TypeScript](https://www.typescriptlang.org/), thanks to
[gatsby-plugin-typescript](https://www.gatsbyjs.org/packages/gatsby-plugin-typescript/).

Even better: since queries are made with GraphQL, I was able to use
[Apollo Client](https://www.apollographql.com/docs/react/) to
[generate the type definitions](https://github.com/apollographql/apollo-tooling#apollo-clientcodegen-output)
corresponding to you queries! No need to define the types by hand anymore. And
now I get autocomplete for my props in my React components. Really makes things
easier.

## Separate content and presentation by creating a theme

This summer, Gatsby announced the ability to
[create themes](https://www.gatsbyjs.org/blog/2019-07-03-announcing-stable-release-gatsby-themes/#reach-skip-nav).
I think in this context you shouldn't understand “theme” as just a way to
customize fonts and colors. Themes are actually a way to reuse the core of a
Gatsby website, i.e. everything but the content (and website-specific settings).
When I heard about Gatsby Themes, I knew that eventually I should rebuild my
blog to split the content from the presentation. And here comes my
[🥔 Potato theme](https://github.com/scastiel/gatsby-theme-potato/tree/master/theme)!
(Why “potato”? Well I wasn't really inspired...)

The idea was not to create a trully-reusable theme, although I would be glad if
somebody else took it to hack and use it. I saw it more as an exercise to get
more familiar with Gatsby, and of course an opportunity to make my code cleaner.
The [source code for my blog](https://github.com/scastiel/new-blog) has gone
much simpler. It now contains:

- the content in _src/content_ (posts in Markdown, pages in React/TypeScript,
  assets);
- the settings in _gatsby-config.js_ (especially the plugins I mentionned
  above);
- some components overrides, to customize the sidebar, the menu items and the
  footer (see
  [customization options](https://github.com/scastiel/gatsby-theme-potato/tree/master/theme#customization)
  for the theme).

I have the feeling that now the architecture of my blog is more than okay. But
still I have some ideas to go further.

## What are the next steps?

The priority when I created the blog was to display everything the way I wanted.
I made a lot of trials ans errors, changed the design a few times, so I have a
small technical debt. But now that I have TypeScript, this debt can be repaid
and I can refactor some of the components. But first, I would like to setup some
regression tests.

Adding tests to a blog? What a weird idea... Well actually when I created the
theme and added TypeScript, I regretted not to have regression tests. If I could
run some end-to-end tests, they could have checked that the links weren't
broken, that the required metadata were there, etc. Instead I had to check
everything by hand, it's not only painful, it also gives a lot a place to
potential errors. And there were a lot.

So before I refactor everything, I would like to discover
[Cypress](https://www.cypress.io/) and add some end-to-end tests for my blog. I
heard a lot of good thing about this tool, and it does seem very appropriate for
my needs. In addition to reassuring me when I refactor my code, it's a good
subject for a future blog post, like “Add end-to-end tests to your Gatsby blog
using Cypress”. It's very likely some other people have this idea before, but
still...

_Cover photo by [Dustin Lee](https://unsplash.com/@dustinlee)._
