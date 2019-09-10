#!/bin/bash

sed -i "s/fr24key=.*/fr24key=`echo $FR24_KEY`/g" /etc/fr24feed.ini

/usr/bin/fr24feed "${@}"
