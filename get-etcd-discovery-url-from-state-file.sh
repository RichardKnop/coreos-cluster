#!/bin/bash

greped=`less ${1}.tfstate | grep vars.etcd_discovery_url`
password=$(echo "${greped}" | awk -v FS="${2}: " 'NF>1{print $2}')

# Trim double quotes
temp="${password%\"}"
temp="${temp#\"}"
echo "$temp"
