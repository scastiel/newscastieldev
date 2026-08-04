---
layout: page
title: Talks
permalink: /talks/
description: "I give talks in meetups and conferences about what I know the best: frontend development."
---
<figure class="talk-photo">
  <img class="post-cover" src="/assets/jug.webp" alt="Sebastien giving a talk" loading="lazy">
  <figcaption>Photo by <a href="https://twitter.com/nicoespeon">Nicolas Carlo</a></figcaption>
</figure>

{% assign upcoming = site.data.talks | where: "upcoming", true %}
{% assign past = site.data.talks | where_exp: "t", "t.upcoming != true" %}

## Upcoming talks

{% if upcoming.size > 0 %}
{% include talk-list.html talks=upcoming %}

_Follow me [on LinkedIn](https://www.linkedin.com/in/scastiel) to be among the first to know when I deliver a talk!_
{% else %}
_No talk is confirmed at the moment, but I hope to give new sessions soon! Follow me [on LinkedIn](https://www.linkedin.com/in/scastiel) to be among the first to know when I deliver a talk!_
{% endif %}

## Past talks

{% include talk-list.html talks=past %}

_Interested in seeing any of these talks at your meetup, or adapted as a workshop for your company?_

[Contact me →](/contact)
