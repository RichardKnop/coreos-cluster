#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

function main() {
  check-prereqs

  gpg --batch --use-agent --quiet --decrypt vault_password.gpg
}

function check-prereqs() {
  if ! (gpg --version 2>&1 | grep -q "gpg (GnuPG)"); then
    echo "!!! GnuPG is required. Use 'brew install gnupg'."
    exit 1
  fi
}

main "$@"
