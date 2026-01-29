#!/bin/bash
set -e

# Get user info from environment or defaults
USER_ID=${LOCAL_UID:-1000}
GROUP_ID=${LOCAL_GID:-1000}
USER_NAME=${USER:-devuser}
GROUP_NAME=${GROUP_NAME:-devgroup}

# Create group if it doesn't exist
if ! getent group "$GROUP_ID" > /dev/null 2>&1; then
    groupadd -g "$GROUP_ID" "$GROUP_NAME"
fi

# Create user if it doesn't exist
if ! getent passwd "$USER_ID" > /dev/null 2>&1; then
    useradd -u "$USER_ID" -g "$GROUP_ID" -m -s /bin/bash "$USER_NAME"

    # Add user to sudo group without password
    usermod -aG sudo "$USER_NAME"
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

# Get the actual username for the UID (in case it already existed)
ACTUAL_USER=$(getent passwd "$USER_ID" | cut -d: -f1)
    
# Set up home directory
export HOME="/home/$ACTUAL_USER"
chown "$USER_ID:$GROUP_ID" "$HOME"

# So that if we get to ssh into the container, like in vast,
# Creating new terminals from tmux/vscode activates the venv
echo "source /workspace/.venv/bin/activate" >> "$HOME/.bashrc"

# chown -R "$USER_ID:$GROUP_ID" /workspace/

# Execute command as the user
exec gosu "$ACTUAL_USER" "$@"
