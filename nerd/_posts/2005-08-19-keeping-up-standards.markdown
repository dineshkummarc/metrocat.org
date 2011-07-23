---
layout: post
title: Keeping Up Standards
date: 2005-08-19
author: Jeff Watkins
tags:
- Web
---

I've an Atom 1.0 feed here, but Safari seems to choke on it. I've tested it via [the Feed Validator](http://www.feedvalidator.org/check.cgi?url=http%3A%2F%2Fmetrocat.org%2Fnerd%2Fatom.xml): it's definitely valid.

I suppose that's the danger of supporting the latest standards.
<!--more-->
I really like keeping on top of standards. If nothing else, it gives me something to do with the three to four hours I have free after working all day. But what should I do if the tools I rely on don't keep up with the standards?

Of course, this is something Web application developers are intimately familiar with in the saga of Internet Explorer's poor standards compliance. There's nothing you can do when a company essentially abandons their product.

In the case of Safari, it's definitely not an abandoned product: I received confirmation that the WebCore developers have even created a test case for the bug I submitted regarding the missing `caller` property on functions in Javascript. Safari is getting better every day.

But we don't get releases of Safari every day. We get them when Apple is ready to release them -- or when we build them ourselves.

So, should I "fix" the broken Atom feed by downgrading to Atom 0.3 or should I leave it and wait for Safari to catch up? Does anyone know of a way to hint to Safari that it should pick the RSS 1.0 feed?