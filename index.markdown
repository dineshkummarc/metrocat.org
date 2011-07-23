---
title: Home
---

Roses are red
Violets are blue
I'm stinky
So are you

Foo this_is_code but this _is_ _silly_.

> "I'm a day vampire. I can go out during the day, not at night."
> -- Molly

This is my index

    !js
    var foo= function()
    {
        console.log("foo");
    };


Latest posts:

<ul>
{% for post in site.posts limit:10 %}
<li><a href="{{post.url}}">{{post.title}}</a></li>
{% endfor %}
</ul>

Categories:

<ul>
{% for category in site.categories_sorted %}
<li><a href="/{{category[0] | downcase}}">{{category[0]}}
  <span class="count">({{category[1].size}})</span></a>
</li>
{% endfor %}
</ul>