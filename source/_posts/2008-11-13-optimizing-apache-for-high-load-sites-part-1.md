--- 
wordpress_id: 271
layout: post
title: Optimizing apache for high load sites - Part 1
date: 2008-11-13 12:33:35 +00:00
tags: 
- apache
- memory
- optimize
categories: 
- linux
- apache
wordpress_url: https://blog.oneiroi.co.uk/linux/optimizing-apache-for-high-load-sites-part-1
comments: true
---
Following on from <a href="https://blog.oneiroi.co.uk/linux/linux-the-sysadmin-script-part-3">linux-the-sysadmin-script-part-3</a> I am now going to cover how to reduce the memory footprint of apache.

So why would you want to reduce the memory footprint?

Simple really so you can have more concurrent connections to the apache server without having to constantly keep adding more memory to your web server.

This 'tutorial' does assume the following:
<ul><li>You are running apache on a server dedicated to doing so.</li><li>You have a basic understanding of how to install and configure apache.</li><li>You have a basic understanding of bash scripting.</li><li>You have the pmap package installed on your server.</li></ul>
As was introduced in <a href="https://blog.oneiroi.co.uk/linux/linux-the-sysadmin-script-part-3">part-3</a> the function appmem will report the memory usage of all current running threads of an application name, report the average memory usage, and an example pmap command using the last PID in the list.

This is where this entry will pick up, once pmap is run you will see the following example output:

