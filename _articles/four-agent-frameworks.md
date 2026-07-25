---
sitemap: false
title: "Four Agent Frameworks in Sixteen Months"
date: '2026-07-07'
excerpt: >-
  How Gama went from LangChain to LangGraph to Google ADK to Mastra to the Claude
  Agent SDK — and what we'd tell our December 2024 selves.
lang: en
canonical_url: https://engineering.vasco.app/articles/four-agent-frameworks/
source_name: Vasco Engineering
source_url: https://engineering.vasco.app
---

```
$ git log --oneline gama/runtime
- LangChain (TypeScript)                Dec 2024
- LangGraph (Python)                    mid 2025
- Google ADK + Agent Engine (Python)    Oct 2025
- Mastra (TypeScript)                   Mar 2026
+ Claude Agent SDK (TypeScript)         Apr 2026
```

Gama is [Vasco](https://www.vasco.app)'s AI agent. It answers questions about your revenue data, investigates why a metric moved, writes business reviews, and runs the custom agents our customers build. Under the hood, it has been rebuilt on a different agent framework four times in sixteen months.

That sounds like a failure. We want to argue it isn't — and that the real mistake in 2026 is the opposite one: staying loyal to a framework out of sunk cost. But to make that argument honestly, we have to walk through each migration, including the parts that don't flatter us.

### By the numbers

- **4 frameworks** in 16 months
- **1.5 weeks** — ADK → Mastra, 2 devs, ~50 PRs
- **37k lines** of old stack deleted (395 files)
- **&lt;24 hours** from prototype to green light on the Agent SDK
- **A few $ per report** for a deep business review, better than before
- **0 disruption** — agents kept running behind a feature flag

*December 2024*
{: .eyebrow}

## Babysitting the LLM

Gama started as a feature called Stage Diagnostics: a text explanation of the numbers on a page, to make the analysis easier to read. Simple enough. We had two problems.

The first was that hallucinations were everywhere, and no amount of prompt engineering gave us a guarantee. Worse — and this is the part people forget about 2024 — the outputs that *were* accurate were mostly useless. They stated the obvious. "Your conversion rate went down because fewer accounts converted." Thanks.

The second was structured output. LLMs at the time were bad at returning data in the exact shape you asked for, and we needed specific values formatted a specific way inside the text. Our fix, and we're not proud of this, was to write code that parsed the generated text, detected the numbers in it, and reformatted them ourselves. Our first solution to unreliable AI output was to write more code around it.

> If we're honest about the effort split, about 70% of the work on that feature was babysitting the LLM — parsing, validating, retrying, formatting — and maybe 30% was the product.

Every prompt change risked breaking the parsing logic, and every parsing change constrained the prompt. That's the context in which [LangChain](https://www.langchain.com/langchain) looked like salvation: a mature framework (by the standards of the time) that promised to absorb the babysitting. We wrote an ADR, chose LangChain over [Vercel's AI SDK](https://sdk.vercel.ai) (too young) and [CrewAI](https://www.crewai.com) (Python-only, and we were a TypeScript shop), and committed. We even decided *not* to build an abstraction layer on top of it. Going all in felt efficient.

*2025*
{: .eyebrow}

## The hiring decision that became an architecture decision

Here's a migration you won't find an ADR for: LangChain in TypeScript became [LangGraph](https://www.langchain.com/langgraph) in Python. Nobody sat down and wrote "we are switching languages because the person we hired knows Python" — but that's what happened, and at the time it was completely rational. In early 2025, Python *was* the language of AI. The ecosystem, the examples, the reference implementations, the future hiring pool: all Python-first. When we hired our first AI developer, betting on TypeScript for the AI layer would have felt contrarian. So we carved the LLM logic out of our existing services into a dedicated Python service, and moved on.

What did it actually cost? More than we expected, in a way that had nothing to do with the language being hard. Python is not a complex language. But doing things *right* — developer experience, CI/CD, Docker builds, deployment hygiene — meant our team of TypeScript veterans had to ramp up on a whole ecosystem.

Meanwhile, the AI developer we'd hired was genuinely good with AI but didn't have much production engineering experience. So we ended up with the worst of both worlds: the people who knew how to run services in production didn't know the language, and the person who knew the language wasn't the one setting up its scaffolding. Everyone was outside their comfort zone at the same time.

We also created a split that a later migration would exist purely to undo: two stacks, one monorepo full of shared TypeScript libraries our AI service couldn't touch.

*October 2025*
{: .eyebrow}

## Google ADK, or "It Worked Locally"

By fall 2025 the LangGraph service worked, but it was heavy: custom orchestration, hand-rolled conversation state in Postgres, Docker builds through CircleCI, and a framework whose age was starting to show — API decisions made early in LangChain's life had calcified, and we were paying for them. When Google's [Agent Development Kit](https://google.github.io/adk-docs/) came along, the promise was exciting. Less boilerplate than LangGraph, batteries included (tools like web search we didn't have to build), decent-looking documentation, and — the part that seduced a team tired of plumbing — managed deployment on [Vertex AI Agent Engine](https://cloud.google.com/vertex-ai/generative-ai/docs/agent-engine/overview). No containers, no CI/CD complexity. Google runs it for you.

And we want to be fair: ADK, the framework, was good. Locally, everything worked. The problem was the second half of the promise. On Agent Engine, we were no longer in control of the agents we deployed. We didn't have access to all the logs. Behavior in production diverged from behavior on our machines, and we had no way to see why. We spent enormous energy on deployment issues for a platform whose entire pitch was that we wouldn't have to think about deployment.

Among the highlights: a tracing library incorrectly instrumenting Agent Engine's requests and killing sessions, an upstream task-affinity bug we had to wait on a release for, and one memorable demo that failed because a service simply never started in production — something we could not have observed until it bit us.

Two smaller things deserve a mention because they're the kind of signal we'd act on faster today. First, the documentation:

> It looked great at a glance, but the more we read it, the more it read like it had been generated by AI — and the real answers to our problems consistently lived in GitHub issues. That's never a good sign.

Second, ADK couldn't instantiate agents dynamically at the time, so to support customer-created custom agents we maintained a pre-allocated pool of ten agent slots with FIFO eviction. When you're building a slot pool to fake a feature, the framework is telling you something.

*March 2026*
{: .eyebrow}

## The Two-Week Bet

This is where the story stops being about frameworks and starts being about migration cost.

Our CTO tried to convince us we could migrate the entire AI infrastructure off ADK — Python, Agent Engine, all of it — in two weeks. We didn't believe him. It seemed far too ambitious: seven sub-agents, custom agents, a task worker, copilot features, evals, observability. He kept insisting that with [Claude Code](https://code.claude.com/docs/en/overview) and modern AI tooling it would be easy, and he built a small prototype to prove the point. In the end, two developers migrated everything to [Mastra](https://mastra.ai) in a week and a half. About fifty PRs. At the end we deleted the old stack in one pass: 395 files, roughly 37,000 lines of Python, gone.

And Mastra was *good*. We were back in TypeScript, which meant the AI service could finally use all the shared libraries in our monorepo. Batteries included, real documentation that held up under reading, and a team that actually talked to us — they helped on a couple of issues, and contributing to the repo or just asking a question was easy. After the ADK experience, that alone felt like luxury.

Which makes what happened next the strangest chapter to write: six weeks later, we left Mastra too. And for the first time, we weren't fleeing a framework that had failed us.

*April 2026*
{: .eyebrow}

## Beaten by Our Own MCP

Around that time, everyone at Vasco was using Claude daily — not just the developers, the whole company. And we had just shipped a public [MCP](https://modelcontextprotocol.io) server exposing Vasco's data to any AI tool. So one day we plugged our own MCP into Claude Code, giving it the same access to our application and data that Gama had.

It was better than Gama. A coding tool, pointed at our data through the same interface, produced better answers and better reports than the product we had spent over a year building. And because the whole company lived in Claude, everyone had already *felt* this gap personally. The frustration wasn't an engineering abstraction.

We had dismissed the [Claude Agent SDK](https://code.claude.com/docs/en/agent-sdk/overview) for a long time, and the reason sounds reasonable when you say it out loud: it's the framework underneath Claude Code, and we don't generate code — we help RevOps people. But sitting with that frustration, the argument inverted. Code is the hardest, most unforgiving agentic task there is: long horizons, huge contexts, zero tolerance for hand-waving. If a harness makes an agent great at *that*, why would it not be great at everything else?

One evening, we built a prototype: the Claude Agent SDK wired to our existing MCP servers, a couple of real use cases. It worked so well it was almost annoying. Same data sources, dramatically better answers, better reports — it was even producing React components for our UI.

We had real concerns, mainly cost: Claude models are significantly more expensive than the Gemini models we'd been running. So the prototype became an ADR with a cost analysis, that became a few short discussions, and less than 24 hours later the decision was made: the next two weeks, the team migrates everything from Mastra to the Claude Agent SDK.

In December 2024 that decision would have taken us a cycle of committee meetings. The Mastra migration had taught us that migrations are cheap now; this one we didn't even hesitate on. The pitch to the rest of the company was also the easiest we've ever made. It wasn't "trust us, this framework benchmarks better." It was:

> You know that thing you already use all day and love? That, inside Vasco.

*The payoff*
{: .eyebrow}

## What a Coding Runtime Gives an Agent That Never Writes Code

The thesis we wrote in the ADR was one sentence:

> Stop reimplementing Claude Code and start running on it.

By then we had also noticed a pattern in ourselves: every time we implemented a new AI feature, our north star was "do the same thing Claude does." It still is today. Running on the same runtime just made the north star the default instead of a reimplementation effort. Concretely, here's what that meant for a revenue analytics product.

**We deleted our supervisor machinery.** Supervisor loop, subagent context isolation, agent handoffs, prompt caching, tool-result trimming — we had hand-rolled versions of all of these, in three frameworks, and they were never as good as the ones battle-tested by the most demanding agent workload in the industry. They're primitives now. We just use them.

**The filesystem turned out to be the killer feature.** This is the one nobody expects from a "coding" SDK. Our agents deal with large data: CRM exports, query results, transcript dumps. In every previous stack, big tool results bloated the context window — at one point a single 9MB activity payload poisoned every subsequent call in a conversation, and we built server-side trimmers and strippers to cope. With the Agent SDK, data-heavy tools write to a scratch directory instead, and the agent uses Read and Grep to pull in only the slice it needs. Watching an agent grep a revenue report it's writing, restructure a section, and edit it in place — exactly the way Claude Code works a codebase — was the moment the "it's only for code" objection died for good. The trimming infrastructure went in the bin.

**Reasoning quality dissolved architecture.** On the weaker model, a deep task like a weekly business review required a whole project system: decomposition into tasks, a runner, multi-stage orchestration. With a frontier model in a proper harness, the agent plans, analyzes, and writes the full review in a single conversation. Most of that scaffolding became optional overnight. Less code, lower latency, and — the part we were most nervous about — the economics work: with cheap fast models handling the data-fetching subagents and prompt caching doing its job, a deep report like a business review costs a few dollars, for output meaningfully better than what we shipped before.

**The trade-offs are real, and we accepted them with open eyes.** We are, in practice, committed to Anthropic. Another model can technically still be swapped in — and we keep that option as a fallback if Claude models are ever down — but it's an emergency exit, not a long-term path; the point of the migration is the harness and the models together. The cost floor is higher than the Gemini Flash and Pro models we ran before, even after caching and model routing. Observability and evals are no longer first-party; we assemble our own. We wrote all of this down before migrating, and we'd rather own these trade-offs than keep paying the tax of being a worse Claude Code.

*Epilogue*
{: .eyebrow}

## What We'd Tell Our December 2024 Selves

Four frameworks in sixteen months looks like churn. But look at the trajectory of the migrations themselves: the move to Python took months to digest; ADK to Mastra took a week and a half; Mastra to the Claude Agent SDK was decided in a day and executed in two weeks, with existing agents running undisturbed behind a feature flag the whole time. Migration cost has collapsed — largely because of the same tools we ended up building on. When switching is this cheap, framework loyalty is the expensive choice. Every ADR we wrote was right *at the time it was written*, and being willing to overwrite them is the only reason Gama is good today.

The other lesson took us longer to accept, because it goes against every engineering instinct: sometimes, when the model can't do what you need, the right move is to give up. Not on the product — on the workaround. The regex that re-formats numbers, the trimmer that fights context bloat, the slot pool that fakes dynamic agents: all of it was depreciation-in-progress the day it was written, engineering effort spent compensating for a model that a release six weeks later made unnecessary. These days we try to recognize that moment, park the problem, and wait.

Though to be honest, since we moved to Claude, it doesn't happen much anymore.

---

## Glossary

**LLM (Large Language Model)**: AI models trained on vast amounts of text data that can understand and generate human-like language. Examples include Claude, GPT, and Gemini.

**Hallucination**: When an LLM confidently produces information that is plausible-sounding but factually wrong or invented.

**Prompt engineering**: The practice of carefully wording and structuring the instructions given to an LLM to steer it toward the output you want.

**Structured output**: Forcing an LLM to return data in an exact machine-readable shape (like JSON with specific fields) rather than free-form prose, so downstream code can rely on it.

**ADR (Architecture Decision Record)**: A short document that captures a significant technical decision — the context, the options considered, and the consequences — so the reasoning survives after the decision is made.

**CI/CD (Continuous Integration / Continuous Delivery)**: The automated pipeline that builds, tests, and ships code changes, so that merging triggers a repeatable path to production.

**ADK (Agent Development Kit)**: Google's framework for building LLM agents, paired with Vertex AI Agent Engine as a managed way to deploy and run them.

**FIFO (First In, First Out)**: An eviction policy where the oldest item is removed first — here, recycling the least recently allocated agent slot.

**Eval (evaluation)**: A repeatable test that scores an agent's output for quality or correctness, used to catch regressions as prompts and models change.

**MCP (Model Context Protocol)**: An open standard for exposing data and tools to AI applications through a uniform interface, so any compatible model or client can consume them.

**Agent SDK (Claude Agent SDK)**: Anthropic's framework for building agents on the same runtime that powers Claude Code — supervisor loops, subagents, prompt caching, and filesystem access included.

**Subagent**: A secondary agent spawned by a main ("supervisor") agent to handle a narrower task in an isolated context, keeping the main conversation focused.

**Supervisor loop**: The top-level control loop that plans an agent's work, dispatches tools or subagents, and decides when the task is done.

**Prompt caching**: Reusing the model's processing of a repeated prompt prefix across calls, cutting latency and cost when much of the context is unchanged.

**Context window**: The finite amount of text (measured in tokens) an LLM can consider at once; large tool results can crowd it out and degrade later responses.

**Feature flag**: A runtime switch that turns functionality on or off without redeploying, letting a new system run alongside the old one and roll back instantly.

**RevOps (Revenue Operations)**: A business function that aligns sales, marketing, and customer success operations to drive growth through process optimization and data analysis.

---

Gama runs on the Claude Agent SDK inside Vasco. If watching a team delete 37,000 lines of their own orchestration code sounds like fun, [sometimes we hire](https://jobs.ashbyhq.com/vasco).
