---
layout: post
title: "Beta functionality still needs security Slack and Shared channels BETA"
date: 2018-03-18 10:05
comments: true
categories:
- security
- shared
- channel
- slack
- beta
---

Toward the end of 2017 I was asked to give [Slack's shared channel beta](https://get.slack.help/hc/en-us/articles/115004151183-Join-Slack-s-shared-channel-beta) by some colleagues who wanted to use it.

One caveat was the need to use a paid for Slack account on either side of the shared-channel so I setup [oneiroi-ltd.slack.com](https://oneiroi-ltd.slack.com) and upgraded it to the plus plan (hey it has 1 user, so wasn't a big deal).

I then proceeded to "Share" a channel from the oneiroi-ltd.slack.com space with another on which I had a presence (and again was running on a Plus plan) and for the most part, it worked as advertised the sharing integration functioning on the server side so all transport encryption etc was OK.


The issue came once the channel was un-shared, this is where things got a little more interesting.

To test the functionality and asses security I ran the following:

1. Connection to oneiroi-ltd using the Slack web application in Chrome.
2. Connection to the "other" Slack using the Slack desktop application.
3. Channel share was initiated on the oneitoi-ltd side.
4. Test messages were sent from both oneiroi-ltd and "other" Slack, received without issues including files shared.
5. Channel un-share was initiated on the "other" (not oneiroi-ltd) side.

In theory the last step could be as a result of a falling out, termination of client-service engagement etc. any number of reasons to wnating to unshare the channel.

What followed next was unexpected;

I had enabled notifications in the chrome browser from which the oneiroi-ltd slack was running, and to my surprise was still receiving messages from the "other" side (no pun intended) despite the channel being un-shared.

So I proceeded to search for Slack's security contact, and authored a quick report, including screenshots:

```
1) We have two workspaces, Alice & Bob
2) Alice invites Bob to share a channel
3) Alice and Bob both have notifications setup for their workspace and receive notifications from the browser whilst using the shared-channel
4) Alice and Bob have a falling out, Bob decides to stop sharing the channel with Alice.
5) Alice writes into the previously shared channel thinking that Bob will not see what is written.
6) Bob however receives the chat message line in notification.

This is a break in the un-sharing of a channel not performing a proper separation of access, allowing the previous occupants to still receive notifications containing the messages from the party which believes at this moment in time they have stopped being shared.
```

{% img /images/slack-shared-channel-broken.png %}

This was of course a serious issue as this _could_ lead to an invisible breach should sensitive information be communicated in the previously shared channel.

I filed the [hackerone issue](https://hackerone.com/bugs?report_id=291822) in order to notify the slack team, and just over a month on 12th January 2018 the Slack team reported the issue was fixed! 

I moved to test this and sure enough un-sharing the channel now was working as intended with no observable leak as occurred previously.

{% img /images/slack-shared-channel-resolved-test1.png %}
{% img /images/slack-shared-channel-resolved-test2.png %}

And all it seemed was well, I would like to thank the Slack team work working on this issue through to completion despite the delays in feedback on either side.


