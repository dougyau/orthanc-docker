#!/bin/bash

rm /etc/orthanc/*
sed "s/$$AUTH_URL$$/${nginx.auth_endpoint}/" /etc/nginx/sites-enabled/orthanc
python generate-config.py > /etc/orthanc/orthanc.json

/usr/local/bin/supervisord -c /etc/supervisord.conf
