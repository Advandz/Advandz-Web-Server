#!/bin/bash

#
# Advandz Web Server Installer
# NOTE: All the included software, names and trademarks are property
# of the respective owners. The Advandz Team not provides 
# support, advice or guarantee of the third-party software included
# in this package. Every software included in this package
# is under their own license.
# 
# @package Advandz
# @copyright Copyright (c) 2012-2017 CyanDark, Inc. All Rights Reserved.
# @license https://opensource.org/licenses/GPL-3.0 GNU General Public License, version 3 (GPL-3.0)
# @author The Advandz Team <team@advandz.com>
# 

# Install Pure-Ftpd
PERCONA_ROOT_PASSWORD=$1;
PUREFTPD_PASSWORD=$(date +%s | sha256sum | base64 | head -c 12 ; echo);

mysql -u root -p$PERCONA_ROOT_PASSWORD -e "CREATE DATABASE pureftpd;" >> /dev/null 2>&1;
mysql -u root -p$PERCONA_ROOT_PASSWORD -e "GRANT ALL ON pureftpd.* TO 'pureftpd'@'localhost' IDENTIFIED BY '$PUREFTPD_PASSWORD';" >> /dev/null 2>&1;
mysql -u root -p$PERCONA_ROOT_PASSWORD -e "FLUSH PRIVILEGES;" >> /dev/null 2>&1;
{
    echo "CREATE TABLE ftpd (
User varchar(16) NOT NULL default '',
status enum('0','1') NOT NULL default '0',
Password varchar(64) NOT NULL default '',
Uid varchar(11) NOT NULL default '-1',
Gid varchar(11) NOT NULL default '-1',
Dir varchar(128) NOT NULL default '',
ULBandwidth smallint(5) NOT NULL default '0',
DLBandwidth smallint(5) NOT NULL default '0',
comment tinytext NOT NULL,
ipaccess varchar(15) NOT NULL default '*',
QuotaSize smallint(5) NOT NULL default '0',
QuotaFiles int(11) NOT NULL default 0,
PRIMARY KEY (User),
UNIQUE KEY User (User)
) ENGINE=MyISAM;";
} >pureftpd.sql
mysql -u root -p$PERCONA_ROOT_PASSWORD "pureftpd" < "pureftpd.sql" >> /dev/null 2>&1;
rm -rf pureftpd.sql >> /dev/null 2>&1;

yum -y install pure-ftpd >> /dev/null 2>&1;

systemctl enable pure-ftpd >> /dev/null 2>&1;
systemctl start pure-ftpd >> /dev/null 2>&1;

groupadd ftpgroup >> /dev/null 2>&1;
useradd -g ftpgroup -d /dev/null -s /etc ftpuser >> /dev/null 2>&1;

firewall-cmd --permanent --zone=public --add-service=ftp >> /dev/null 2>&1;
firewall-cmd --permanent --add-port=20/tcp >> /dev/null 2>&1;
firewall-cmd --permanent --add-port=21/tcp >> /dev/null 2>&1;
firewall-cmd --reload >> /dev/null 2>&1;

{
    echo "MYSQLSocket      /var/lib/mysql/mysql.sock
#MYSQLServer     localhost
#MYSQLPort       3306
MYSQLUser       pureftpd
MYSQLPassword   $PUREFTPD_PASSWORD
MYSQLDatabase   pureftpd
MYSQLCrypt      md5
MYSQLGetPW      SELECT Password FROM ftpd WHERE User=\"\L\" AND status=\"1\" AND (ipaccess = \"*\" OR ipaccess LIKE \"\R\")
MYSQLGetUID     SELECT Uid FROM ftpd WHERE User=\"\L\" AND status=\"1\" AND (ipaccess = \"*\" OR ipaccess LIKE \"\R\")
MYSQLGetGID     SELECT Gid FROM ftpd WHERE User=\"\L\"AND status=\"1\" AND (ipaccess = \"*\" OR ipaccess LIKE \"\R\")
MYSQLGetDir     SELECT Dir FROM ftpd WHERE User=\"\L\"AND status=\"1\" AND (ipaccess = \"*\" OR ipaccess LIKE \"\R\")
MySQLGetBandwidthUL SELECT ULBandwidth FROM ftpd WHERE User=\"\L\"AND status=\"1\" AND (ipaccess = \"*\" OR ipaccess LIKE \"\R\")
MySQLGetBandwidthDL SELECT DLBandwidth FROM ftpd WHERE User=\"\L\"AND status=\"1\" AND (ipaccess = \"*\" OR ipaccess LIKE \"\R\")
MySQLGetQTASZ   SELECT QuotaSize FROM ftpd WHERE User=\"\L\"AND status=\"1\" AND (ipaccess = \"*\" OR ipaccess LIKE \"\R\")
MySQLGetQTAFS   SELECT QuotaFiles FROM ftpd WHERE User=\"\L\"AND status=\"1\" AND (ipaccess = \"*\" OR ipaccess LIKE \"\R\")";
} >/etc/pure-ftpd/pureftpd-mysql.conf

echo $PUREFTPD_PASSWORD;