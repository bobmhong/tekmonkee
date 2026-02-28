#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
FAIL=0
WARN=0

check_cmd() {
  local name="$1"
  local cmd="${2:-$1}"
  if command -v "$cmd" &>/dev/null; then
    local ver
    ver=$("$cmd" --version 2>/dev/null | head -1) || ver="installed"
    printf "${GREEN}[OK]${NC}  %-14s %s\n" "$name" "$ver"
    PASS=$((PASS + 1))
  else
    printf "${RED}[MISS]${NC} %-14s not found\n" "$name"
    FAIL=$((FAIL + 1))
  fi
}

check_python_pkg() {
  local pkg="$1"
  if python3 -c "import $pkg" &>/dev/null; then
    local ver
    ver=$(python3 -c "import $pkg; print($pkg.__version__)" 2>/dev/null) || ver="installed"
    printf "${GREEN}[OK]${NC}  %-14s %s\n" "$pkg (py)" "$ver"
    PASS=$((PASS + 1))
  else
    printf "${RED}[MISS]${NC} %-14s not installed\n" "$pkg (py)"
    FAIL=$((FAIL + 1))
  fi
}

check_docker_compose() {
  if docker compose version &>/dev/null; then
    local ver
    ver=$(docker compose version --short 2>/dev/null) || ver="installed"
    printf "${GREEN}[OK]${NC}  %-14s %s\n" "docker compose" "$ver"
    PASS=$((PASS + 1))
  elif docker-compose --version &>/dev/null; then
    local ver
    ver=$(docker-compose --version 2>/dev/null | head -1) || ver="installed"
    printf "${YELLOW}[WARN]${NC} %-14s %s (legacy standalone)\n" "docker-compose" "$ver"
    WARN=$((WARN + 1))
  else
    printf "${RED}[MISS]${NC} %-14s not found\n" "docker compose"
    FAIL=$((FAIL + 1))
  fi
}

check_gpg_signing() {
  local signing
  signing=$(git config --global commit.gpgsign 2>/dev/null || echo "false")
  if [[ "$signing" == "true" ]]; then
    printf "${GREEN}[OK]${NC}  %-14s enabled\n" "gpg signing"
    PASS=$((PASS + 1))
  else
    printf "${YELLOW}[WARN]${NC} %-14s not configured (git config --global commit.gpgsign)\n" "gpg signing"
    WARN=$((WARN + 1))
  fi
}

check_nvm() {
  if [[ -d "${NVM_DIR:-$HOME/.nvm}" ]] && [[ -s "${NVM_DIR:-$HOME/.nvm}/nvm.sh" ]]; then
    printf "${GREEN}[OK]${NC}  %-14s %s\n" "nvm" "${NVM_DIR:-$HOME/.nvm}"
    PASS=$((PASS + 1))
  else
    printf "${RED}[MISS]${NC} %-14s not found\n" "nvm"
    FAIL=$((FAIL + 1))
  fi
}

check_pyenv() {
  if command -v pyenv &>/dev/null; then
    local ver
    ver=$(pyenv --version 2>/dev/null | head -1) || ver="installed"
    printf "${GREEN}[OK]${NC}  %-14s %s\n" "pyenv" "$ver"
    PASS=$((PASS + 1))
  else
    printf "${RED}[MISS]${NC} %-14s not found\n" "pyenv"
    FAIL=$((FAIL + 1))
  fi
}

echo "============================================"
echo " TekMonkee Dev Environment Check"
echo "============================================"
echo ""
echo "OS: $(uname -s) $(uname -r)"
echo ""

echo "--- Version Control ---"
check_cmd git
check_gpg_signing

echo ""
echo "--- Runtime Version Managers ---"
check_nvm
check_pyenv

echo ""
echo "--- Runtimes ---"
check_cmd node
check_cmd python3
check_cmd go

echo ""
echo "--- Containers ---"
check_cmd docker
check_docker_compose

echo ""
echo "--- Kubernetes ---"
check_cmd kubectl
check_cmd flux

echo ""
echo "--- Infrastructure as Code ---"
check_cmd terraform
check_cmd sops

echo ""
echo "--- CLI Utilities ---"
check_cmd ripgrep rg
check_cmd jq
check_cmd yq

echo ""
echo "--- Python Packages ---"
check_python_pkg pandas

echo ""
echo "============================================"
printf "Results: ${GREEN}%d passed${NC}, ${RED}%d missing${NC}, ${YELLOW}%d warnings${NC}\n" "$PASS" "$FAIL" "$WARN"
echo "============================================"

if [[ "$FAIL" -gt 0 ]]; then
  echo ""
  echo "Run: bash .cursor/skills/tekmonkee-setup/scripts/install-tools.sh"
  echo "to install missing tools."
fi
