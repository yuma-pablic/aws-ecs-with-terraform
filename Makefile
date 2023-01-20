dev-init:
	@cd environment/dev;terraform init

pro-init:
	@cd environment/pro;terraform init

dev-init-up:
	@cd environment/dev;terraform init -upgrade

pro-init-up:
	@cd environment/pro;terraform init -upgrade

dev-plan:
	@cd environment/dev;terraform plan

dev-apply:
	@cd environment/dev;terraform apply

pro-apply:
	@cd environment/pro;terraform apply

dev-destroy:
	@cd environment/dev;terraform destroy

pro-destroy:
	@cd environment/pro;terraform destroy