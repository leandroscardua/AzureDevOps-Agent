#!/bin/bash

# update
apt update -y && apt upgrade -y && apt install curl git jq libicu70 apt-transport-https software-properties-common unzip zip -y
apt-get -yq update
apt-get -yq dist-upgrade

# Install Microsoft repository
os_label="22.04"
curl -O https://packages.microsoft.com/config/ubuntu/$os_label/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
apt update -y

# Install Powershell
pwsh_version=7.4
apt install -y powershell=$pwsh_version*

# # Install Terraform
# download_url=$(curl -fsSL https://api.releases.hashicorp.com/v1/releases/terraform/latest | jq -r '.builds[] | select((.arch=="amd64") and (.os=="linux")).url')
# curl -O $download_url
# unzip terraform_*.zip -d /usr/local/bin
# rm terraform_*.zip

# Install Azure CLI (instructions taken from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
curl -fsSL https://aka.ms/InstallAzureCLIDeb | bash
echo "azure-cli https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt" >> $HELPER_SCRIPTS/apt-sources.txt
rm -f /etc/apt/sources.list.d/azure-cli.list
rm -f /etc/apt/sources.list.d/azure-cli.list.save

# # AZURE_EXTENSION_DIR shell variable defines where modules are installed
# # https://docs.microsoft.com/en-us/cli/azure/azure-cli-extensions-overview
# export AZURE_EXTENSION_DIR=/opt/az/azcliextensions
# set_etc_environment_variable "AZURE_EXTENSION_DIR" "${AZURE_EXTENSION_DIR}"

# # install azure devops Cli extension
# az extension add -n azure-devops


# clears out the local repository of retrieved package files
# It removes everything but the lock file from /var/cache/apt/archives/ and /var/cache/apt/archives/partial
apt-get clean
rm -rf /tmp/*
rm -rf /root/.cache

# delete all .gz and rotated file
find /var/log -type f -regex ".*\.gz$" -delete
find /var/log -type f -regex ".*\.[0-9]$" -delete

# wipe log files
find /var/log/ -type f -exec cp /dev/null {} \;
