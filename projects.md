---
layout: page
title: Projects
permalink: /projects/
description: I always have several side projects ongoing.
---
# Projects

I always have several side projects ongoing. Here are the main ones.

{% assign projects = site.projects | sort: 'started' | reverse %}
{% include project-list.html projects=projects %}
