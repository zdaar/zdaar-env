# Script to install and initialize tmux with custom keybindings

echo "Checking for tmux installation..."

if ! command -v tmux >/dev/null 2>&1; then
    echo "Installing tmux..."
    sudo apt-get update && sudo apt-get install -y tmux
else
    echo "tmux is already installed."
fi

echo "Configuring tmux..."

# Create or modify the tmux configuration file
TMUX_CONF=~/.tmux.conf

if [ ! -f "$TMUX_CONF" ]; then
    touch "$TMUX_CONF"
    echo "Created $TMUX_CONF."
else
    echo "$TMUX_CONF already exists. Updating configuration..."
fi

# Add vim-style pane navigation if not already present
if ! grep -q "bind -n C-h select-pane -L" "$TMUX_CONF"; then
    echo 'bind -n C-h select-pane -L  # Move left' >> "$TMUX_CONF"
    echo 'bind -n C-j select-pane -D  # Move down' >> "$TMUX_CONF"
    echo 'bind -n C-k select-pane -U  # Move up' >> "$TMUX_CONF"
    echo 'bind -n C-l select-pane -R  # Move right' >> "$TMUX_CONF"
    echo "Vim-style pane navigation added to $TMUX_CONF."
fi

# Add smart suggestions if not already present
if ! grep -q "set -g mouse on" "$TMUX_CONF"; then
    echo 'set -g mouse on  # Enable mouse support' >> "$TMUX_CONF"
    echo 'setw -g mode-keys vi  # Use vi keys in copy mode' >> "$TMUX_CONF"
    echo 'bind r source-file ~/.tmux.conf \; display "Config reloaded!"' >> "$TMUX_CONF"
    echo "Smart suggestions added to $TMUX_CONF."
fi

echo "tmux configuration complete."

echo "Reloading tmux configuration..."
tmux source-file ~/.tmux.conf
