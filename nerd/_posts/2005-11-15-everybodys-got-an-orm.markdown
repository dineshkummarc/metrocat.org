---
layout: post
title: Everybody's Got An ORM
date: 2005-11-15
author: Jeff Watkins
categories:
- TurboGears
---

If you look at the python.org Web site, there are quite a few different object relational mapping (ORM) libraries for Python. The only one I'm really familiar with it [SQLObject](http://sqlobject.org), because that's what's included with TurboGears.

[Ian Bicking](http://blog.ianbicking.org), the principal author of SQLObject, has done a really great job creating a library that supports Python back to 2.2, lots of different databases, and probably more features than I understand. However, SQLObject differs significantly from other ORMs I've used, like [Hibernate](http://hibernate.org) and [CoreData](http://developer.apple.com/documentation/Cocoa/Conceptual/CoreData/index.html).

My goals for an alternative ORM are the following:

* No Magic -- The dynamic nature of Python lends itself to magic solutions, metaclasses and twiddling under the covers.
* Conservative Network Traffic -- In order to scale smoothly, Web applications (and any other application) must be extremely careful to optimise communication with the DB server.
* Rich Support for Idiomatic Programming -- Reducing the number of compromises necessary just because the data will live in a database will make developing applications quicker, easier and ultimately more robust.
<!--more-->
#### Some Quick Examples ####

I just want to throw out a few quick examples before diving in. The examples all use the following model:

<div style="text-align:center;">
<img src="/photos/model.png" alt="Model">
</div>

The Python code for this model looks like this:

    import orm

    class Genre(orm.Entity):
        name= orm.StringCol( length=200, alternateId=True )
        books= orm.ToMany( dest="Book", inverse="genres" )

    class Book(orm.Entity):
        title= orm.StringCol( length=200 )
        genres= orm.ToMany( dest="Genre", inverse="books" )
        author= orm.ToOne( dest="Author", inverse="books" )

    class Author(orm.Entity):
        name= orm.StringCol( length=200, alternateId=True )
        books= orm.ToMany( dest="Book", inverse="author" )

So far this doesn't look significantly different from entities defined when using SQLObject.

#### No magic ####

Python has some really cool features like metaclasses and first-class class types. However cool these features may be, overuse tends to leave developers feeling like magic is happening while they aren't looking.

In the example model above, all the attributes defined on each model class are descriptor objects. Nothing fancy happens under the covers. (Yes, there's a metaclass, and I'll explain what it's for later.)

For example, what's the length specified for the title column of the Book entity?

        >>> Book.title.length
        200

There are two bits of minor magic happening in the orm library.

The first bit of magic is where the column values get stored: because the attributes are descriptors, I can't store the value from the database in an attribute with the same name. So they are squirrelled away in a *private* dictionary of column values. This has a few advantages which I describe in a moment.

The second bit of magic is a metaclass (`EntityMeta`) that picks up the column descriptors and creates a *private* dictionary of columns and relations. The metaclass will also create a primary key if you didn't specify one, although you are permitted and even encouraged to define your own primary keys. The metaclass also adds each entity class to the `ClassRegistry`.

#### Conservative network traffic ####

One of the things I like most about Hibernate (and it certainly isn't the XML push-ups necessary to get it configured) is the notion that nothing gets sent to the database until I commit the `Session`. This is *huge*. If I create a bunch of objects and after considerable work discover everything is all horked up, I call `rollback` and I've only wasted my own time. Nothing ever touched the database server.

Furthermore, if I have a `Genre` with 10,000 books in it, when I load that `Genre` into the `Session`, those 10,000 books aren't materialised. They are loaded lazily as I request them (or not, it's up to me).

I've tried *very* hard to mimic this behaviour with the orm library. Nothing is transferred from the database unless you expect to use it. There are two objects that make this possible: `ObjectFault` and `ColumnFault`. Basically a fault is merely some data that I haven't retrieved yet. So an `ObjectFault` is an entire object that hasn't been retrieved (kind of the inverse of a `WeakReference`) while a `ColumnFault` is a single column, like a BLOB, that will be loaded when needed.

Because the column values are stored in a *private* dictionary and accessed via the column descriptors, I can convert a `Fault` into the real thing when first accessed. Furthermore, I can track which columns have changed and only send the modified columns when updating the database.

In the future, I'd like to load dependant objects (not discussed yet) and possibly the destination of to-one relations using joins during initial selects. I'd also like to have component objects, which are defined by columns in the same table as the component object's container. Consider an Author's address. You *could* have a separate table for addresses (usually what I do) or you could put the street, city, state, and zip code columns in the Author table. By defining a component object as defined by those columns, you get the advantage of object-oriented design and tabular simplicity.

#### Rich support for idiomatic programming ####

Let's create a sample book:

        >>> b= Book()
        >>> b.title= "Thud"
        >>> b.title
        'Thud'

And now let's create an author for this book:

        >>> a=Author()
        >>> a.name="Terry Pratchett"
        >>> a.books.add(b)

The books attribute supports the same interface as a set object. But unlike a regular set, this set *knows* that it is part of an two-way relation. When we add a book to the collection, the relation is automatically updated. In this case, the author is set for the book.

        >>> b.author.name
        'Terry Pratchett'

This knowledge of the relationship between columns extends to many-to-many relations as well as one-to-many relations.

        >>> g1= Genre()
        >>> g1.name= "Fantasy"
        >>> g2= Genre()
        >>> g2.name= "Humour"
        
        >>> b.genres.add( g1 )
        >>> g2.books.add( b ) 

        >>> list(b.genres)
        [<__main__.Genre object at 0x2c2cb0>,
         <__main__.Genre object at 0x2c2db0>]

        >>> list(g1.books)
        [<__main__.Book object at 0x2c2cd0>]

Although I haven't actually written them yet, I fully expect to have both `list` relations and `dict` relations. Currently the ToMany relation is mapped as a `set`, which means the objects are returned in no particular order. However, a `list` relation would include a third column to use for ordering. In the case of a one-to-many relation (like author-books), this ordering column might be the title of the book or the publishing date (not shown in the model).

Dictionary relations would require an intermediate table (unless the dictionary key is a value in the to-many object?) which would contain three columns: id1, id2, and dict-key.

#### Plugging it together ####

Obviously there's a bit of code under the covers. The diagram below attempts to put some of the pieces in place.

<div style="text-align:center;">
<img src="/photos/relation.png" alt="Everything">
</div>

The parts in baby-blue are long-lived objects which (will) be thread-safe. And the parts in pinky-red are ephemeral objects you use and discard.

Probably another example would help. I'll use a TurboGears-y example:

    import orm
    
    storage= Storage( "sqlite:///users/jeff/Projects/Web/orm/test.db" )
    
    class Root( controllers.RootController ):
    
        @expose( html="templates.index" )
        def index( self ):
            context= storage.context()
            book= context.load( Book, 1 )
            return dict( book=book )

Loading an object isn't quite as convenient as the equivalent code in SQLObject, but this allows entity objects to be stored in several different databases. And it's possible to do something clever like looking for a thread-local `Context` and loading the book via that.

#### Fly in the ointment ####

Of course, all the code barely registers as Alpha quality code. But there's one nasty bug that I know about: using autoincrement key generators can mean some to-one relations don't get set correctly. There's an *easy* solution to this problem: I just need to rearrange the order in which objects are saved based on the to-one relations.

This bug only rears its head when you have a to-one relation: either to-one, one-to-one or one-to-many. It never happens when you have a to-many or many-to-many relation (which have intermediate tables).

In that case one or both entities have a foreign key for the other (a ToOne column). If you're using autoincrement keys (the only option at the moment) obviously one of these columns has to allow a null value, because one of the objects isn't going to have a primary key when the other is inserted.

I'm fairly certain libraries like SQLObject also have this problem, but I've not bothered to write a test case for it.

So the trick will be to determine which entity allows a null value in the ToOne column and save that one first. Then save the other entity and update the first. Not perfect, but Relations (from which ToOne is derived) already have a notion about which side is the primary relation. So I can probably hook into that.

#### Take a look ####

You're welcome to take a look at the source code. It's available from my subversion server (I love TextDrive):

[http://newburyportion.com/svn/orm/](http://newburyportion.com/svn/orm/)

I try to keep things reasonably up to date.