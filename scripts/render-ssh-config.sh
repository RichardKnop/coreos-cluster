#!/bin/bash

sed -e "s/DEPLOY_ENV/${1}/g" -e "s/DOMAIN/${2}/g" ssh.config.template > ssh.config
