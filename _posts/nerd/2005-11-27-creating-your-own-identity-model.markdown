---
layout: post
title: Creating Your Own Identity Model
date: 2005-11-27
author: Jeff Watkins
categories:
- TurboGears
---

Recently there's been some discussion on the TurboGears mailing list about how to get around a flaw in [SQLObject](http://sqlobject.org) where the classes from the SQLObjectProvider model are causing conflicts with existing model classes sharing the same names.

It's also become clear that many people *want* to extend the default model to include additional fields and capabilities.

So it makes sense to provide a short tutorial on how to create an alternate model for the SQLObjectProvider. But first, I need to explain how the Filter processes each incoming request.

<!--more-->

### Location of Identity information ###

A visitor's identity can be presented either via form fields or a cookie. You can configure the names of the form fields and the cookie via configuration parameters.

Future versions of the Identity filter might also look for identity credentials in HTTP Authentication headers and Atom Authentication headers. But today the two options are form fields and cookie.

#### Identity in the form ####

The filter first checks to determine whether the request contains identity credentials in the form fields. This allows visitors to authenticate as a different identity from whatever the cookie contains.

The sequence of operations for determining a visitor's identity based on form fields is shown in the figure below:

<div class="figure"><img src="http://newburyportion.com/photos/identity-from-form.png" alt="Identity From Form"/></div>

**Step 1**: The filter first calls the `identity_from_form` method of the provider (SQLObjectProvider in this case) to convert form fields into a valid identity. The provider pulls out the `userId` and `password` fields in preparation for loading the visitor's identity from the model.

**Step 2**: The provider calls its own method `validate_identity` passing the `userId` and `password` values it pulled out of the request fields. The provider then constructs an identity record based on the credentials (assuming the visitor really has an identity and that the password is correct). This identity record is returned to `identity_from_form`.

**Step 3**: The provider calls `send_identity_cookie` to create a cookie for the visitor -- that way credentials don't have to be supplied with each request. This cookie contains the visitor's user ID, an expiration time, and a Secret Token unique to this visitor. All this is securely signed using a SHA1 hash.

Once the cookie has been sent back to the visitor's browser, the identity is returned to the filter. The filter then makes the identity available via the thread-local storage wrapper `current`. You can refer to the current identity in your code with the following:

	from turbogears import identity
	if 'admin' in identity.current.groups:
		pass

For subsequent requests, the visitor's identity can be retrieved from the cookie.

#### Identity in a cookie ####

After a visitor authenticates using the login form, his browser will send the identity cookie on each request. The sequence of operations for the identity filter then becomes similar to the diagram below:

<div class="figure"><img src="http://newburyportion.com/photos/identity-from-cookie.png" alt="Identity From Cookie"/></div>

The filter will still attempt to discover the visitor's identity from form fields, however, none will be present. It will then ask the provider to pull an identity from the cookie.

**Step 1**: The filter calls `identity_from_cookie` on the provider. This method gets the value of the cookie and pulls out the visitor's user ID, the identity session's expiration time, and the cookie signature.

**Step 2**: In order to validate the cookie's signature, the provider calls its `secret_token_for_identity` method to retrieve the visitor's unique secret token. The default Identity provider uses the same secret token for all users, but the SQLObjectProvider uses the SecretToken model class to create a unique token for each user. This method returns a string representing the secret token.

The provider creates an SHA1 hash of the visitor's user ID, the identity session's expiration, and the secret token. This hash is compared against the signature of the cookie. If they don't match, the provider clears the cookie and returns `None` -- signalling that it couldn't find an identity in the cookie.

However, if the signature is valid, the provider then checks to determine whether the identity session has expired. If the expiration time has passed, the provider raises an `IdentitySessionExpiredException`. You can handle this exception in your login method.

**Step 3**: If the identity session hasn't expired, the provider calls its `load_identity` method to retrieve the identity record for the current visitor. The SQLObjectProvider will loads the necessary `User`, `Group`, and `Permission` objects to complete this task.

This identity is then returned to the filter, which stashes it in the `current` variable for use by your controllers.

### Creating a new model ###

Since not everyone is happy with the default model objects (I'm not either, but you don't want my model objects either).

Let's create a provider model like the following:

<div class="figure"><img src="http://newburyportion.com/photos/identity-howto-model.png" alt="Custom Identity Model"/></div>

Let's tackle the easy ones first:

    class SecretToken(SQLObject):
        userId= StringCol( length=16, alternateID=True )
        value= StringCol( length=40 )

    class Permission(SQLObject):
        permissionId= StringCol( length=16, alternateID=True )
        description= StringCol( length=255 )

    class Email(SQLObject):
        user= ForeignKey( "User" )
        name= StringCol( length=16 )
        address= StringCol()
    
That was easy. Now the slightly more complicated items:

    class User(SQLObject):
        userId= StringCol( length=16, alternateID=True )
        password= StringCol( length=16 )
        firstName= StringCol()
        lastName= StringCol()
        displayName= StringCol( default="" )
        personalInfo= StringCol( default="" )
        primaryEmail= ForeignKey( "Email", default=None )
        emailAddresses= RelatedJoin( "Email" )
        groups= RelatedJoin( "Group" )

    class Group(SQLObject):
        groupId= StringCol( length=16, alternateID=True )
        displayName= StringCol()
        owner= ForeignKey( "User" )
        members= RelatedJoin( "User" )
        permissions= RelatedJoin( "Permission" )

### Connecting our model ###

We now need to inform the default Identity provider, SqlObjectProvider, which classes it should use to handle the database. This is done with a few configuration statements in your `def.cfg` or `production.cfg` file.

    identity.soprovider.model.user="id.model.User"
    identity.soprovider.model.group="id.model.Group"
    identity.soprovider.model.permission="id.model.Permission"
    identity.soprovider.model.secret_token="id.model.SecretToken"

If you've created your database, you're ready to create a User and a Group and fire up the Identity Sample.

I'll be uploading an updated sample with a custom model shortly.