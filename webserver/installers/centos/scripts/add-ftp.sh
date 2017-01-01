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

#
# Usage:
#   ./add-ftp.sh --[user] --[password] --[dir] --[disk-space] --[max-sessions]
# Example:
# ./add-ftp.sh advandz ***** /etc/advandz/domains/advandz.com  1024 5
#

#
# Adds a FTP account
# @param string FTP User
# @param string Password
# @param string FTP User directory
# @param string FTP Account Disk Space in MB
# @param string Max-Sessions - 0 means unlimited
# 

FTP_USER=$1;
FTP_PASSWORD=$2;
FTP_DIR=$3;
FTP_DISK_SPACE=$4;
FTP_MAX_SESSIONS=$5;

# Create FTP User
( echo ${FTP_PASSWORD}; echo ${FTP_PASSWORD} ) | pure-pw useradd $FTP_USER -u ftpuser -d $FTP_DIR -N $FTP_DISK_SPACE -y $FTP_MAX_SESSIONS >> /dev/null 2>&1;
( echo ${FTP_PASSWORD}; echo ${FTP_PASSWORD} ) | pure-pw passwd $FTP_USER -m >> /dev/null 2>&1;