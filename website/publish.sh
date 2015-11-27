#!/bin/bash

../etc/addContentWebsite.sh
sudo mkdir tmp
sudo sshfs psmeros@users.uoa.gr: tmp
sudo rm -r tmp/public_html
sudo cp -r public_html tmp/
sudo umount tmp
sudo rm -r tmp
../etc/removeContentWebsite.sh
