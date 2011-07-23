---
layout: post
title: Tagging is Tough
date: 2005-12-06
author: Jeff Watkins
tags:
- TurboGears
- Web
---

With all the talk about tagging and folksonomies (I hate that word), I encountered a discussion on Philipp Keller's site about the [database schemas behind tagging systems](http://www.pui.ch/phred/archives/2005/04/tags-database-schemas.html).

I've been thinking a lot about these sorts of things, because I'm still hoping to build a content management system using TurboGears. Understanding how the database is implemented is critical to the success of the task -- especially because I'm not an SQL wizard (as was demonstrated on the TG mailing list today).

The primary issue I hadn't resolved as yet was whether to permit tagging by users (and whether to permit tagging by anonymous users) or to restrict tagging to just authors. My impression is that adding user tags makes things considerably more complicated if you're keeping one user's tags distinct from any other's. And at least I *think* I should be.