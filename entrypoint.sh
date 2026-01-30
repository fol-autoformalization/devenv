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

# Check if user with this UID exists
if getent passwd "$USER_ID" > /dev/null 2>&1; then
    # User exists - get their username and update their primary GID
    ACTUAL_USER=$(getent passwd "$USER_ID" | cut -d: -f1)
    CURRENT_GID=$(id -g "$ACTUAL_USER")

    # If the GID doesn't match, update it
    if [ "$CURRENT_GID" != "$GROUP_ID" ]; then
        usermod -g "$GROUP_ID" "$ACTUAL_USER"
    fi

    # Ensure user is in sudo group
    usermod -aG sudo "$ACTUAL_USER" 2>/dev/null || true
else
    # Create new user
    useradd -u "$USER_ID" -g "$GROUP_ID" -m -s /bin/bash "$USER_NAME"
    ACTUAL_USER="$USER_NAME"

    # Add user to sudo group without password
    usermod -aG sudo "$ACTUAL_USER"
    echo "$ACTUAL_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

# Add user to shared groups for cache and workspace access
usermod -aG uvcache "$ACTUAL_USER"
usermod -aG workspace "$ACTUAL_USER"

# Set up home directory
export HOME="/home/$ACTUAL_USER"
chown "$USER_ID:$GROUP_ID" "$HOME"

# So that if we get to ssh into the container, like in vast,
# Creating new terminals from tmux/vscode activates the venv
echo "source /workspace/.venv/bin/activate" >> "$HOME/.bashrc"

# chown -R "$USER_ID:$GROUP_ID" /workspace/

# Execute command as the user
exec gosu "$ACTUAL_USER" "$@"
