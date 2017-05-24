---
layout: post
title: "Passphrase or complex passwords?"
date: 2017-04-06 21:24
comments: true
categories:
- passwords
- security
- something-you-know
---

I like healthy debate, if I am wrong then I encourage my colleagues and others to explain in detail as to why my thoughts on a particular matter/subject are incorrect and often this causes a somewhat extensive back and forth until a consensus is reached on the issue being discussed.

So one such discussion over the last couple of days has been over password complexity vs pass-phrases, not to be confused with password length let me make that point clear.

So let me give you some examples

#Complexity

- 14 characters or more
- 2 uppercase letters
- 2 numerical digits
- 2 'special' characters

A typical example of a password policy with complexity requirements and fairly typical of most standards out there right ? 

#The problem of the human

So let's explore this a little, and discuss some of the issues. Here's an example of a "compliant" password

`CompanyPassword2017!$`

1. 21 characters (compliant)
2. 2 uppercase characters (compliant)
3. 4 numerical digits (compliant)
4. 2 special characters (compliant)

The password is compliant with policy and as such is not a problem ... right ?

Well if you've read anything on my blog before you'll know the answer is no there is still a problem.

1. This password contains the company name (I used Company to keep thing generic so use a little imagination this represents a company name).
2. This password contains the word `Password` (still better than `123456` though ;-) )
3. This password contains the current year (this happens *WAY* more often that you would think, remember `123456` was the most used password in 2016)
4. This password has had the special chars appended to the end (typical human typographical behavior, the the password first and have the requirements as an after thought)

The problem is *human behavior*, and in the english language at least this is predictable behavior allowing for pattern analysis or behavioral analysis attacks to be carried out.

1. Capitalizing the first or each word (Camelcase)
2. Using company or password or service related words to make the password more memorable (not everyone uses a password manager, so these little cheats to aid memory can be predicted)
3. Using the current year at the end of the password
4. Appending the special char requirements at the end of the password (this allows someone to quickly enter the first part before they have to think about the end part of the password).

I'm speaking in generalizations, if you do not do any of this then great! Use a word list throw a [dice to decide the password](https://xkcd.com/221/) ;-) ... 

The downfall here is with a complexity requirement is poor choices of passwords and this is most prevalent where the target individual does not use a password manager and the password generation feature.

**Note**: This is not a bashing of p:eople not using password managers, password managers have their own issues (just see examples from Travis Ormandy or Dan Tentler) so please bare with me until the end I am simply speaking about human behavior being predictable of which *MANY* studies are available to back this up).

#Pass-phrases

If you do not know what a pass-phrase is then go take a look at [this](https://xkcd.com/936/), I'll wait ...

Oh you're back? good did you review the XKCD comic in full ? Excellent let's continue then.

A pass-phrase is a series of words used ideally with a separating character (I will recommend using a space instead of a dash!) for example

`Peter Piper Picked A Peck Of Pickled Peppers 2017 $!` 

1. 52 characters (compliant)
2. 8 uppercase (compliant)
3. 4 numerical digits (compliant)
4. 11 special characters (compliant)

Q: Wait ?! I only see 2 special characters, your count is off!
A: Actually I counted the spaces; as space is a special character.

# Both look fine to me, wth are you talking about ?!

Precisely that, both are acceptable provided they follow the same basic guidelines, no you can not sacrifice complexity for a longer password perhaps I should explain more

`peter piper picked a peck of pickled peppers`

Some may argue that a longer password removes the need for complexity which is simply not the case as this pass-phrase has lowered the `address space` considerably.

#WTF is an address space, and what has it got to do with my password ?

** WARNING ** here be math ...

The address space is the total addressable character set for any given password for example 

1. a through z ([a-z]) would be 26 possible characters
2. a through Z ([a-Z]) would be 52
3. a through 9 ([a-Z][0-9]) would be 62

And so on, so to evaluate when brute forcing (iterating every single possible combination) a password the math becomes as follows.

1. password is 58 characters
2. password is comprised of *only lowercase and space separation* `58^27 == 4.0978x10^47` possible combinations (53 == 52 + space)

How about throwing in some complexity ? 

1. password is 58 characters
2. password uses a through 9 (this includes captilized letters)

`58^63 == 1.2472789544046017 x 10^111`

Which may not seem like a huge difference until you work out that the former non complex address space is `3.2853 x 10^-67`% of the size of the complex address space.

## Why should I care really ? I have a long password it'll take many years to brute force it

Yes you're correct, but you're also wrong. Brute force is not the only attack you can carry out, let's use the example from before

1. password is 58 characters
2. password is comprised of *only lowercase and space separation* `58^27 == 4.0978x10^47` possible combinations
4. We know this is a pass-phrase, so it's likely each part of said phrase uses complete words.
5. We know the target uses the english language
6. The english language has approximately `171,476` words this is by **FAR** much less than `4.09785x10^47` 

`171476` is `4.1845 x 10^-43`% of the address space when compared with the full size of the bruteforceable address space,
as such when looking at possible combinations, start to factor in other human factors such as poor word choice (names, places, colours etc ...) and you reduce the address space even further.

`The problem is choice` to throw a quick pun in here (and an obligatory matrix reference).

**Note** This is all 'napkin math' so please forgive me if I am wrong anywhere, and note it in the comments so I can fix in the post ;-)

*Update*: corrected napkin math 2017-05-05 password example assumed `a-Z ` where as example given was `a-z ` corrected the math to account for `a-z ` as intended.
*Update2*: corrected napkin math AGAIN 2017-05-24
 
# Conclusion

Password complexity is no stronger than pass-phrase with complexity, if you manage / are authoring a policy on password security then remember the following quote

*"Security at the expense of usability comes at the expense of security"* otherwise known as *AviD’s Rule of Usability*.

1. Any policy must be simple to understand
2. Any policy myst be simple to execute

In order to gain the expected result, otherwise you're going to get users whom develop poor habits and choose poor-passwords.

Not everyone wants to use a password-manager some people are even fearful of storing all their passwords in a single repository, there is no one solution here but there is the management of how each available option can be used.

# N.B

Think I got something wrong or have strong opinions on something ?

Please put your thoughts into a comment, again I encourage debate so please include as much information as you can in your argument.
