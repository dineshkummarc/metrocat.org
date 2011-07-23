---
layout: post
title: If It Doesn't Buzz
date: 2005-09-21
author: Jeff Watkins
tags:
- Web
---

Jeremy Jones, writing for O'Reilly states ["I was compelled enough to give
TurboGears a spin. Why? I watched the TurboGears
video."](http://www.oreillynet.com/pub/wlg/7869). As much as it pains me to
admit it, that's largely what got me to try TurboGears too.

I've already written about searching for a Web application framework, and
last weekend I spent most of Friday night and all of Saturday (much to my
wife's consternation) searching for a really good platform I could build
on. I wanted to build on JSP because of the really cool tag library support
(I still think this is a critical addition to something like TurboGears),
but there was no way I could ever justify (or probably afford) a hosting
account that allowed me to run JSPs.
<!--more-->
During my investigations I'd run across [AxKit](http://www.axkit.org),
[CherryPy](http://www.cherrypy.org) (which is a vital component of
TurboGears), [Mason](http://www.masonhq.org), and numerous other packages
which really didn't interest me for a number of reasons. My criteria came
down to:

* **Built on an expressive Object-Oriented language** -- I've no desire to ever
    learn Perl. I won't say that people who code in Perl are bad people,
    but they certainly have a tendancy to write *really* bad code.
    Astoundingly bad, opaque code that simply can't be maintained. That's
    not Perl's fault, but if I'm going to dive into a framework, I want it
    to be understandable.

    Python may be a little funky, but it's definitely a first-class
    object-oriented language. And I'm especially grooving on the whole
    [function decorator syntax](http://www.python.org/peps/pep-0318.html).
    That's so cool. However, I'm not certain I like significant indentation
    (especially when tabs versus spaces makes a difference).

* **Shouldn't require sixteen pages of configuration directives** -- The
    thing I hate most about Microsoft's .Net platform is the reliance on
    configuration files. Worse, the config files are in XML. This may be
    going out on a limb a bit, but I don't think there is any format
    **less** readable than XML. For most configuration files, the syntax of
    XML represents a significant portion of the file. I don't have any
    statistics and I'm not willing to make some up, but XML is much less
    efficient, and no more expressive, than Java's resource files.

    At work our homegrown (AKA homegroan) unit testing framework is built
    in C#. In addition to being incredibly fragile (which is attributable
    to being developed by a QA guy as he was learning how to program), no
    one seems to be able to successfully configure the app. We've just
    barely managed to get two versions of the config file: one for testing
    directly from version control and one for testing on the QA machines.

* **Solved the entire problem** -- Too many of the packages I looked at
    solved part of the problem: mapping HTTP requests to objects, OR
    mapping, templating, or Ajax. But few of them put the entire package
    together. Those that did have a complete end-to-end solution clearly
    weren't production ready.

    Even when I'm just putting together a small Web application, I expect
    enterprise-level thinking. I want to know how something scales. I want
    to know how I can optimise the OR layer. I want to know how I can
    extend the framework in ways the original author may not have expected.

    There are clearly places where TurboGears is lacking -- the Kid
    templating package is good, but it lacks the extensibility of JSP's
    tag libraries. I've no reason to believe something like that couldn't
    be added as a filter within CherryPy.

* **Shouldn't require a full-fledge SQL server** -- using MySQL, PostgreSQL,
    Oracle or MSSQL is great, but it's not a useful development
    environment. It's also not conducive to trying something out. Yes, I've
    installed MySQL on my PowerBook, but it's never running.

    When the time comes to deploy a project, I expect any Web application
    framework will support the full-featured SQL servers, but during
    development (and more importantly for beta testers and early adopters)
    it's critical that the framework work with SQLite (or similar embedded
    SQL engines).

    I especially love the fact that [SQLObject](http://www.sqlobject.org/)
    supports both transparent updates to the database as well as explicit
    flushing. While it would be cool if it were to take a page from
    Hibernate's playbook and allow me to specify a context and have
    everything flushed to the database when I commit the context.

Naturally, I don't expect any framework to provide everything. Especially
not for free. Some of the features I miss from my days hawking BroadVisions
One-to-One Enterprise Web applications will just have to be written from
the ground up. That's OK, they're not that revolutionary any more. And
these features don't necessarily have anything to do with Web applications.

I'm curious to see how TurboGears lives up to my expectations. I'm also
curious to discover whether I've left anything out of my criteria...