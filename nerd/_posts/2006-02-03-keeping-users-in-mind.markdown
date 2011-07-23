---
layout: post
title: Keeping Users In Mind
date: 2006-02-03
author: Jeff Watkins
tags:
- Design
---

Kathy Sierra has a [really great article about designing for users rather than features](http://headrush.typepad.com/creating_passionate_users/2006/02/its_the_stupid.html). (Thanks [Josh](http://bokardo.com/) for linking to the [Creating Passionate Users](http://headrush.typepad.com/creating_passionate_users/) site.)

The closing paragraph really sums it all up:

> Most importantly, keep asking yourself, "How can I help my users kick ass?" And to answer that, you'll have to know the context in which users interact with your product or service. Chances are, whatever you provide is NOT their ultimate goal. It's just a tool to get to something that is meaningful.

My current project is building a wizard-ish tool to help our customers write adapters for their legacy host applications (think green screen terminal stuff) to our Identity Management product. At the moment, this task is really hard and requires a team of brilliant engineers to crank out each adapter.

Of course, if our customers *have* brilliant engineers, they probably have better things to do than write an adapter like this. So the goal for this project is to allow our customer's IT staff to create adapters using a point and click style interface. But that's not enough.

No. I want our customers to be able to build a complete adapter (using any one of the 4 currently supported terminal emulators) that embodies best-practice [single sign on](http://en.wikipedia.org/wiki/Single_sign-on) functionality in **under 15 minutes**.

The key to understanding this goal is to understand *who* I think my customers are. *My* customers aren't really the people who *buy* this product. My customers are the sales team and they don't have more than 15 minutes to demo the product. Therefore, with the time they *do* have, I really want them to be able to knock the audience's socks off.

Fortunately, by making this product simple enough for a sales guy (not even a sales engineer) to build an adapter, the end customer will have no trouble using it to accomplish his task.

The last version of the "Wizard" (for Windows and Web) included some flashy control highlighting features. So I've already set the bar pretty high. Once it's released, I hope to be able to include a screen cast of the finished product in my portfolio.