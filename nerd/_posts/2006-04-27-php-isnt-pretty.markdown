---
layout: post
title: PHP Isn't Pretty
date: 2006-04-27
author: Jeff Watkins
categories:
- Web
---

I've been working on a PHP-based Web site for my employer -- tying together [WordPress](http://wordpress.org) and [Vanilla](http://lussumo.com) under an [SSO](http://en.wikipedia.org/wiki/Single_sign-on) umbrella -- and I'm impressed by how awful the PHP language is.

In the past I've resisted learning PHP because it always struck me as a toy Web scripting language. And as I've delved into it, my initial impressions have only been confirmed. There are so many places where things behave unexpectedly or inconsistently that it's hard for me to imagine that anyone can *truly* be very productive with this environment.

On the other hand, there are clearly quite a few Web sites that are very successful using PHP and there's a tremendous amount of momentum behind the language. I just wish it wasn't so ugly.

Some highlights of things I find unpleasant:

* The whole dollar sign marker for variables is just lame. It makes me wonder whether the first versions of PHP even had a real grammar. I suspect it was just a bunch of regular expressions hacked together to generate HTML.

* Associative arrays are wonderful, but the syntax PHP uses for them is simply unbearable. How about something akin to JavaScript or Python?

* Objects are definitely an afterthought. Almost everything is a function so the global namespace quickly becomes polluted and you have to resort to prefixing your functions with little markers (everything in my current project is prefixed with *idm\_* and it's driving me nuts).

If I weren't already over committed in so many areas, I'd consider trying to put a JavaScript syntax onto PHP -- there are already projects to integrate Mozilla's SpiderMonkey with PHP.

I hate to say it, but I actually *miss* writing good, old-fashioned ASPs in JavaScript. That was a good environment -- especially the BroadVision implementation with the rich content management and personalisation services. Oh, well. I don't suppose BroadVision is likely to release One-to-One as Open Source any time soon.

