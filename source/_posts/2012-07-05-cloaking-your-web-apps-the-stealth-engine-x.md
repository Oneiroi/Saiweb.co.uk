---
title: "Cloaking your Web Apps - The Stealth Engine X"
date: 2012-07-05 12:52
tags:
- hacking
- linux
- security
- nginx
---

Following on from [The Hooded Apache](https://blog.oneiroi.co.uk/hacking/linux/security/cloaking-your-web-apps-the-hooded-apache/), I thought it was about time to cover Nginx configuration.

Nginx [is not exempt from security issues](https://web.nvd.nist.gov/view/vuln/defail?vulnId=CVE-2012-2089), and as with apache certain versions can vulnerable to a specific attack, as such the first line of defense is you hide your nginx version.

This can be done via:

```
server {
    server_tokens off;
    ...
}
```

This changes the put from

```
Server: nginx/1.0.12
```

To

```
Server: nginx
```

You could if you are so inclined change the server string in the c code itself 

src/http/ngx_http_header_filter_module.c

{% highlight c %}
...
static char ngx_http_server_string[] = "Server: my_modified_server" CRLF;
static char ngx_http_server_full_string[] = "Server: my_modified_server/release_version" CRLF;
...
{% endhighlight %}

<strong>To err is human ...</strong>

Sometimes standard responses can be used for service fingerprinting as such error documents could still give away your running server version even if you were to edit the header code as per above, again this _could_ be done by modifying the C code to only return "" for each error page, in which case you will need to edit

src/http/ngx_http_special_response.c

{% highlight c %}
...
static char ngx_http_error_301_page[] = "";
{% endhighlight %}

I'm not going to list all of them you should get the idea from the exmaple above; however this is not really required, you can also swap out the default error pages with standard configuration.

```
    error_page 404 = /path/to/custom/404.html;
```

<strong> A strong Front ... </strong>

Nginx ofetn gets used to proxy other services, as such you could be revealing the backend technologies in use due to the backend server sending headers such as X-Powered-By.

This where in your proxy configure options you can have nginx intercept and remove the headers being sent by the backend.

```
proxy_hide_headers X-Powered-By;
```


