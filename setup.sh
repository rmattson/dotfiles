#!/usr/bin/env bash
set -e

# Ensure Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
	echo "Installing Ansible..."
	if command -v dnf &> /dev/null; then
		sudo dnf install -y ansible
	elif command -v brew &> /dev/null; then
		brew install ansible
	else
		echo "Could not auto-install Ansible. Please install it manually."
		exit 1
	fi
fi

# Determine if we need sudo prompt (-K) for Fedora
FLAGS=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	FLAGS="-K"
fi

echo "Running Ansible Playbook..."
# Run the playbook
ansible-playbook $FLAGS ansible/site.yml

echo "Done! Machine bootstrapped successfully."
