#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

VAULT_DATA=""

function main() {
  # Parse arguments
  if [[ "$#" -ne 1 ]]; then
    usage
    exit 1
  fi
  local -r env=${1}
  VAULT_DATA=`ansible-vault view vault/$env.yml`

  check-prereqs

  # Database config
  local -r database_host=`get-vault-variable api.database_host`
  local -r database_port=`get-vault-variable api.database_port`
  local -r database_user=`get-vault-variable api.database_user`
  local -r database_password=`get-vault-variable api.database_password`
  local -r database_name=`get-vault-variable api.database_name`
  local -r database_max_idle_conns=`get-vault-variable api.database_max_idle_conns`
  local -r database_max_open_conns=`get-vault-variable api.database_max_open_conns`

  # Web config
  local -r api_scheme=`get-vault-variable api.scheme`
  local -r api_host=`get-vault-variable api.host`
  local -r app_scheme=`get-vault-variable app.scheme`
  local -r app_host=`get-vault-variable app.host`

  # Is development environment?
  local -r is_development=$(boolean `get-vault-variable is_development`)

  echo "{
  \"Database\": {
    \"Type\": \"postgres\",
    \"Host\": \"$database_host\",
    \"Port\": $database_port,
    \"User\": \"$database_user\",
    \"Password\": \"$database_password\",
    \"DatabaseName\": \"$database_name\",
    \"MaxIdleConns\": $database_max_idle_conns,
    \"MaxOpenConns\": $database_max_open_conns
  },
  \"Oauth\": {
    \"AccessTokenLifetime\": 3600,
    \"RefreshTokenLifetime\": 1209600,
    \"AuthCodeLifetime\": 3600
  },
  \"Facebook\": {
    \"AppID\": \"TODO\",
    \"AppSecret\": \"TODO\"
  },
  \"Sendgrid\": {
    \"APIKey\": \"TODO\"
  },
  \"Web\": {
    \"Scheme\": \"$api_scheme\",
    \"Host\": \"$app_host\",
    \"AppScheme\": \"$app_scheme\",
    \"AppHost\": \"$app_host\"
  },
  \"AppSpecific\": {
    \"PasswordResetLifetime\": 604800,
    \"CompanyName\": \"TODO\",
    \"CompanyEmail\": \"TODO\"
  },
  \"IsDevelopment\": $is_development
}"
}

function usage() {
  echo "Usage: ${0} <environment>"
  echo
  echo "<environment> the environment (stage, prod etc)"
}

function check-prereqs() {
  if ! (ansible-vault view -h | grep -q ansible-vault); then
    echo "!!! ansible-vault is required. Use 'pip install -r requirements.txt'."
    exit 1
  fi
}

function get-vault-variable() {
  local -r key="${1}"

  decrypted="$(printf "${VAULT_DATA}" | shyaml get-value ${key})"
  printf '%s' "$decrypted"
}

function boolean() {
  case $1 in
    True) echo true ;;
    False) echo false ;;
    *) echo "Err: Unknown boolean value \"$1\"" 1>&2; exit 1 ;;
   esac
}

main "$@"
