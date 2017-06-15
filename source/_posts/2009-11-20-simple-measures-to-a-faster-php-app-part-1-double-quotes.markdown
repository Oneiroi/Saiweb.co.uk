--- 
wordpress_id: 796
layout: post
title: Simple measures to a faster PHP app - Part 1 Double Quotes
date: 2009-11-20 10:25:06 +00:00
tags: 
- php
- performance.
- single quotes
- double quotes
categories: 
- php
wordpress_url: https://saiweb.co.uk/php/simple-measures-to-a-faster-php-app-part-1-double-quotes
comments: true
---
In some situations using a double quotes string is required i.e. "this\nstring\nappears\over\nmany\nlines" ...

However in 99% of cases it is used without even thing about in implications of doing so ... PHP will infact evaluate any string wrapped in double quotes, this adds a processing overhead, but it seems people do not actually reliase how much in comparrison to using single quotes for the same string.

Take for example this code:

{% highlight php %}
<?PHP
/**
 * double-quotes-are-bad.php ~ D.Busby (Saiweb.co.uk)
 **/
$start = microtime(true);
$var = "This is a stiring it may not actually have anything to be parse within"
        .       " However the issue remains that infact php will attempt to evaluate every char"
        .       " In this string, which in this example may not be so bad, as it's just one string"
        .       " In one file, buit imagine what happens when every string in your webapp uses double quotes";
$end = microtime(true);
$len = strlen($var);
$res = round($end-$start,10);
echo $len.' Chars evaluated in '.$res.' seconds'."\n";

$start = microtime(true);
$var = 'This is a stiring it may not actually have anything to be parse within'
        .       ' However the issue remains that infact php will attempt to evaluate every char'
        .       ' In this string, which in this example may not be so bad, as it\'s just one string'
        .       ' In one file, buit imagine what happens when every string in your webapp uses double quotes';
$end = microtime(true);
$len = strlen($var);
$res2 = round($end-$start,10);

echo $len.' Chars evaluated in '.$res2.' seconds'."\n";

$speed = round((1 - $res2/$res) * 100,2);

echo 'Single quotes are '.$speed.'% faster'."\n";

?>
{% endhighlight %}


Now I am running this on a live server, that is serving in excess of 100 pages a second, take a look at the output:

320 Chars evaluated in 1.40667E-5 seconds
320 Chars evaluated in 3.0994E-6 seconds
Single quotes are 77.97% faster

320 Chars evaluated in 1.28746E-5 seconds
320 Chars evaluated in 3.0994E-6 seconds
Single quotes are 75.93% faster

320 Chars evaluated in 1.3113E-5 seconds
320 Chars evaluated in 2.1458E-6 seconds
Single quotes are 83.64% faster

320 Chars evaluated in 1.19209E-5 seconds
320 Chars evaluated in 2.861E-6 seconds
Single quotes are 76% faster

320 Chars evaluated in 1.3113E-5 seconds
320 Chars evaluated in 2.861E-6 seconds
Single quotes are 78.18% faster

320 Chars evaluated in 1.3113E-5 seconds
320 Chars evaluated in 2.861E-6 seconds
Single quotes are 78.18% faster

The improvement is consistently in excess of 75%, so the moral of the story? don't use "" if you do not need to!

Thanks to everyone along the way who've discussed and proven development methods along the way with me, and sorry it's taken so long to get them written up.


