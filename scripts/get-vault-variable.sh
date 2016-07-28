#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

VAULT_DATA=`ansible-vault view vault/${1}.yml`

function main() {
  get-vault-variable $1 $2
}

function get-vault-variable() {
  local -r environment="${1}"
  local -r key="${2}"

  password=$(echo "${VAULT_DATA}" | awk -v FS="${2}: " 'NF>1{print $2}')

  # Trim double quotes
  temp="${password%\"}"
  temp="${temp#\"}"
  echo "$temp"
}

main "$@"