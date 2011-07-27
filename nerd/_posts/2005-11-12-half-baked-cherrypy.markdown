---
layout: post
title: Half-baked CherryPy
date: 2005-11-12
author: Jeff Watkins
categories:
- TurboGears
---

As part of my work on the Identity framework for [TurboGears](http://www.turbogears.org), I've had to write a filter for [CherryPy](http://www.cherrypy.org). While I'm certain the team building CherryPy is well meaning, I doubt whether there's a coherent design in place.
<!--more-->
For example, because CherryPy doesn't allow filters to catch and handle exceptions thrown, er, raised by the controllers, I've had to resort to throwing, er, raising an `InternalRedirect` exception which is somewhat strange.

One of the latest features of the framework raises an `IdentitySessionExpiredException` when your login has expired (um, duh?). However, because only the filter is able to check your identity credentials to determine whether your session has expired, I need to redirect as part of the `beforeMain` filter function.

Wouldn't you know it? This just happens to be outside the function that catches the `InternalRedirect` exception when it's thrown, damn, raised. Of course, I could fuck with the internal and almost entirely undocumented `cherrypy.request.objectPath`. Why is this even necessary?

Fortunately, all of this Python stuff ships with source code. After pouring over the code for CherryPy, I've discovered I can magically change the `cherrypy.request.objectPath` value to the URL I would normally use as the parameter to `InternalRedirect`.

## Inadvisability of casting stones ##

Of course, there's likely to be *someone* who'll point out that I still haven't documented the Identity framework. That's definitely true. I've been meaning to, but this whole product release at work has taken most of my attention and the rest has been consumed by writing an ORM for Python (I'm trying to crossbreed Hibernate and CoreData). But I haven't forgotten my obligation to document what I've built. Ultimately, the docs will include this spiffy diagram drawn in [OmniGraffle](http://www.omnigroup.com/applications/omnigraffle/).

<div style="text-align:center">
<img src="/photos/identity.png" border="0" alt="TurboGears Identity Framework">
</div>

I hope to get started on the documentation this weekend. After all, I will be committing some changes to the framework to make it a little more customisable -- perhaps not as much as some would like, but more than it already is. Of course, I'm getting *really* close to being able to read & write from SQLite with my new ORM, so maybe that will be more pressing.

And there's [more painting to be done](http://newburyportion.com/journal/2005/11/oh-my-gods-its-yellow) too...