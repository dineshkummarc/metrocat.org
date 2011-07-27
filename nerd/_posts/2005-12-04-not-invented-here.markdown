---
layout: post
title: Not Invented Here
date: 2005-12-04
author: Jeff Watkins
categories:
- TurboGears
---

It's so tempting to question the decisions of those who went before you when you're getting to know a new programming environment. There are numerous things about Python that I'm not comfortable with yet (like line continuation, why not just indent a bit more to indicate a continuation?) but overall I think it's cool.

After [my attempt to build another ORM for Python](http://nerd.newburyportion.com/2005/11/everybodys-got-an-orm), I had lots of helpful and some not so helpful feedback. Several folks pointed out existing ORMs that I hadn't run across in my exploration of the available packages. One notable ORM is [SQLAchemy](http://sqlalchemy.org). With a little work, I think SQLAlchemy can address all of my requirements. Plus it's got some really cool features and a much more sane query mechanism than packages like SQLObject.

So in keeping with the words of Carl Sagan:

>â€œIn science it often happens that scientists say, â€˜You know thatâ€™s a really good argument; my position is mistaken,â€™ and then they actually change their minds and you never hear that old view from them again. They really do it. It doesnâ€™t happen as often as it should, because scientists are human and change is sometimes painful. But it happens every day. I cannot recall the last time something like that happened in politics or religion.â€ -- Carl Sagan, 1987

I'm going to apply myself to adding some functionality to SQLAlchemy that will make it feel a bit more declarative, while retaining the underlying power to step out of the declarative mode and kick ass.

And now that Mike (the SQLAlchemy author) has added MySQL support, my last reservation is removed. 
