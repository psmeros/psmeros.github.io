#!/bin/bash

../etc/addContentWebsite.sh
mkdir papaki
curlftpfs psmeros:TerastioPassword\!11@5.9.111.116 papaki
rm -r papaki/panayiotis.smeros.info/*
cp -r public_html/* papaki/panayiotis.smeros.info/
sudo fusermount -u papaki
rm -r papaki
../etc/removeContentWebsite.sh
