--- 
wordpress_id: 274
title: Optimizing Apache for high load sites - Part 2
date: 2008-11-13 15:38:45 +00:00
tags: 
- apache
- optimize
tags: 
- linux
- apache
wordpress_url: https://blog.oneiroi.co.uk/linux/optimizing-apache-for-high-load-sites-part-2
---
This is going to be quite an extension from what I had planned, instead of providing just a list of results post optimization I am going to provide a basic list of modules loaded as part of a basic apache install, and provide a description for each, the ones I have disabled are mods I have deemed not required for my purposes, use your own best judgment before switching things off...
<ul>
	<li>LoadModule auth_basic_module modules/mod_auth_basic.so</li>
</ul>
ENABLED: User authentication for access control using 	    HTTP basic authentication (.htaccess and .htpasswd)
<ul>
	<li> LoadModule auth_digest_module modules/mod_auth_digest.so</li>
</ul>
ENABLED: Similar to <span class="systemitem">auth_basic_module</span> but instead 	    of using a plain text authentication scheme, it uses a 	    cryptographic one. (MD5 etc ...)
<ul>
	<li> LoadModule authn_file_module modules/mod_authn_file.so</li>
</ul>
ENABLED: Allows authentication front-ends such as 	    auth_digest_module and auth_basic_module to authenticate 	    users by looking up users in plain text password 	    files. This function was previously part of <span class="systemitem">auth_module</span> and <span class="systemitem">auth_digest_module</span>.
<ul>
	<li> LoadModule authn_alias_module modules/mod_authn_alias.so</li>
</ul>
DISABLED: Allows extended authentication providers to 	    be created within the configuration file and assigned an 	    alias name.
<ul>
	<li> LoadModule authn_anon_module modules/mod_authn_anon.so</li>
</ul>
DISABLED: Allows anonymous user access and logs the 	    password given. Previously known as<span class="systemitem">auth_anon_module</span>.
<ul>
	<li> LoadModule authn_dbm_module modules/mod_authn_dbm.so</li>
</ul>
DISABLED: Allows authentication front-ends such as 	    auth_digest_module and auth_basic_module to authenticate 	    users by looking up users in dbm password 	    files. Previously known as<span class="systemitem">auth_dbm_module</span>.
<ul>
	<li> LoadModule authn_default_module modules/mod_authn_default.so</li>
</ul>
DISABLED: Fallback authentication module - it simply 	    rejects any credentials supplied by the 	    user
<ul>
	<li>LoadModule authz_host_module modules/mod_authz_host.so</li>
</ul>
ENABLED: Access control by browser 	    hostname. Previously known as<span class="systemitem">access_module</span>.
<ul>
	<li>LoadModule authz_user_module modules/mod_authz_user.so</li>
</ul>
DISABLED: Provides authorization capabilities so that 	    authenticated users can be allowed or denied access to 	    portions of the web site.  This function was previously 	    part of <span class="systemitem">auth_module</span>.
<ul>
	<li> LoadModule authz_owner_module modules/mod_authz_owner.so</li>
</ul>
DISABLED: Authorization based on file 	    ownership.
<ul>
	<li> LoadModule authz_groupfile_module modules/mod_authz_groupfile.so</li>
</ul>
DISABLED: Group authorization using plaintext 	    files. This function was previously part of <span class="systemitem">auth_module</span>.
<ul>
	<li> LoadModule authz_dbm_module modules/mod_authz_dbm.so</li>
</ul>
DISABLED: Group authorization using DBM 	    files. This function was previously part of <span class="systemitem">auth_dbm_module</span>.
<ul>
	<li> LoadModule authz_default_module modules/mod_authz_default.so</li>
</ul>
DISABLED: Fallback authorisation module - it simply 	    rejects any authorization request.
<ul>
	<li> LoadModule ldap_module modules/mod_ldap.so</li>
</ul>
DISABLED: LDAP connection pooling and result caching 	    services for use by other LDAP modules.

