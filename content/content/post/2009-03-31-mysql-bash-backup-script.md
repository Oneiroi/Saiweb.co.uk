---
date: "2009-03-31T09:06:33Z"
tags:
- mysql
- bash-script
title: mySQL bash backup script
wordpress_id: 622
wordpress_url: https://blog.oneiroi.co.uk/mysql/mysql-bash-backup-script
---
In on of those "oh ffs" moments I found myself writing a BASH script to quickly dump all database on a mySQL server.

{{< highlight bash >}}
#!/bin/bash
MYSQL=`which mysql`;
MYSQLDUMP=`which mysqldump`;
GZIP=`which gzip`;
DEST="/path/to/dump/folder"

USER="root";
PWD="XXXXXX";

DBS=(`$MYSQL  -u $USER -p$PWD  -Bse 'show databases'`);

for db in ${DBS[@]};
do
        `$MYSQLDUMP --default-character-set=utf8 --set-charset -u $USER -p$PWD $db | $GZIP -9 > $DEST/$db.sql.gz`
        echo "$db - DONE";
done;
{{< / highlight >}}

This script gets a list of all databases, dumps them out with UTF8 encoding, and gzip compresses the SQL file into the given "DEST" folder.

If you want to skip over certain databases i.e. "mysql"

Change this line:

{{< highlight bash >}}
DBS=(`$MYSQL  -u $USER -p$PWD  -Bse 'show databases'`);
{{< / highlight >}}

To:
{{< highlight bash >}}
DBS=(`$MYSQL  -u $USER -p$PWD  -Bse 'show databases' | grep -v "database_to_exclude"`);
{{< / highlight >}}

Or for multiple exclusions

{{< highlight bash >}}
DBS=(`$MYSQL  -u $USER -p$PWD  -Bse 'show databases' | grep -v "database_to_exclude" | grep -v "another_database_to_exclude" | grep -v "etc"`);
{{< / highlight >}}


I may re-write this in Python, if I get time.

