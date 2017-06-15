--- 
wordpress_id: 743
layout: post
title: Subversion - Force commit message
date: 2009-08-24 14:21:35 +01:00
tags: 
- subversion
- force
- commit
categories: 
- python
wordpress_url: https://saiweb.co.uk/python/subversion-force-commit-message
comments: true
---
Again this is a late blog post about some code committed several months ago, in this case the code was committed 09/06/2009 

It is a very short python script to force a subversion commit message to be greater than 10 characters in length

<strong>Installation:</strong>

svn export <a href="https://svn.saiweb.co.uk/branches/python/svn_force_message.py">https://svn.saiweb.co.uk/branches/python/svn_force_message.py</a> /path/to/your/svn/hooks/pre-commit
chmod +x /path/to/your/svn/hooks/pre-commit

Note installation this way will replace your current pre-commit hooks file.



