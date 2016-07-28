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
  local -r env=${1-}
  VAULT_DATA=`ansible-vault view vault/$env.yml`

  check-prereqs

  # Database config
  local -r database_host=`get-vault-variable api_database_host`
  local -r database_port=`get-vault-variable api_database_port`
  local -r database_user=`get-vault-variable api_database_user`
  local -r database_password=`get-vault-variable api_database_password`
  local -r database_name=`get-vault-variable api_database_name`
  local -r database_max_idle_conns=`get-vault-variable api_database_max_idle_conns`
  local -r database_max_open_conns=`get-vault-variable api_database_max_open_conns`

  # Web config
  local -r api_scheme=`get-vault-variable api_scheme`
  local -r api_host=`get-vault-variable api_host`
  local -r app_scheme=`get-vault-variable app_scheme`
  local -r app_host=`get-vault-variable app_host`

  # Is development environment?
  local -r is_development=`get-vault-variable is_development`

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
    \"AppHost\": \"l$app_host\"
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
  echo "<environment> is the environment you want to use to construct config JSON"
}

function check-prereqs() {
  if ! (ansible-vault view --version 2>&1 | grep -q ansible-vault); then
    echo "!!! Ansible Vault is required. Use 'pip install -r requirement.stxt'."
    exit 1
  fi
}

function get-vault-variable() {
  local -r key="${1}"

  password=$(echo "${VAULT_DATA}" | awk -v FS="$key: " 'NF>1{print $2}')

  # Trim double quotes
  temp="${password%\"}"
  temp="${temp#\"}"
  echo "$temp"
}

main "$@"
