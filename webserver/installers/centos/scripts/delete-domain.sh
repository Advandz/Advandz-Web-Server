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
#   ./delete-domain.sh --[domain]
# Example:
# ./add-domain.sh google.com
#

#
# Delete a domain and creates a virtual host in Apache
# @param string Domain
# 
function delete_domain {
    APACHE_DOMAIN=$1;
    DIRECTORY="/etc/advandz/domains/$APACHE_DOMAIN";

    if [ -d "$DIRECTORY" ]; then
        # Delete Domain Folder
        rm -rf /etc/advandz/domains/$APACHE_DOMAIN/

        # Delete Domain Vhost
        rm -rf /etc/httpd/sites-enabled/$APACHE_DOMAIN.conf
        rm -rf /etc/httpd/sites-enabled/$APACHE_DOMAIN-ssl.conf
        rm -rf /etc/nginx/conf.d/$APACHE_DOMAIN-ssl.conf
        
        # Restart Servers
        service httpd restart >> /dev/null 2>&1;
        service nginx restart >> /dev/null 2>&1;

        echo "SUCCESS : Domain has been deleted succesfully. : $APACHE_DOMAIN";
        exit;
    else
        echo "ERROR : The entered domain not exists. : $APACHE_DOMAIN";
        exit;
    fi
}

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
    delete_domain $DOMAIN
fi