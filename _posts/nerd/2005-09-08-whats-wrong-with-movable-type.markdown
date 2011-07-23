---
layout: post
title: What's Wrong With Movable Type
date: 2005-09-08
author: Jeff Watkins
categories:
- Web
---

I just upgraded our installation of [Movable Type](http://www.sixapart.com/movabletype/) to version 3.2. The new stream-lined interface is much better than version 3.1, but I've learned to absolutely loathe MT in the last two days.
<!--more-->
#### Design decisions ####

Everything in Movable Type, excepting the server configuration, lives in the database. While I understand that being able to query a database for the configuration of each Weblog is convenient, it makes using standard system development practices impractical.

For example, I have an installation of Movable Type on my laptop. This is where I develop the site and where I prototype new ideas and designs. The new version of Newburyportion has been running on my laptop in various stages of completion for several weeks. The nightmare began when I wanted to migrate my development environment over to the production server.

I had to step through each setup screen on the production system and compare the settings against the development system. At one point I accidentally crashed the import of the entries and made the Weblog non-functional (all the templates were missing). Unfortunately, there's no way to reset a Weblog and the Weblog IDs are non-repeating. So now my development system's IDs don't match my production system's IDs.

#### Regrets ####

I convinced my employer to purchase a license for Movable Type version 3.1 to be used in our private customer-facing development Web site. MT was my primary choice because I was familiar with it and we absolutely had to use the [MarkDown](http://daringfireball.net/projects/markdown) plug in to write about coding.

That Web site is divided into four sections: Articles, Downloads, Tips & Tricks, and internal information (for employees only). Each section is implemented as a separate Weblog within Movable Type -- in part so we could have different entry styling because MT doesn't offer customisable content types.

Fortunately, we built the site on what became the production server (after a month of testing and feedback, we moved the development server outside the firewall). Because if I had to go through the pain of migrating that development server over to a production server, I would have demanded my money back from Six Apart.

As it is, my employer will be purchasing a different system for any further releases of our customer community site. And I'll be looking for a new content management system for my own Web site.

#### What Movable Type does wrong ####

First, let me say that for what Movable Type was originally designed to accomplish, it is quite well suited. I'm not even unhappy with their lumbering and uncoordinated move into dynamic site publishing with PHP. I'm annoyed at how difficult it is to setup and configure a Movable Type server.

What's wrong with a text configuration file? Yes, editing that file within a friendly Web form complete with online help and hyperlinks and whirling progress indicators is great. But at the end of the day, the configuration information should be in a text file. The same text file that I can upload to the new server as part of the migration process.

Consider the process of creating the categories on a new server based on the categories of the development server:

1. Click on the category name on the development server.
2. Click on the create top level category link on the production server.
3. Enter the name of the new top level category and push the submit button.
4. After the page refreshes, click on the name of the new category.
5. Enter the description of the new category and push the submit button.
6. Wait for the page refrehs, then click on the link back to the category listing page.

Repeat that process for each category. The Journal section has 12 categories, the Nerd section has 10 categories (many without content yet), and the photo galleries have 11 categories. That's 198 steps. No wonder I forgot to enter the description on the [Work](http://metrocat.org/journal/work/) category.

However, if Movable Type were saving all this information to a text file rather than only into the SQLite database, all I would have had to do is upload a single file or at the worst, three files. (Unfortunately, my host doesn't support SQLite and I don't run MySQL on my PowerBook.)

#### Suggestions? ####

[Josh](http://bokardo.com/) would have me switch to [WordPress](http://wordpress.org). Except I've heard horror stories about the database schema for WordPress. And it doesn't solve the problem, because all configuration information is in the database.

What content management/Weblogging system doesn't suck?