---
title: "Git svn - working with branches and tags"
date: 2012-03-26 14:35
published: false 
tags:
- git
---

So as many know I am firmly an advocate of git, and a pesemist when it comes to subversion because well it seems to fail for unresolveable reasons either through use, or through fault of it's own (lock files in meta directories for one ...).

Now this is not to say that git is infallable. At any rate here is the best way to use git as an svn client and still maintain access to branches and tags.

{% highlight bash %}
git svn init -s <protocol>://<FQDN of server>/<repo path> ./folder_to_checkout_to
{% endhighlight %}

OR

{% highlight bash %}
git svn init -t tags -b branches -T trunk <protocol>://<FQDN of server>/<repo path> ./folder_to_checkout_to
{% endhighlight %}

1. This initializes an empty git respository in the folder specified (This can also be handy for migrating from subversion)
2. The examples above use -s for stdlayout, the 2nd example can be used to specify exact locations of trunk,tags,branches.


Now we need the data:

`git svn fetch`


One thing to note that whilst tags are present within git, subversion tags do not (at this stage) translate into git tags, as such to checkout svn tags (if you are not yet ready to make the jump to using git and want to maintain a subversion server this will needed).

`git checkout -b tags/tag_name tags/tag_name`

What does this do? it will checkout the tag from subversion: tag_name and setup a local git branch to track it.

If you are ready however to make the jump to git you can [https://gitready.com/advanced/2009/02/16/convert-git-svn-tag-branches-to-real-tags.html](Conver git-svn tags to real git tags).


