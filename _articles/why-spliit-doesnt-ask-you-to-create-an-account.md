---
sitemap: false
title: "Why Spliit Doesn't Ask You to Create an Account"
date: '2026-08-29'
excerpt: >-
  Spliit has no sign-up form, no password and no user database, and that is a
  design decision rather than a missing feature. Here is what the no-account
  model buys you in privacy and onboarding speed, and the trade-offs it costs.
lang: en
canonical_url: https://spliit.app/blog/why-spliit-doesnt-ask-you-to-create-an-account/
source_name: Spliit Blog
source_url: https://spliit.app/blog
---

One of the first things people notice about Spliit is what's *not* there. No sign-up form. No "continue with Google" button. No password to invent, no email to confirm. You create a group, you share the link, and everyone is in.

It comes up regularly — on GitHub, in emails, on Reddit. Some people love it. Some people assume it's a feature we haven't gotten to yet. So let me be clear: **the absence of accounts is a design decision**, and it's one of the decisions I care most about. Here's why.

## Splitting expenses is a group activity, not an individual one

Think about the moment you actually need an app like Spliit. You're on a trip with friends. Someone just paid for dinner. You want to write it down *now*, while everyone is around the table.

With most expense-sharing apps, that moment goes like this: everyone downloads an app, creates an account, verifies an email, accepts a privacy policy, and *then* you can add them to a group. By the time your least tech-enthusiastic friend has finished, dessert is over.

With Spliit, you send a link. That's the whole onboarding. Your friend opens it in their browser, selects their name, and can add an expense ten seconds later — on their phone, without installing anything, without telling us who they are.

The group link *is* the access control. If you have the link, you're part of the group. It's the same model as a shared note or an unlisted document: simple to understand, and exactly as private as the people you share it with.

## The privacy you get by not collecting anything

The second reason is privacy, and it's the one I find hardest to get across, because it's about what *doesn't* happen.

Expense data is intimate. It says where you traveled, who you were with, what you spent, and when. An account system attaches all of that to a durable identity — your email, and often, through "Sign in with Google" or "Sign in with Facebook", to a third party that now knows you use an expense-sharing app and when you open it.

Spliit sidesteps this entirely:

* **There is no user database.** We can't leak email addresses or passwords, because we don't have any.

* **No identity provider sits between you and your expenses.** No third party learns that you exist, that you use Spliit, or when.

* **Your expense history isn't tied to you.** Groups contain participant names that *you* chose — "Seb", "Mom", "Roommate #2" — not verified identities.

We take the same stance in the code itself. Group IDs are treated as capabilities — having one means being able to read a group — so they never reach our analytics. Events are typed to accept no properties at all, which makes attaching an ID a compile error, and the IDs that appear in page URLs are stripped in the single place every event passes through. Neither is something a code review has to catch. Analytics are disabled by default on self-hosted instances anyway. And since Spliit is open source, you don't have to take my word for any of this: you can read the code, or run your own instance where the only person with access to the database is you.

## The honest trade-offs

I won't pretend this model is free. Not having accounts means:

* **The link is the key.** Anyone who gets the link can see and edit the group. For expenses between friends this is fine — you already trust these people with your money — but it's not the right model for sensitive data among strangers.

* **No automatic group list across devices.** Your browser remembers the groups you've visited, but a new device starts empty until you open your links again. (Tip: starring the group or keeping the link in your group chat solves this in practice.)

* **No notifications, no "friends" feature, no payment integrations** — most of the things people ask accounts for.

These requests are legitimate, and the discussion has been going on in the open for years (see [issue #76](https://github.com/spliit-app/spliit/issues/76) if you want the full history). But every one of them pulls the same thread: once accounts exist, they become the center of gravity of the app. Sign-up flows, password resets, OAuth providers, session security, account deletion, GDPR requests — the project changes nature, and so does the promise it makes to you.

If you genuinely need authentication, you have good options. You can self-host Spliit behind a reverse proxy with OIDC, which gives you a login screen without changing the app. And because Spliit is MIT-licensed, forks exist that add full user accounts. That's open source working as intended: the mainline keeps its opinion, and the code is free to disagree.

## Simplicity is the feature

Spliit's promise fits in one line, and it's been on the homepage from the start: *no account, no limitation, no problem*. You shouldn't have to hand over your identity to figure out who owes what for pizza.

Ten seconds from link to expense. That's the product. The missing login screen is not a gap in it — it's the point.
