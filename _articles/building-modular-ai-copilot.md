---
title: "Building a Modular AI Copilot: From Monolithic to Dynamic Context"
date: '2025-10-30'
excerpt: >-
  How we built Vasco's Copilot — from a LangChain-and-Gemini prototype to a
  modular architecture where each page declares its own context and tools.
lang: en
canonical_url: https://engineering.vasco.app/articles/building-modular-ai-copilot/
source_name: Vasco Engineering
source_url: https://engineering.vasco.app
---

Revenue operations teams face a constant challenge: complex workflows that require deep domain knowledge, even for seemingly simple tasks. At Vasco, users struggle with forms that ask for **CRM field mappings**, **date categorizations**, and **pipeline classifications** — tasks that feel straightforward but actually require significant **RevOps** expertise. Our platform brings **clarity**, **control**, and **automation** to these inherently complex revenue workflows, but even with the best user experience, **RevOps** tasks can feel overwhelming.

To help users find their way through this complexity, we built a **Copilot** — a contextual assistant that provides real-time guidance and suggestions within the app.

For example, when a user is filling out a form to categorize sales events, the Copilot might suggest "Q4 2024" for a date field based on the context, or recommend relevant CRM fields to group similar events together. It can also auto-fill fields when confident about the user's intent, saving users from having to remember and type the same information repeatedly.

In this post, we'll walk through:

- how we built the Copilot,
- the design iterations we made along the way, and
- how this foundation will support more interactive AI features throughout the Vasco platform.

## 1. Why We Built the Copilot

This isn't our first time using AI at Vasco. For over a year, we've relied on both **generative and non-generative models** to power features like CRM enrichment, pipeline analysis, and workflow automation. But until now, those capabilities mostly ran in the background. The Copilot marks a shift: AI stepping out of the **backend** to assist users **directly** within the product experience.

We typically favor a **buy-vs-build** approach, especially as a startup. When exploring ways to deliver this kind of experience, we looked for existing solutions. The closest we found was [CopilotKit](https://www.copilotkit.ai/), which inspired a few ideas but didn't align with our architectural needs or product direction.

So we built our own. We started small with a **domain-specific form** that was just the right mix of compact and complex. This form — used to group events into buckets by leveraging CRM fields — doesn't have many inputs, but each one requires domain knowledge. That made it an ideal first test case for the Copilot's assistant capabilities.

## 2. How We Got It Working

Our initial implementation of the Copilot was built using **LangChain** and **Gemini**. Our intuition was to treat frontend interactions as if they were tools in a typical agent setup — allowing the LLM to reason about which action to perform, like `updateForm()`, based on the current context.

However, the LLM workflow lives on the backend, and doesn't have direct access to the frontend. We needed a way for the model to request UI actions and receive feedback. To solve this, we introduced a **lightweight communication protocol** between the backend and the frontend.

The LLM would emit structured messages like:

```
callTool: updateFormField({
  fieldId: "eventDate",
  value: "2024-12-15",
  confidence: 0.95,
  reasoning: "Based on the user's mention of 'end of year' and current context, suggesting Q4 2024 date"
})
```

The frontend, observing these messages, would parse them, run the corresponding UI action (e.g., updating the form field), and return a response back to the backend:

```
toolCallResponse: {
  success: true,
  fieldUpdated: "eventDate",
  newValue: "2024-12-15",
  uiState: "field_highlighted"
}
```

This protocol enabled a basic but functional loop: the LLM could plan what to do next based on the tool responses it received. The backend essentially orchestrated the sequence of tool calls, while the frontend served as an executor.

We used LangChain to:

- model the agent's reasoning steps,
- manage the state of the interaction, and
- generate the next action based on context and history.

Gemini served as the underlying LLM, interpreting the prompts and producing the next `callTool` or final response.

Overall, this setup let us prototype a **multi-turn, interactive experience** with minimal coupling between the frontend and the model logic. It gave us early validation that the Copilot could interact intelligently with the interface.

While this first version worked well in isolation, it exposed some cracks as we started thinking about scaling. Every new use case required custom logic and tool wiring in both the prompt and frontend. That wasn't sustainable.

It made it obvious we needed a more modular approach — one where each page could declare its own context and tools in a structured, dynamic way.

## 3. Making It Modular

To address the scalability and modularity challenges, we rethought the architecture so that each page could define its own context and capabilities dynamically. Rather than maintaining a central list of tools or hardcoding logic into prompts, the **frontend became responsible for sending a session-specific configuration** to the backend.

At the beginning of each session, the frontend now provides:

- **A dynamic description of the page** — what the user is doing and how the Copilot can help.
- **Static context** — like current user info or available icons.
- **Available tools** — each with a serialized parameter schema and return type.

This makes the system much more **modular**. Every page or view can expose its own assistant behavior, with clear boundaries between context, capabilities, and logic. The backend simply registers runtime tools from the configuration and drives the interaction accordingly.

The backend uses this to register **runtime LangChain tools** that conform to the page's contract. Each view is responsible for implementing and handling the tools it exposes.

Additionally, with each message (the first one and all subsequent ones), we also send the current page's state. This way, the agent knows if the user updated a field without using the chat.

Here's what the system prompt looks like (we've simplified these examples for clarity — the actual prompts and messages contain much more detailed context and structured data):

