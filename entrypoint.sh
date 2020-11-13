#!/bin/bash

rm /etc/orthanc/*
python generate-config.py > /etc/orthanc/orthanc.json

/usr/local/bin/supervisord -c /etc/supervisord.conf
