---
layout: post
title: "Spanking the scan monkies"
date: 2014-02-06 16:52
comments: true
categories:
- trolling
- skiddies
- scan
- tarpit
- security
---

Hello 2014, do I have your attention?

**Early warning** This is a satirical blog post, with colourful language of which the sole intent is to troll automated scanners and script kiddies, those of a disposition nature should stop reading now.
 
Shortly after watching [@chrisjohnriley](https://twitter.com/chrisjohnriley)'s Defcon 21 talk [defense by numbers](https://www.youtube.com/watch?v=I3pNLB3Cq24),
I began thinking how I could implement so of the methods within nginx, taking them to another level by trolling and generally pissing off anyone scanning the server.

Some background on this nginx server does nothing but bounce old domains, and links to their appropriate place on this blog, so it's out of the way not something you'd typically see attacked en mass.

(seriously I see one or two hits from search engines on the instance, except recently China Telecom must LOVE my blog, 500K requests in an hour ... aww shucks guys I love you too)

So let us start with response codes, because 400 response codes are so last century right? I really can't see why the [7xx-rfc](https://github.com/joho/7xx-rfc) isn't already a standard.

So I opted for responding to automated scans of my nginx instance with the 793 response code; helpfully letting the scanner know that the Zombie Apocalypse has occured where the instance is located and that I care not of their scans as I'm either shambling along biting everyone within reach and incoherently moaning, or I'm too busy trying to not get my ass zombified.

{% img /images/zombie_apoc_evolution_suprise.jpg %}

Zombie apocolypse is serious business; they should appreciate my early warning!

Providing this sorely needed public service is this small nginx server block after my main server block handling all valid requests.

```
server {
    listen 80 default_server;

    server_tokens off;
    autoindex off;
    root /var/www/rickroll;
    index index.html;
    add_header X-Never-gonna-give-you-up "";
    add_header X-Never-gonna-let-you-down "";
    add_header X-Never-gonna-run-around-and-desert-you "";
    add_header X-Never-gonna-make-you-cry "";
    add_header X-Never-gonna-say-goodbye "";
    add_header X-Never-gonna-tell-a-lie-and-hurt-you "";

    return 793; #zombie apocolypse 
}
```


if only those scanners could fully appreciate the midi tones of Rick Astley melodic symphony soothing them to sleep in the wake of the end of all things via Zombie Apocolypse ... alas we wonder do calculators dream?

Yup no hostnames were being sent as part of the request, so China telecom doesn't love my blog afterall ... well screw you guys! I thought we had something but you were just a fake ...

[but wait there's more](https://www.youtube.com/watch?v=i_RLYSaPvak) just as the sweet verses dictate; we're never going to give you up, so if you're making so many requests in such a short time you must want to stay connected to me for as long as possible, it's ok I've got you covered.

```
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --set
iptables -I INPUT -p tcp --dport 80 --state NEW -m recent --update --seconds NN --hitcount N -j TARPIT
```

Forever together ... into the tarpit ... shhhh ... only dreams now ...

And for those not snuggling with us down in the tarpit, sorry but you'll just need to prove you really want to be in there; sticky cuddles ... 


YMMV etc this isn't a fully tested configuration, it's not ment to do anything but troll all the automated scanners out there hammering the instance.



