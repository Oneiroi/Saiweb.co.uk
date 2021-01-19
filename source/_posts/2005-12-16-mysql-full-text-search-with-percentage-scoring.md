--- 
wordpress_id: 9
layout: post
title: mySQL Full Text Search With Percentage Scoring (originally Posted on 3dbuzz.com)
date: 2005-12-16 12:37:08 +00:00
tags: 
- mysql
- full text
- relevance
- scoring
categories: 
- mysql
- php
wordpress_url: https://blog.oneiroi.co.uk/mysql/mysql-full-text-search-with-percentage-scoring
comments: true
---
** Note I am not the "Buzz" from 3dbuzz.com this is just a coincidence **

All right lets begin...

First off you will need to understand how to take advantage of mySQL's inbuilt fulltext search functionality.

First lets create the table, using the cli or your favorite GUI (i.e. mysql administrator) to run the following SQL statement.

Code:
{% highlight sql %}
CREATE DATABASE sion_ft;

USE sion_ft;

CREATE TABLE sion_ft_tutorial (

Id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,

Title VARCHAR (255),

Body LONGTEXT

)

ENGINE=myISAM;

ALTER TABLE sion_ft_tutorial ADD FULLTEXT search (title,body);

{% endhighlight %}

Ok we have now created a database, changed to use that database, and created that databases first table, then altered the table to add a fulltext index for both the title and body columns, and called this index "search".

Notice the "ENGINE=myISAM;", unfortunately it seems InnoDB does not support full text indexes. At least that's the problem I ran into using mySQL 4.x.

Now before we go any further we need to put some data into that database so it can be searched.

Code:

{% highlight sql %}

INSERT INTO sion_ft_tutorial (title,body) VALUES

('Sion Fulltext tutorial at 3dbuzz', 'Posted originally by sion at the 3dbuzz forums'),

('3DBUZZ.com ', 'Look Listen Learn, forums vtm\'s and more'),

('I am hungry', 'Lets order pizza!!' ),

('hi Ho Hi Ho', 'A forum trolling I will go' ),

('PHP problems?', 'Go to 3dbuzz forums, where some nutter called sion roams.' );

{% endhighlight %}

Ok now we have inserted 5 rows of data into the table, we will use this data when testing our fulltext search.

Before we begin with the PHP we need to construct the SQL statement to use the FULL text feature, so keep that CLI OPEN!

Code:

{% highlight sql %}

SELECT * FROM sion_ft_tutorial WHERE MATCH(title,body) AGAINST('sion');

+----+----------------------------------+----------------------------------------------------------+

| id | title | body |

+----+----------------------------------+----------------------------------------------------------+

| 1 | Sion Fulltext tutorial at 3dbuzz | Posted originally by sion at the 3dbuzz forum… |

| 5 | PHP problems? | Go to 3dbuzz forum, where some nutter called sion roams. |

+----+----------------------------------+----------------------------------------------------------+

{% endhighlight %}

Ok so the search is now working no we need to get the relevance score working.

Code:

{% highlight sql %}

SELECT *, MATCH(title,body) AGAINST('sion') AS score FROM sion_ft_tutorial WHERE MATCH(title,body) AGAINST('sion');

+----+----------------------------------+----------------------------------------------------------+------------------+

| id | title | body | score |

+----+----------------------------------+----------------------------------------------------------+------------------+

| 1 | Sion Fulltext tutorial at 3dbuzz | Posted originally by sion at the 3dbuzz forum… | 0.53033631317832 |

| 5 | PHP problems? | Go to 3dbuzz forum, where some nutter called sion roams. | 0.37130504609119 |

+----+----------------------------------+----------------------------------------------------------+------------------+

{% endhighlight %}

As you can see id 1 has the higher score this is because "sion" is found both in the title and the body text.

The "relevance score" is calculated by hard code formulae within mySQL.

Full details on this formulae can be found here :<a href=" https://dev.mysql.com/doc/internals/en/full-text-search.html"> https://dev.mysql.com/doc/internals/en/full-text-search.html</a>

This covers the mySQL side of the system.

<h2>PHP</h2>

First off we have to make some assumptions for this method to work.

We have to assume that the highest score is equivalent to 100% relevant to the search.

And for this "basic" stage we have to assume that the default mySQL setup is sufficient for our needs, as there is a whole host of things to configure such as minimum word length, and mySQL's "stop list" to consider.

This will be covered in the "fine tuning" section of this tutorial.

I am also assuming you have read the above section on mySQL and not skipped strait to the PHP code.

First of all as I'm sure you know we need to create a connection to the mySQL server.

Code:

{% highlight php %}

<?PHP

$usr = "mysqlusr";

$pass = "mysqlpass";

$host = "localhost";

$db = "sion_ft";

$connection = mysql_connect($host,$usr,$pass);

mysql_select_db($db,$connection);

?>

{% endhighlight %}

Ok so lets now get some data to start playing with.

Code:

{% highlight php %}

<?PHP

$query = "SELECT *, MATCH(title,body) AGAINST('sion') AS score FROM sion_ft_tutorial WHERE MATCH(title,body) AGAINST('sion') ORDER BY SCORE DESC";

$result = mysql_query($query);

$row = mysql_fetch_assoc($result);

??

{% endhighlight %}

Now we have the data as mentioned above in the MYSQL section.

Remember I said we have to "assume" the highest score is 100% relevant. well lets do that and start creating relevance percentages.

Code:

{% highlight php %}

$max_score = 0;

$data = array();

do {

if($row['score'] &gt; $max_score){ $max_score = $row['score']; } //because we are ordering by score we can assume on the first run this wil be the max score.

echo $row['title']." ".@number_format(($row['score']/$max_score)*100,0)."%&lt;br&gt;n";

}while($row = mysql_fetch_assoc($result));

{% endhighlight %}

Now you should get a list that looks something like the following.

{% highlight bash %}

Sion Fulltext tutorial at 3dbuzz 100%

PHP Problems? 70%

{% endhighlight %}

Right so lets go over what we have done so far, we have used mySQL's inbuilt "relevance" calculation and assume the highest "score" to bee 100% as such we have used that score as the "denominator" for the result of the results to calculate their percentage relevance.
