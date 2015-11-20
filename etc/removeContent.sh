#!/bin/bash

folder="public_html"
rm -r "$folder"
mv "$folder".bak "$folder"
