[1]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair
[2]: http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html

# CoreOS Cluster

An example of how to provision a CoreOS cluster on AWS using Terraform and Ansible. This example sets up a VPC, private and public networks, NAT server, an RDS database, a CoreOS cluster and properly configures tight security groups.

# Index

* [CoreOS Cluster](#coreos-cluster)
* [Index](#index)
* [Requirements](#requirements)
  * [AWS Provisioning](#aws-provisioning)
    * [Environment Variables](#environment-variables)
    * [SSL Certificate](#ssl-certificate)
* [Provisioning](#provisioning)
  * [Variables](#variables)
  * [Apply Execution Plan](#apply-execution-plan)
  * [Connecting To Instances](#connecting-to-instances)
  * [Debugging](#debugging)
  * [Recreate Database](#recreate-database)
* [Resources](#resources)

# Requirements

You need Terraform >= 0.6.9, e.g.:

```
brew install terraform
```

You need an SSH key. The private key needs to be chmod to 600.

You need the cloud provider credentials. These will be entered on the command line.

## Requirements For AWS Provisioning

### Environment Variables

The terraform provider for AWS will read the standard AWS credentials environment variables. You must have these variables exported:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION` (eu-west-1)

You can get the credentials from the AWS console.

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

Create virtual Python environment for Ansible:

```
virtualenv .venv
source .venv/bin/activate
pip install -r ansible/requirements.txt
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
export TF_VAR_dns_zone_id=$(cd ansible ; ./scripts/get-vault-variable.sh $TF_VAR_env dns_zone_id)
export TF_VAR_dns_zone_name=$(cd ansible ; ./scripts/get-vault-variable.sh $TF_VAR_env dns_zone_name)
export TF_VAR_ssl_certificate_id=$(cd ansible ; ./scripts/get-vault-variable.sh $TF_VAR_env ssl_certificate_id)
```

Export DB variables from the `ansible-vault`:

```
export TF_VAR_db_name=$(cd ansible ; ./scripts/get-vault-variable.sh $TF_VAR_env database_name)
export TF_VAR_db_user=$(cd ansible ; ./scripts/get-vault-variable.sh $TF_VAR_env database_user)
export TF_VAR_db_password=$(cd ansible ; ./scripts/get-vault-variable.sh $TF_VAR_env database_password)
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

# Resources

- [Creating EC2 Key Pairs][1]
- [Create a Public Hosted Zone][2]
