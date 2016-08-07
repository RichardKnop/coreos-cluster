#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

VAULT_DATA=""

function main() {
  # Parse arguments
  if [[ "$#" -ne 1 && "$#" -ne 2 ]]; then
    usage
    exit 1
  fi
  local -r env="${1}"
  local -r key="${2}"

  check-prereqs

  VAULT_DATA=`ansible-vault view vault/${env}.yml`

  get-vault-variable ${key}
}

function usage() {
  echo "Usage: ${0} <environment> <key>"
  echo
  echo "<environment> the environment (stage, prod etc)"
  echo "<key> the key you want to get from encrypted vault file"
}

function check-prereqs() {
  if ! (ansible-vault view -h | grep -q ansible-vault); then
    echo "!!! ansible-vault is required. Use 'pip install -r requirements.txt'."
    exit 1
  fi
  if ! (shyaml -h | grep -q shyaml); then
    echo "!!! shyaml is required. Use 'pip install -r requirements.txt'."
    exit 1
  fi
}

function get-vault-variable() {
  local -r key="${1}"

  decrypted="$(printf "${VAULT_DATA}" | shyaml get-value ${key})"
  printf '%s' "$decrypted"
}

main "$@"
