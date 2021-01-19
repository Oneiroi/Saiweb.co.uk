---
layout: post
title: "RHEL 6 Openstack via EPEL Keystone installation and integration with Nova and Glance"
date: 2012-04-22 16:04
comments: true
categories: 
- openstack
---

{% img https://blog.oneiroi.co.uk/openstack-cloud-software-vertical-small.png %}

In this post I follow on from [Setting up Nova and Glance](https://blog.oneiroi.co.uk/openstack/rhel-6-openstack-via-epel-nova-and-glance-on-kvm/), and now moving installing and Integrating keystone.
I'd first like to [give credit to IBM developerWorks](https://www.ibm.com/developerworks/mydeveloperworks/wikis/home/wiki/OpenStack?lang=en#configure-nova-api) the guys in #openstack @ freenode IRC, and [Psycle Interactive](https://psycle.com) without whom I would not of been able to complete this write up.

Please be aware the following applies to 2011.3 ONLY! (Diablo Final) the configuration to come in Essex is far simpler, if when reading this post your packages are 2012.X you have just installed essex and this is not relevant, anyway here we go ...

```
yum install openstack-keystone
```

Keystone itself has it's own tirade of concepts to get to grips with ... tenant, user, role, service, token etc ... I'm not going to go into detail on those concetps, for that [Please see the documentation](https://keystone.openstack.org/).

<strong>Configuring mySQL</strong>

First thing I am going to do is change from sqlite to mySQL connection, this involves editing line 54 of /etc/keystone/keystone.conf

```
sql_connection = mysql://keystone:keystone@localhost/keystone
```

Ignoring the default_store configuration at the top of the file, as this states sqllite, from what I can tell this simply instructs keystone to use the sqlAlchemy driver, which we just updated to point to mySQL.

Now like glance we need to restart keystone for the database to be populated.

```
service openstack-keystone restart
```

Now run keystone-manage with no args if you see

```
File "/usr/lib/python2.6/site-packages/keystone/manage/__init__.py", line 283, in main
    raise exc
sqlalchemy.exc.OperationalError: (OperationalError) (1044, "Access denied for user 'keystone'@'localhost' to database 'keystone'") None None
```

Review your keystone.conf file and ensure your mySQL credentials are correct, once done start keystone again.

<strong>Initial Credentials</strong>

Now we need to create an admin Tenant, and add an admin user to this tenancy.

```
keystone-manage tenant add adminTenant
SUCCESS: Tenant adminTenant created.
keystone-manage user add adminUser <password>
SUCCESS: User adminUser created.
keystone-manage role add Admin
SUCCESS: Role Admin created successfully.
keystone-manage role grant Admin adminUser
SUCCESS: Granted Admin the adminUser role on None.
keystone-manage role grant Admin adminUser adminTenant
SUCCESS: Granted Admin the adminUser role on adminTenant.
```

Ok so we have just:

1. setup a tenant named adminTenant.
2. setup a user named adminUser and specified their password.
3. created an admin role.
4. assigned the adminUser to the Admin role.
5. granted adminUser the Admin role to the adminTenant

Note: the outputs are a little confusion on the role assignments...

"Granted Admin the adminUser role on adminTenant", 

it appears the string output has the arguments in the wrong order here it should read:

"Granted adminUser the Admin role on adminTenant".

I have however verified the mySQL data and can see the roles being correctly assigned.

Also the output from
```
keystone-manage role grant help
Missing arguments: role grant 'role' 'user' 'tenant (optional)'
```

Confirms the arguments are being entered in the correct order.

i.e.

{% highlight sql %}
mysql> select * from user_roles;
+----+---------+---------+-----------+
| id | user_id | role_id | tenant_id |
+----+---------+---------+-----------+
|  1 |       1 |       1 |      NULL |
|  2 |       1 |       1 |         1 |
+----+---------+---------+-----------+
2 rows in set (0.00 sec)
{% endhighlight %}

Now we need to configure keystone to recognise these new admin roles.

Lines 41 and 44:

```
keystone-admin-role = Admin
keystone-service-admin-role = KeystoneServiceAdmin
```

Edit these to reflect your Admin role accordingly and then restart openstack-keystone
The above shows seperate roles for general and service admin, in my case I set these to the same role, it is of course entirely up to you and your delegation setup.
If you choose to retain the KeystoneServiceAdmin delegation you will need to setup the role as per the Admin role above and run through the grants accordingly.

<strong>Setting up the Service token and service definitions</strong>

```
keystone-manage token add 999888777666 adminUser adminTenant 2012-12-23T00:00
SUCCESS: Token 999888777666 created.
```

If instead you get an error:
```
ERROR: 'NoneType' object has no attribute 'id'
2012-04-23 12:27:29    ERROR [root] 'NoneType' object has no attribute 'id'
Traceback (most recent call last):
  File "/usr/bin/keystone-manage", line 16, in <module>
    keystone.manage.main()
  File "/usr/lib/python2.6/site-packages/keystone/manage/__init__.py", line 283, in main
    raise exc
AttributeError: 'NoneType' object has no attribute 'id'
```

check your have correctly entered adminUser adminTenant (or the details you have entered) including correct capitilization.

```
keystone-manage service add nova compute "Openstack Compute Service"
SUCCESS: Service nova created successfully.
keystone-manage service add glance image "Openstack Image Service"
SUCCESS: Service glance created successfully.
keystone-manage service add keystone identity "Openstack Image Service"
SUCCESS: Service keystone created successfully.
```

<strong>Defining endPoints</strong>

<u>Nova</u>
Here I managed to confuse myself, so let me be clear, this needs the nova_api service ip, not each compute node, meaning you only need one endpoint.

```
keystone-manage endpointTemplates add regionOne nova https://<nova_api_ip>:8774/v1.1/%tenant_id% https://<nova_api_ip>:8774/v1.1/%tenant_id% https://<nova_api_ip>:8774/v1.1/%tenant_id% 1 1
SUCCESS: Created EndpointTemplates for nova pointing to https://<nova_api_ip>:8774/v1.1/%tenant_id%
```

The 3 URL arguments are for publicURL, internalURL, adminURL (No idea if that is the order).

<u>Glance</u>

```
keystone-manage endpointTemplates add regionOne nova https://<glance_ip>:9292/v1 https://<nova_api_ip>:9292/v1 https://<nova_api_ip>:9292/v1 1 1
SUCCESS: Created EndpointTemplates for glance pointing to https://<glance_ip>:9292/v1
```

<u>Keystone</u>

```
keystone-manage endpointTemplates add pi-whc keystone https://<keystone_ip>:5000/v2.0 https://<keystone_ip>:5000/v2.0 https://<keystone_ip>:5000/v2.0 1 1
SUCCESS: Created EndpointTemplates for keystone pointing to https://<keystone_ip>:5000/v2.0.
```

<strong>Configuring Nova</strong>

Now we have keystone setup we need to configure nova to use keystone for authentication, by editing /etc/nova/api-paste.ini.
Now there are seveal edits required, as such what follows are snippets of those changes.

<u>EC2 Section modification</u>

line 22 and 27 ([pipeline:ec2cloud] and  [pipeline:ec2admin] sections).
```
pipeline = logrequest totoken authtoken keystonecontext ec2noauth cloudrequest authorizer ec2executor
```

New section for EC2 (in my config lines 60-61)

```
[filter:totoken]
paste.filter_factory = keystone.middleware.ec2_token:EC2Token.factory
```

<u>Openstack section modification</u>

Modification to [pipeline:openstackapi10] and [pipeline:openstackapi11] sections.

```
[pipeline:openstackapi10]
pipeline = faultwrap authtoken keystonecontext ratelimit extensions osapiapp10

[pipeline:openstackapi11]
pipeline = faultwrap authtoken keystonecontext ratelimit extensions osapiapp11
```

<u>Shared section addition</u>

We now need to add a complete new subsection to the .ini file

```
##########
# Shared #
##########

[filter:keystonecontext]
paste.filter_factory = keystone.middleware.nova_keystone_context:NovaKeystoneContext.factory

[filter:authtoken]
paste.filter_factory = keystone.middleware.auth_token:filter_factory
service_protocol = http
service_host = <keystone_ip>
service_port = 5000
auth_host = <keystone_ip>
auth_port = 35357
auth_protocol = http
auth_uri = https://<keystone_ip>:5000/
admin_token = 999888777666
```

<strong>NOTE:</strong> you will want to change this to https, but I will not be covering https configuration in this post.

Check that your configuration is working:

```
curl -d '{"auth": {"tenantName": "adminTenant", "passwordCredentials":{"username": "adminUser", "password": "password"}}}' -H "Content-type: application/json" https://<keystone_ip>:35357/v2.0/tokens | python -mjson.tool
```

Now restart openstack-nova-api

```
service openstack-nova-api restart
```

<u>Verifying nova keystone integration</u>

```
nova --debug --username=adminUser --apikey=<password> --url=https://<keystone_ip>:5000/v2.0 --version=1.1 list
connect: (<keystone_ip>, 5000)
send: 'POST /tokens HTTP/1.1\r\nHost: <keystone_ip>:5000\r\nContent-Length: 69\r\ncontent-type: application/json\r\naccept-encoding: gzip, deflate\r\nuser-agent: python-novaclient\r\n\r\n'
send: '{"passwordCredentials": {"username": "adminUser", "password": "<password>"}}'
reply: 'HTTP/1.1 400 Bad Request\r\n'
header: Content-Type: application/json; charset=UTF-8
header: Content-Length: 60
header: Date: Mon, 23 Apr 2012 14:16:13 GMT
Traceback (most recent call last):
  File "/usr/bin/nova", line 9, in <module>
    load_entry_point('python-novaclient==2.6.1', 'console_scripts', 'nova')()
  File "/usr/lib/python2.6/site-packages/novaclient/shell.py", line 209, in main
    OpenStackComputeShell().main(sys.argv[1:])
  File "/usr/lib/python2.6/site-packages/novaclient/shell.py", line 166, in main
    self.cs.authenticate()
  File "/usr/lib/python2.6/site-packages/novaclient/v1_1/client.py", line 54, in authenticate
    self.client.authenticate()
  File "/usr/lib/python2.6/site-packages/novaclient/client.py", line 140, in authenticate
    auth_url = self._v2_auth(auth_url)
  File "/usr/lib/python2.6/site-packages/novaclient/client.py", line 180, in _v2_auth
    resp, body = self.request(token_url, "POST", body=body)
  File "/usr/lib/python2.6/site-packages/novaclient/client.py", line 87, in request
    raise exceptions.from_response(resp, body)
novaclient.exceptions.BadRequest: Expecting auth (HTTP 400)

```

Don't PANIC! it seems there was never a 2011.3 build for python-novaclient, as such we can "cheat" a little, and use 2012.1-1

```
rpm -Uvh https://pbrady.fedorapeople.org/openstack-el6/python-novaclient-2012.1-1.el6.noarch.rpm
nova --debug --os_username=adminUser --os_password=<password> --os_tenant_name=adminTenant --os_auth_url=https://<keystone_ip>:5000/v2.0/ usage-list
connect: (<keystone_ip>, 5000)
send: 'POST /v2.0/tokens HTTP/1.1\r\nHost: <keystone_ip>:5000\r\nContent-Length: 110\r\ncontent-type: application/json\r\naccept-encoding: gzip, deflate\r\naccept: application/json\r\nuser-agent: python-novaclient\r\n\r\n'
send: '{"auth": {"tenantName": "adminTenant", "passwordCredentials": {"username": "adminUser", "password": "psycle"}}}'
reply: 'HTTP/1.1 200 OK\r\n'
header: Content-Type: application/json; charset=UTF-8
header: Content-Length: 924
header: Date: Mon, 23 Apr 2012 15:14:00 GMT
connect: (<nova_ip>, 8774)
send: u'GET /v1.1/1/os-simple-tenant-usage?start=2012-03-26T16:14:00.749451&end=2012-04-24T16:14:00.749491&detailed=1 HTTP/1.1\r\nHost: <keystone_ip>:8774\r\nx-auth-project-id: adminTenant\r\nx-auth-token: 999888777666\r\naccept-encoding: gzip, deflate\r\naccept: application/json\r\nuser-agent: python-novaclient\r\n\r\n'
reply: 'HTTP/1.1 200 OK\r\n'
header: Content-Type: application/json
header: Content-Length: 21
header: Date: Mon, 23 Apr 2012 15:14:00 GMT
Usage from 2012-03-26 to 2012-04-24:
+-----------+-----------+--------------+-----------+---------------+
| Tenant ID | Instances | RAM MB-Hours | CPU Hours | Disk GB-Hours |
+-----------+-----------+--------------+-----------+---------------+
+-----------+-----------+--------------+-----------+---------------+
```

You can also follow diablo more closely by using griddynamics' rpm package

```
rpm -e --nodeps python-novavclient
rpm -Uvh https://yum.griddynamics.net/yum/diablo/python-novaclient-2011.3-b2489.noarch.rpm
nova --debug --username adminUser --password <password> --tenant_name adminTenant --auth_url https://<keystone_ip>:5000/v2.0/ usage-list
connect: (<keystone_ip>, 5000)
send: 'POST /v2.0/tokens HTTP/1.1\r\nHost: <keystone_ip>:5000\r\nContent-Length: 110\r\ncontent-type: application/json\r\naccept-encoding: gzip, deflate\r\naccept: application/json\r\nuser-agent: python-novaclient\r\n\r\n'
send: '{"auth": {"tenantName": "adminTenant", "passwordCredentials": {"username": "adminUser", "password": "<password>"}}}'
reply: 'HTTP/1.1 200 OK\r\n'
header: Content-Type: application/json; charset=UTF-8
header: Content-Length: 924
header: Date: Mon, 23 Apr 2012 15:27:01 GMT
connect: (<nova_ip>, 8774)
send: u'GET /v1.1/1/os-simple-tenant-usage?start=2012-03-26T16:27:01.859467&end=2012-04-24T16:27:01.859524&detailed=1 HTTP/1.1\r\nHost: <keystone_ip>:8774\r\nx-auth-project-id: adminTenant\r\nx-auth-token: 999888777666\r\naccept-encoding: gzip, deflate\r\naccept: application/json\r\nuser-agent: python-novaclient\r\n\r\n'
reply: 'HTTP/1.1 200 OK\r\n'
header: Content-Type: application/json
header: Content-Length: 21
header: Date: Mon, 23 Apr 2012 15:27:01 GMT
Usage from 2012-03-26 to 2012-04-24:
+-----------+-----------+--------------+-----------+---------------+
| Tenant ID | Instances | RAM MB-Hours | CPU Hours | Disk GB-Hours |
+-----------+-----------+--------------+-----------+---------------+
+-----------+-----------+--------------+-----------+---------------+

```

<strong>BE WARNED</strong>

Most of the other commands for myself are presently returning 404 / 500 errors, with the [Essex Release Impending](https://pbrady.fedorapeople.org/openstack-el6/) the current EPEL advice seems to be to use Essex, I will update as/when I can with futher information on these issues.

For instance on a: flavor-create a 500 error is encountered with the following logged in api.log

```
...
(nova.api.openstack): TRACE: AttributeError: 'ControllerV11' object has no attribute 'create'
...
```


<strong>Configuring Glance</strong>

Modify /etc/glance/glance-api.conf 

Comment out line 138 and uncomment 140

```
[pipeline:glance-api]
#pipeline = versionnegotiation context apiv1app
# NOTE: use the following pipeline for keystone
pipeline = versionnegotiation authtoken auth-context apiv1app
```

Modify lines 165-174 accordingly

```
[filter:authtoken]
paste.filter_factory = keystone.middleware.auth_token:filter_factory
service_protocol = http
service_host = <keystone_ip>
service_port = 5000
auth_host = <keystone_ip>
auth_port = 35357
auth_protocol = http
auth_uri = https://<keystone_ip>:5000/
admin_token = 999888777666
```

now edit /etc/glance/glance-registry.conf and again comment out the current pipline= line and uncomment the keystone line.

```
[pipeline:glance-registry]
#pipeline = context registryapp
# NOTE: use the following pipeline for keystone
pipeline = authtoken auth-context registryapp
```

Update the authtoken filter accordingly

```
[filter:authtoken]
paste.filter_factory = keystone.middleware.auth_token:filter_factory
service_protocol = http
service_host = <keystone_ip>
service_port = 5000
auth_host = <keystone_ip>
auth_port = 35357
auth_protocol = http
auth_uri = https://<keystone_ip>:5000/
admin_token = 999888777666
```

Restart glance

```
for i in api registry; do service openstack-glance-$i restart; done
Stopping openstack-glance-api:                             [  OK  ]
Starting openstack-glance-api:                             [  OK  ]
Stopping openstack-glance-registry:                        [  OK  ]
Starting openstack-glance-registry:                        [  OK  ]
```

<u>testing Keystone</u>

```
nova --debug --username adminUser --password <password> --tenant_name adminTenant --auth_url https://<keystone_ip>:5000/v2.0/ image-list
connect: (<keystone_ip>, 5000)
send: 'POST /v2.0/tokens HTTP/1.1\r\nHost: <keystone_ip>:5000\r\nContent-Length: 110\r\ncontent-type: application/json\r\naccept-encoding: gzip, deflate\r\naccept: application/json\r\nuser-agent: python-novaclient\r\n\r\n'
send: '{"auth": {"tenantName": "adminTenant", "passwordCredentials": {"username": "adminUser", "password": "<password>"}}}'
reply: 'HTTP/1.1 200 OK\r\n'
header: Content-Type: application/json; charset=UTF-8
header: Content-Length: 924
header: Date: Mon, 23 Apr 2012 15:48:56 GMT
connect: (<nova_ip>, 8774)
send: u'GET /v1.1/1/images/detail HTTP/1.1\r\nHost: <keystone_ip>:8774\r\nx-auth-project-id: adminTenant\r\nx-auth-token: 999888777666\r\naccept-encoding: gzip, deflate\r\naccept: application/json\r\nuser-agent: python-novaclient\r\n\r\n'
reply: 'HTTP/1.1 200 OK\r\n'
header: Content-Type: application/json
header: Content-Length: 14
header: Date: Mon, 23 Apr 2012 15:48:56 GMT
+----+------+--------+--------+
| ID | Name | Status | Server |
+----+------+--------+--------+
+----+------+--------+--------+
```

More to follow soon as I work through these issues, and later move onto 2012.X (Essex)
