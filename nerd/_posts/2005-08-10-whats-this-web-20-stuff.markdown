---
layout: post
title: What's This Web 2.0 Stuff
date: 2005-08-10
author: Jeff Watkins
categories:
- Web
---

I don't really mean to be contrary (No, really, I don't). But I don't get all this Web 2.0 stuff. Yes, I've read about [Tim Bray's discomfort with the Web 2.0 moniker](http://www.tbray.org/ongoing/When/200x/2005/08/04/Web-2.0). And I've read [Tim O'Reilly's response](http://radar.oreilly.com/archives/2005/08/not_20.html). But I just don't get it.

The Web hasn't reached its second major revision. I'd be generous if I even said it was in the Beta phase of 1.0. Here's what I think we really need before we can claim the Web has *really* become a platform (hence 1.0).


It seems everyone has an opinion on the whole Web 2.0 meme. Just check the [del.icio.us tag *Web 2.0*](http://del.icio.us/tag/web2.0). Everyone's got something to say about it -- and now I do too.

My buddy Josh over on [Bokardo](http://www.bokardo.com/) has written about the whole thing several times -- he calls it the [Era of Interfaces](http://bokardo.com/archives/web-20-as-the-era-of-interfaces/), which I like rather better than Web 2.0. Josh thinks more about these things that I do -- and his insights are usually better reasoned than mine.

But after a decade of building Web applications, I can tell you that the Web as a platform is just beginning to be worth the attention. Although some of the technologies we played with back in 1996 (like using Java applets to communicate back to the server to do form validation) are only now becoming convenient and commonplace, we still have a long way to go.

Here's my list of what the Web really needs to be a credible 1.0 environment:

1. A robust, [unobtrusive](http://domscripting.webstandards.org/?page_id=2) MVC framework.

2. Stateful, persistent, two-way network connections.

3. Scalable Vector Graphics implementation in all browsers.

4. Other stuff


## Model View Controller Framework ##

Josh turned me on to a article by an IBM blogger [comparing Web 2.0 and MVC](http://www-128.ibm.com/developerworks/blogs/dw_blog_comments.jspa?blog=392&entry=92098&ca=drs-bl). It's a cool article, but it glosses over the fact that one of the greatest approaches to building robust user interfaces is completely missing from Web applications.

Yes, lots of server-side frameworks support a MVC-like implementation. But its a pale comparison to a real client-side implementation. Frameworks like Spring and Java Server Faces and the bizarre ASP.Net might work great when you have a Gigabit ethernet network at your disposal, but why are we foresaking the processing power sitting on the *other* end of the network connection? When was the last time you sat down at a computer that didn't clock in over 1GHz? (Now that I've upgraded my aging iBook I'm in the 1+GHz club too.) Whether you buy into the Megahertz Myth or not, there's a lot of horsepower sitting on your desktop: all to display an HTML page.

I want to be able to write HTML like the following to define an address book table:

    <table id="userTable" contentKeyPath="applicationState.people">
        <caption>Address Book</caption>
        <col displayValueKeyPath="applicationState.people.firstName">
        <col displayValueKeyPath="applicationState.people.lastName">
        <col displayValueKeyPath="applicationState.people.emailAddress">
        <thead>
            <tr>
                <th>First Name</th>
                <th>Last Name</td>
                <th>Email Address</td>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>

I'd expect designers to put sample data into the table while using DreamWeaver or a similar tool, but when it loads in the application it should be filled in automagically.

That covers both the Model and the View. You'll probably still have to write the controller. That's just life. But taking a page out of Apple's book (again), we can expect things like ObjectControllers, ArrayControllers, and even TreeControllers that manage selection and handle inserting new objects into your model.

And for god's sake, figure out how to do *real* undo.

## Stateful, Persistent, Two-Way Network Connections ##

Don't get me wrong, having XMLHttpRequest built into every modern browser is really nice. I've used it now in a host of little ways from the [search field on this Web site](http://metrocat.org/nerd/2005/08/05/search-via-ajax) to long-running server processes which would otherwise cause the form submission to timeout. But XMLHttpRequest is a one-shot, one-way communication mechanism: the server can't call me to let me know something interesting has happened.

What I really want is an XMLHttpConnection object: a two-way, XML-packet based communication channel. This should share the browser's cookies so the connection has access to my server session. I should be able to install a callback for receipt of a packet as well as completion of a request.

There's no need to specify how the server side of XMLHttpConnection should work. I leave that as an exercise to the implementers, but I'm certain it can be shoehorned into the HTTP 1.1 specification. For example, we could use the [Jabber/XMPP protocol over HTTP](http://www.jabber.org/jeps/jep-0124.html). This would mean anyone could run a server or you could use any one of the existing servers.

This would be huge.

There are already server applications that communicate via XMPP. This would give them something to do. Heck, someone's probably already doing this and it will be the next big thing.

There are probably political reasons why we'll never see Microsoft adopt XMPP -- hell, they still haven't supported PNGs properly and won't until Internet Explorer 7. Maybe.

Don't even bother suggesting SOAP. SOAP is dead as far as I'm concerned. It gave lots of people something to worry about while the rest of us got on with building applications. RESTful XML protocols like ATOM have shown themselves to be far superior, because you can actually understand them. And if you can understand them, you can use them.

That's where XMLHttpRequest (and the whole Ajax thing) wins big: everyone can understand it. Hell, the whole API for XMLHttpRequest only has a handful of methods. That's so easy even I grasped it the first time I read it.

## Scalable Vector Graphics in *ALL* Browsers ##

SVG has been around for ages. Really. Ages. I can remember talking to an investor about building a Web-based Visio application using SVG. At the time support was limited to a plug-in from Adobe. But now browsers are starting to include support for SVG natively. [Eric Seidel has started implementing SVG in Safari's WebCore.](http://webkit.opendarwin.org/blog/?p=7). The Mozilla project is working steadily on [adding SVG to Firefox](http://www.mozilla.org/projects/svg/).

Basically, I'm tired of using images to *draw* my Web application's interface. I want to be able to specify the content of an HTML element in SVG. I want to be able to create a div that uses an SVG gradient fill for its background.

This is so simple that there really isn't much more to write about it. Let's implement SVG already.

## Other Stuff ##

Of course there's other stuff I'd like to see in the Web application platform. Most of it is minor: like being able to reliably specify that a page should occupy the entire browser window.

What would you think Web 1.0 needs before it can exit Beta test and become a *real* application platform?