---
title: How to give code review as a junior developer?
date: '2023-06-24'
excerpt: >-
  By focusing on learning, providing constructive feedback with a positive tone,
  and embracing the opportunity to contribute, junior developers can make
  valuable contributions to code quality and their own growth. Code reviews are
  essential for skill development and fostering collaboration within development
  teams.
cover: /assets/posts/code-review-junior-developer/cover.jpg
---

“The code must be reviewed by senior developers.” “A review by a junior is nice, but their approval is worth nothing.” If you’ve never heard these phrases, you’re lucky. Of course, they’re completely wrong.

As a junior developer, participating in code reviews offers a valuable learning opportunity and a chance to contribute to the team’s success.

In this post, I’ll explore how you can provide effective code review feedback as a junior developer.

<aside>

This article became a part of my book [Pull Requests and Code Review](/pull-requests-code-review)! You’ll find in it many other real-life examples and actionable insights. Download it for free!

</aside>

<!-- <aside>

Do you need guidance in your journey as a junior developer? I can help you learn skills, be more confident, and reach your dream job! [Check out my mentoring services](/mentoring) 😉

</aside> -->

## Why Code Review?

Code reviews serve several purposes that benefit both individual developers and the team as a whole. Here are a few key reasons why code review is essential:

### Learn from the Code

Code reviews expose you to different coding styles, techniques, and approaches. By reviewing code written by other developers, more experienced or not, you can gain valuable insights and enhance your own skills.

### Ensure Good Practices

Code reviews help maintain coding standards and best practices within the project. By identifying deviations from established guidelines, you contribute to the overall code quality and maintainability.

For instance, if your team decided that the files should be organized by business modules, and a developer did not follow this convention in their pull-request, then code review is the right way to tell them.

### Check for Bugs or Edge Cases

Through careful examination, code reviews help catch potential bugs, logic errors, or vulnerabilities that might have been overlooked during development. Identifying and addressing these issues early on saves time and minimizes future complications.

Note that depending on what your team agreed on, it might or might not be a responsibility of the reviewer to manually test the changes.

### Challenge the Implementation

Code reviews encourage critical thinking and provide an opportunity to challenge the design decisions or suggest alternative approaches. By sharing your perspective, even as a junior developer, you contribute to the team’s collective problem-solving capabilities.

## What Code Review Should Not Be Used For

While code review is a valuable process, it’s important to understand its scope and limitations. As a junior developer, it’s helpful to know what code review should not be primarily used for:

### Code Formatting and Linting

Code reviews are not the place to nitpick about minor formatting or styling preferences. Automated tools and linting processes can handle these concerns, allowing code reviews to focus on more substantial issues: [ESLint](https://eslint.org/), [Prettier](https://prettier.io/), etc.

### Big Architecture Discussion

Code reviews are typically not the ideal place for large-scale architectural discussions. While providing input on architectural decisions can be valuable, it’s better to address these concerns in separate discussions or meetings.

## What is Expected from a Junior Developer

As a junior developer participating in code reviews, you have a crucial role to play. Here’s what is expected from you:

### Read the Code Carefully and Learn from It

Take the time to thoroughly understand the code being reviewed. Absorb the logic, patterns, and techniques used by more experienced developers, as this will help improve your own skills.

You’ll also learn about the specific project you’re working on, how the application was designed, its technical debt, etc.

### Speak Up if Something Isn’t Clear

Don’t hesitate to ask questions or seek clarification if you encounter sections of code that are unclear or confusing. Effective communication ensures everyone is on the same page and helps prevent misunderstandings.

It should be possible for every developer, including junior, to understand every piece of code in the project. If you can’t understand some code, it might be because it wasn’t written in the clearest way.

Note that sometimes, the code is hard to understand for good reasons, for instance to handle performance issues. In that case, comments in the code can be used to make it easier for other developers.

### Share Alternative Perspectives

As a junior developer, you bring a fresh perspective to the code review process. If you believe there’s a different, more efficient, or elegant way to implement something, respectfully share your thoughts and encourage discussion.

Don’t think you are not experienced enough to challenge a senior developer’s implementation because you just learned the tech. Sometimes, asking why a developer didn’t follow the practice you just learned leads to insightful discussion!

## Use the Right Tone in Your Comments

Providing feedback in a positive and constructive manner is crucial for maintaining a healthy and collaborative team environment. The following tips apply to developers of all levels of experience, but they’re especially relevant for junior developers challenging senior developers’ code.

### Use "Why Not" Instead of "You Should"

Frame your suggestions or alternative approaches as questions rather than commands. This approach encourages discussion and allows the developer to explain their thought process.

Example: you notice that a developer did something that the framework’s documentation deprecates. Instead of telling “You should do it this way instead of that way”, consider “I notice the documentation suggest not doing it that way. Why not doing it this way instead?”.

### Be Open and Positive

Embrace a supportive tone in your comments, highlighting the positive aspects of the code and recognizing the developer’s effort. By fostering a positive atmosphere, you encourage continuous improvement and inspire your peers.

Example: “I wasn’t aware we could implement the function this way, thanks for helping me learn! Just wondering if it couldn’t cause performance issues, due to…”

### If You Think Something is Wrong, Suggest an Alternative

When you add a comment to suggest a change, always try to propose a specific way to make the change. For instance, if you think a variable or function name is wrong [(naming things is hard)](https://martinfowler.com/bliki/TwoHardThings.html), don’t just tell “Please give a better name to the variable/function”. Instead, you can tell “I think _thisName_ or _thatName_ would make more sense, what do you think?”

---

As a junior developer, participating in code reviews is an invaluable opportunity to enhance your skills, contribute to code quality, and collaborate effectively with your team.

By approaching code review with a desire to learn, sharing constructive feedback, and fostering a positive environment, you can make a meaningful impact on the development process.

Embrace code reviews as a chance to grow and improve, both individually and as part of a team.

<!-- _Cover photo by [Annie Spratt](https://unsplash.com/fr/@anniespratt)._ -->
