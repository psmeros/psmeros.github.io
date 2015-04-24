#!/bin/bash

sed -i "s|?DATE?|`date +%d/%m/%Y`|g" public_html/index.html
mkdir tmp
sudo sshfs psmeros@users.uoa.gr: tmp
sudo rm -r tmp/public_html
sudo cp -r public_html tmp/
sudo umount tmp
rm -r tmp
sed -i "s|`date +%d/%m/%Y`|?DATE?|g" public_html/index.html

