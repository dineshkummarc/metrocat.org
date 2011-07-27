---
layout: post
title: Identity Sample
date: 2005-11-13
author: Jeff Watkins
categories:
- TurboGears
---

Enough folks have had trouble getting the TurboGears identity framework to work that I thought I'd share the project I've been using to test various features as I add them.

The one user is `jeff` with password `foobar`.

There are two *interesting* pages: /secured and /logout. In order to see the secured page, you'll have to authenticate. When you request the /logout page, you're identity session is terminated.

This sample also demonstrates using the current identity from within a template.

**Note:** This sample will not work with the latest TurboGears code. Changes were made to the predicates and other code that makes this sample invalid. I'll see if I can't update the sample soon. (1/2/2006)