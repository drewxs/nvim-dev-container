# Neovim Dev Container

A simple script to use your Neovim configuration in a Docker container.

Note: The script currently only supports Debian-based images. If you're interested in supporting other distributions, please open an issue or submit a pull request.

## Quick Start

### One-Time Use

Run the script directly from GitHub:

```sh
bash <(curl -s https://raw.githubusercontent.com/drewxs/nvim-dev-container/main/devc.sh) <container_name>
```

### Persistent Use

Add the following to your `~/.bashrc` or `~/.zshrc`:

```sh
# `devc` can be replaced with whatever you want
alias devc='bash <(curl -s https://raw.githubusercontent.com/yourusername/docker-dev-container-helper/main/devc.sh)'
```

Then you can use it like this: `devc <container_name>`.
