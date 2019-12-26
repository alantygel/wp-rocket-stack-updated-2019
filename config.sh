#!/bin/bash

DEFAULT_NAME=rocketstack
echo Type the name of your website?
read NAME

echo Type your hostname
read HOST

echo Do you want a www hostname to redirect to non-www hostname? \[Y/N\]
read WWW

echo Weserver root dir has html folder? \[Y/n\]
read HTML

if [[ HTML = "" ]]
then
        HTML=Y
fi


echo username:group? \[alantygel:alantygel\]
read USER

if [[ USER = "" ]]
then
	USER=alantygel:alantygel
fi

echo $USER

sed "s/$DEFAULT_NAME/$NAME/g" nginx/sites-available/rocketstack.conf > nginx/sites-available/$NAME.conf
sed -i "s/server_name _/server_name $HOST/g" nginx/sites-available/$NAME.conf

if [ $WWW == Y ]
then
	echo "server {
    server_name www.$HOST;
    return 301 \$scheme://$HOST\$request_uri;
} " >> nginx/sites-available/$NAME.conf
fi


if [ $HTML == Y ]
then
	sed -i "s/var\/www\/$HOST/var\/www\/html\/$HOST/g" nginx/sites-available/$NAME.conf
fi

mkdir /var/www/cache/$NAME
chown $USER:$USER /var/www/cache/$NAME
ln -s /etc/nginx/sites-available/$NAME.conf /etc/nginx/sites-enabled/

