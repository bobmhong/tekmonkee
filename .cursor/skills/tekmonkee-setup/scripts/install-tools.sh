#!/usr/bin/env bash
set -eo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Warn if running as root
if [[ "$EUID" -eq 0 ]]; then
  printf "${RED}[error]${NC} Do not run this script as root or with 'sudo su'.\n"
  printf "        Run as your normal user. The script will prompt for sudo when needed.\n"
  printf "\n"
  printf "        Example:\n"
  printf "          cd /home/\$USER/repos/bobmhong/tekmonkee\n"
  printf "          bash .cursor/skills/tekmonkee-setup/scripts/install-tools.sh\n"
  exit 1
fi

log()  { printf "${BLUE}[setup]${NC} %s\n" "$*"; }
ok()   { printf "${GREEN}[done]${NC}  %s\n" "$*"; }
skip() { printf "${YELLOW}[skip]${NC}  %s (already installed)\n" "$*"; }

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
      else
        echo "linux"
      fi
      ;;
    MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
    *) echo "unknown" ;;
  esac
}

OS=$(detect_os)
log "Detected OS: $OS"

need() { ! command -v "$1" &>/dev/null; }

install_homebrew() {
  if ! command -v brew &>/dev/null; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ "$OS" == "linux" || "$OS" == "wsl" ]]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv 2>/dev/null || true)"
    fi
  fi
}

apt_install() {
  sudo apt-get update -qq
  sudo apt-get install -y -qq "$@"
}

# --- Git ---
if need git; then
  log "Installing git..."
  case "$OS" in
    macos) brew install git ;;
    linux|wsl) apt_install git ;;
  esac
  ok "git"
else
  skip "git"
fi

# --- nvm + Node.js ---
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  log "Installing nvm..."
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  export NVM_DIR
  # shellcheck source=/dev/null
  . "$NVM_DIR/nvm.sh"
  log "Installing Node.js LTS via nvm..."
  nvm install --lts
  nvm use --lts
  ok "nvm + node"
else
  skip "nvm"
  # shellcheck source=/dev/null
  . "$NVM_DIR/nvm.sh" 2>/dev/null || true
  if need node; then
    log "Installing Node.js LTS via nvm..."
    nvm install --lts
    ok "node"
  else
    skip "node"
  fi
fi

# --- pyenv + Python ---
# Check both command and directory since pyenv may be installed but not in PATH
if ! command -v pyenv &>/dev/null && [[ ! -d "$HOME/.pyenv" ]]; then
  log "Installing pyenv..."
  case "$OS" in
    macos)
      brew install pyenv
      ;;
    linux|wsl)
      apt_install make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
        libffi-dev liblzma-dev
      curl -fsSL https://pyenv.run | bash
      ;;
  esac
  ok "pyenv"
else
  skip "pyenv"
fi

# Ensure pyenv is in PATH for subsequent commands
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)" 2>/dev/null || true
fi

if need python3; then
  log "Installing Python via pyenv..."
  pyenv install -s 3.12
  pyenv global 3.12
  ok "python3"
else
  skip "python3"
fi

# --- Go ---
if need go; then
  log "Installing Go..."
  case "$OS" in
    macos) brew install go ;;
    linux|wsl)
      GO_VERSION="1.22.5"
      curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" | sudo tar -C /usr/local -xz
      echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.bashrc"
      export PATH=$PATH:/usr/local/go/bin
      ;;
  esac
  ok "go"
else
  skip "go"
fi

# --- Docker ---
if need docker; then
  log "Installing Docker..."
  case "$OS" in
    macos)
      brew install --cask docker
      log "Open Docker Desktop to complete setup"
      ;;
    linux|wsl)
      curl -fsSL https://get.docker.com | sh
      sudo usermod -aG docker "$USER"
      log "Log out and back in for docker group membership"
      ;;
  esac
  ok "docker"
else
  skip "docker"
fi

# --- kubectl ---
if need kubectl; then
  log "Installing kubectl..."
  case "$OS" in
    macos) brew install kubectl ;;
    linux|wsl)
      curl -fsSL -o /tmp/kubectl "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
      sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
      rm /tmp/kubectl
      ;;
  esac
  ok "kubectl"
else
  skip "kubectl"
fi

# --- Flux ---
if need flux; then
  log "Installing Flux CLI..."
  case "$OS" in
    macos) brew install fluxcd/tap/flux ;;
    linux|wsl) curl -fsSL https://fluxcd.io/install.sh | sudo bash ;;
  esac
  ok "flux"
