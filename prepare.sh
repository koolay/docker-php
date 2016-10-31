#!/bin/bash
## Create a user for the web app.
addgroup --gid 9999 app
adduser --uid 9999 --gid 9999 --disabled-password --gecos "Application" app
usermod -L app
mkdir -p /home/app
chown -R app:app /home/app
