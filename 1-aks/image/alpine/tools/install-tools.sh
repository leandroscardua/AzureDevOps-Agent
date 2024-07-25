#!/bin/bash

# Install Requirements

targetarch="linux-musl-x64"

apk add --no-cache \
    ca-certificates \
    less \
    ncurses-terminfo-base \
    krb5-libs \
    libgcc \
    libintl \
    libssl1.1 \
    libstdc++ \
    tzdata \
    userspace-rcu \
    zlib \
    icu-libs \
    curl \
    python3 \
    py3-pip \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    py3-psutil

# # Install Powershell
pwsh_base_version=7
pwsh_version=$pwsh_base_version.4.3
curl -L https://github.com/PowerShell/PowerShell/releases/download/v$pwsh_version/powershell-$pwsh_version-$targetarch.tar.gz -o /tmp/powershell.tar.gz
mkdir -p /opt/microsoft/powershell/$pwsh_base_version
tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/$pwsh_base_version
chmod +x /opt/microsoft/powershell/$pwsh_base_version/pwsh
ln -s /opt/microsoft/powershell/$pwsh_base_version/pwsh /usr/bin/pwsh

# # # Install Terraform
terraform_version=1.9.3
curl -L https://releases.hashicorp.com/terraform/$terraform_version/terraform_${terraform_version}_linux_amd64.zip -o /tmp/terraform.zip
unzip /tmp/terraform.zip -d /usr/local/bin

# # Install Azure CLIi)
azcli_version=2.62.0
pip3 install azure-cli==$azcli_version
az --version

# # install azure devops Cli extension
exec bash
export AZURE_EXTENSION_DIR=/opt/az/azcliextensions
az extension add -n azure-devops

# # clears out the local repository of retrieved package files
# # It removes everything but the lock file from /var/cache/apt/archives/ and /var/cache/apt/archives/partial
rm -rf /tmp/*

# # delete all .gz and rotated file
find /var/log -type f -regex ".*\.gz$" -delete
find /var/log -type f -regex ".*\.[0-9]$" -delete

# # wipe log files
find /var/log/ -type f -exec cp /dev/null {} \;
