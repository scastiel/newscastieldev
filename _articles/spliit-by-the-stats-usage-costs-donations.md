---
title: "Spliit by the Stats: Usage, Costs, Donations"
date: '2024-10-14'
excerpt: >-
  A transparency report on Spliit's first year, sharing figures on visits and usage, the roughly $115 monthly hosting costs, the donations that nearly cover them, and how much time goes into the project.
lang: en
canonical_url: https://spliit.app/blog/spliit-by-the-stats-usage-costs-donations/
source_name: Spliit Blog
source_url: https://spliit.app/blog
---

I created Spliit a few years ago, but the version you can use today is only one year old. As a user [suggested on GitHub](https://github.com/spliit-app/spliit/issues/242), it’s a great opportunity to release some information about the project as a transparency exercise.

## How many people use it?

In the last 12 months, Spliit received 152k visits, starting from ~200/week, and now regularly 5-6k/week. What is more interesting: the bounce rate is 33%, meaning that most people don’t just visit the home page; they _act_ on the website, either by switching groups, creating expenses, or reading a blog post.

![Spliit's visitors in the last 12 months (stats by Plausible)](/assets/posts/spliit-by-the-stats-usage-costs-donations/visitors.webp)
_Spliit's visitors in the last 12 months (stats by Plausible)_

Among these 152k visitors, at least 29k used a shared link. Which confirms that the normal use case scenario is for someone to create a group, then share it with the participants. But many visitors also come from Reddit, thanks to the many posts where someone asks for a viable alternative to Splitwise.

![Top sources and countries visitors came from in the last 12 months (stats by Plausible)](/assets/posts/spliit-by-the-stats-usage-costs-donations/sources-countries.webp)
_Top sources and countries visitors came from in the last 12 months (stats by Plausible)_

When looking where the visitors geographically come from, we can observe that countries where Spliit is the most popular are Germany, United States, and India. (To be honest, I don’t know what makes Spliit more successful in these countries specifically.)

## What do people do on Spliit?

When using Spliit, there are basically two things you can do: creating groups or adding expenses. As displayed on the home page, users created almost 15k groups at the time I’m writing this post, and a total of 162k expenses.

Since last January (I didn’t use to track it before), about 300 groups are created each week, and 2000 expenses.

![Number of group created in 2024, by week (stats by Plausible)](/assets/posts/spliit-by-the-stats-usage-costs-donations/groups-per-week.webp)
_Number of group created in 2024, by week (stats by Plausible)_

![Number of expenses created in 2024, by week (stats by Plausible)](/assets/posts/spliit-by-the-stats-usage-costs-donations/expenses-per-week.webp)
_Number of expenses created in 2024, by week (stats by Plausible)_

Here is the repartition of groups by number of expenses. An obvious information we can see here is that at least 4,600 groups were created only to test the application, as no expenses were created then. Then, on the 10k other groups, half have more than five expenses.

![Number of groups by how many expenses they contain](/assets/posts/spliit-by-the-stats-usage-costs-donations/groups-by-expense-count.webp)
_Number of groups by how many expenses they contain_

## How much does it cost?

Let’s talk money! I started many side projects in the past, and for most of them, I didn’t have to spend any cent. But when a project starts having hundreds of users, it’s hard to avoid some costs.

As you can see in the chart below, Spliit costs me about $115 each month, most of them being for the database hosting. _(Note: the amounts in this post are all in US dollars.)_

![Spliit's costs in 2024 (in USD)](/assets/posts/spliit-by-the-stats-usage-costs-donations/costs-2024.webp)
_Spliit's costs in 2024 (in USD)_

The database is hosted on Vercel, and the price is calculated from the total time the database is read in the month (the writings cost almost nothing). As Spliit is used worldwide, it is used almost the full month…

It is the source of cost I’d really like to work on. There must be database providers that charge less for Spliit’s use case. If you have any good opportunity to tell me about, feel free to [contact me](https://scastiel.dev/contact) 😉.

## How much does Spliit earn?

Since the beginning, Spliit’s “business model” is clear to me: it is [an open source project](https://spliit.app/blog/we-need-an-open-source-alternative-to-splitwise), that will stay free to use forever. There might be some premium features in the future, but they will be only for advanced use cases, never to limit the normal usage of the application.

This makes it hard to find a way to finance the app, which is why currently the only way Spliit makes money is via donations, either by [GitHub sponsoring](https://github.com/sponsors/scastiel), or with direct donations (via a [Stripe link](https://donate.stripe.com/28o3eh96G7hH8k89Ba)).

![Spliit's donations in 2024 (in USD)](/assets/posts/spliit-by-the-stats-usage-costs-donations/donations-2024.webp)
_Spliit's donations in 2024 (in USD)_

And I’ll be honest: I didn’t expect to receive that much money for Spliit! On the first month, someone donated $70! Since then, some people donate $5, others $20… I am amazed at people’s generosity.

A short disclaimer: I don’t _need_ donations to make Spliit work. I am lucky enough to have a full-time job that pays me enough to live comfortably and I am happy to give some of the money I earn to the community. (Side note: as a developer, Spliit is also a pretty cool project to show in interview when I look for a job 😉)

I added the ability to donate for two reasons:

1. Several users like the project so much they [asked for a way to give back](https://github.com/spliit-app/spliit/issues/40).
2. If I decide someday to leave the project, I would love if the community could keep it alive without financial issues.

You can see that the donations aren’t enough yet to cover all the project costs, but it’s close! 😊

## How much time do I spend working on Spliit?

Not as much as I would like! Something like 5 to 10 hours a month. Most of (if not all) the new features you’ve noticed in the app for a few months aren’t made by me, but the community!

![The many contributors who make Spliit](/assets/posts/spliit-by-the-stats-usage-costs-donations/contributors.webp)
_The many contributors who make Spliit_

The time I spend on Spliit, I use it to manage the [issues](https://github.com/spliit-app/spliit/issues) (feature suggestions, bug reports, questions), review and test the [pull requests](https://github.com/spliit-app/spliit/pulls) (feature implemented by contributors), and deploy the new features so that they’re accessible to everyone.

So a lot of time is spent on Spliit, but more by [other contributors](https://github.com/spliit-app/spliit/graphs/contributors) than by me. 😊

---

Spliit is a project I’m really passionate about, and it’s clear that others appreciate it as well! Generous donations help cover most of the hosting costs, though I still contribute some each month—which I’m happy to do 😊.

I’ll aim to keep these transparency updates coming, giving a regular look at the project's progress and funding.

**Do you have any follow-up question about Spliit?**

Two places you can ask them:

- [In this Reddit post](https://www.reddit.com/r/spliit/comments/1g3spf3/spliit_by_the_stats_usage_costs_donations/)
- [In this GitHub issue](https://github.com/spliit-app/spliit/issues/242)
