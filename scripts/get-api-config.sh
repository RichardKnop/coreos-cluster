#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

vault_data=`ansible-vault view vault/${1}.yml`

function main() {
  local -r environment="${1}"

  local -r database_host=`get-vault-variable $environment api_database_host`
  local -r database_port=`get-vault-variable $environment api_database_port`
  local -r database_user=`get-vault-variable $environment api_database_user`
  local -r database_password=`get-vault-variable $environment api_database_password`
  local -r database_name=`get-vault-variable $environment api_database_name`
  local -r database_max_idle_conns=`get-vault-variable $environment api_database_max_idle_conns`
  local -r database_max_open_conns=`get-vault-variable $environment api_database_max_open_conns`
  local -r facebook_app_id=`get-vault-variable $environment facebook_app_id`
  local -r facebook_app_secret=`get-vault-variable $environment facebook_app_secret`
  local -r sendgrid_api_key=`get-vault-variable $environment sendgrid_api_key`
  local -r api_scheme=`get-vault-variable $environment api_scheme`
  local -r api_host=`get-vault-variable $environment api_host`
  local -r app_scheme=`get-vault-variable $environment app_scheme`
  local -r app_host=`get-vault-variable $environment app_host`
  local -r is_development=`get-vault-variable $environment is_development`

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
    \"AppID\": \"$facebook_app_id\",
    \"AppSecret\": \"$facebook_app_secret\"
  },
  \"Sendgrid\": {
    \"APIKey\": \"$sendgrid_api_key\"
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

function get-vault-variable() {
  local -r environment="${1}"
  local -r key="${2}"

  password=$(echo "${vault_data}" | awk -v FS="${2}: " 'NF>1{print $2}')

  # Trim double quotes
  temp="${password%\"}"
  temp="${temp#\"}"
  echo "$temp"
}

main "$@"
