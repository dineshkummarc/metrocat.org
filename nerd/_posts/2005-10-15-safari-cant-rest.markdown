---
layout: post
title: Safari Can't REST
date: 2005-10-15
author: Jeff Watkins
tags:
- Ajax
- Safari
- TurboGears
---

I've been working on an authentication system for [TurboGears](http://www.turbogears.org) and my forthcoming Content Management System.

I really wanted to support a REST interface to the admin console. For example:

    GET /admin/user/jeff HTTP/1.1
    Accept: text/javascript

Should return a JSON formatted object containing my user record. That actually works great.

The admin console will interact with the server by creating Ajax requests on the REST interface. Seems reasonable, right?

Except Safari translates the PUT and DELETE methods into **GET** methods. I suppose I should be happy that I can use GET and POST.

**UPDATE**: This is a known [bug in Safari's XMLHttpRequest](http://bugzilla.opendarwin.org/show_bug.cgi?id=3812) object. Now I wonder whether it will be fixed anytime soon.