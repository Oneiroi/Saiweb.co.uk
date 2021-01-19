--- 
wordpress_id: 637
layout: post
title: Wordpress Flowplayer 2.1 Preview
date: 2009-04-14 16:00:45 +01:00
tags: 
- flowplayer
- wordpress
- 2.1.0.0
- wordpress flowplayer
categories: 
- php
- flowplayer
wordpress_url: https://blog.oneiroi.co.uk/php/wordpress-flowplayer-21-preview
comments: true
---
Tonight I will be pushing to the development SVN a beta preview of the 2.1 release.

Here are some of the changes:


<strong>Poor tags, we barely knew them...</strong>

GOODBYE! inpost tags, (sort of), configuration will no longer be handled using the inpost tags, the old tag structure will be retired in favor of an anchor to place the player in your content [FLOWPLAYER], configuration of the player will now be handled by an admin menu box.

<strong>That's quite a list you've got there...</strong>

(basic) Playlists support has been added, this is configurable from the admin menu for the post

<strong>Dude, where's your config file?</strong>

The saiweb_wpfp.conf file has now been removed *gasp*, now reliant in internal wordpress *magic* for the storing of the plugin config.

<strong>Your media is a great big canvas, and you should throw all the paint you can on it</strong>

Fixed a bug with the canvas colour settings

<strong>Is that a logo in your pocket, or are you just pleased to see me?</strong>

The commercial version of flowplayer will now only be used if a license key is specified, the free version will now be used if no key is specified which has a reduced logo branding.

<strong>I Once Was Blind, But Now I See</strong>

Player embed causing issues with some navigation menus, this should be resolved with the wmode setting.

Details of how to get the preview version and install it along with screen casts of the new menus (time allowing) will be added to this post once everything is committed to subversion.

<strong>UPDATE: 15/04/2009</strong> Got my hands on flowplayer 3.1 code is around 60% finished, went for a complete re-write.
