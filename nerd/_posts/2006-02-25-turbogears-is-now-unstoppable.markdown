---
layout: post
title: TurboGears Is Now Unstoppable
date: 2006-02-25
author: Jeff Watkins
tags:
- TurboGears
---

I've long been of the opinion that one of the few things that's wrong with TurboGears is its reliance on SQLObject. While it's nice to hear that a new version of SQLObject is in the works, I'm not confident the newer version will be much better than the older.

After an aborted attempt to create my own ORM, [I've endorsed SQLAlchemy](http://nerd.newburyportion.com/2005/12/not-invented-here) and committed to helping out -- in my copious spare time.

Today marks an important milestone: You can now use [SQLAlchemy](http://sqlalchemy.org) in [TurboGears](http://turbogears.org).

<!--more-->

### SQLAlchemy meet TurboGears

True, you've really always been able to use SQLAchemy in TurboGears. It just wasn't pretty. Fortunately, Jonathan LaCour recently wrote a declarative layer on top of SQLAlchemy. I'd been meaning to address this, but I've not had time lately. And Jonathan has done a better job than I probably would have.

Beginning in revision 852, you can now make full use of SQLAlchemy in your TurboGears projects. I committed code that automatically commits your SQLAlchemy objects when the request succeeds. And with the new `PackageEngine` (in the `turbogears.database` module), you can create an `engine` based on the `sqlalchemy.dburi` property of your config file.

Enough with the talk already. Make with the code.

### Getting started

You start with SQLAlchemy much like you would with SQLObject. You'll need an engine. TurboGears includes a new `PackageEngine` that works just like the SQLObject `PackageHub` -- it pulls the connection uri from your application's configuration file.

    from sqlalchemy import *
    from sqlalchemy.ext.activemapper import *
    import turbogears

    __engine__ = turbogears.database.PackageEngine( "myproject" )
    
Now we have an engine. This engine will only be connected to the database when you actually make your first query. Now we can create our first model class.

    class Page(ActiveMapper):
        '''
        A page in our Wiki.
        '''
        class mapping:
            page_id= column( Integer, primary_key=True )
            pagename= column( String(30), unique=True )
            data= column( Unicode )
        
This should look familiar if you've read the [20 Minute Wiki Tutorial](http://www.turbogears.org/docs/wiki20/). The main difference is that the model definition occurs in a nested class named `mapping`.

You can specify that a column is indexed or unique simply by passing the appropriate keyword argument. _Note: `unique=True` implies `indexed=True`_. (These keywords aren't yet supported by the base SQLAlchemy `Column` class, but there's a ticket to implement it.)

Just like in the Wiki, we need to load the page in our index method:

    class WikiRoot(RootController):
        @turbogears.expose( template="alchemy.templates.page" )
        def index( self, pagename="FrontPage" ):
            page= Page.get_by( pagename=pagename )
            content= publish_parts(page.data, writer_name="html")["html_body"]
            return dict( data=content, pagename=page.pagename )
            
### Creating our first page

Creating the first page isn't any different than before. Fire up `tg-admin shell` and type:

    p= Page(pagename="FrontPage", data="Welcome to my front page")
    
Here's one different thing, the `shell` doesn't know to save your objects when you're using SQLAlchemy. So you need to do that by hand:

    objectstore.commit()
    
### Branching out

You could simply follow along with the Wiki tutorial, but you've probably done that before. And it wouldn't show you anything about relations in SQLAlchemy.

So let's create an `User` class that we can relate to each `Page` instance.

    class User(ActiveMapper):
        class mapping:
            __table__ = 'users'
            user_id= column( Integer, primary_key=True )
            user_name= column( Unicode(40), unique=True )
            password= column( String(40) )
            full_name= column( Unicode )
            
            pages= one_to_many( 'Page', backref='creator' )
            
And now we can add a creator relation to the `Page` class.

    class Page(ActiveMapper):
        '''
        A page in our Wiki.
        '''
        class mapping:
            __table__ = 'pages'
            page_id= column( Integer, primary_key=True )
            pagename= column( String(30) )
            data= column( Unicode )
            creator_id= column( Integer, foreign_key='users.user_id' )
            
            creator= relation( 'User', backref='pages' )

Now the `User` and `Page` classes are linked. Each `Page` has a creator and each `User` has a collection of the pages he has authored. You might notice that SQLAlchemy is quite a bit more explicit than SQLObject. You need to declare the `creator_id` column _and_ the `creator` relation. Some might think this a bit burdensome, however, lots of times I've wanted to override the default SQLObject magic, but I couldn't, because the SQLObject philosophy comes directly from [Henry Ford](http://en.wikipedia.org/wiki/Henry_Ford): "You better like Black, `cause Black is what we got."

### Back-references

One of the really neat features of SQLAlchemy is the notion of back references. Note in the definition of the `User` relation `pages` there's a `backref` argument. This tells the relation the name of the property on the other side of the relation which should be kept in sync with this relation. So if you add a page to the `pages` relation, its `creator` relation will be set appropriately.

This can get really powerful when you've multiple classes all connected via back-referenced relations. That's when things get particularly interesting.

### More later

I'm currently working on an example application using the ActiveMapper layer for SQLAlchemy. This example will demonstrate tagging and collaborative filtering. I've been waiting to do this until I could use SQLAlchemy, because SQLObject simply can't handle compound primary keys and is too limiting in a number of other ways. But now I have the _right_ tool for the job: SQLAlchemy.
