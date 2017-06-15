--- 
wordpress_id: 1169
layout: post
title: RedHat mock your SCM
date: 2012-02-03 16:33:19 +00:00
tags: 
- centos
- build
- redhat
- mock
- scientific linux
- enable-scm
- scm-option
- fedora
categories: 
- linux
wordpress_url: https://saiweb.co.uk/linux/redhat-mock-your-scm
comments: true
---
The mock tool can be a wonderful thing, allowing you to produce rpm packages for any rpm based system (assuming your have the written .cfg for it).

What I did find a little lacking on the documentation side was the SCM integration (read: Source Control Management), git/svn etc ...

In short so long as your rpm spec file is in your SCM (and it should be), moc will build your rpm from your sources in scm, which can be used for.

1. bleeding edge builds for testing
2. builds from "stable tags"

Yes yes yes ... obvious I know ...

So with no futher ado here is the syntax:

{% highlight bash %}
mock -r your_target --scm-enable --scm-option method=git --scm-option package=git_project --scm-option git_get='git clone git@git_ip_address:SCM_PKG.git SCM_PKG' --scm-option spec='SCM_PKG.spec' --scm-option branch=1-2 --scm-option write_tar=True -v
{% endhighlight %}

<ol>
	<li>scm-enable - turns on the use of scm</li>
	<li>scm-option - set an option for the scm in use</li>
</ol>

The above worked for me, you will need to adjust it acordingly, i.e. if your spec file is not named identically to that of your git project: --scm-option spec='specfile_name.spec'

This will tie me over untill I get chance to play with my <a href="https://github.com/rackspace/monkeyfarm">monkey farm</a>
