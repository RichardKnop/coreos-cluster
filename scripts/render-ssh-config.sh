#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function main() {
  # Parse arguments
  if [[ "$#" -ne 1 && "$#" -ne 2 ]]; then
    usage
    exit 1
  fi
  local -r env=${1}
  local -r domain=${2}

  sed -e "s/DEPLOY_ENV/${env}/g" -e "s/DOMAIN/${domain}/g" ${DIR}/ssh.config.template > ssh.config
}

function usage() {
  echo "Usage: ${0} <env> <domain>"
  echo
  echo "<env> the environment (stage, prod etc)"
  echo "<domain> name of your main DNS zone (NAT server is assumed to be at <env>-nat.<domain>)"
}

main "$@"
