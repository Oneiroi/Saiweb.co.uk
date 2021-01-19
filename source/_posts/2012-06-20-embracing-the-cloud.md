---
title: "Embracing the cloud"
date: 2012-06-20 21:07
tags:
- cloud
- clouddns
- cloudfiles
---

Yeh yeh ... so it is true I have some quite [vocal opinions](https://blog.oneiroi.co.uk/hosting/cloud-hosting-my-views/), on all this cloud marketing fluff.

That said it has some great potential, if you've been following my open source contributions and posts you'll known I have an special affinity for [Openstack](https://openstack.org), [Aeolus](https://aeolusproject.org/), and of course [Opennebula](https://opennebula.org/).

As such I've taken to jumping in "feet first", what better way eh?

Last October I was fortunate enough to attend the Openstack training in London, hosted by [Rackspace](https://rackspace.com), recently I now have a full openstack deployment running on fedora 17 on my laptop for prototyping, and testing (I have of course been bugreporting to redhat bugzilla! and I encourage you to do the same!).

I met some great people on the course last October, which unfortunatly I've only managed to keep in contact with a few of (if you're reading this and were there get in contact!).

I have some upstream commits for: EPEL Openstack, libcloud, aeolus, boxgrinder ... and I've gotten to a point this year where I can reflect, and make a post to that effect.

In short I have one problem with the cloud, and that's the marketing; let me explain why, marketing is driven to make sales, it does not care about the education of the end user as to the product they are paying for, (and frankly hearing my parents / clients ask "Can't you just use the cloud?" makes me want to break out the beating stick of education, more for the marketing people I belive in making a solution right for the indvidual not for the bottom line...), as I've come to know more on the systems involved it's a revolution, now calm down and let me explain.

Yes the cloud is simply virtualization if you break it down into it's rawest form, and that has been around for decades ... but what "the cloud" is doing despite the marketing fluff, is comoditizing the technology and plating it firmly in the hands of users who have little to no technical background or knowlege, why is this a revolution? 

Inherently a person who is somewhat intellegent is curious, curiosity (Despite killing the cat, though if my neighbours cat craps in my garden again it may well be my boot and not the curioisity) leads to discovery, this inturn leads to understanding; putting something so powerful so simply within reach of those who do not understand the technology both increases it's proftiablity and should said end user persue their curosity they will learn.

Right so education for the massses, what's next hugging trees?
Not quiet the you may be missing the point, what's better than an educated client someone who knows what they want and the potential technologies to achieve it as apposed to the uneducated who take the line of "it can't be that hard all you do is sit there and tap the keyboard all day".

There is a very real gap in understanding between the end user, and the Sysadmin/Devops supporting it, the cloud may well help to bridge the gap between the technology and the user, such as Devops bridges the gap between operations and the developer.

So, pulling this back to the original point of this blog, I appear to have gone off at a tangent.

1. I've conveted Wordpress -> Jekyll + Octopress
2. I've worked on the Rakefile to push differing assets to cloudfiles/
3. I am now just waiting on clouddns to allow CNAME records for the main domain, then ...
4. blog.oneiroi.co.uk will exist purely in cdn.

With any luck I will be the first but this is reliant on the dns options becomming available, please comment and let me know your thoughts!


