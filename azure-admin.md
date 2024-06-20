# Azure CLI

You can get the Azure CLI on Docker-Hub
We'll need the Azure CLI to gather information so we can build our Terraform file.

# Run Azure CLI

```
docker run -it --rm -v ${PWD}:/work -w /work --entrypoint /bin/sh mcr.microsoft.com/azure-cli

```

# Login to Azure
```
#login and follow prompts
az login 
TENTANT_ID=<your-tenant-id>

# view and select your subscription account

az account list -o table
SUBSCRIPTION=<id>
az account set --subscription $SUBSCRIPTION
```
# Create Service Principal
Kubernetes needs a service account to manage our Kubernetes cluster
Lets create one!

```
SERVICE_PRINCIPAL_JSON=$(az ad sp create-for-rbac --skip-assignment --name service-principle-name -o json)

# Keep the `appId` and `password` for later use!

SERVICE_PRINCIPAL=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.appId')
SERVICE_PRINCIPAL_SECRET=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.password')

#note: reset the credential if you have any sinlge or double quote on password
az ad sp credential reset --name "service-principle-name"

# Grant contributor role over the subscription to our service principal

az role assignment create --assignee $SERVICE_PRINCIPAL \
--scope "/subscriptions/$SUBSCRIPTION" \
--role Contributor
```

For extra reference you can also take a look at the Microsoft Docs: [here](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/aks/kubernetes-service-principal.md)

# Terraform CLI

```
# Download the Terraform zip file using wget
wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip

# Unzip the downloaded file
unzip /tmp/terraform.zip

# Make the Terraform binary executable and move it to /usr/local/bin/
chmod +x terraform && mv terraform /usr/local/bin/


# Verify Terraform Manifests in Container

/work # ls -l
total 9
-rwxrwxrwx    1 root     root          1824 Jun 17 14:04 azure-admin.md
-rwxrwxrwx    1 root     root           128 Jun 17 12:35 backend.tf
-rwxrwxrwx    1 root     root           635 Jun 17 12:54 main.tf
drwxrwxrwx    1 root     root           512 Jun 17 12:50 modules
-rwxrwxrwx    1 root     root             0 Jun 16 11:59 outputs.tf
-rwxrwxrwx    1 root     root           343 Jun 17 13:18 providers.tf
-rwxrwxrwx    1 root     root           323 Jun 17 14:03 readme.md
-rwxrwxrwx    1 root     root           254 Jun 17 12:54 terraform.tfvars
-rwxrwxrwx    1 root     root           366 Jun 17 12:55 variables.tf

```

# Generate SSH key

```
ssh-keygen -t rsa -b 4096 -N "VeryStrongSecret123!" -C "your_email@example.com" -q -f  ~/.ssh/id_rsa

SSH_KEY=$(cat ~/.ssh/id_rsa.pub)

# gets the ssh_key value to be used in terraform.tfvars
echo "$SSH_KEY"

# get ptivate key to working directory to have local copy

/work # ls ~/.ssh/
id_rsa      id_rsa.pub

/work # cp ~/.ssh/id_rsa /work
```

# Automate Admin Process Above

Fastrack setup process by running [script](./scripts/setup_azure_terraform.sh)

```
export SUBSCRIPTION="your-subscription-id"

chmod +x ./scripts/setup_azure_terraform.sh

./scripts/setup_azure_terraform.sh

```