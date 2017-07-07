# Advandz Web Server #
### High Performance Web Server. ###

Advandz Web Server, is a high performance web server stack featuring a powerful and open-source control panel.

### The Stack ###
Advandz Web Server, has been designed to be used in enterprise-class environments, large sites and demanding applications and be a Drop-in replacement of the classic LAMP stack, featuring a high performance and scalable stack.

#### Apache
We decided to implement Apache to give the maximum compatibility with all the actual products on the market, but we know that is not the best server in terms of performance, due to this we have developed Advandz Web Server, that includes an Apache booster that use an integration of NGINX and Varnish that caches both the static and dynamic contents which help the web server to serve the content from the cache every time it is requested.

#### Varnish
Varnish is an HTTP accelerator designed for content-heavy dynamic web sites as well as heavily consumed APIs. It typically speeds up delivery with a factor of 300 - 1000x.

#### NGINX
NGINX is an HTTP and reverse proxy server, Is very fast serving static content. Due Varnish doesn't support the HTTPS protocol, we use NGINX to cache and reverse-proxy the SSL Vhosts from Apache.

#### HHVM
HHVM is an open-source virtual machine designed for executing programs written in Hack and PHP. HHVM uses a just-in-time (JIT) compilation approach to achieve superior performance while maintaining the development flexibility that PHP provides.

#### Percona Server
Percona Server for MySQL® is a free, fully compatible, enhanced, open source drop-in replacement for MySQL that provides superior performance, scalability and instrumentation.

#### PowerDNS
PowerDNS is a open source and Scalable DNS Server, featuring a large number of different backends ranging from simple BIND style zonefiles to relational databases and load balancing/failover algorithms.

#### Pure-FTPd
Pure-FTPd is a free, open source, secure, production-quality and standard-conformant FTP server. It doesn't provide useless bells and whistles, but focuses on efficiency and ease of use. It provides simple answers to common needs, plus unique useful features for personal users as well as hosting providers.

#### Advandz Server Manager
The Advandz Server Manager is the official Control Panel provided with Advandz Web Server, is a Cloud-Ready, open source, multi-domain, a single user control panel that enables you to focus more on using applications rather than maintaining them.
