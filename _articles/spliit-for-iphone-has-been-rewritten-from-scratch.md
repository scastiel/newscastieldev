---
sitemap: false
title: "Spliit for iPhone Has Been Rewritten from Scratch"
date: '2026-09-03'
excerpt: >-
  Version 2.0 is a SwiftUI app that shares no code with the one it replaces.
  Here is why it needed to exist next to a website that already works on a
  phone, how it got built in weeks rather than months, and why the Android
  version is somebody else's to build.
lang: en
canonical_url: https://spliit.app/blog/spliit-for-iphone-has-been-rewritten-from-scratch/
source_name: Spliit Blog
source_url: https://spliit.app/blog
---

There has been a Spliit app on the App Store since the end of 2024. If you installed it, you probably opened it once, noticed it did a fraction of what spliit.app does, and went back to the website.

That's fair. I built it quickly in React Native to find out whether people wanted a mobile app at all, and it looked like a website in a wrapper. The version on the App Store today is not that app: it is 2.0, a complete rewrite in SwiftUI, with no line of the old one left in it.

## Why rewrite it instead of improving it

The honest answer is that I couldn't find a good reason for the old app to exist. Spliit's website already works on a phone — every split mode, every currency, all 35 languages. An app that does *less* than the website, on the same device, isn't worth the space it takes up.

So the question was never "how do I improve the app". It was: **what can an app do that a website on the same phone cannot?**

The list is short but real. A camera that reads a receipt without sending the photo anywhere. Groups that follow you to a new phone. Siri and Spotlight. Links that open in the app instead of the browser. A buzz that tells you the expense saved, so you don't have to look. That list is the reason the app exists; everything else simply had to be at least as good as the website before any of it counted.

## What it looks like

![The groups list and a group's expenses, bucketed by date](/assets/posts/spliit-for-iphone-has-been-rewritten-from-scratch/ios-2-groups-expenses.webp)

The home screen is the groups you have opened: starred, recent, and the ones you archived when the trip ended. Inside a group, expenses are bucketed by when they happened, under four tabs and a search.

![The split modes on an expense, and the balances screen of a group](/assets/posts/spliit-for-iphone-has-been-rewritten-from-scratch/ios-2-split-balances.webp)

The same four split modes as the web app and the same validation rules, so a phone and a browser can't disagree about an expense. Balances lead with *your* balance, once you have told the app which participant you are.

![The totals screen, showing group spending broken down by participant and category](/assets/posts/spliit-for-iphone-has-been-rewritten-from-scratch/ios-2-totals.webp)

## Originality goes into the content, not the chrome

I asked for the app to look "a bit more original than the default iOS look", and I'm glad that got pushed back on. Nothing in it replaces a navigation bar, a tab bar or a form. What got designed is the four things the system has no opinion about, which happen to be the four things Spliit is about: money gets a typeface of its own, people get a colour and their initials, categories get a glyph, and empty screens get a voice.

The other half of that is what didn't ship — a zoom transition into a group, built and then taken back out because a push is the movement iOS uses to say "deeper in", and any haptic not tied to an outcome, because a phone that buzzes at every tap teaches you to ignore it.

## How it got built

I should be straightforward about this: I used Claude Code, extensively.

It was an unusually good case for it. A rewrite is not a blank page — the web app is a working reference implementation, so every split rule, every validation message and every API contract already existed and was known to be correct, and the old React Native app had already answered what a mobile version should contain. Most of the work was translation rather than invention.

What it doesn't do is decide things. That glass belongs to the chrome and not the content, that the zoom transition had to go, that "who are you in this group?" belongs beside the balances rather than in a modal in front of them — those needed an opinion, and they took the most back and forth. Weeks rather than months, which I'll admit surprised me.

## Reading receipts without sending them anywhere

The website has had receipt scanning [since 2024](/announcing-receipt-scanning-using-ai/), and it works by sending your photo to OpenAI: it costs money on every scan, it needs an API key — so it doesn't work on most self-hosted instances — and a picture of your dinner goes to a third party.

On the phone, none of that happens. The text is read by the system's own document recognition and a model on the device makes sense of it, so it is free, it works offline, and the photo never leaves your iPhone unless you attach it to the expense.

## Still no account

Nothing changed there, and nothing is going to. No sign-up, no "continue with Apple", no profile — a group is reachable by its link, and that is the whole model, the one I wrote about [a few days ago](/why-spliit-doesnt-ask-you-to-create-an-account/).

One thing did get better. "Your groups" used to mean "the groups on this phone", and a new phone started empty; they are now kept in iCloud, which is your private database, not mine. If you are upgrading from the old app, your groups came across — the one part I tested on a physical phone rather than a simulator, because there is no undo for getting it wrong.

## What it doesn't do

* **It requires iOS 26**, which is the price of the on-device parts above. Older iPhones keep the last version that runs on them, with their groups untouched.

* **It is in English and French only**, against the website's 35 languages. The translations already exist in the web repository, so this is a "not yet" rather than a "no".

* **Recurring expenses, CSV export and saved split defaults** are still missing. They are on the list.

## It is open source too

Of course it is. The app is [its own repository](https://github.com/spliit-app/spliit-ios), and every screen above is SwiftUI you can read, build and run yourself. It talks to spliit.app out of the box, and any group can live on an instance you host instead. Nothing to buy and no advertising, which is the same deal as the website.

## Somebody should build the Android one

I would genuinely like there to be an Android version, and I think it has become a realistic thing for somebody to take on. The same process would largely work: the web app is still a reference implementation, and this app is now a second one, so the behaviour is pinned down twice over before a line is written.

What stops me is not the code. I don't know Android's conventions well enough to build something that feels native there rather than like an iOS app in the wrong place — and going by how the rest of this got built, that judgement is exactly the part the tooling doesn't supply.

So this is an open invitation. If you know Android and want to build it, [get in touch](https://github.com/spliit-app/spliit/issues) — the code is all there to read, and I will help however I can.

***

[Spliit for iPhone is on the App Store](https://apps.apple.com/us/app/spliit-shares-expenses/id6737742507), free, and there is [a page about it](https://spliit.app/ios) if you want the shorter version. After a rewrite this size there will be things I got wrong, so if you find one, [an issue on GitHub](https://github.com/spliit-app/spliit-ios/issues) is the most useful place to put it 😊