(I don't use LDAP, if you use apache interaction with ldap keep this module, if you use LDAP within PHP you can turn this mod off!)
<ul>
	<li> LoadModule authnz_ldap_module modules/mod_authnz_ldap.so</li>
</ul>
DISABLED: Allows authentication front-ends such as 	    auth_basic_module to authenticate users through an ldap 	    directory. Previously known as<span class="systemitem">auth_ldap_module</span>. (same as above)
<ul>
	<li> LoadModule include_module modules/mod_include.so</li>
</ul>
DISABLED: Server-side includes.
<ul>
	<li> LoadModule log_config_module modules/mod_log_config.so</li>
</ul>
ENABLED: Configurable logging of requests and 	    reponses.
<ul>
	<li> LoadModule logio_module modules/mod_logio.so</li>
</ul>
ENABLED: Logging of input and output bytes per 	    request.
<ul>
	<li> LoadModule env_module modules/mod_env.so</li>
</ul>
DISABLED: Changes the environment that CGI program are 	    run in.
<ul>
	<li> LoadModule ext_filter_module modules/mod_ext_filter.so</li>
</ul>
ENABLED: Pass the response body through an external 	    program before delivery to the client (i'm using mods like gzip compression, disalbe this if you don't need it).
<ul>
	<li> LoadModule mime_magic_module modules/mod_mime_magic.so</li>
</ul>
ENABLED: Determines MIME types based on file 	    contents. (Great for directly serving download easily).
<ul>
	<li> LoadModule expires_module modules/mod_expires.so</li>
</ul>
ENABLED: Autogenerates the <span class="systemitem">Expires:</span> header according to 	    user rules.
<ul>
	<li> LoadModule deflate_module modules/mod_deflate.so</li>
</ul>
ENABLED: Compress content prior to serving 	    it. (If you don't have compression configured for your websites disable this mod).
<ul>
	<li> LoadModule headers_module modules/mod_headers.so</li>
</ul>
ENABLED: More general control of HTTP 	    headers. (You can disable this if you do not want to handle bespoke HTTP headers)
<ul>
	<li> LoadModule usertrack_module modules/mod_usertrack.so</li>
</ul>
DISABLED: Provision of cookies. (I am using PHP to handle cookies).
<ul>
	<li>LoadModule setenvif_module modules/mod_setenvif.so</li>
</ul>
ENABLED: Sets the environment for CGI programs based 	    on properties of the request.
<ul>
	<li> LoadModule mime_module modules/mod_mime.so</li>
</ul>
ENABLED: Determines MIME types based on file 	    names.
<ul>
	<li> LoadModule dav_module modules/mod_dav.so</li>
</ul>
DISABLED: Distributed Authoring and Versioning 	    functionality. (This is a webserver not serving a versioning system).
<ul>
	<li> LoadModule status_module modules/mod_status.so</li>
</ul>
ENABLED: Provides information about the server's 	    current status via a web request. (If you don't have this set in your httpd.conf then disable the mod, I use this for apache monitoring).
<ul>
	<li> LoadModule autoindex_module modules/mod_autoindex.so</li>
</ul>
ENADLED: Automatically picks the index file when browsing to a folder, (index.html, index.php etc ..)
<ul>
	<li> LoadModule info_module modules/mod_info.so</li>
</ul>
DISABLED: Similar to a php info call, provides running configuration information about the apache server.
<ul>
	<li> LoadModule dav_fs_module modules/mod_dav_fs.so</li>
</ul>
DISABLED: More no required D.A.V
<ul>
	<li> LoadModule vhost_alias_module modules/mod_vhost_alias.so</li>
</ul>
ENABLED: Allows for handling enormous numbers of 	    virtual hosts without having to change the configuration 	    each time.
<ul>
	<li> LoadModule negotiation_module modules/mod_negotiation.so</li>
</ul>
ENABLED: Provides for content negotiation between 	    server and client. (Accept encoding etc...)
<ul>
	<li> LoadModule dir_module modules/mod_dir.so</li>
</ul>
ENABLED: Supports the use of 	    <tt class="filename">index.html</tt> files for directory 	    lookups.
<ul>
	<li> LoadModule actions_module modules/mod_actions.so</li>
</ul>
ENABLED: Run specific CGI programs according to the 	    MIME content type of the object served.
<ul>
	<li> LoadModule speling_module modules/mod_speling.so</li>
</ul>
ENABLED: Attempts to correct misspelled 	    URLs. (Ignores case etc..)
<ul>
	<li> LoadModule userdir_module modules/mod_userdir.so</li>
</ul>
ENABLED: Allow public_html userdir and use of https://servername/~username, I have disabled this as can be used to verify the presence of a valid username to be used in a brute force attack
<ul>
	<li> LoadModule alias_module modules/mod_alias.so</li>
</ul>
ENABLED: Override the <strong class="command">DocumentRoot</strong> directive for specific URLs.
<ul>
	<li> LoadModule rewrite_module modules/mod_rewrite.so</li>
</ul>
ENABLED: Allows the use of the Rewriteengine to provide SEO friends URL's amoungst other things.
<ul>
	<li> LoadModule proxy_module modules/mod_proxy.so</li>
</ul>
ENABLED: Lets your web server be a proxy.  Typically 	    it needs additional modules for specific 	    protocols.
<ul>
	<li> LoadModule proxy_balancer_module modules/mod_proxy_balancer.so</li>
	<li> LoadModule proxy_ftp_module modules/mod_proxy_ftp.so</li>
	<li> LoadModule proxy_http_module modules/mod_proxy_http.so</li>
	<li> LoadModule proxy_connect_module modules/mod_proxy_connect.so</li>
</ul>
ENABLED: As above, I have need to have apache act as a proxy, in the future
<ul>
	<li> LoadModule cache_module modules/mod_cache.so</li>
</ul>
ENABLED: Implements an RFC 2616 compliant HTTP content             cache that can be used to cache either local or proxied             content.
<ul>
	<li> LoadModule suexec_module modules/mod_suexec.so</li>
</ul>
ENABLED: Allows CGI scripts to run as a user other 	    than <span class="systemitem">wwwrun</span>.
<ul>
	<li> LoadModule disk_cache_module modules/mod_disk_cache.so</li>
	<li> LoadModule file_cache_module modules/mod_file_cache.so</li>
	<li> LoadModule mem_cache_module modules/mod_mem_cache.so</li>
</ul>
ENABLED: More cache-ing functions (reduces need for disk read time).
<ul>
	<li> LoadModule cgi_module modules/mod_cgi.so</li>
</ul>
ENABLED: Run CGI programs
<ul>
	<li> LoadModule version_module modules/mod_version.so</li>
</ul>
ENABLED: Version dependent configuration (Can be handy when writing configs to have this enabled).

Source's used:

Module information can be found HERE: <a href="https://www-uxsup.csx.cam.ac.uk/~jw35/courses/apache/html/a2617.htm">https://www-uxsup.csx.cam.ac.uk/~jw35/courses/apache/html/a2617.htm</a>

{% highlight bash %}
----- MEMORY USAGE REPORT FOR 'apache' -----
PID Count: 32
Mem usage: 4594 MB
Mem/PID: 143 MB
For more information run: pmap -x 12345
{% endhighlight %}

<del datetime="2008-11-14T09:34:03+00:00">So 143mb down from 189mb, saving 46mb/thread.

Not much of a saving right? ... well actually wrong.

Take for example a webserver with 2048MB Avail system ram, lets allocate 15% of that for the OS use.

So we have 1741MB to play with, with the original setup of 189mb 9.21 concurrent connections could be active an any one given time.

now however 12.71 concurrent connections can be in memory at any given time (28% increase).

Still a long way to go to bring the memory foot print down to a minimal level, but as you can see spending 5 minutes disabling mod's in the config yields a quick win 28% increase in capacity.</del>

<strong>UPDATE</strong>

Following the improvements to the appmem script in <a href="https://blog.oneiroi.co.uk/uncategorized/linux-the-sysadmin-script-part-4">part 4</a> here are the new figures.

With all mods enabled:

{% highlight bash %}
 ----- MEMORY USAGE REPORT FOR 'httpd' ----- 
PID Count: 37
Shared Mem usage: 176 MB
Total Resident Set Size: 112 MB
Mem/PID: 3 MB
{% endhighlight %}

Results attained running "ab -n 1000 -c 100 https://xxx.xxx.xxx.xxx/".

Results with disabled mods (listed above):

{% highlight bash %}
 ----- MEMORY USAGE REPORT FOR 'httpd' ----- 
PID Count: 41
Shared Mem usage: 140 MB
Total Resident Set Size: 95 MB
Mem/PID: 2 MB
{% endhighlight %}

Shared mem down 36MB (20.45% improvement), RSS/PID down 1mb (33% improvement)

Allowing for 1741MB availble ram, means 1601mb (1741MB -140MB shared) is available for apache threads, allowing for 800.5 concurrent connections with the improved config and by comparison

1565 MB Avail for threads (1741MB - 176MB), allowing 521.66 concurrent connections.

So with the improvements outlined above in theory the Apache server can now handle ~280 more concurrent connections.



