---
title: On distraction and developer productivity
date: '2020-07-07'
excerpt: >-
  When twenty developers were asked to keep a precise diary of what tasks they
  worked on during the day minute by minute, the results were surprising. Maybe
  you don’t code as much as you think you do during a day…
cover: /assets/posts/on-distraction-and-developer-productivity/cover.webp
lang: en
---

Think about a normal day of work. You arrive at the office, take a coffee, start
coding, do some code review, have lunch, some meetings, code again, and that’s
it. But is it really?

I could bet that looking more precisely at your day, it looks more like: start
coding, answer a question on Slack, help a colleague, have a short meeting, code
again, ask a question to a colleague, fix the build pipeline, answer an e-mail,
fill your timesheet... and it’s not even noon.

## 2 hours of coding

When twenty developers from the US, Canada, and Switzerland
[were asked to keep a precise diary](https://ieeexplore.ieee.org/abstract/document/7829407/)
([PDF](https://www.zora.uzh.ch/id/eprint/136503/1/productiveWorkday_TSE17.pdf))
of what tasks they worked on during the day minute by minute, the results were
surprising.

First, code-related tasks (coding, debugging, code review, etc.) take only two
hours a day. This is 25% of the classic day of work. You can add almost one hour
of “work-related browsing” (I would consider this as part of the coding
activity, as long as it’s not to procrastinate), then it’s e-mail (one hour),
planning (30 minutes), documentation (30 minutes), planned or informal meetings
(1.5 hours), etc.

Maybe you’ll tell me that you spend more than two hours a day coding, but I
can’t recommend you enough to try during a day or two to keep a diary of
everything you do. And I mean everything: when you leave your computer for a
minute to get a glass of water, when you stop coding for thirty seconds to
answer a question on Slack, or when you open your inbox to get some information
you need.

If you do this, you may realize another interesting and disturbing thing: the
average time you spend on coding before switching to something else: an
interruption, a meeting...

## 36 seconds before being distracted

The same study highlighted that on average, a developer writes code for 36
seconds before switching. Not even a minute! Of course, sometimes you code
during much more time, but it’s compensated by the several other times you code
for just a few seconds before being interrupted.

![Photo by ThisisEngineering RAEng](/assets/posts/on-distraction-and-developer-productivity/thisisengineering.webp)

The other tasks follow the same pattern, except the planned meetings (it’s more
difficult to leave a meeting after one minute I guess). So, looking at the
global picture, a developer’s day is composed of a lot of small periods of a
couple of minutes, when they can either code, answer e-mails, write
documentation, or participate in an informal meeting.

But I can imagine that if you try to plan your day, you don’t expect such a
fragmentation of work. This is a big obstacle to productivity. So, what causes
this fragmentation and how can we overcome it?

## 40 in-person interruptions

A
[study made in 2011](https://www.sciencedirect.com/science/article/pii/S0268401210001568)
([PDF](https://www.interruptions.net/literature/Sykes-IntJInformManag11.pdf))
found that most interruptions encountered by developers during a day are
in-person interruptions. On average, there can be between 12 of them for an
entry-level developer, and up to 40 for a senior developer or technical lead.
Other kinds of interruptions are provoked by instant messaging (4 to 9), e-mail
(8 to 52), and phone (0 to 20).

Let’s focus on colleague interruptions. Most of them are legitimate: it’s part
of a developer job to ask questions to colleagues, and you rely on your
coworkers to answer yours, especially for junior developers. Therefore, removing
these interactions is out of the question.

Still, there must be a way to keep a reasonable level of interaction with
coworkers without causing that many interruptions.

## The “Do not disturb” mode

In 2017, a team developed for
[a study](https://dl.acm.org/doi/abs/10.1145/3025453.3025662)
([PDF](https://www.zora.uzh.ch/id/eprint/136997/1/FlowLight.pdf)) a tool to help
other teams in several IT companies (developers, testers, project managers,
etc.), reducing in-person interruptions. It was composed of a LED light above
each desk and an application installed on developers’ computers to automatically
update the LED color. The LED was green if the developer was considered
_available_, red for _busy_, and blinking red for _do not disturb_. The software
used indicators such as keyboard typing during a given time to determine the
developer’s status.

This tool showed good improvement in the teams where it was tested. The number
of interruptions was divided by two, and around 60% of participants estimated
they had been less interrupted when busy (20% disagreed with that statement).

More importantly, almost 60% of participants felt that their productivity
increased during the study. Not all interruptions were removed, but they tend to
happen less when the developer was deeply focused on a task. Plus, the LED
helped people being aware of the cost of disturbing someone.

This system may not be a revolution to improve developers’ productivity, but we
can draw inspiration from it. What it demonstrates is that people tend to
disturb people less often when aware of how busy they are.

In the different teams I worked with, we almost always had a system to indicate
others that we were busy and preferred not to be disturbed. Sometimes, it was
having headphones on. Other times, we used the status of our instant messaging
application, setting it to _busy_.

![Photo by Megan Markham](/assets/posts/on-distraction-and-developer-productivity/notnow.webp)

But one of the most efficient systems we found was not a specific sign to
indicate we were busy. I still try to initiate it with the teams I work in
today. We simply consider everyone as busy. It means that if you ask a question
to someone on instant messaging, you shouldn’t expect an immediate answer. More
importantly, if you need to ask a question in person, first send a message on
IM, such as: “I need your help, tell me when you have a moment”. Or just: “Got a
second?”

Why sending a message on IM instead of just asking directly, you may ask? It
turns out that just asking “do you have a minute?” in person is often enough to
make the person lose focus on what they were doing and ruin the whole strategy.

A past colleague of mine, when someone (sometimes it was me) asked him “can I
disturb you for a minute?”, used to answer, “you just did”. Always in a humorous
way, but it was enough to make people realize that asking a question as short
and easy-to-answer it is (“do you have a moment?”), is enough to make the person
lose a precious focus.

When I’m working on a task requiring a lot of focus, I usually turn off IM
notifications. My coworkers know that I won’t answer them immediately, but that
I’ll find time to answer them eventually and spend the necessary amount of time
to help them. And when I’m the one having a question, as much as possible I use
IM to ask them to ping me when they have a moment.

---

Want to know more about productivity for developers? Have a look at my
work-in-progress book [The Outstanding Developer](https://theoutstanding.dev).

_Cover photo by [Isaac Smith](https://unsplash.com/@isaacmsmith)._
