---
layout: post
title: Refining the Identity Framework
date: 2006-01-21
author: Jeff Watkins
categories:
- TurboGears
---

My goal for any API I develop is to keep things simple. This is especially true for the TurboGears Identity framework, because it identity management and access control can be a pretty daunting concept for anyone to grasp.

> Making the simple complicated is commonplace;
> making the complicated awesomely simple, that's creativity.<br>
> -- Charles Mingus

So while there's still time before the 0.9 release, I've been wracking my brains to simplify while keeping in mind the developers who have more demanding needs. Today I checked in some changes that continue the trend towards making Identity easier to use and also make things a little more configurable.

###IdentityFailure exception###
Previously there were a number of places where I would handle an access control failure. I'd set the errors into the CherryPy request and then <strike>throw</strike> raise an `InternalRedirect` exception. This meant you couldn't signal an access control failure of your own. That's simple, but not very flexible or powerful.

Hence there's now a new exception, `IdentityFailure`, which you can raise (and which get's raised by the Identity framework) to signal that a custom access control check has failed. `IdentityFailure` is simply a subclass of the CherryPy `InternalRedirect` exception, so everything still works as expected. You pass the error or errors to the constructor before you raise the exception and the visitor will be directed to the appropriate URL.

    if identity.current.user.colour!="green":
        raise identity.IdentityFailure( _("You must be green to get in.") )

###Callable failure URLs
Previously, you could specify a single URL to which the visitor should be redirected upon the failure of an access control check. You can still do that, but you can *also* use a `callable` instead of a string to allow customising the URL based on the particular error.

So you could put the following into your config.py:

    import myapp.controllers
    identity.failure_url=myapp.controllers.url_for_identity_failure

And then in your controllers file add a function, `url_for_identity_failure`, that decides what the correct URL is.

    def url_for_identity_failure( errors ):
        if identity.current.anonymous:
            return "/login"
        else:
            return "/no-access"

This example would prompt the anonymous visitor to login while alerting registered users that they didn't have access to the resources.

###Customising the model###
Creating a custom model for the default IdentityProvider was a little complicated, you had to specify the name of the module containing your model classes. And all classes *had* to reside in one module (yeah, not a horrible restriction, but not *really* necessary). Taking advantage of the new configuration mechanism, you now specify the classes for the identity model directly. Take the following config file as an example:

    identity.soprovider.model.user="test.model.User"
    identity.soprovider.model.group="test.model.Group"
    identity.soprovider.model.permission="test.model.Permission"

This assumes you have a project named `test`, which I do, and that your classes are available via the `model` module. I think this is a little easier than the previous mechanism.

*NOTE:* You shouldn't name your model classes `TG_User`, `TG_Group`, and `TG_Permission` because the `TG_` prefix is reserved for TurboGears framework classes.

###Protecting an entire tree###
The Identity framework has offered two classes that promised to apply access controls to an entire controller tree: `SecureResource` and `SecureObject`.

`SecureResource` is a mix-in class you can add to your controllers so that every exposed method and every sub-controller will be protected by the access control predicate specified in the `require` class attribute.

`SecureObject` on the other hand is the tool of choice if you're attempting to apply access controls to a Controller you can't change. So if you're repurposing another controller from an Egg or similar, you can't change it's source code to include support for the TurboGears Identity framework. Just wrap it with a `SecureObject` and you're good.

The problem is neither of these worked prior to revision 551. Oops.

Additionally, as of revision 552, you can now specify the access control predicate for a `SecureResource` via the config file. Try this on for size:

    path("/secure_foo")
    import turbogears.identity
    identity.require = turbogears.identity.in_group("admin")

It's not ideal, because you have to import a messy module name and then fully qualify everything (there's a bug in the config code). But it works.
