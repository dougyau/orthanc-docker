#!/bin/bash

rm /etc/orthanc/*
echo $(cat /etc/nginx/sites-enabled/orthanc | awk -v endpoint=$AUTH_URL '{sub(/\$\$AUTH_URL\$\$/, endpoint)}1') > /etc/nginx/sites-enabled/orthanc
python generate-config.py > /etc/orthanc/orthanc.json

/usr/local/bin/supervisord -c /etc/supervisord.conf
