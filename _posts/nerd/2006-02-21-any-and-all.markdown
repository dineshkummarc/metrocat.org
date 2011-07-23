---
layout: post
title: Any and All
date: 2006-02-21
author: Jeff Watkins
categories:
- TurboGears
---

I need to keep a closer eye on the tickets for Identity. There's a really interesting ticket up there about [changing the Identity predicates to use overloaded operators](http://trac.turbogears.org/turbogears/ticket/591) and it includes a note about `any()` and `all()`, which are new built-in functions which will make an appearance in Python 2.5.

On the one hand, I think it's wrong to overload binary operators (`&`, `|` and `~`) to mean boolean operators (`and`, `or` and `not`). Unfortunately, Python doesn't allow overloading the standard boolean operators; so this practice has become pretty widespread.

I don't like it and unless someone forces me to implement it, I'm not going to. (So there!)

<!--more-->

On the other hand, I'd not heard of the `any()` and `all()` built-in functions. I think they are very cool. That should be obvious because I basically have my own version of them in Identity. I think it's very important that the Identity predicates be able to work with these new functions. But there may be problems.

One of the features of the predicate system is that the predicates are evaluated at request time, not at creation time. I'm afraid `any()` and `all()` will be too aggressive and try to evaluate the predicates too early in the process. So I doubt you'll ever be able to do the following:

    @identity.require( all( in_group('admin'), has_permission('edit') ) )
    def index( self ):
        pass

My guess is that `all()` in the previous example will attempt to evaluate the predicates passed to it (which seems only reasonable). One of the reasons I implemented predicates as objects rather than functions was to allow them to be evaluated at the last possible moment. That would be lost if `all()` immediately evaluates all the predicates.

Additionally, based on my quick reading of Guido's proposal, I'd actually expect the syntax to me more like:

    @identity.require( all( [ in_group('admin'), has_permission('edit') ] ) )
    def index( self ):
        pass

And that's just plain ugly.

I'm not certain what the right answer is, but maybe this might be a good time to re-investigate some of the clever compiler-based hacks that would actually allow me to build a predicate using the built-in `and`, `or` and `not` operators. I know it can be done: one of the ORMs I looked at before getting excited by SQLAlchemy does it (although I've forgotten which at the moment).

And if I'm going to play around with the compiler, then there's no reason I can't twiddle the `all()` and `any()` built-in functions to evaluate later...