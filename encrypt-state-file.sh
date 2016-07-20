#!/bin/bash

gpg -e -r "risoknop@gmail.com" -r "erol.ziya@gmail.com" ${1}.tfstate > ${1}.tfstate.gpg
