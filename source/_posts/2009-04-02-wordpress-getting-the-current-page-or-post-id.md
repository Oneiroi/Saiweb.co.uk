--- 
wordpress_id: 626
title: Wordpress getting the current Page or Post ID
date: 2009-04-02 14:50:01 +01:00
tags: 
- wordpress
- get
- page
- id
tags: 
- php
wordpress_url: https://blog.oneiroi.co.uk/php/wordpress-getting-the-current-page-or-post-id
---
An example of getting the current page / post ID, identifying whether the current item is a page or a post, and then appending the results to the content.

All from within a plugin.


{% highlight php %}
<?PHP
/*
Plugin Name: Get Page / Post ID using a plugin by D.Busby Saiweb.co.uk
Plugin URI: https://blog.oneiroi.co.uk
Description: Identifies the current page/post and appends text to the content
Version: 0.1
Author: David Busby
Author URI: https://blog.oneiroi.co.uk
*/

//WP hooks start
add_filter('the_content', 'post_page');
//WP hooks end

function post_page($content){
    global $post; //wordpress post global object
    if($post->post_type == 'page'){
        $content .= '<br /> This item is a page and the ID is: '.$post->ID;
    } elseif($post->post_type == 'post') {
        $content .= '<br /> This item is a post and the ID is: '.$post->ID;
    }
    return $content;
}
?>
{% endhighlight %}

Install the above as a plugin i.e. in wp-content/plugins/test/test.php

Head over to your admin menu and enable the plugin, now each page and post will identify itself as a page or post, and provide it's ID.

There is a lot available in the $post object for a list add

{% highlight php %}
ob_start();
var_dump($post);
$content .= ob_get_contents();
ob_end_clean();
{% endhighlight %}

