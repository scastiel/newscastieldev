---
layout: page
title: Articles
permalink: /articles/
description: "I write about what I learn: programming, productivity, and building side projects."
redirect_from:
  - /posts
---
# Articles

I write about what I learn: programming, productivity, and building side projects.

{% assign articles = site.articles | sort: 'date' | reverse %}
{% include article-list.html articles=articles %}
