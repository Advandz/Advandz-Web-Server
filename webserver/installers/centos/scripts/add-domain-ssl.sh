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
#   ./add-domain-ssl.sh --[domain]
# Example:
# ./add-domain-ssl.sh google.com
#

#
# Adds a domain and creates a virtual host in Apache
# @param string Domain
# 
function add_domain_ssl {
    APACHE_DOMAIN=$1;
    DIRECTORY="/etc/advandz/domains/$APACHE_DOMAIN/ssl";
    
    if [ -d "$DIRECTORY" ]; then
        SSL_CERT="/etc/advandz/domains/$APACHE_DOMAIN/ssl/$APACHE_DOMAIN.crt";
        SSL_CERT_NGINX="/etc/advandz/domains/$APACHE_DOMAIN/ssl/$APACHE_DOMAIN-nginx.crt";
        SSL_CHAIN="/etc/advandz/domains/$APACHE_DOMAIN/ssl/$APACHE_DOMAIN-chain.crt";
        SSL_KEY="/etc/advandz/domains/$APACHE_DOMAIN/ssl/$APACHE_DOMAIN.key";

        if [ -f "$SSL_CERT" ] || [ -f "$SSL_KEY" ]; then
            # Create Domain SSL Vhost
            {
                echo "<VirtualHost *:4343>";
                echo "  SSLEngine on";
                echo "  SSLCertificateFile $SSL_CERT";
                echo "  SSLCertificateKeyFile $SSL_KEY";
                if [ -f "$SSL_CHAIN" ]; then
                    echo "  SSLCertificateChainFile $SSL_CHAIN";
                fi
                echo "  ServerName $APACHE_DOMAIN";
                echo "  ServerAlias www.$APACHE_DOMAIN";
                echo "  ServerAdmin webmaster@$APACHE_DOMAIN";
                echo "  DirectoryIndex index.html index.php";
                echo "  DocumentRoot /etc/advandz/domains/$APACHE_DOMAIN/public_html";
                echo "  ErrorLog /etc/advandz/domains/$APACHE_DOMAIN/logs/error.log";
                echo "  CustomLog /etc/advandz/domains/$APACHE_DOMAIN/logs/access.log combined";
                echo "  ScriptAlias /cgi-bin/ \"/etc/advandz/domains/$APACHE_DOMAIN/public_html/cgi-bin/\"";
                echo "  ProxyPassMatch ^/(.+\.(hh|php)(/.*)?)$ fcgi://127.0.0.1:9001/etc/advandz/domains/$APACHE_DOMAIN/public_html/\$1";
                echo "</VirtualHost>";
            } >/etc/httpd/sites-enabled/$APACHE_DOMAIN-ssl.conf

            # Add Reverse-Proxy Nginx
            {
                echo "server {";
                echo "    listen 443 ssl http2;";
                echo "    server_name $APACHE_DOMAIN www.$APACHE_DOMAIN;";
                echo "    ssl on;";
                echo "    ssl_certificate $SSL_CERT_NGINX;";
                echo "    ssl_certificate_key $SSL_KEY;";
                echo "    location / {";
                echo "        proxy_pass http://127.0.0.1:4343;";
                echo "        proxy_set_header X-Real-IP  \$remote_addr;";
                echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;";
                echo "        proxy_set_header X-Forwarded-Proto https;";
                echo "        proxy_set_header X-Forwarded-Port 443;";
                echo "        proxy_set_header Host \$host;";
                echo "    }";
                echo "}";
            } >/etc/nginx/conf.d/$APACHE_DOMAIN-ssl.conf

            # Restart Servers
            service httpd restart >> /dev/null 2>&1;
            service nginx restart >> /dev/null 2>&1;

            echo "SUCCESS : SSL has been enabled in the domain succesfully. : $APACHE_DOMAIN";
        else
            echo "ERROR : The SSL Certificate or Private Key not exists. : $APACHE_DOMAIN";
            exit;
        fi
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
    add_domain_ssl $DOMAIN
fi