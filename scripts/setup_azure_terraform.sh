#!/bin/bash

# Set up environment variables
TENANT_ID="<your-tenant-id>"
SERVICE_PRINCIPAL_NAME="service-principle-name"
TERRAFORM_VERSION="1.0.11"
SSH_PASSPHRASE="VeryStrongSecret123!"
SSH_EMAIL="your_email@example.com"
WORK_DIR="${PWD}"

# Run Azure CLI in Docker
docker run -it --rm -e SUBSCRIPTION -v $WORK_DIR:/work -w /work --entrypoint /bin/sh mcr.microsoft.com/azure-cli -c "
    
    # Login to Azure
    az login

    # Set the specified subscription account
    az account set --subscription \$SUBSCRIPTION

    # Create Service Principal
    SERVICE_PRINCIPAL_JSON=\$(az ad sp create-for-rbac --skip-assignment --name $SERVICE_PRINCIPAL_NAME -o json)
    SERVICE_PRINCIPAL=\$(echo \$SERVICE_PRINCIPAL_JSON | jq -r '.appId')
    SERVICE_PRINCIPAL_SECRET=\$(echo \$SERVICE_PRINCIPAL_JSON | jq -r '.password')

    # Reset credentials if needed
    az ad sp credential reset --name $SERVICE_PRINCIPAL_NAME

    # Grant Contributor role to Service Principal
    az role assignment create --assignee \$SERVICE_PRINCIPAL \\
    --scope \"/subscriptions/\$SUBSCRIPTION\" \\
    --role Contributor

    # Download and install Terraform
    wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    unzip /tmp/terraform.zip
    chmod +x terraform && mv terraform /usr/local/bin/

    # Generate SSH key
    ssh-keygen -t rsa -b 4096 -N \"$SSH_PASSPHRASE\" -C \"$SSH_EMAIL\" -q -f ~/.ssh/id_rsa
    SSH_KEY=\$(cat ~/.ssh/id_rsa.pub)
    echo \"\$SSH_KEY\"

    # Copy private key to working directory
    cp ~/.ssh/id_rsa /work
"

# Verify Terraform Manifests in Container
ls -l