---
layout: post
title: One Word, Sounds Like
date: 2006-02-17
author: Jeff Watkins
tags:
- Design
---

Today I was thwarted by a voicemail directory. I called the main phone number for a company with an automated PBX. However, I didn't know how to spell the last name of the guy I was trying to call.

I'd heard his name several times over the phone, so I knew roughly how it was spelled, but not exactly. But I figured the PBX would be helpful and meet me half way. I therefore typed his name using the phone's keypad. When I finished typing the last "letter", the PBX repeated the prompt about typing in the last name. Clearly it didn't know who I was talking about.

This is an ideal opportunity for a [soundex algorithm](http://en.wikipedia.org/wiki/Soundex) or other phonetic matching algorithm. In a case like this (I thought there were two Bs rather than one), if the PBX were smart it would have computed the _sound_ of what I'd typed and used that to match instead.

Soundex is really, really cool and it's been around for ages. It was first patented back in 1918. I first used Soundex back in 1991 for a text search program and I've used soundex in MySQL a number of times.

Using an algorithm like Soundex, the PBX would have generated the value P614 for both versions (mine and the correct) of this name and would have connected me.

Fortunately, I managed to make the connection and life went on.