#!/bin/bash
# Ensure git is available
command -v git >/dev/null 2>&1 || { echo "Error: git is not installed"; exit 1; }

# Define repositories and their target clone directories
declare -A TARGET_DIRS=(
  ["git@github.com-personal:itsfabijano/config.nvim.git"]="$HOME/repos/personal/config.nvim"
  ["git@github.com-personal:itsfabijano/nixos-config.git"]="$HOME/repos/personal/nixos-config"
)

# Define symlinks: source path -> symlink target
declare -A SYMLINKS=(
  ["$HOME/repos/personal/config.nvim"]="$HOME/.config/nvim"
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

# Step 2: Create symlinks
for source_path in "${!SYMLINKS[@]}"; do
  symlink_target="${SYMLINKS[$source_path]}"
  source_name=$(basename "$source_path")

  # Check if source_path exists
  if [ ! -e "$source_path" ]; then
    echo "Error: Source $source_path does not exist for $source_name. Ensure it is created (e.g., by cloning)."
    success=0
    continue
  fi

  # Create parent directory for symlink_target
  mkdir -p "$(dirname "$symlink_target")"

  # Check if symlink_target exists
  if [ -e "$symlink_target" ]; then
    if [ -L "$symlink_target" ]; then
      # Symlink exists, update it
      if ln -sfn "$source_path" "$symlink_target"; then
        echo "Updated symlink: $symlink_target -> $source_path"
      else
        echo "Failed to update symlink: $symlink_target -> $source_path"
        success=0
      fi
    else
      # Non-symlink exists, skip
      echo "Warning: $symlink_target exists and is not a symlink. Skipping."
      success=0
      continue
    fi
  else
    # Create new symlink
    if ln -sfn "$source_path" "$symlink_target"; then
      echo "Created symlink: $symlink_target -> $source_path"
    else
      echo "Failed to create symlink: $symlink_target -> $source_path"
      success=0
    fi
  fi
done

# Final status message
if [ $success -eq 1 ]; then
  echo "Dotfiles setup completed successfully!"
else
  echo "Dotfiles setup completed with errors."
  exit 1
fi
