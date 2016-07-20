#!/bin/bash

vault_variables=`ansible-vault view environments/${1}.yml`
password=$(echo "${vault_variables}" | awk -v FS="${2}: " 'NF>1{print $2}')

# Trim double quotes
temp="${password%\"}"
temp="${temp#\"}"
echo "$temp"
