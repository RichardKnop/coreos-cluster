all:
	$(error Usage: make deploy DEPLOY_ENV=name [ARGS=extra_args])

deploy: check-env-var check-env-aws
	ansible-playbook -i ec2.py site.yml -e @aws.yml -e "deploy_env=${DEPLOY_ENV}" ${ARGS}

check-env-aws:
ifndef AWS_SECRET_ACCESS_KEY
	$(error Environment variable AWS_SECRET_ACCESS_KEY must be set)
endif
ifndef AWS_ACCESS_KEY_ID
	$(error Environment variable AWS_ACCESS_KEY_ID must be set)
endif

check-env-var:
ifndef DEPLOY_ENV
	$(error Must pass DEPLOY_ENV=<name>)
endif
