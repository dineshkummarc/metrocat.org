---
layout: post
title: Identity Management for TurboGears
date: 2005-10-23
author: Jeff Watkins
categories:
- TurboGears
- Web
---

I just committed the code for the TurboGears identity management support (revision 89). And because this is such new code, I thought it might be helpful to include a short How To for getting everything up and running.

This How To is written from the perspective of a fresh quick-started project, but most everything applies for existing projects.
<!--more-->
1\. Create new project (idtest). Set dburi.

2\. Edit idtest.egg-info/sqlobject.txt

        db_module=idtest.model, turbogears.identity.model.somodel

3\. Create login.kid
        
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
            "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml"
            xmlns:py="http://purl.org/kid/ns#"
            py:extends="'master.kid'">

        <head>
            <meta content="text/html; charset=UTF-8"
                http-equiv="content-type" py:replace="''"/>
            <title>Login to TurboGears</title>
        </head>

        <body>
            <h2>Login</h2>
            <p>${message}</p>
            <form action="${previous_url}" method="POST">
                <label for="user_name">User Name:</label>
                <input type="text" id="user_name" name="user_name"/><br/>

                <label for="password">Password:</label>
                <input type="password" id="password" name="password"/><br/>

                <input type="submit" value="Login"/>
            </form>
        </body>
        </html>

4\. Create secured.kid

        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
            "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml"
            xmlns:py="http://purl.org/kid/ns#"
            py:extends="'master.kid'">

        <head>
            <meta content="text/html; charset=UTF-8"
                http-equiv="content-type" py:replace="''"/>
            <title>Welcome to Secured TurboGears</title>
        </head>

        <body>
            <h2>Secure!</h2>
            <p>This page is secured.</p>
        </body>
        </html>

5\. Modify controllers.py

        from turbogears import identity
        import cherrypy
    
        @turbogears.expose( html="idtest.templates.login" )
        def login( self, *args, **kw ):
            if hasattr(cherrypy.request,"identity_exception"):
                msg= str(cherrypy.request.identity_exception)
            else:
                msg= "Please log in"
            cherrypy.response.status=403
            return dict( message=msg, previous_url=cherrypy.request.path )

        @turbogears.expose( html="idtest.templates.secured" )
        @identity.require( group="admin" )
        def secured( self ):
            return dict()

6\. Turn on Identity management and configure failure url in dev.cfg

        [global]
        identity.on=True
        identity.failure_url="/login"

7\. Create the database

        tg-admin sql create

8\. Create a user and group

        tg-admin shell

        Python 2.4.1 (#2, Mar 31 2005, 00:05:10) 
        [GCC 3.3 20030304 (Apple Computer, Inc. build 1666)] on darwin
        Type "help", "copyright", "credits" or "license" for more information.
        (InteractiveConsole)
        >>> from turbogears.identity.model.somodel import *
        >>> hub.begin()
        >>> u=User( userId="jeff", emailAddress="jeff@metrocat.org",
                    displayName="Jeff Watkins", password="xxxxx" )
        >>> g=Group( groupId="admin", displayName="Administrators" )
        >>> hub.commit()
        >>>
    
9\. Start project and visit secured page and login. Should fail with message:

        Not member of group: admin

10\. Add user to admin group

        tg-admin shell

        Python 2.4.1 (#2, Mar 31 2005, 00:05:10) 
        [GCC 3.3 20030304 (Apple Computer, Inc. build 1666)] on darwin
        Type "help", "copyright", "credits" or "license" for more information.
        (InteractiveConsole)
        >>> from turbogears.identity.model.somodel import *
        >>> hub.begin()
        >>> u=User.get(1)
        >>> g=Group.get(1)
        >>> u.addGroup(g)
        >>> hub.commit()
        >>>

11\. Revisit secured page and login. Should succeed.

**Update:** There is now a [sample identity project](http://newburyportion.com/nerd/2005/11/identity-sample) which demonstrates this and some of the latest features of the identity framework. It's actually the project I use to test features of the framework.