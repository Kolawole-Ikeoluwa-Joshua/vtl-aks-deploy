# Provisioning AKS using Terraform

More resources:

Terraform provider for Azure [here](https://github.com/hashicorp/terraform-provider-azurerm)

# Prerequisite:

Setup needed tools like Azure CLI, Terraform CLI, etc using the [Admin Docs](./docs/azure-admin.md). Note that everything is containerized using Docker.

# Terraform Azure Kubernetes Provider

Documentation on all the Kubernetes fields for terraform [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster.html)


- ### Init, Plan & Applying using Remote Backend + terraform.tfvars file:

Authenticate HCP Terraform Cloud Remote Backend using Tokens

```
terraform login
```
Ensure you set the following values in terraform.tfvars file

```
subscription_id      = ""
tenant_id            = ""
serviceprinciple_id  = ""
serviceprinciple_key = ""
ssh_key = ""
```
Init, Plan & Apply

```
terraform init

terraform plan


# apply the configuration to Azure:

terraform apply -var-file="terraform.tfvars"
```

- ### Init, Plan & Applying using Local Backend:

```
terraform init

terraform plan -var serviceprinciple_id=$SERVICE_PRINCIPAL \
    -var serviceprinciple_key="$SERVICE_PRINCIPAL_SECRET" \
    -var tenant_id=$TENTANT_ID \
    -var subscription_id=$SUBSCRIPTION \
    -var ssh_key="$SSH_KEY"

terraform apply -var serviceprinciple_id=$SERVICE_PRINCIPAL \
    -var serviceprinciple_key="$SERVICE_PRINCIPAL_SECRET" \
    -var tenant_id=$TENTANT_ID \
    -var subscription_id=$SUBSCRIPTION \
    -var ssh_key="$SSH_KEY"
```

# Lets see what we deployed

```
# grab our AKS config
az aks get-credentials -n vtl-aks-dev -g vtl-aks-dev

# Get kubectl

wget -O kubectl https://storage.googleapis.com/kubernetes-release/release/$(wget -qO- https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

kubectl get svc

```

# Bonus: Infracost

You can use [Infracost](https://github.com/infracost/infracost) for cloud cost estimates and FinOps best practices for Terraform.

Options:

1. Infracost CLI & API Key: can easily view cost estimates on deployment server.
[Infracost CLI & API Key](./docs/infracost_cli.png)
2. Integrate Infracost with CI/CD: can easily post cost estimates in pull requests. This provides your team with a safety net as people can discuss costs as part of the workflow.
[Integrate Infracost with CI/CD](./docs/infracost_cicd.png)



# Clean up

```

terraform destroy --auto-approve
```