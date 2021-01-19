---
layout: post
title: "auditing passwords with k-anonymity and pwnedpasswords"
date: 2018-03-18 10:05
comments: true
categories:
- security
- passwords
- audit
- pwnedpasswords
---

Hello one and all, despite my somewhat lacking blog postings throughout 2017 and thusfar into 2018 complete absence I am in fact still breathing.

That being said I want to cover in this post today something which has I think unjustly gathered some F.U.D. (Fear, Uncertainty, Doubt).

[Troy Hunt (and some engineers from Cloudflare)](https://www.troyhunt.com/ive-just-launched-pwned-passwords-version-2/) has released pwnedpasswords version 2; with an API!

# So I send my password to some third party service and it tells me what ?

First off, *NO* you do not send your passwords and you should *NEVER* send your password to anything but the system you are intending to log into.

Secondly, No, the API does not take the raw password in plaintext, it implements the k-Anonymity model.

# The k-What now?!

First we take you plaintext password, hash it using the SHA1 algorithm and send the first 5 characters of the hash to https://api.pwnedpasswords.com.

In this way the original password is *NEVER* sent to api.pwnedpasswords.com, only the first 5 chars of the SHA1(your password) hash to allow an index lookup and return whether your password has ever been seen in breaches made public / obtained by Troy for haveibeenpwned.com.

#Wait a minute, SHA1 hashes are stupid easy to brute force; this seems like a real bad idea!

SHA1 itself is easily computed using software, such as [hashcat](https://hashcat.net/hashcat/) and [John The Ripper](http://www.openwall.com/john/) most certainly, however we are not sending the complete hash only the first 5 hexidecimal digits of the hash for index lookup.

# Why exactly is that better ?

To answer that I need to go into some detail as to how the SHA1 hash algorithm works, or rather the output of the SHA1 algorithm.

Don't worry this will not be all math, I promise, we are focusing on the output hash only.

Let's take a really common password in 2016/2017 of `123456` as I noted in [Passphrase or Complex Passwords](https://blog.oneiroi.co.uk/passwords/security/something-you-know/passphrase-or-complex-passwords/) as an example.

```
>>> from hashlib import sha1
>>> sha1('123456').hexdigest().upper()
'7C4A8D09CA3762AF61E59520943DC26494F8941B'
>>> sha1('123456').hexdigest().upper()[:5]
'7C4A8'
```

So we would send the `7C4A8` string to api.pwnedpasswords.com; but not the whole digest of `7C4A8D09CA3762AF61E59520943DC26494F8941B`. 

So for an attacker / adversary to get back the original password (assuming they can intercept the api calls being made to api.pwnedpasswords.com), how do they go from `7C4A8` to derive the password of `123456` ?

SHA1 in theory can return `7C4A800000000000000000000000000000000` through `7C4A8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF` that's `35^16`.
`35^16 == 5.070942774902497 x 10^24` possible outcomes.

And this presumes you are able to iterate over every single hash in the `7C4A8` 'index' space.

This is not how the SHA1 algorithm works; for example `123456` returns a very different hash value that `1234567` or `123457` etc. 

There is at the time of writing this post *no known method* to iterate over the SHA1 space for a specific 'index'.

```
>>> sha1('1234567').hexdigest().upper()[:5]
'20EAB'
>>> sha1('123457').hexdigest().upper()[:5]
'908F7'
```

The two examples are not even in the same 'index' space as the original example.

# Conclusion ?

I am not saying it is entirely impossible to iterate every single value in the SHA1 algorithm space, and there issues with creating [known hash collision](https://shattered.io) this took down for instance subversion repositories where the example good and bad files were committed (You can search for this there are many articles to choose from).

The thing is it is highly unlikely for an adversary to get your original password.

1. The adversary will need a pre-computed list of all possible password strings for the SHA1 algorithm (`4.294967296 x 10^25`)
2. The adversary will need to test all `5.070924774902497 x 10^24` possible known passwords against some source of truth that knows your password.
3. The adversary will be blocked by the absence of any username to use to test this.
4. The adversary will be blocked by any 2FA / MFA on the account.
5. The adversary will be blocked by any brute force protections enabled by the vendor / maintainer of the application.

So what's the take-away here ? 

Provided you use a unique password for every one of your online accounts (*PLEASE never re-use a password!*) and that your end vendor / maintainer is taking basic precautions to protect accounts the chances of an adversary getting your password because you looked up the first 5 chars of a SHA1 hash are *VERY VERY* small.

And if a nation-state threat actor is in your threat model, I hope you are not using `123456` as a password!

I have made available a python script which will allow you to lookup your passwords (or not) against api.pwnedpassword.com, the code is available [here](https://github.com/Oneiroi/sysadmin/tree/master/security/pwnedpassword), and it is released open source, so you are free to inspect the source code and choose to use it or not,

So in summary, checking your passwords is unlikely to pose a significant risk; especially when weighed up against the risk your of password being within a breach disclosure.

# Feedback

Think I have something wrong ? Have I missed something ? 

[Ping me on twitter](https://twitter.com/icleus) but be sure to have evidence to backup your claims ;-) 

