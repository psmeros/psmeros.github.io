#!/bin/bash

../etc/addContentWebsite.sh
scp -r public_html psmeros@jose.di.uoa.gr:
ssh -t psmeros@jose.di.uoa.gr 'mkdir tmp; sshfs psmeros@users.uoa.gr: tmp; rm -r tmp/public_html; cp -r public_html tmp/; fusermount -u tmp; rm -r tmp public_html'
../etc/removeContentWebsite.sh