else
  skip "flux"
fi

# --- Terraform ---
if need terraform; then
  log "Installing Terraform..."
  case "$OS" in
    macos) brew install hashicorp/tap/terraform ;;
    linux|wsl)
      sudo apt-get install -y -qq gnupg software-properties-common
      curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
      echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
      sudo apt-get update -qq && sudo apt-get install -y -qq terraform
      ;;
  esac
  ok "terraform"
else
  skip "terraform"
fi

# --- SOPS ---
if need sops; then
  log "Installing sops..."
  case "$OS" in
    macos) brew install sops ;;
    linux|wsl)
      SOPS_VER="3.9.4"
      curl -fsSL -o /tmp/sops "https://github.com/getsops/sops/releases/download/v${SOPS_VER}/sops-v${SOPS_VER}.linux.amd64"
      sudo install -o root -g root -m 0755 /tmp/sops /usr/local/bin/sops
      rm /tmp/sops
      ;;
  esac
  ok "sops"
else
  skip "sops"
fi

# --- ripgrep ---
if need rg; then
  log "Installing ripgrep..."
  case "$OS" in
    macos) brew install ripgrep ;;
    linux|wsl) apt_install ripgrep ;;
  esac
  ok "ripgrep"
else
  skip "ripgrep"
fi

# --- jq ---
if need jq; then
  log "Installing jq..."
  case "$OS" in
    macos) brew install jq ;;
    linux|wsl) apt_install jq ;;
  esac
  ok "jq"
else
  skip "jq"
fi

# --- yq ---
if need yq; then
  log "Installing yq..."
  case "$OS" in
    macos) brew install yq ;;
    linux|wsl)
      YQ_VER="4.44.6"
      curl -fsSL -o /tmp/yq "https://github.com/mikefarah/yq/releases/download/v${YQ_VER}/yq_linux_amd64"
      sudo install -o root -g root -m 0755 /tmp/yq /usr/local/bin/yq
      rm /tmp/yq
      ;;
  esac
  ok "yq"
else
  skip "yq"
fi

# --- pip (ensure available) ---
if ! command -v pip3 &>/dev/null && ! python3 -m pip --version &>/dev/null 2>&1; then
  log "Installing pip..."
  case "$OS" in
    macos) python3 -m ensurepip --upgrade 2>/dev/null || brew install python3 ;;
    linux|wsl) apt_install python3-pip ;;
  esac
  ok "pip"
else
  skip "pip"
fi

# --- Python packages ---
log "Installing Python packages..."
case "$OS" in
  macos)
    pip3 install --quiet --upgrade pandas 2>/dev/null \
      || python3 -m pip install --quiet --upgrade pandas
    ;;
  linux|wsl)
    # Ubuntu 24.04+ uses PEP 668 externally-managed Python
    # Use apt for pandas, or pyenv Python if available
    if command -v pyenv &>/dev/null && pyenv version 2>/dev/null | grep -qv system; then
      pip install --quiet --upgrade pandas
    else
      apt_install python3-pandas
    fi
    ;;
esac
ok "pandas"

# --- Docker helper aliases (WSL/Linux only) ---
if [[ "$OS" == "wsl" || "$OS" == "linux" ]]; then
  if ! grep -q "docker-wsl-start" "$HOME/.bashrc" 2>/dev/null; then
    log "Adding Docker helper aliases to ~/.bashrc..."
    cat >> "$HOME/.bashrc" << 'ALIASES'

# Docker Engine helpers (for when Docker Desktop is off)
alias docker-wsl-start='sudo systemctl start docker.service && echo "WSL Docker Engine started"'
alias docker-wsl-stop='sudo systemctl stop docker.service && echo "WSL Docker Engine stopped"'
alias docker-wsl-status='sudo systemctl status docker.service'
alias docker-which='docker info 2>/dev/null | grep -E "Operating System|Server Version" || echo "Docker not running"'
ALIASES
    ok "docker aliases"
  else
    skip "docker aliases"
  fi
fi

echo ""
log "Setup complete. Re-run check-tools.sh to verify."
log "You may need to open a new terminal for PATH changes to take effect."
if [[ "$OS" == "wsl" ]]; then
  log ""
  log "WSL Docker notes:"
  log "  - If Docker Desktop is running, it takes over the docker socket"
  log "  - To use WSL Docker Engine: quit Docker Desktop, then run 'docker-wsl-start'"
  log "  - Run 'newgrp docker' to use docker without sudo"
fi
