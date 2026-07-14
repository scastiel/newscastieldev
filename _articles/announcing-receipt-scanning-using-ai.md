---
sitemap: false
title: "Announcing Receipt Scanning Using AI"
date: '2024-01-31'
excerpt: >-
  Spliit now lets you create an expense by taking a photo of a receipt, using OpenAI's GPT-4 with Vision to automatically extract the title, category, amount, and date.
lang: en
canonical_url: https://spliit.app/blog/announcing-receipt-scanning-using-ai/
source_name: Spliit Blog
source_url: https://spliit.app/blog
---

When I created Spliit, I wanted it to be minimalist and not implement dozens of features that nobody uses. Spliit is an open source project, and many users suggest features (see [the issues on GitHub](https://github.com/spliit-app/spliit/issues)). It is sometimes hard to decide which features are worth implementing. This time, it was an easy choice: if I can make it faster to create expenses, I have to do it.

I’m excited to announce that you can now create a new expense by taking a photo of a receipt:

![Screenshot of the new Receipt button in Spliit’s UI](/assets/posts/announcing-receipt-scanning-using-ai/receipt-button.webp)

You will be presented a dialog, where you can upload an existing a photo or take a new one. And if everything goes right (and I worked hard to make sure it does), the magic happens and you can see information extracted from the receipt: a title, a category, the expense amount and its date.

![Screenshot of the new dialog to create an expense by scanning its receipt](/assets/posts/announcing-receipt-scanning-using-ai/scan-dialog.webp)

If the information looks (mostly) correct, you can create the expense and adjust some information if needed, like a wrongly guessed date or category. The receipt photo will be attached to the expense in case you or your friends need it.

Of course, I know that there might be some wrong guesses. We’ll need to adjust a few parameters to make better guesses, but I am thrilled to see that it is already working so well!

Are you curious about how it works? Good news, as Spliit is open source, you can just go to GitHub and see how I implemented the feature. Here is a hint: [it happens in this file](https://github.com/spliit-app/spliit/blob/main/src/app/groups/%5BgroupId%5D/expenses/create-from-receipt-button-actions.ts#L8) 😉. Long story short, we rely on Open AI’s GPT 4 with Vision API to read the image and extract information from it. The prompt is fairly simple, and can be updated when new fields are added to expenses.

I hope you’ll find this feature useful. Feel free to test it, and if you want to contribute to the project, have a look at [our GitHub repository](https://github.com/spliit-app/spliit).

---

A huge thanks to everyone who contributed to [the original issue on GitHub](https://github.com/spliit-app/spliit/issues/23): [@rgov](https://github.com/rgov), [@manuerwin](https://github.com/manuerwin), [@vladartym](https://github.com/vladartym), [@adiso06](https://github.com/adiso06). This feature is here because of you! ❤️
