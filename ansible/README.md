[1]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair

# Ansible

# Index

* [Ansible](#ansible)
* [Index](#index)
* [Requirements](#requirements)
  * [AWS Provisioning](#aws-provisioning)
  * [Setting Up GPG-encrypted Vault Support](#setting-up-gpg-encrypted-vault-support)
  * [Encrypt / Decrypt Vault Password](#encrypt--decrypt-vault-password)
* [Provisioning](#provisioning)
* [Resources](#resources)

# Requirements

You need Ansible. Create a virtual Python environment and install requirements:

```
virtualenv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

To setup CoreOS hosts for Ansible, we will use `coreos-bootstrap` role:

```
ansible-galaxy install defunctzombie.coreos-bootstrap -p ./roles
```

## Requirements For AWS Provisioning

To successfully make an API call to AWS, you will need to configure `boto` (the Python interface to AWS). There are a variety of methods available, but the simplest is just to export two environment variables:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

Test that the dynamic inventory file is working:

```
./ec2.py --list
```

Render an SSH configuration file, i.e.:

```
./render-ssh-config.sh <env-name-prefix> <domain-name>
```

## Setting Up GPG-encrypted Vault Support

You will need to have setup [gpg-agent](https://www.gnupg.org/) on your computer before you start.

```
brew install gpg
brew install gpg-agent
```

If you haven't already generated your PGP key (it's ok to accept the default options if you never done this before):

```
gpg --gen-key
```

Get your KEYID from your keyring:

```
gpg --list-secret-keys | grep sec
```

This will probably be pre-fixed with 2048R/ or 4096R/ and look something like 93B1CD02.

Send your public key to PGP key server:

```
gpg --keyserver pgp.mit.edu --send-keys KEYID
```

To import a public key (e.g. when a new engineer joins the team):

```
gpg --keyserver pgp.mit.edu --search-keys john@doe.com
```

Create `~/.bash_gpg`:

```
envfile="${HOME}/.gnupg/gpg-agent.env"

if test -f "$envfile" && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
  eval "$(cat "$envfile")"
else
  eval "$(gpg-agent --daemon --log-file=~/.gpg/gpg.log --write-env-file "$envfile")"
fi
export GPG_AGENT_INFO  # the env file does not contain the export statement
```

Add to `~/.bash_profile`:

```
GPG_AGENT=$(which gpg-agent)
GPG_TTY=`tty`
export GPG_TTY

if [ -f ${GPG_AGENT} ]; then
  . ~/.bash_gpg
fi
```

Start a new shell or source the current environment:

```
source ~/.bash_profile
```

## Encrypt / Decrypt Vault Password

Encrypt the vault password:

```
echo "the vault password" | gpg -e -r "your_email_address" > vault_password.gpg
```

Ansible will decrypt the file based using PGP key from your keyring. See `vault_password_file` option in the `ansible.cfg` configuration file.

## Required Secure Variables

This repository is using `ansible-vault` to secure sensitive information. Secure variables for each environment are stored in a separate file in `environments` directory:

```
.
├── environments
│   ├── stage.yml
│   └── prod.yml
│
└── ...
```

If you already know the password you do not need to recreate the `environments/<env-name-prefix>.yml` file.

You can edit variables stored in the vault:

```
ansible-vault edit environments/<env-name-prefix>.yml
```

Required contents for `environments/<env-name-prefix>.yml` (if you don't know the password):

```yml
aws_region: "aws_region"
dns_zone_id: "dns_zone_id"
domain_name: "domain_name"
ssl_certificate_id: "ssl_certificate_id"
database_type: "postgres"
database_host: "{{ deploy_env }}-rds.{{ domain_name }}"
database_port: 5432
database_user: "database_user"
database_password: "database_password"
database_name: "database_name"
is_development: false
```

# Provisioning

In order to provision an environment, do something like:

```
make deploy DEPLOY_ENV=<env-name-prefix>
```

It's recommended to use verbose flags to see more output for debugging:

```
make deploy DEPLOY_ENV=<env-name-prefix> ARGS=-vvv
```

# Resources

- [How To Use GPG on the Command Line][1]
