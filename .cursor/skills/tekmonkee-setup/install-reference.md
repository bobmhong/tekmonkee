# Install Reference

Detailed install notes for each tool in the tekmonkee dev environment.

## Version Managers

### nvm (Node Version Manager)

- **Repo**: https://github.com/nvm-sh/nvm
- Installs to `~/.nvm`
- Add to shell profile: `export NVM_DIR="$HOME/.nvm"` and source `nvm.sh`
- Install LTS: `nvm install --lts`
- Switch versions: `nvm use 20`

### pyenv

- **Repo**: https://github.com/pyenv/pyenv
- Installs to `~/.pyenv`
- Requires build dependencies on Linux (libssl-dev, zlib1g-dev, etc.)
- Add to shell profile: `export PYENV_ROOT="$HOME/.pyenv"` and `eval "$(pyenv init -)"`
- Install Python: `pyenv install 3.12`
- Set global: `pyenv global 3.12`

## Runtimes

### Go

- **Downloads**: https://go.dev/dl/
- macOS: `brew install go`
- Linux: extract tarball to `/usr/local/go`, add to PATH
- Verify: `go version`

## Container & Kubernetes

### Docker

**macOS:**
- Docker Desktop via `brew install --cask docker`
- Alternative (no licensing): Colima (`brew install colima docker docker-compose && colima start`)

**Linux:**
- `curl -fsSL https://get.docker.com | sh`
- Post-install: `sudo usermod -aG docker $USER` (requires re-login or `newgrp docker`)

**WSL (Windows Subsystem for Linux):**

Two options exist — pick one:

| Option | Pros | Cons |
|--------|------|------|
| Docker Desktop (Windows) | Auto port forwarding, GUI, easy | Licensing for large enterprises |
| Docker Engine in WSL | CI parity, no licensing | Manual daemon start, networking quirks |

**Docker Desktop with WSL integration:**
- Install Docker Desktop on Windows
- Enable WSL integration: Settings → Resources → WSL Integration
- Docker commands in WSL use Docker Desktop's daemon
- `localhost:PORT` works from Windows automatically

**Docker Engine in WSL (standalone):**
- Installed via `get.docker.com` script
- Must quit Docker Desktop first to avoid socket conflicts
- Start daemon: `sudo systemctl start docker.service`
- Access from Windows: use WSL IP (`hostname -I`) or SSH tunnel

**Switching between them:**

Helper aliases (added during setup):
```bash
docker-wsl-start   # Start WSL Docker Engine
docker-wsl-stop    # Stop WSL Docker Engine  
docker-which       # Show which Docker is active
```

**Fixing socket conflicts:**
```bash
sudo systemctl stop docker.socket docker.service
sudo rm -f /var/run/docker.sock
sudo systemctl start docker.service
newgrp docker
```

### kubectl

- **Docs**: https://kubernetes.io/docs/tasks/tools/
- macOS: `brew install kubectl`
- Linux: download binary from `dl.k8s.io`

### Flux

- **Docs**: https://fluxcd.io/docs/installation/
- macOS: `brew install fluxcd/tap/flux`
- Linux: `curl -s https://fluxcd.io/install.sh | sudo bash`

## Infrastructure as Code

### Terraform

- **Docs**: https://developer.hashicorp.com/terraform/install
- macOS: `brew install hashicorp/tap/terraform`
- Linux: add HashiCorp apt repository

### SOPS

- **Repo**: https://github.com/getsops/sops
- Encrypts/decrypts secrets in YAML, JSON, ENV, INI files
- macOS: `brew install sops`
- Linux: download binary from GitHub releases

## CLI Utilities

### ripgrep (rg)

- **Repo**: https://github.com/BurntSushi/ripgrep
- Fast recursive text search
- macOS: `brew install ripgrep`
- Linux: `apt install ripgrep`

### jq

- **Docs**: https://jqlang.github.io/jq/
- JSON processor
- macOS: `brew install jq`
- Linux: `apt install jq`

### yq

- **Repo**: https://github.com/mikefarah/yq
- YAML processor (like jq for YAML)
- macOS: `brew install yq`
- Linux: download binary from GitHub releases

## Python Packages

### pandas

- **Docs**: https://pandas.pydata.org/
- Data analysis library

**Install methods:**

| Environment | Command |
|-------------|---------|
| macOS / pyenv Python | `pip3 install pandas` |
| Ubuntu 24.04+ (system Python) | `sudo apt install python3-pandas` |
| Virtual environment | `pip install pandas` |

**Note:** Ubuntu 24.04+ enforces PEP 668 which blocks `pip install` for system Python. Use apt or a virtual environment instead.

## GPG Signing for Git

Ensure git commits are GPG-signed:

```bash
git config --global commit.gpgsign true
git config --global user.signingkey <YOUR_KEY_ID>
```

List GPG keys: `gpg --list-secret-keys --keyid-format=long`
