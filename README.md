[1]: http://blog.ghostinthemachines.com/2015/03/01/how-to-use-gpg-command-line/
[2]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair
[3]: http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html

# CoreOS Cluster

An example of how to provision a CoreOS cluster on AWS using Terraform. This example sets up a VPC, private and public networks, NAT server, an RDS database, a CoreOS cluster and a private Docker registry and properly configures tight security groups.

The cluster is configured via `cloud-config` user data and runs `etcd2.service` and `fleet.service`. All peer and client traffic is encrypted using self signed certificates.

A private Docker registry is also created at `registry.local` and Docker nodes are properly configured to use it.

# Index

* [CoreOS Cluster](#coreos-cluster)
* [Index](#index)
* [Requirements](#requirements)
  * [Vault](#vault)
    * [Setting Up GPG-encrypted Vault Support](#setting-up-gpg-encrypted-vault-support)
    * [Encrypt / Decrypt Vault Password](#encrypt--decrypt-vault-password)
    * [Required Secure Variables](#required-secure-variables)
  * [AWS Provisioning](#aws-provisioning)
    * [Environment Variables](#environment-variables)
    * [SSH Agent](#ssh-agent)
    * [SSL Certificate](#ssl-certificate)
* [Provisioning](#provisioning)
  * [Variables](#variables)
  * [Apply Execution Plan](#apply-execution-plan)
  * [Connecting To Instances](#connecting-to-instances)
  * [Debugging](#debugging)
  * [Recreate Database](#recreate-database)
* [Managing Cluster](#managing-cluster)
  * [Private Docker Registry](#private-docker-registry)
  * [ETCD](#etcd)
  * [Fleet](#fleet)
* [Resources](#resources)

# Requirements

You need Terraform >= 0.6.9, e.g.:

```
brew install terraform
```

You need an SSH key. The private key needs to be chmod to 600.

You need the cloud provider credentials. These will be entered on the command line.

## Vault

### Setting Up GPG-encrypted Vault Support

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

### Encrypt / Decrypt Vault Password

Encrypt the vault password:

```
echo "the vault password" | gpg -e -r "your_email_address" > vault_password.gpg
```

Ansible Vault will decrypt the file based using PGP key from your keyring. See `vault_password_file` option in the `ansible.cfg` configuration file.

### Required Secure Variables

This repository is using `ansible-vault` to secure sensitive information. Secure variables for each environment are stored in a separate file in `vault` directory:

```
.
├── vault
│   ├── stage.yml
│   └── prod.yml
│
└── ...
```

If you already know the password you do not need to recreate the `vault/<env-name-prefix>.yml` file.

You can edit variables stored in the vault:

```
ansible-vault edit vault/<env-name-prefix>.yml
```

Required contents for `vault/<env-name-prefix>.yml` (if you don't know the password):

```yml
dns_zone_id: "dns_zone_id"
dns_zone_name: "dns_zone_name"
ssl_certificate_id: "ssl_certificate_id"
aws_region: "eu-west-1"
api_database_type: "postgres"
api_database_host: "database1.local"
api_database_port: 5432
api_database_user: "example_api"
api_database_password: "test_password"
api_database_name: "example_api"
api_database_max_idle_conns: 5
api_database_max_open_conns: 5
api_scheme: "https"
api_host: "localhost:8080"
app_scheme: "https"
app_host: "localhost:8000"
is_development: true
```

## AWS Provisioning

### Environment Variables

The terraform provider for AWS will read the standard AWS credentials environment variables. You must have these variables exported:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION` (eu-west-1)

You can get the credentials from the AWS console.

### SSH Agent

Terraform will look for a deployment key in `~/.ssh` directory when creating a NAT instance. Add the deployment key to the ssh-agent, e.g.:

```
ssh-add ~/.ssh/stage-deployer
```

### SSL Certificate

An SSL certificate can be purchased from [Comodo](https://www.comodo.com/).

Comodo will then provide the certificate itself in a ZIP file which consists of:

- certificate (`STAR_your_domain_com.crt`)
- intermediate and root Comodo certificates

AWS only supports PEM format of certificates so first, we needed to convert the private key and all certificates to the correct format:

```
openssl x509 -inform PEM -in your_domain_com.key > your_domain_com.pem
openssl x509 -inform PEM -in STAR_your_domain_com.crt > STAR_your_domain_com.pem
openssl x509 -inform PEM -in COMODORSADomainValidationSecureServerCA.crt > COMODORSADomainValidationSecureServerCA.pem
openssl x509 -inform PEM -in COMODORSAAddTrustCA.crt > COMODORSAAddTrustCA.pem
openssl x509 -inform PEM -in AddTrustExternalCARoot.crt > AddTrustExternalCARoot.pem
```

Secondly, generate a certificate chain from intermediate and root certificates one by one using `cat` command:

```
cat COMODORSADomainValidationSecureServerCA.pem COMODORSAAddTrustCA.pem AddTrustExternalCARoot.pem > your_domain_com_certificate_chain.pem
```

Finally, upload the certificate to AWS IAM:

```
aws iam upload-server-certificate --server-certificate-name yourdomain-com-certificate \
--certificate-body file://STAR_yourdomain_com.pem --private-key file://yourdomain_com.pem \
--certificate-chain file://yourdomain_com_certificate_chain.pem
```

Result:

```json
{
  "ServerCertificateMetadata": {
    "ServerCertificateId": "BLABLABLABLABLABLABLA",
    "ServerCertificateName": "yourdomain-com-certificate",
    "Expiration": "2017-01-18T23:59:59Z",
    "Path": "/",
    "Arn": "arn:aws:iam::123123123123:server-certificate/yourdomain-com-certificate",
    "UploadDate": "2016-01-20T10:49:07.300Z"
  }
}
```

`Arn` attribute is used as `ssl_certificate_id` for HTTPS listener in the ELB.

# Provisioning

Render an SSH configuration file, i.e.:

```
./scripts/render-ssh-config.sh <env-name-prefix> <domain-name>
```

Create virtual Python environment:

```
virtualenv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Variables

You will need to export couple of needed environment variables.

Most importantly, define an environment name, e.g.:

```
export TF_VAR_env=stage
```

Or:

```
export TF_VAR_env=prod
```

Export DNS variables:

```
export TF_VAR_dns_zone_id=$(./scripts/get-vault-variable.sh $TF_VAR_env dns_zone_id)
export TF_VAR_dns_zone_name=$(./scripts/get-vault-variable.sh $TF_VAR_env dns_zone_name)
export TF_VAR_ssl_certificate_id=$(./scripts/get-vault-variable.sh $TF_VAR_env ssl_certificate_id)
```

Export DB variables from the `ansible-vault`:

```
export TF_VAR_db_name=$(./scripts/get-vault-variable.sh $TF_VAR_env database_name)
export TF_VAR_db_user=$(./scripts/get-vault-variable.sh $TF_VAR_env database_user)
export TF_VAR_db_password=$(./scripts/get-vault-variable.sh $TF_VAR_env database_password)
```

Load JSON configuration for API service:

```
export TF_VAR_api_config=$(./scripts/get-api-config.sh $TF_VAR_env)
```

For test environments, it's useful to disable final DB snapshot:

```
export TF_VAR_rds_skip_final_snapshot=true
```

See `variables.tf` for the full list of variables you can set.

## State Files

We need to support multiple environments (`stage`, `prod` etc) and share state files across the team. Therefor state files include environment suffix and their encrypted versions are stored in git.

First, decrypt a state file you want to use:

```
./scripts/decrypt-state-file.sh $TF_VAR_env
```

The above script would decrypt `$TF_VAR_env.tfstate.gpg` to `$TF_VAR_env.tfstate`.

After running Terraform, don't forget to update the encrypted state file:

```
./scripts/encrypt-state-file.sh $TF_VAR_env
```

## Apply Execution Plan


First, check the Terraform execution plan:

```
terraform plan -state=$TF_VAR_env.tfstate
```

Now you can provision the environment:

```
terraform apply -state=$TF_VAR_env.tfstate
```

**IMPORTANT**: The option `-var force_destroy=true` will mark all the resources, including S3 buckets to be deleted when destroying the environment. This is fine in test environments, but dangerous in production.

So, you could provision a test environment like this:

```
terraform apply -state=$TF_VAR_env.tfstate -var force_destroy=true
```

## Connecting To Instances

Now you can SSH to instances in a private subnet of the VPS via the NAT instance, e.g.:

```
ssh -F ssh.config <private_ip>
```

## Debugging

Once you have connected to a CoreOS node, you can use `systemctl` to check status of services:

```
systemctl status api.service
```

To view logs specific to a service running as a Docker container, use `journalctl`:

```
journalctl -u api.service -n 100 -f
```

## Recreate Database

NEVER do this against production environment.

Sometimes during development it is useful or needed to destroy and recreate the database. You can use `taint` command to mark the database instance for destruction. Next time you run the `apply` command the database will be destroyed and a new once created:

```
terraform taint -module=rds -state=$TF_VAR_env.tfstate aws_db_instance.rds
```

# Managing Cluster

Once your cluster is app and running, there are plenty of ways to manage it.

## Private Docker Registry

The cluster is configured to use a private Docker registry secured by a self signed certificate. It uses S3 as a storage backend.

To push images to the registry, ssh to the instance and do something like:

```
git clone https://github.com/RichardKnop/example-api.git
docker build -t example-api:latest example-api/
docker tag example-api:latest registry.local/example-api
docker push registry.local/example-api
```

You can then pull the image from cluster nodes:

```
docker pull registry.local/example-api
```

## ETCD

TODO

## Fleet

TODO

# Resources

- [How To Use GPG on the Command Line][1]
- [Creating EC2 Key Pairs][2]
- [Create a Public Hosted Zone][3]
