#!/bin/bash

# Function to configure gpg-agent for SSH support
configure_gpg_agent() {
  echo "Configuring gpg-agent for SSH support..."
  
  # Ensure gpg-agent.conf exists
  mkdir -p ~/.gnupg
  touch ~/.gnupg/gpg-agent.conf

  # Add SSH support settings if not already present
  if ! grep -q "enable-ssh-support" ~/.gnupg/gpg-agent.conf; then
    echo "enable-ssh-support" >> ~/.gnupg/gpg-agent.conf
  fi

  if ! grep -q "default-cache-ttl" ~/.gnupg/gpg-agent.conf; then
    echo "default-cache-ttl 600" >> ~/.gnupg/gpg-agent.conf
  fi

  if ! grep -q "max-cache-ttl" ~/.gnupg/gpg-agent.conf; then
    echo "max-cache-ttl 7200" >> ~/.gnupg/gpg-agent.conf
  fi

  # Enable verbose logging
  if ! grep -q "log-file" ~/.gnupg/gpg-agent.conf; then
    echo "log-file ~/.gnupg/gpg-agent.log" >> ~/.gnupg/gpg-agent.conf
  fi

  if ! grep -q "debug-level" ~/.gnupg/gpg-agent.conf; then
    echo "debug-level advanced" >> ~/.gnupg/gpg-agent.conf
  fi

  # Specify pinentry program
  if ! grep -q "pinentry-program" ~/.gnupg/gpg-agent.conf; then
    echo "pinentry-program /usr/bin/pinentry" >> ~/.gnupg/gpg-agent.conf
  fi
}

# Function to set environment variables
set_environment_variables() {
  echo "Setting environment variables..."

  # Add environment variable settings to shell profile
  if ! grep -q "GPG_TTY" ~/.bashrc; then
    echo "export GPG_TTY=\$(tty)" >> ~/.bashrc
  fi

  if ! grep -q "SSH_AUTH_SOCK" ~/.bashrc; then
    echo "export SSH_AUTH_SOCK=\$(gpgconf --list-dirs agent-ssh-socket)" >> ~/.bashrc
  fi

  # Source the profile to apply changes
  source ~/.bashrc
}

# Function to restart gpg-agent
restart_gpg_agent() {
  echo "Restarting gpg-agent..."
  gpgconf --kill gpg-agent
  gpgconf --launch gpg-agent
}

# Function to update gpg-agent TTY info
update_gpg_tty() {
  echo "Updating gpg-agent TTY info..."
  gpg-connect-agent updatestartuptty /bye
}

# Function to check gpg-agent and SSH configuration
check_configuration() {
  echo "Checking configuration..."

  # Check SSH_AUTH_SOCK
  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    echo "Error: SSH_AUTH_SOCK is not set."
    exit 1
  else
    echo "SSH_AUTH_SOCK is set to $SSH_AUTH_SOCK"
  fi

  # Check GPG_TTY
  if [[ -z "$GPG_TTY" ]]; then
    echo "Error: GPG_TTY is not set."
    exit 1
  else
    echo "GPG_TTY is set to $GPG_TTY"
  fi

  # Check if gpg-agent has opened the SSH socket using ss or netstat
  if netstat -a | grep -q "S.gpg-agent.ssh"; then
    echo "gpg-agent is running and has opened the SSH socket."
  else
    echo "Error: gpg-agent has not opened the SSH socket."
    exit 1
  fi

  # List SSH keys managed by gpg-agent
  if ssh-add -l; then
    echo "SSH keys managed by gpg-agent:"
    ssh-add -l
  else
    echo "Error: ssh-add could not list keys managed by gpg-agent."
    exit 1
  fi
}

show_reminder() {
  echo "Check ~/.gnupg/sshcontrol file. Add GPG authentication keygrip if it is required."
  echo "Check ~/.gnupg/gpg-agent.conf pinentry path."
}

# Main script execution
configure_gpg_agent
set_environment_variables
restart_gpg_agent
update_gpg_tty
check_configuration
show_reminder

echo "Configuration and verification completed successfully."

