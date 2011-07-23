---
layout: post
title: VisitManager
date: 2006-02-27
author: Jeff Watkins
tags:
- TurboGears
---

Now that [TurboGears has experimental support for SQLAlchemy](http://nerd.newburyportion.com/2006/02/turbogears-is-now-unstoppable), I need to provide SQLAlchemy-based alternatives to the SQLObject components of Visit Tracking and Identity.

Writing a SQLAlchemy Identity Provider won't be a terribly difficult task, however, Visit didn't include facility for abstracting the database access. But now it does via the `VisitManager`.

<!--more-->

Frankly, the visit tracking code was already pretty simple, but in order to allow plugging in different database implementations I had to factor out some of the functionality. This is what I wound up with as the `BaseVisitManager`:

    class BaseVisitManager(threading.Thread):
        def __init__(self, timeout):
        def create_model(self):
        def new_visit_with_key(self, visit_key):
        def visit_for_key(self, visit_key):
        def update_queued_visits(self, queue):
        def update_visit(self, visit_key, expiry):
        def shutdown(self, timeout=None):
        def run(self):

Of these methods, you need to implement `create_model`, `new_visit_with_key`, `visit_for_key`, and `update_queued_visits` in order to create a new `VisitManager`.

In addition, I've added a `DeprecationWarning` when you access the `visit.id` attribute via `turbogears.visit.current().id` because there's no real way to guarantee the id will really be unique. However, the key is reasonably likely to be unique -- it's made up of enough random noise (time, remote_host, remote_port, etc) and hashed.

I also removed the `new_visit` method of Visit tracking plugins like Identity, because there's really no reason to have a separate call. The `record_request` plug-in method can simply check the visit to see whether the visit is new (via the `visit` argument passed to the callback).

So right now, there's a `SqlObjectVisitManager` class which is the default as specifyed via the `visit.manager` config option `sqlobject`. Pretty soon there will be a `SqlAlchemyVisitManager` for those of us who want a robust ORM.

You can add your own `VisitManager` class via the `turbogears.visit.manager` entry point.