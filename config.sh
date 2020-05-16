#!/bin/bash

DEFAULT_NAME=rocketstack
NAME=$1
HOST=$2
WWW=$3
USER=alantygel

sed "s/$DEFAULT_NAME/$NAME/g" nginx/sites-available/rocketstack.conf > /etc/nginx/sites-available/$NAME.conf
sed -i "s/server_name _/server_name $HOST/g" /etc/nginx/sites-available/$NAME.conf

if [ $WWW == Y ]
then
        echo "server {
    server_name www.$HOST;
    return 301 \$scheme://$HOST\$request_uri;
} " >> /etc/nginx/sites-available/$NAME.conf
fi

mkdir /var/www/cache/$NAME
chown $USER:$USER /var/www/cache/$NAME
ln -s /etc/nginx/sites-available/$NAME.conf /etc/nginx/sites-enabled/
