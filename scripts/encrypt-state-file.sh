#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

function main() {
  # Parse arguments
  if [[ "$#" -ne 1 ]]; then
    usage
    exit 1
  fi
  local -r env=${1}

  check-prereqs

  gpg -e -r "risoknop@gmail.com" $env.tfstate > $env.tfstate.gpg
}

function usage() {
  echo "Usage: ${0} <environment>"
  echo
  echo "<environment> the environment (stage, prod etc)"
}

function check-prereqs() {
  if ! (gpg --version 2>&1 | grep -q 'gpg (GnuPG)'); then
    echo "!!! GnuPG is required. Use 'brew install gnupg'."
    exit 1
  fi
}

main "$@"
