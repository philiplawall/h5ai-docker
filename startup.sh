#!/bin/bash

if [ -s /conf/lighttpd.conf ]; then
  cp /conf/lighttpd.conf /etc/lighttpd/
fi

if [ -s /conf/options.json ]; then
  cp /conf/options.json /var/www/_h5ai/private/conf/
fi

if [ -s /conf/index.html ]; then
  cp /conf/index.html /var/www/
fi

if [ -s /conf/Masthead.html ]; then
  sed -i '/<body id="root" class="index">/ r /conf/Masthead.html' /var/www/_h5ai/private/php/pages/index.php
fi

if [ -d /conf/img ]; then
  mkdir /var/www/img
  cp /conf/img/* /var/www/img/
fi

if [ -s /conf/custom.css ]; then
  cp /conf/custom.css /var/www/_h5ai/public/ext/
  sed -i "s/\"styles\": \[/ \"styles\": \[ \"custom.css\",/" /var/www/_h5ai/private/conf/options.json
fi

service lighttpd restart
tail -f /dev/null
