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

# Install EPEL
yum update -y  >> /dev/null 2>&1;
rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm  >> /dev/null 2>&1;

# Install Apache
yum -y install httpd httpd-itk >> /dev/null 2>&1;
yum -y install mod_security >> /dev/null 2>&1;
yum -y install mod_evasive >> /dev/null 2>&1;
yum -y install mod_ssl >> /dev/null 2>&1;

# Configure Mod_MPM_ITK
{
    echo "LoadModule mpm_itk_module modules/mod_mpm_itk.so";
} >/etc/httpd/conf.modules.d/00-mpm-itk.conf

systemctl enable httpd >> /dev/null 2>&1;
systemctl start httpd >> /dev/null 2>&1;