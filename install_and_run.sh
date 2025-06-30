#!/usr/bin/env bash

set -e

# Install Ansible if not installed
if ! command -v ansible >/dev/null 2>&1; then
  sudo apt update && sudo apt install -y ansible
fi

# Run the playbook
ansible-playbook dev_env_setup.yml -K
./create_symlinks.sh
