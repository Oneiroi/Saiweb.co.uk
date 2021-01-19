---
layout: post
title: "Wordpress to Octopress"
date: 2012-03-05 19:30
comments: true
tags:
- octopress
- wordpress
- jekyll
- markdown
categories:
- jekyll
---

So I have as some know been wrestling with <a href="https://github.com/mojombo/jekyll">Jekyll</a>, and have sucessfully been porting my <a href="https://github.com/Oneiroi/blog.oneiroi.co.uk">Wordpress posts to markdown</a>.

Why you may ask? Performance!

To facilitate running wordpress on the smalest possible CloudServer I am using <a href="https://varnish-cache.org">Varnish</a> which using Apache as the backend, now with static files I can get all the blogging functionality without the need for Wordpress nor varnish, yet still uncached content can lead to increased load on the server.

Also wordpress does not lend itself to scalability especially with the at the time of writing schema and sql queries (percona-query-advisor flags up a few wordpress core sql queries as non scalable).

But this does not mean you need remove the option of using Wordpress, for you client for instance keeping wordpress in place can aid in content generation simply through ease of use.

1. wordpress used as normal
2. wordpress content is ported to markdown
3. markdown used to generate html

Now this does have caveats:

1. you're going to need to maintain designs in wordpress templates and markdown (_layouts).
2. you're going to need to handel any shortcode plugins in your export process.
3. you're going to need to handel any other content modifying plugins in your export process.
4. any UGC / Dynamic requests will still need PHP. 

But it essentially replaces the whole caching layer with static content which then can be pushed to CDN.

And with CDN's now supporting index files (<a href="https://docs.amazonwebservices.com/AmazonS3/latest/dev/IndexDocumentSupport.html">S3</a>, and Coming Soon @ <a href="https://feedback.rackspacecloud.com/forums/71021-product-feedback/suggestions/1511991-index-and-404-page-support">CloudFiles</a>) in essence entire sites can be placed on CDN whilst maintaining ease of content generation.

Now don't get me wrong, this requires a whole lot of "glue" to get working, but the potential for serving an entire web app from CDN without Origin pull / cache headers etc, saves a lot of systems time in scaling and adressing performance issues, or rather makes them "less critical" as the "business" part of the webapp is all on CDN.

I'm still getting to grips with Jekyll and by extention Octopress to see what it can achieve, so expect more posts.

 
