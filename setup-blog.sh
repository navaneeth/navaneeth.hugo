#!/bin/sh

echo -e "\033[0;32mSetup public directory and origin to GH pages...\033[0m"

mkdir public/
git clone git@github.com:navaneeth/navaneeth.github.com.git public/

echo "ALL DONE"

