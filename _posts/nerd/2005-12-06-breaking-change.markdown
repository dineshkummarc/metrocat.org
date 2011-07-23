---
layout: post
title: Breaking Change
date: 2005-12-06
author: Jeff Watkins
categories:
- TurboGears
---

I just committed change number 290 to the TurboGears subversion repository and it breaks everything!

Well, not really, but it will break every existing system using the default Identity provider (SqlObjectProvider). The reason for this change is that I misread the SQLObject documentation on joins -- which is pretty easy to do because they don't make any sense to me. I had mistaken `joinColumn` for `otherColumn`.

Now you have to rebuild your database. Sorry about that.