{% highlight bash %}
----- MEMORY USAGE REPORT FOR 'apache' -----
PID Count: 6
Mem usage: 1135 MB
Mem/PID: 189 MB
For more information run: pmap -x 25883
------
[buzz@buzz_srv .sysadmin]# pmap -x 25883
25883: /usr/sbin/httpd
Address Kbytes RSS Anon Locked Mode Mapping
00002b777eac8000 308 - - - r-x-- httpd
00002b777eb15000 100 - - - rw-s- zero (deleted)
00002b777eb2e000 88 - - - rw-s- zero (deleted)
00002b777ed14000 16 - - - rw--- httpd
00002b777ed18000 12 - - - rw--- [ anon ]
00002b777ed1b000 104 - - - r-x-- ld-2.5.so
00002b777ed35000 4 - - - rw--- [ anon ]
00002b777ed3f000 4 - - - rw--- [ anon ]
00002b777ef35000 4 - - - r---- ld-2.5.so
00002b777ef36000 4 - - - rw--- ld-2.5.so
00002b777ef37000 520 - - - r-x-- libm-2.5.so
00002b777efb9000 2044 - - - ----- libm-2.5.so
00002b777f1b8000 4 - - - r---- libm-2.5.so
00002b777f1b9000 4 - - - rw--- libm-2.5.so
00002b777f1ba000 108 - - - r-x-- libpcre.so.0.0.1
00002b777f1d5000 2048 - - - ----- libpcre.so.0.0.1
00002b777f3d5000 4 - - - rw--- libpcre.so.0.0.1
00002b777f3d6000 84 - - - r-x-- libselinux.so.1
00002b777f3eb000 2048 - - - ----- libselinux.so.1
00002b777f5eb000 8 - - - rw--- libselinux.so.1
00002b777f5ed000 8 - - - rw--- [ anon ]
00002b777f5ef000 112 - - - r-x-- libaprutil-1.so.0.2.7
00002b777f60b000 2044 - - - ----- libaprutil-1.so.0.2.7
00002b777f80a000 8 - - - rw--- libaprutil-1.so.0.2.7
00002b777f80c000 36 - - - r-x-- libcrypt-2.5.so
00002b777f815000 2044 - - - ----- libcrypt-2.5.so
00002b777fa14000 4 - - - r---- libcrypt-2.5.so
00002b777fa15000 4 - - - rw--- libcrypt-2.5.so
00002b777fa16000 184 - - - rw--- [ anon ]
00002b777fa44000 224 - - - r-x-- libldap-2.3.so.0.2.15
00002b777fa7c000 2048 - - - ----- libldap-2.3.so.0.2.15
00002b777fc7c000 8 - - - rw--- libldap-2.3.so.0.2.15
00002b777fc7e000 4 - - - rw--- [ anon ]
00002b777fc7f000 52 - - - r-x-- liblber-2.3.so.0.2.15
00002b777fc8c000 2048 - - - ----- liblber-2.3.so.0.2.15
00002b777fe8c000 4 - - - rw--- liblber-2.3.so.0.2.15
00002b777fe8d000 964 - - - r-x-- libdb-4.3.so
00002b777ff7e000 2044 - - - ----- libdb-4.3.so
00002b778017d000 20 - - - rw--- libdb-4.3.so
00002b7780182000 128 - - - r-x-- libexpat.so.0.5.0
00002b77801a2000 2044 - - - ----- libexpat.so.0.5.0
00002b77803a1000 12 - - - rw--- libexpat.so.0.5.0
00002b77803a4000 4 - - - rw--- [ anon ]
00002b77803a5000 152 - - - r-x-- libapr-1.so.0.2.7
00002b77803cb000 2048 - - - ----- libapr-1.so.0.2.7
00002b77805cb000 4 - - - rw--- libapr-1.so.0.2.7
00002b77805cc000 84 - - - r-x-- libpthread-2.5.so
00002b77805e1000 2044 - - - ----- libpthread-2.5.so
00002b77807e0000 4 - - - r---- libpthread-2.5.so
00002b77807e1000 4 - - - rw--- libpthread-2.5.so
00002b77807e2000 16 - - - rw--- [ anon ]
00002b77807e6000 8 - - - r-x-- libdl-2.5.so
00002b77807e8000 2048 - - - ----- libdl-2.5.so
00002b77809e8000 4 - - - r---- libdl-2.5.so
00002b77809e9000 4 - - - rw--- libdl-2.5.so
00002b77809ea000 4 - - - rw--- [ anon ]
00002b77809eb000 1320 - - - r-x-- libc-2.5.so
00002b7780b35000 2044 - - - ----- libc-2.5.so
00002b7780d34000 16 - - - r---- libc-2.5.so
00002b7780d38000 4 - - - rw--- libc-2.5.so
00002b7780d39000 20 - - - rw--- [ anon ]
00002b7780d3e000 236 - - - r-x-- libsepol.so.1
00002b7780d79000 2048 - - - ----- libsepol.so.1
00002b7780f79000 4 - - - rw--- libsepol.so.1
00002b7780f7a000 40 - - - rw--- [ anon ]
00002b7780f84000 12 - - - r-x-- libuuid.so.1.2
00002b7780f87000 2048 - - - ----- libuuid.so.1.2
00002b7781187000 4 - - - rw--- libuuid.so.1.2
00002b7781188000 4 - - - rw--- [ anon ]
00002b7781189000 128 - - - r-x-- libpq.so.4.1
00002b77811a9000 2048 - - - ----- libpq.so.4.1
00002b77813a9000 8 - - - rw--- libpq.so.4.1
00002b77813ab000 352 - - - r-x-- libsqlite3.so.0.8.6
00002b7781403000 2048 - - - ----- libsqlite3.so.0.8.6
00002b7781603000 8 - - - rw--- libsqlite3.so.0.8.6
00002b7781605000 68 - - - r-x-- libresolv-2.5.so
00002b7781616000 2048 - - - ----- libresolv-2.5.so
00002b7781816000 4 - - - r---- libresolv-2.5.so
00002b7781817000 4 - - - rw--- libresolv-2.5.so
00002b7781818000 12 - - - rw--- [ anon ]
00002b778181b000 96 - - - r-x-- libsasl2.so.2.0.22
00002b7781833000 2048 - - - ----- libsasl2.so.2.0.22
00002b7781a33000 4 - - - rw--- libsasl2.so.2.0.22
00002b7781a34000 268 - - - r-x-- libssl.so.0.9.8b
00002b7781a77000 2048 - - - ----- libssl.so.0.9.8b
00002b7781c77000 24 - - - rw--- libssl.so.0.9.8b
00002b7781c7d000 1172 - - - r-x-- libcrypto.so.0.9.8b
00002b7781da2000 2048 - - - ----- libcrypto.so.0.9.8b
00002b7781fa2000 124 - - - rw--- libcrypto.so.0.9.8b
00002b7781fc1000 20 - - - rw--- [ anon ]
00002b7781fc6000 572 - - - r-x-- libkrb5.so.3.3
00002b7782055000 2048 - - - ----- libkrb5.so.3.3
00002b7782255000 16 - - - rw--- libkrb5.so.3.3
00002b7782259000 84 - - - r-x-- libnsl-2.5.so
00002b778226e000 2044 - - - ----- libnsl-2.5.so
00002b778246d000 4 - - - r---- libnsl-2.5.so
00002b778246e000 4 - - - rw--- libnsl-2.5.so
00002b778246f000 12 - - - rw--- [ anon ]
00002b7782472000 176 - - - r-x-- libgssapi_krb5.so.2.2
00002b778249e000 2048 - - - ----- libgssapi_krb5.so.2.2
00002b778269e000 8 - - - rw--- libgssapi_krb5.so.2.2
00002b77826a0000 8 - - - r-x-- libcom_err.so.2.1
00002b77826a2000 2044 - - - ----- libcom_err.so.2.1
00002b77828a1000 4 - - - rw--- libcom_err.so.2.1
00002b77828a2000 144 - - - r-x-- libk5crypto.so.3.1
00002b77828c6000 2044 - - - ----- libk5crypto.so.3.1
00002b7782ac5000 8 - - - rw--- libk5crypto.so.3.1
00002b7782ac7000 4 - - - rw--- [ anon ]
00002b7782ac8000 80 - - - r-x-- libz.so.1.2.3
00002b7782adc000 2044 - - - ----- libz.so.1.2.3
00002b7782cdb000 4 - - - rw--- libz.so.1.2.3
00002b7782cdc000 32 - - - r-x-- libkrb5support.so.0.1
00002b7782ce4000 2044 - - - ----- libkrb5support.so.0.1
00002b7782ee3000 4 - - - rw--- libkrb5support.so.0.1
00002b7782ee4000 8 - - - r-x-- libkeyutils-1.2.so
00002b7782ee6000 2044 - - - ----- libkeyutils-1.2.so
00002b77830e5000 4 - - - rw--- libkeyutils-1.2.so
00002b77830e6000 12 - - - rw--- [ anon ]
00002b77830e9000 8 - - - r-x-- mod_auth_basic.so
00002b77830eb000 2044 - - - ----- mod_auth_basic.so
00002b77832ea000 8 - - - rw--- mod_auth_basic.so
00002b77832ec000 24 - - - r-x-- mod_auth_digest.so
00002b77832f2000 2044 - - - ----- mod_auth_digest.so
00002b77834f1000 8 - - - rw--- mod_auth_digest.so
00002b77834f3000 8 - - - r-x-- mod_authn_file.so
00002b77834f5000 2044 - - - ----- mod_authn_file.so
00002b77836f4000 8 - - - rw--- mod_authn_file.so
00002b77836f6000 8 - - - r-x-- mod_authn_alias.so
00002b77836f8000 2044 - - - ----- mod_authn_alias.so
00002b77838f7000 8 - - - rw--- mod_authn_alias.so
00002b77838f9000 4 - - - r-x-- mod_authn_anon.so
00002b77838fa000 2048 - - - ----- mod_authn_anon.so
00002b7783afa000 8 - - - rw--- mod_authn_anon.so
00002b7783afc000 4 - - - r-x-- mod_authn_dbm.so
00002b7783afd000 2048 - - - ----- mod_authn_dbm.so
00002b7783cfd000 8 - - - rw--- mod_authn_dbm.so
00002b7783cff000 4 - - - r-x-- mod_authn_default.so
00002b7783d00000 2044 - - - ----- mod_authn_default.so
00002b7783eff000 8 - - - rw--- mod_authn_default.so
00002b7783f01000 8 - - - r-x-- mod_authz_host.so
00002b7783f03000 2044 - - - ----- mod_authz_host.so
00002b7784102000 8 - - - rw--- mod_authz_host.so
00002b7784104000 4 - - - r-x-- mod_authz_user.so
00002b7784105000 2044 - - - ----- mod_authz_user.so
00002b7784304000 8 - - - rw--- mod_authz_user.so
00002b7784306000 8 - - - r-x-- mod_authz_owner.so
00002b7784308000 2044 - - - ----- mod_authz_owner.so
00002b7784507000 8 - - - rw--- mod_authz_owner.so
00002b7784509000 8 - - - r-x-- mod_authz_groupfile.so
00002b778450b000 2044 - - - ----- mod_authz_groupfile.so
00002b778470a000 8 - - - rw--- mod_authz_groupfile.so
00002b778470c000 8 - - - r-x-- mod_authz_dbm.so
00002b778470e000 2044 - - - ----- mod_authz_dbm.so
00002b778490d000 8 - - - rw--- mod_authz_dbm.so
00002b778490f000 4 - - - r-x-- mod_authz_default.so
00002b7784910000 2044 - - - ----- mod_authz_default.so
00002b7784b0f000 8 - - - rw--- mod_authz_default.so
00002b7784b11000 44 - - - r-x-- mod_ldap.so
00002b7784b1c000 2044 - - - ----- mod_ldap.so
00002b7784d1b000 8 - - - rw--- mod_ldap.so
00002b7784d1d000 24 - - - r-x-- mod_authnz_ldap.so
00002b7784d23000 2044 - - - ----- mod_authnz_ldap.so
00002b7784f22000 8 - - - rw--- mod_authnz_ldap.so
00002b7784f24000 36 - - - r-x-- mod_include.so
00002b7784f2d000 2048 - - - ----- mod_include.so
00002b778512d000 8 - - - rw--- mod_include.so
00002b778512f000 20 - - - r-x-- mod_log_config.so
00002b7785134000 2044 - - - ----- mod_log_config.so
00002b7785333000 8 - - - rw--- mod_log_config.so
00002b7785335000 8 - - - r-x-- mod_logio.so
00002b7785337000 2044 - - - ----- mod_logio.so
00002b7785536000 8 - - - rw--- mod_logio.so
00002b7785538000 4 - - - r-x-- mod_env.so
00002b7785539000 2048 - - - ----- mod_env.so
00002b7785739000 8 - - - rw--- mod_env.so
00002b778573b000 16 - - - r-x-- mod_ext_filter.so
00002b778573f000 2044 - - - ----- mod_ext_filter.so
00002b778593e000 8 - - - rw--- mod_ext_filter.so
00002b7785940000 20 - - - r-x-- mod_mime_magic.so
00002b7785945000 2044 - - - ----- mod_mime_magic.so
00002b7785b44000 8 - - - rw--- mod_mime_magic.so
00002b7785b46000 8 - - - r-x-- mod_expires.so
00002b7785b48000 2044 - - - ----- mod_expires.so
00002b7785d47000 8 - - - rw--- mod_expires.so
00002b7785d49000 16 - - - r-x-- mod_deflate.so
00002b7785d4d000 2044 - - - ----- mod_deflate.so
00002b7785f4c000 8 - - - rw--- mod_deflate.so
00002b7785f4e000 12 - - - r-x-- mod_headers.so
00002b7785f51000 2044 - - - ----- mod_headers.so
00002b7786150000 8 - - - rw--- mod_headers.so
00002b7786152000 8 - - - r-x-- mod_usertrack.so
00002b7786154000 2048 - - - ----- mod_usertrack.so
00002b7786354000 8 - - - rw--- mod_usertrack.so
00002b7786356000 8 - - - r-x-- mod_setenvif.so
00002b7786358000 2048 - - - ----- mod_setenvif.so
00002b7786558000 8 - - - rw--- mod_setenvif.so
00002b778655a000 16 - - - r-x-- mod_mime.so
00002b778655e000 2044 - - - ----- mod_mime.so
00002b778675d000 8 - - - rw--- mod_mime.so
00002b778675f000 84 - - - r-x-- mod_dav.so
00002b7786774000 2044 - - - ----- mod_dav.so
00002b7786973000 8 - - - rw--- mod_dav.so
00002b7786975000 16 - - - r-x-- mod_status.so
00002b7786979000 2044 - - - ----- mod_status.so
00002b7786b78000 8 - - - rw--- mod_status.so
00002b7786b7a000 32 - - - r-x-- mod_autoindex.so
00002b7786b82000 2044 - - - ----- mod_autoindex.so
00002b7786d81000 8 - - - rw--- mod_autoindex.so
00002b7786d83000 16 - - - r-x-- mod_info.so
00002b7786d87000 2044 - - - ----- mod_info.so
00002b7786f86000 8 - - - rw--- mod_info.so
00002b7786f88000 44 - - - r-x-- mod_dav_fs.so
00002b7786f93000 2044 - - - ----- mod_dav_fs.so
00002b7787192000 8 - - - rw--- mod_dav_fs.so
00002b7787194000 8 - - - r-x-- mod_vhost_alias.so
00002b7787196000 2044 - - - ----- mod_vhost_alias.so
00002b7787395000 8 - - - rw--- mod_vhost_alias.so
00002b7787397000 28 - - - r-x-- mod_negotiation.so
00002b778739e000 2044 - - - ----- mod_negotiation.so
00002b778759d000 8 - - - rw--- mod_negotiation.so
00002b778759f000 8 - - - r-x-- mod_dir.so
00002b77875a1000 2044 - - - ----- mod_dir.so
00002b77877a0000 8 - - - rw--- mod_dir.so
00002b77877a2000 8 - - - r-x-- mod_actions.so
00002b77877a4000 2044 - - - ----- mod_actions.so
00002b77879a3000 8 - - - rw--- mod_actions.so
00002b77879a5000 8 - - - r-x-- mod_speling.so
00002b77879a7000 2048 - - - ----- mod_speling.so
00002b7787ba7000 8 - - - rw--- mod_speling.so
00002b7787ba9000 8 - - - r-x-- mod_userdir.so
00002b7787bab000 2044 - - - ----- mod_userdir.so
00002b7787daa000 8 - - - rw--- mod_userdir.so
00002b7787dac000 12 - - - r-x-- mod_alias.so
00002b7787daf000 2044 - - - ----- mod_alias.so
00002b7787fae000 8 - - - rw--- mod_alias.so
00002b7787fb0000 56 - - - r-x-- mod_rewrite.so
00002b7787fbe000 2044 - - - ----- mod_rewrite.so
00002b77881bd000 8 - - - rw--- mod_rewrite.so
00002b77881bf000 64 - - - r-x-- mod_proxy.so
00002b77881cf000 2044 - - - ----- mod_proxy.so
00002b77883ce000 8 - - - rw--- mod_proxy.so
00002b77883d0000 20 - - - r-x-- mod_proxy_balancer.so
00002b77883d5000 2044 - - - ----- mod_proxy_balancer.so
00002b77885d4000 8 - - - rw--- mod_proxy_balancer.so
00002b77885d6000 28 - - - r-x-- mod_proxy_ftp.so
00002b77885dd000 2044 - - - ----- mod_proxy_ftp.so
00002b77887dc000 8 - - - rw--- mod_proxy_ftp.so
00002b77887de000 24 - - - r-x-- mod_proxy_http.so
00002b77887e4000 2044 - - - ----- mod_proxy_http.so
00002b77889e3000 8 - - - rw--- mod_proxy_http.so
00002b77889e5000 8 - - - r-x-- mod_proxy_connect.so
00002b77889e7000 2044 - - - ----- mod_proxy_connect.so
00002b7788be6000 8 - - - rw--- mod_proxy_connect.so
00002b7788be8000 28 - - - r-x-- mod_cache.so
00002b7788bef000 2044 - - - ----- mod_cache.so
00002b7788dee000 8 - - - rw--- mod_cache.so
00002b7788df0000 4 - - - r-x-- mod_suexec.so
00002b7788df1000 2048 - - - ----- mod_suexec.so
00002b7788ff1000 8 - - - rw--- mod_suexec.so
00002b7788ff3000 16 - - - r-x-- mod_disk_cache.so
00002b7788ff7000 2048 - - - ----- mod_disk_cache.so
00002b77891f7000 8 - - - rw--- mod_disk_cache.so
00002b77891f9000 8 - - - r-x-- mod_file_cache.so
00002b77891fb000 2044 - - - ----- mod_file_cache.so
00002b77893fa000 8 - - - rw--- mod_file_cache.so
00002b77893fc000 24 - - - r-x-- mod_mem_cache.so
00002b7789402000 2044 - - - ----- mod_mem_cache.so
00002b7789601000 8 - - - rw--- mod_mem_cache.so
00002b7789603000 20 - - - r-x-- mod_cgi.so
00002b7789608000 2048 - - - ----- mod_cgi.so
00002b7789808000 8 - - - rw--- mod_cgi.so
00002b778980a000 8 - - - r-x-- mod_version.so
00002b778980c000 2044 - - - ----- mod_version.so
00002b7789a0b000 8 - - - rw--- mod_version.so
00002b7789a0d000 28 - - - r-x-- mod_proxy_ajp.so
00002b7789a14000 2044 - - - ----- mod_proxy_ajp.so
00002b7789c13000 8 - - - rw--- mod_proxy_ajp.so
00002b7789c15000 16 - - - r-x-- mod_suphp.so
00002b7789c19000 2044 - - - ----- mod_suphp.so
00002b7789e18000 4 - - - rw--- mod_suphp.so
00002b7789e22000 40 - - - r-x-- libnss_files-2.5.so
00002b7789e2c000 2044 - - - ----- libnss_files-2.5.so
00002b778a02b000 4 - - - r---- libnss_files-2.5.so
00002b778a02c000 4 - - - rw--- libnss_files-2.5.so
00002b778a02d000 16 - - - r-x-- libnss_dns-2.5.so
00002b778a031000 2044 - - - ----- libnss_dns-2.5.so
00002b778a230000 4 - - - r---- libnss_dns-2.5.so
00002b778a231000 4 - - - rw--- libnss_dns-2.5.so
00002b778b815000 1476 - - - rw--- [ anon ]
00007fff2bfcd000 84 - - - rw--- [ stack ]
ffffffffff600000 8192 - - - ----- [ anon ]
---------------- ------ ------ ------ ------
total kB 193636 - - -

-----
{% endhighlight %}

As can be seen above via the script and pmap output, the majority of apache's memory footprint is taken up by dynamicaly loaded libraries or 'mods'.

Take for example mod_authz_ldap, this module itself on each thread spawn (new connection) is taking up ~2mb of physical memory space, now this may not seem like much until you are serving 100's of concurrent connections, at which point this becomes a very real problem.

mod_authz_ldap I have used as an example because it is an authentication module for use with the Lightweight Directory Access Protocol, something not commonly used in a generic LAMP setup.

By going through your httpd.conf and disabling modules you know you do not require (such as the example above), you can substantially reduce the memory footprint of apache, and therefor increase the number of concurrent connections apache can serve with the available memory.

In part 2 I will provide a new ouput of the script and pmap post optimization ... stay tuned :-)
