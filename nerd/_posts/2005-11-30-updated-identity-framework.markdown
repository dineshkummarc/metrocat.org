---
layout: post
title: Updated Identity Framework
date: 2005-11-30
author: Jeff Watkins
tags:
- TurboGears
---

I've just checked in revision 255 which contains modifications to the Identity framework.

Probably the most significant is that the default Identity provider, `SqlObjectProvider`, model classes are now prefixed with `TG_`. So you have `TG_User`, `TG_Group`, `TG_Permission`, `TG_SecretToken`. This was necessary because the SQLObject registry feature is broken and prevents you from linking your model objects to the identity model -- so you can't have a foreign key to a user anywhere in your model. However, to prevent naming clashes (because SQLObject doesn't use fully qualified class names), we had to prefix the classes with `TG_`. I'm *really* not a fan of prefixes like this, but there was no other alternative.

For those of you who would like to implement your own provider or tweak the behaviour of the current provider, you'll be happy to note that almost all of the functionality that formerly lived in the Filter has been factored out into the `IdentityProvider` base class.

The filter now calls only the following methods:

    provider.identity_from_form()
    provider.identity_from_cookie()
    provider.anonymous_identity()

So if you want to completely change how the cookie is generated, you'll want to create a subclass of `IdentityProvider` that overrides the methods `identity_from_cookie` and `send_identity_cookie`. Go wild.

Additionally, I removed the thread local storage. The current identity is now stored in the CherryPy request object as `identity`. For backwards compatibility, the current identity is still available as `turbogears.identity.current` and is also still exposed via the `std` kid variable.

Finally, I added checks to the `IdentityWrapper` object (what `turbogears.identity.current` really is) that will detect whether identity management is turned on and throw the appropriate exception. This means you should get better error messages should you attempt to access the current identity when you've forgotten to turn on identity management in your config file.

As usual, please let me know if I broke something or haven't addressed a problem you've been encountering.