#!/bin/bash
# Ensure git is available
command -v git >/dev/null 2>&1 || { echo "Error: git is not installed"; exit 1; }

# Define repositories and their target clone directories
declare -A TARGET_DIRS=(
  ["git@github.com:itsfabijano/config.nvim.git"]="$HOME/repos/personal/config.nvim"
  ["git@github.com:itsfabijano/nixos-config.git"]="$HOME/repos/personal/nixos-config"
)

# Flag to track if all operations were successful
success=1

# Step 1: Clone repositories
for repo_url in "${!TARGET_DIRS[@]}"; do
  target_dir="${TARGET_DIRS[$repo_url]}"
  repo_name=$(basename "$repo_url" .git)

  # Create parent directory for target_dir
  mkdir -p "$(dirname "$target_dir")"

  # Check if the target directory already exists
  if [ -d "$target_dir" ]; then
    echo "Repository $repo_name already exists at $target_dir"
  else
    echo "Cloning $repo_name to $target_dir..."
    if git clone "$repo_url" "$target_dir"; then
      echo "Successfully cloned $repo_name"
    else
      echo "Failed to clone $repo_name"
      success=0
    fi
  fi
done

# Enable and start Docker service for the user
if systemctl --user is-active --quiet docker.service; then
    echo "Docker (user service) is running."
else
    echo "Docker (user service) is NOT running."
    echo "Enabling and starting Docker service for the user..." 
    systemctl --user enable --now docker
fi

if [ ! -f "$HOME/repos/personal/nixos-config/.variables.json" ]; then
    echo "Copying .variables.json file to nixos-config..."
    cp "/tmp/nixos-config/.variables.json" "$HOME/repos/personal/nixos-config/.variables.json"
fi

if [[ ! -f "$HOME/repos/personal/nixos-config/.env" && -f "/nix-config/.env" ]]; then
    echo "Copying .env file to nixos-config..."
    cp "/nix-config/.env" "$HOME/repos/personal/nixos-config/.env"
fi

# Final status message
if [ $success -eq 1 ]; then
  echo "Dotfiles setup completed successfully!"
else
  echo "Dotfiles setup completed with errors."
  exit 1
fi
