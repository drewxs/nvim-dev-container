#!/bin/sh

[ -z "$1" ] && echo "Usage: devc <container_name>" && exit 1
container_name="$1"

if ! docker ps -a --filter "name=^${container_name}$" --format "{{.Names}}" | grep -q "^${container_name}$"; then
  echo "Container '$container_name' does not exist."
  exit 1
elif ! docker ps --filter "name=^${container_name}$" --format "{{.Names}}" | grep -q "^${container_name}$"; then
  echo "Container '$container_name' is not running."
  exit 1
fi

docker exec -it "$container_name" bash -c "mkdir -p /root/.config"

if [ -L "$HOME/.config/nvim" ]; then
  # Handle symlinked configs
  cp -rL "$HOME/.config/nvim/" /tmp/nvim-tmp
  docker cp -q /tmp/nvim-tmp "$container_name":/root/.config/nvim
  rm -rf /tmp/nvim-tmp
else
  docker cp -q "$HOME/.config/nvim" "$container_name":/root/.config/nvim
fi

docker exec -it "$container_name" bash -c "
  if ! command -v nvim > /dev/null 2>&1; then
    if command -v apt > /dev/null 2>&1; then
      apt update && apt upgrade -y
      apt install -y curl git ripgrep fzf fd-find;
      if ! command -v python3 > /dev/null 2>&1; then
        apt install -y python3 python3-pip
      fi
      if ! command -v node > /dev/null 2>&1; then
        apt install -y nodejs npm
      fi
      apt autoremove && apt clean

      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
      rm -rf /opt/nvim
      tar -C /opt -xzf nvim-linux64.tar.gz
      rm nvim-linux64.tar.gz
      ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    else
      echo 'Unsupported package manager. Manual installation required.'
    fi
  fi

  nvim --headless +Lazy! restore +qa
  printf '\n'
"

docker exec -it "$container_name" bash
