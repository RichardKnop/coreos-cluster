#!/bin/bash

gpg --batch --use-agent --quiet --decrypt ${1}.tfstate.gpg > ${1}.tfstate
