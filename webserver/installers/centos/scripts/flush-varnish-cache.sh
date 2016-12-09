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
#   ./flush-varnish-cache.sh --[domain]
# Example:
# ./flush-varnish-cache.sh google.com
#

#
# Script
#
DOMAIN=$1;
DOMAIN_REGEX=$(echo $DOMAIN| grep -P '(?=^.{5,254}$)(^(?:(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)');

# Add to Apache
if [ -z "$DOMAIN_REGEX" ]; then
    echo "ERROR : The entered domain is not valid. : $DOMAIN";
    exit;
else
    varnishadm -T 127.0.0.1:80 $DOMAIN >> /dev/null 2>&1;
    echo "SUCCESS : Domain cache has been flushed succesfully. : $APACHE_DOMAIN";
fi