# Orthanc docker image
This repository contains the source to the docker image dougyau/orthanc

Plugins included:
- dicomweb
- mysql
- s3

## Configuration
To override a default, define an environment variable with the setting to override. It is case sensitive.

Example:
```
docker run -e config.DicomWeb.Enable=True dougyau/orthanc
```
The value is a python expression.