```
You are a helpful Copilot helping the user on a form.
You'll receive a description of the page and instructions about how you can help the user on it. Follow these instructions by the letter.
```

When a user starts a conversation, we send an initialization message that sets up the context for the entire session:

```
Initialization message:
Here is the description of the page the user is on:
PAGE DESCRIPTION
Here is some additional context on the page:
CONTEXT
Here is the page's current state:
CURRENT STATE
```

**Note:** LangChain's tool system handles the available tools, so we don't need to include them in our prompt — they're automatically available to the LLM when needed.

Then, with every user message, we include the current state so the Copilot always knows what's changed:

```
User message:
USER MESSAGE
Here is the page's current state:
CURRENT STATE
```

This gives every page autonomy over its Copilot experience — giving the system:

- **Modularity**: Each page defines its own tools and capabilities without affecting other parts of the app.
- **Predictability**: Clear contracts between frontend and backend eliminate guesswork about available functionality.
- **Extensibility**: Adding Copilot support to new pages requires no changes to core backend logic.
- **Contextual Intelligence**: The Copilot adapts its behavior based on the specific page context.

## 4. What's Ahead and Wrapping Up

Currently, the Copilot is only available in one form. But with the modular architecture now in place, we've started rolling it out to more parts of the app — with **user onboarding flows** being a key next target.

Thanks to this setup, the Copilot can now operate across multiple UI zones at once. Imagine a page that includes both:

- a **form** the user is editing, and
- a **sidebar** with navigation actions or analytics.

The Copilot can help with both. If the user navigates away from the form, the frontend tells the agent the form tools and context are no longer available — but keeps the sidebar tools active.

This makes the assistant **persistent and adaptive**, able to evolve with the UI as users move through the app.

#### Key Lessons Learned

Building the Copilot taught us several important lessons about AI-powered UX:

1. **Start small, think modular** — Beginning with a focused use case helped us validate the concept before scaling
2. **Context is everything** — The Copilot's value comes from understanding not just what the user is doing, but why
3. **Developer experience matters** — The modular architecture makes it easy for our team to add Copilot support to new features
4. **Real-time interaction is powerful** — Moving from passive insights to active assistance fundamentally changes the user experience

Building the Copilot has been a big step toward making Vasco more interactive, approachable, and AI-native. We've moved from passive insights to real-time, contextual assistance — and the foundation we've laid opens up exciting possibilities across the product.

The journey isn't over. As we continue to expand the Copilot to new workflows, we're staying focused on keeping things intuitive for users, modular for developers, and grounded in real utility.

## 5. Technical Implementation Details

While the modular architecture solved our core scalability challenges, we also implemented several technical features that make the Copilot robust and developer-friendly.

These implementation details might seem like nice-to-haves, but they're crucial for creating a production-ready AI assistant that developers can trust and users can rely on.

#### Tool Integration Architecture

To strengthen the communication between frontend and backend, we wrapped each client-side tool with a corresponding **LangChain tool** on the backend. These tools define a clear input schema, validate inputs before execution, and dispatch a well-formed message to the frontend. Once the frontend executes the action and returns a structured result, LangChain picks up the thread and continues reasoning — creating a clean loop with minimal glue code.

We leveraged LangChain's [interrupt feature](https://blog.langchain.com/making-it-easier-to-build-human-in-the-loop-agents-with-interrupt/), normally used for "Human in the loop" workflows, to create what we call "Frontend in the loop" — allowing the LLM to pause execution while waiting for frontend actions to complete, then resume with the results.

#### Type-Safe Communication

Our architecture enabled us to build a **type-safe communication library using LangChain with TypeScript** between the frontend and backend. This ensures that:

- Message parsing and tool execution happen in a robust, predictable way
- TypeScript catches potential errors at compile time rather than runtime
- The system integrates seamlessly with **streaming responses** for real-time interactions

#### Rich UI Components

Beyond simple tool calls, the frontend can register **custom components** that the Copilot can use in its responses. This enables us to render **rich and even interactive content** directly inside the chat interface — from styled messages to embedded action buttons that users can click without leaving the conversation.

#### Debugging and Observability

The modular approach also made it easier to implement comprehensive logging throughout the system. We added proper logging in the frontend that allows developers to see all messages — including internal tool calls and system messages that aren't displayed to users — directly from the browser's DevTools console. This visibility is crucial for debugging complex AI interactions and understanding how the Copilot reasons about user requests.

---

## Glossary

**LLM (Large Language Model)**: AI models trained on vast amounts of text data that can understand and generate human-like language. Examples include GPT, Claude, and Gemini.

**LangChain**: A framework for building applications with LLMs that provides tools for managing conversations, integrating external data, and orchestrating complex AI workflows.

**Gemini**: Google's large language model that powers our Copilot's reasoning and response generation.

**RevOps (Revenue Operations)**: A business function that aligns sales, marketing, and customer success operations to drive growth through process optimization and data analysis.

**Agent**: An AI system that can take actions and make decisions based on its environment and goals, often using tools or APIs to accomplish tasks.

**Tool**: A function or capability that an AI agent can use to perform specific actions, such as updating form fields or retrieving data.
