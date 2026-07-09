---
title: How well should I know React before applying to my first job?
date: '2023-06-15'
excerpt: >-
  A recurring question I hear from people learning React: “how do I know if I’m
  ready to apply to junior React developer jobs?”. Very often, they’re ready
  before they know.
cover: /assets/posts/what-to-know-react-first-job/cover.jpg
---

A recurring question I hear from people learning React: “how do I know if I’m ready to apply to junior React developer jobs?”. Very often, they’re ready before they know.

If you’ve built a couple of applications using React (your portfolio, a side project…), I bet you’re ready! (If you haven’t, what not checking out [my online course](https://learn.scastiel.dev) or [my React workshop](/react-workshop)? 😇)

In this article, I listed some things you don’t have to know, and some you do. My goal is to prepare you to your first technical interview.

Let’s start with what you _think_ you might need to know but definitely don’t.

## You don’t have to know everything

**It’s okay not to know how React works internally**

React is complex, and not many developers know how it works internally. Although it’s a fascinating topic, don’t feel you have to learn it unless you want to apply at Meta to work _on_ React.

**It’s okay not to have dozens of projects with React**

Showing you worked on a couple projects is more than enough. The more different they are, the better, especially if you’re able to tell how they were different and how it made the challenges different too.

**It’s okay not to have built a huge project with React**

Of course, if you worked on a big project, it’s an advantage. But don’t do it just to increase your chances at your first job interview, it isn’t worth it. If you get the job, you might work on a big project you’ll tell about at the interview for your next job!

**It’s okay not to know how to bootstrap a complex React app**

Do you know how to bootstrap an app with the right `npm` or `yarn` command? It’s enough! Actually, looking for it in the documentation is enough. Bootstraping an entreprise app is a useless skill, as only one person will do it in any project, and will probably forget about it before the next project.

**It’s okay not to know how to set up a deployment pipeline for React**

Setting up a deployment pipeline is not something expected from a junior developer. Plus, all applications are different, and a pipeline at one company might differ from the one at another company.

**It’s okay not to know Redux/Xstate/Tailwind/Next.js…**

It may be seen as an advantage to have used an external library in a React project, but there’s a huge chance that the one you learned is not the one used where you’re applying. So don’t overthink it too much.

**It’s okay to go find answers on the web**

Senior developers go find answers on Google, StackOverflow or ChatGPT all the time! No one will expect you to know how to build an application without using resources you can find on the web.

---

Alhought it’s okay to go on the web to find some information, example, answers, there are basics you should know very well before going to your first technical interview:

## But there are some things you should know

**Know JavaScript**

I know it isn’t technically React, but if you don’t master JavaScript’s basics during the interview, it isn’t a good start. Know how to declare constants, functions, how to use the spread syntax to update arrays and objects, or how to use promises…

**Know how to create a component**

You should know how to create a new component (as a function) with basic HTML content, and display it in your browser.

**Know how to display data conditionnaly, and how to perform iterations**

Be prepared to use the ternary operator `? :` to display data depending on a condition, and to use `.map` to display several elements from an array (and don’t forget to use the `key` prop).

**Know how to add a local state to the component**

`useState` is the most useful hook, and you should know how to use it: how to declare a state, how to update it, how to deal with complex states such as arrays or objects…

**Know how to add some form inputs in it**

Dealing with a text input is something you’ll have to do in many apps. Better be able to show you can do it without leaving your IDE.

**Know how to update the state when the user types something**

Displaying an input is nice, but you should also know how to use the _change_ event to update the state accordingly.

**Know how to perform a `fetch` request when the component is loaded**

Maybe you won’t have to use `fetch`, but you should at least know how to call an async function in the component… well, in a `useEffect`, without forgetting to define the dependency array.

**Know how to update the state depending on the `fetch` request result**

Storing the result of an async request (using a combination of `useState` and `useEffect`) is a very common pattern. If you show you can do it eyes closed, the recruiter will be impressed!

**Know how to extract some logic in another component, passing props**

Components are at the core of React, so you should know how to create a new component accepting props, and use it in the one you already created.

**Know what you don’t know**

Even if you don’t know how to use them, be able to mention the other hooks that exist and what they can be used for: `useReducer`, `useRef`… You can also read about server-side rendering, global state management libraries such as Redux…

---

Do you feel more confident now? Even if you don’t know some of the points I mentioned, you must admit it’s not that much: if you learned React already, you shouldn’t need too much time to learn what you’re missing.

Also, it’s okay if you don’t do perfectly well during the interview. The most important is that you don’t feel blocked. If you do, tell the interviewers and they’ll unblock you.

Hopefully you feel more prepared now; or at least you know what to prepare next 😊.

<aside>

If you need any help to get ready for your first (or next) job interview, have a look at the [mentoring services](/mentoring) I’m offering! I can help by answering questions, reviewing your portfolio, and even make you pass a mock interview 😉.

</aside>
