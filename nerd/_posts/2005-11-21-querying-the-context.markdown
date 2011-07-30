---
layout: post
title: Querying the Context
date: 2005-11-21
author: Jeff Watkins
categories:
- TurboGears
---

An important part of any ORM is being able to easily query the objects contained in the database. Not every ORM handles this particularly gracefully.

Probably the most graceful I've seen is the Pythonic query in [Dejavu](http://projects.amor.org/docs/dejavu/managing.html) where you literally write Python code which gets disassembled and turned into queries under the covers.

One of the least graceful is the SQLBuilder module which is part of [SQLObject](http://sqlobject.org). While I recognise the vast amount of really clever code that goes into making SQLBuilder work, I just find it icky. ***Note:*** *This is just my personal opinion.*


## High expectations ##

One of the goals for the querying facility within my ORM library is the ability to cleanly perform multiple queries. Given the following model:

    class Page(orm.Entity):
        name= orm.StringCol( length=200 )
        entries= orm.ToMany( dest="Entry", inverse="page" )
        
    class Entry(orm.Entity):
        data= orm.StringCol()
        lastModified= orm.DateTimeCol( defaults= datetime.now )
        
I want to be able to perform the following query: Find the `Page` that was most recently modified. Currently this is pretty tough. I've not spent enough time with Dejavu to know how I would perform this query with that library, but I'm pretty certain this would be a *really* nasty rat's-nest of SQLBuilder code.

## First steps ##

Last night I took the very first steps on the road to providing a clean query facility. I haven't yet built a parser for queries, so they must be built by combining objects (like SQLBuilder).

My tests used the following model:

    class Address(orm.Entity):
        street= orm.StringCol()
        city= orm.StringCol()
        state= orm.StringCol(length=2)
        zip= orm.StringCol()

    class User(orm.Entity):
        _tablename="users"

        name= orm.StringCol( alternateId=True )
        address= orm.ToOne( dest="orm.test.model.Address" )

I then created some Users with Addresses:

    u1= User( name="Jeff", address=Address( street="3 Market Sq Apt #3",
                                            city="Newburyport", state="MA",
                                            zip="01950" ) )
    u2= User( name="Anna", address=Address( street="3 Market Sq Apt #3",
                                            city="Newburyport", state="MA",
                                            zip="01950" ) )
    u3= User( name="Bean", address=Address( street="300 Brickstone Sq",
                                            city="Andover", state="MA",
                                            zip="01810" ) )

At the moment, I have to build the query by hand:

    a= orm.AttributeExpression( "address.city" )
    e= orm.ComparisonPredicate( a, orm.ConstExpression("Newburyport"),
                                orm.ComparisonPredicate.EQ )
    f=orm.FetchRequest( User, e )

But eventually I want to have the syntax something like:

    context.fetch( User, "address.city='Newburyport'" )

## A fetched collection ##

One of the driving reasons behind creating this query code (beside the obvious ability to retrieve objects from the database) is a `Query` column for `Entities`. These `Query` columns would contain a predefined database query that can access properties of the host object. So if I were building a smart playlist like in iTunes, I might have:

    class SmartPlaylist(orm.Entity):
        genres= orm.ToMany( dest="Genre" )
        songs= orm.Query( dest="Song", query="genre in ${genres}" )

I think this would be *really* powerful.
        
## Parser generator ##

Were I writing a C++ or Java library, I'd know where to go for a good parser generator. But what's the tool of choice for Python?