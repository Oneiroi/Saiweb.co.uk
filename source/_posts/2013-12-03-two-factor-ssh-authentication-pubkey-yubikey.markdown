---
layout: post
title: "Two factor SSH authentication - pubkey yubikey"
date: 2013-12-03 19:16
comments: true
categories:
- ssh
- yubikey
- pam
---

OpenSSH >= 6.2 supports "multi factor authentication" which is to say you can require multiple forms of identification to complete authentication for the SSH connection.

A real world comparrison would be I suppose providing more than one form of identification to open a bank account.

OpenSSH 6.2 introduces the AuthenticationMethods setting; this combined with pam_yubico can be used to require that the connections provides both the SSH public key and the yubikey O.T.P (One time password).

OpenSSH 6.2 is [included Fedora 19](http://danwalsh.livejournal.com/65054.html) and for a while now [OpenSSH has supported the Match Group]({{ root_url }}/linux/yummy-chroots-building-chroot-with-yum-fedora-16/) (I covered the use of such for chrooting users easily).

So we're going to combined this combination such that we attain the following:

1. SSH Connections will require pubkey authentication
2. SSH Connections will also require yubikey authentication
3. The above will be applied to specified users via the Match Group clause

To be clear if the connection does not provide a valid public key for the user; it will never reach the yubikey prompt stage; also if the provided yubikey OTP is invalid authentication will also fail.

Install the pam_yubico package: `sudo yum -y install pam_yubico`

At the end of your /etc/ssh/sshd_config add the following:

```
Match Group mfagroup
    AuthenticationMethods pubkey,keyboard-interactive
    
```

You will also need to set `ChallengeResponseAuthentication yes` in your sshd_config file.

The above is the bare minimum you can add any additions you wish; and restart sshd.

Create the file /etc/pam.d/yubi-auth with the content

```
auth sufficient pam_yubico.so id=your_yubicloud_id key=your_yubicloud_api_key authfile=/etc/ssh/yubikey_mappings url=https://api.yubico.com/wsapi/2.0/verify?id=%d&otp=%s debug
```

Note: I am specifying the URL as the default will use http and not https despite what the documentation might say.

Create the file: /etc/ssh/yubikey_mappings with the content:

```
username:yubikey_identity
```

You can get your yubikey identity from [demo.yubicloud.com](http://demo.yubicloud.com)

Edit /etc/pam.d/sshd so that the first lines read:

```
#%PAM-1.0
auth       include     yubi-auth
```

And finally create a user in your group, in this case we're using the mfagroup.

`useradd -g mfagroup -s /bin/bash username` and install their public ssh key in /home/username/.ssh/authorized_keys, ensuring proper permissions.

All being well when you try to login with the user you should see the following:

```
Authenticated with partial success.
Yubikey for `username': 
```

And you have sucessfully setup two factor ssh authentication with public keys.


