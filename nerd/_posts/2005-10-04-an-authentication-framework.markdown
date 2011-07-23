---
layout: post
title: An Authentication Framework
date: 2005-10-04
author: Jeff Watkins
tags:
- Ajax
---

#### Authentication baked into the framework ####

All the frameworks I've looked at have poor authentication support. Some don't have an authentication framework at all. Some support HTTP Basic Auth or HTTP Digest Auth. Others support form-based login withought HTTP auth.

Using form-based authentication is preferred for Web applications because you have complete control over the user experience. You can change the appearance of the login form; you can change the number and type of input fields; you can do anything.

HTTP Authentication has the advantage of simplicity. You can use HTTP auth to secure a folder on your Web server with only a few configuration parameters. You also have a surprising amount of flexibility with HTTP auth: your user records can be stored in a DB or in LDAP or in a flat file.

#### Authentication in an Ajax world ####

I've been working with [TurboGears](http://www.turbogears.org) lately to build out the server-side of the CMS. One of TurboGear's halmark features is the ability to seamlessly return either XHTML or Javascript objects in [JSON](http://www.json.org/) format. That's huge if you're working with Ajax like I am. When you combine the JSON data with my [DHTML Bindings Framework](http://metrocat.org/nerd/2005/08/dhtml-binding-example), you've got a *really* powerful toolset.

Ajax demands greater flexibility from authentication frameworks.

If you're using Ajax with form-based authentication, what do you do if the user's session expires and you need to redirect him to a login screen? I suppose you could send the HTML for the login screen back instead of JSON formatted objects, but your client-side code would have to be *very* smart.

Ideally, when building an Ajax application, you would respond with an HTML form for authentication when the browser requests an HTML page and an HTTP authentication error code when the browser uses an XMLHttpRequest to fetch a resource.

<div><img src="/photos/form-auth.png" alt="Form-based Authentication"/></div>

<div><img src="/photos/Ajax-auth.png" alt="Ajax Authentication"/></div>It's no secret that I'm not a fan of any of the big free (or reasonably free, like [MovableType](http://www.sixapart.com/movabletype/)) content management systems. They all lack something. Possibly, what they really lack is the key ingredient that [37signals](http://www.37signals.com/) has added to all of their products: simplicity.

I'm going to build my own content management system. I'll join the horde of open source (I suspect) CMSs. But I hope to be different, however, I'm not going to give away my secrets now.

Now I want to talk about authentication for Web applications.
<!--more-->
#### Authentication baked into the framework ####

All the frameworks I've looked at have poor authentication support. Some don't have an authentication framework at all. Some support HTTP Basic Auth or HTTP Digest Auth. Others support form-based login withought HTTP auth.

Using form-based authentication is preferred for Web applications because you have complete control over the user experience. You can change the appearance of the login form; you can change the number and type of input fields; you can do anything.

HTTP Authentication has the advantage of simplicity. You can use HTTP auth to secure a folder on your Web server with only a few configuration parameters. You also have a surprising amount of flexibility with HTTP auth: your user records can be stored in a DB or in LDAP or in a flat file.

#### Authentication in an Ajax world ####

I've been working with [TurboGears](http://www.turbogears.org) lately to build out the server-side of the CMS. One of TurboGear's halmark features is the ability to seamlessly return either XHTML or Javascript objects in [JSON](http://www.json.org/) format. That's huge if you're working with Ajax like I am. When you combine the JSON data with my [DHTML Bindings Framework](http://metrocat.org/nerd/2005/08/dhtml-binding-example), you've got a *really* powerful toolset.

Ajax demands greater flexibility from authentication frameworks.

If you're using Ajax with form-based authentication, what do you do if the user's session expires and you need to redirect him to a login screen? I suppose you could send the HTML for the login screen back instead of JSON formatted objects, but your client-side code would have to be *very* smart.

<div style="text-align:center">
<img src="/photos/form-auth.png" alt="Form-based Authentication"/>
<p>Form-based Authentication</p>
</div>

Ideally, when building an Ajax application, you would respond with an HTML form for authentication when the browser requests an HTML page and an HTTP authentication error code when the browser uses an XMLHttpRequest to fetch a resource.

<div style="text-align:center">
<img src="/photos/Ajax-auth.png" alt="Ajax Authentication"/>
<p>Ajax Authentication</p>
</div>

Sadly, none of the existing authentication frameworks seem to support this model. Of course, I could write a custom framework and plug it into TurboGears. But I'm rather hoping the unique nature of TurboGears encourages someone to build (or extend) a framework which supports both form-based and HTTP header-based authentication schemes.

I may be *too* optimistic.