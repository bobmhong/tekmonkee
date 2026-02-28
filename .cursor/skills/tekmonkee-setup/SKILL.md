---
name: tekmonkee-setup
description: Configure Cursor IDE layout and install standard dev tools on a new machine. Use when setting up a new workstation, onboarding a new machine, or when the user mentions IDE setup, new machine setup, dev environment, or workstation configuration.
---

# TekMonkee Setup

One-time setup for configuring Cursor IDE preferences and installing standard development tools on a new machine. Supports Linux/WSL, macOS, and Windows.

## Workflow

```
Setup Progress:
- [ ] Step 1: Configure Cursor IDE layout          (agent does this)
- [ ] Step 2: Check which dev tools are installed   (agent does this)
- [ ] Step 3: Install missing tools                 (may need user action)
- [ ] Step 4: Post-install manual steps             (user does this)
- [ ] Step 5: Verify                                (agent does this)
```

---

## Step 1: Configure Cursor IDE Layout

**Who**: Agent (automatic)

Read the current Cursor settings file, then merge the preferences below. Preserve all existing settings — do not overwrite the file.

| OS | Settings path |
|----|---------------|
| macOS | ~/Library/Application Support/Cursor/User/settings.json |
| Linux/WSL | ~/.config/Cursor/User/settings.json |
| Windows | %APPDATA%\Cursor\User\settings.json |

If the file does not exist, create it with the directory path. Apply these settings:

```json
{
  "workbench.activityBar.location": "top",
  "workbench.sideBar.location": "left",
  "editor.formatOnSave": true
}
```

Notes:
- `"top"` places tool icons in a horizontal strip across the top of the window, which is how newer Cursor builds replicate the classic VSCode vertical activity bar.
- If the user wants a true vertical sidebar icon strip instead, use `"default"`.

---

## Step 2: Check Installed Dev Tools

**Who**: Agent (automatic)

Run the check script from the project root:

```bash
bash .cursor/skills/tekmonkee-setup/scripts/check-tools.sh
```

This prints a report with `[OK]`, `[MISS]`, or `[WARN]` for each tool below.

### Required Tools

| Category | Tools |
|----------|-------|
| Version control | `git`, GPG commit signing |
| Version managers | `nvm`, `pyenv` |
| Runtimes | `node` (via nvm), `python3` (via pyenv), `go` |
| Containers | `docker`, `docker compose` |
| Kubernetes | `kubectl`, `flux` |
| IaC | `terraform`, `sops` |
| CLI utilities | `rg` (ripgrep), `jq`, `yq` |
| Python packages | `pandas` |

---

## Step 3: Install Missing Tools

**Who**: Agent attempts this automatically. On Linux/WSL, most installs require `sudo`, which needs an interactive terminal. If `sudo` fails, tell the user to run the install script manually (see below).

### Agent-driven install

```bash
bash .cursor/skills/tekmonkee-setup/scripts/install-tools.sh
```

The script auto-detects the OS and skips tools that are already installed.

| OS | Package manager |
|----|-----------------|
| macOS | Homebrew (`brew`) — installed automatically if missing |
| Debian/Ubuntu/WSL | `apt` + direct binary downloads |
| Windows | `winget` / `choco` (if available) |

### If sudo is required (user action)

On Linux/WSL, the agent cannot provide a sudo password. If the install script fails with a `sudo` error, **tell the user** to run the install script manually in their terminal.

Present this exact block to the user:

```
┌─────────────────────────────────────────────────────────────┐
│  ACTION REQUIRED: Run in your terminal                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  IMPORTANT: Run as your normal user, NOT as root.           │
│  Do NOT use "sudo su" or "sudo -i" first.                   │
│  The script will prompt for your password when needed.      │
│                                                             │
│  cd /home/<username>/repos/bobmhong/tekmonkee               │
│  bash .cursor/skills/tekmonkee-setup/scripts/install-tools.sh│
│                                                             │
│  The script will:                                           │
│    • Skip tools already installed                           │
│    • Prompt for your sudo password when needed              │
│    • Install remaining tools via apt / direct download      │
│    • Take approximately 5-10 minutes                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Replace `<username>` with the actual username (e.g., from `$USER` or the workspace path).

After the user confirms the script finished, proceed to Step 5 (verify).

---

## Step 4: Post-Install Manual Steps

**Who**: User (manual). After tools are installed, present this checklist to the user.

### 4a. Reload shell PATH

New tools won't be visible until the shell profile is reloaded. Run **one** of:

```bash
source ~/.bashrc        # if using bash
source ~/.zshrc         # if using zsh
```

Or simply **open a new terminal**.

### 4b. Docker group membership (Linux/WSL only)

Docker was installed with the current user added to the `docker` group, but this only takes effect after re-login:

```bash
newgrp docker           # apply immediately in current shell
# — or —
# log out and log back in
```

Verify with: `docker run hello-world`

### 4c. Docker Desktop (macOS only)

Open **Docker Desktop** from Applications to complete first-time setup. Docker commands won't work until the daemon is running.

### 4d. GPG commit signing

If the check script showed a GPG signing warning, configure it:

```bash
# List your GPG keys to find your key ID
gpg --list-secret-keys --keyid-format=long

# Configure git to sign commits
git config --global commit.gpgsign true
git config --global user.signingkey <YOUR_KEY_ID>
```

If you don't have a GPG key yet, generate one first:

```bash
gpg --full-generate-key
```

### 4e. Reload Cursor window

Apply IDE layout changes by reloading the Cursor window:

- **Keyboard**: `Ctrl+Shift+P` (Linux/Windows) or `Cmd+Shift+P` (macOS)
- **Command**: Type `Developer: Reload Window` and press Enter
- **Verify**: Activity bar icons should appear at the top; sidebar on the left

---

## Step 5: Verify

**Who**: Agent (automatic)

Re-run the check script to confirm everything is installed:

```bash
bash .cursor/skills/tekmonkee-setup/scripts/check-tools.sh
```

Expected result: all `[OK]` with 0 missing. GPG signing should also show `[OK]`.

If any tools still show `[MISS]`, check [install-reference.md](install-reference.md) for manual install instructions per tool.

---

## Docker on WSL: Important Notes

When running on WSL with Docker Desktop installed on the Windows host, be aware of how the two Docker runtimes interact.

### Docker Desktop WSL Integration

When Docker Desktop is running with WSL integration enabled:
- Docker Desktop takes over `/var/run/docker.sock` in your WSL distro
- The `docker` CLI in WSL connects to Docker Desktop's daemon, not WSL's Docker Engine
- Containers started from WSL appear in Docker Desktop GUI
- Port forwarding to Windows `localhost` works automatically

### Using Docker Engine in WSL (when Docker Desktop is off)

For enterprise/CI parity or to avoid Docker Desktop licensing:

1. **Fully quit Docker Desktop** (not just pause — right-click tray icon → "Quit Docker Desktop")
2. **Clean restart Docker in WSL:**
   ```bash
   sudo systemctl stop docker.socket docker.service
   sudo rm -f /var/run/docker.sock /var/run/docker.pid
   sudo systemctl start docker.service
   ```
3. **Apply docker group membership:**
   ```bash
   newgrp docker
   ```

### Switching Between Runtimes

Helper aliases (added to `~/.bashrc` during setup):

| Command | What it does |
|---------|--------------|
| `docker-wsl-start` | Start Docker Engine in WSL |
| `docker-wsl-stop` | Stop Docker Engine in WSL |
| `docker-wsl-status` | Check if WSL Docker is running |
| `docker-which` | Show which Docker you're connected to |

**Workflow:**
- **Docker Desktop running** → Just use `docker`, it routes to Docker Desktop
- **Need WSL Docker** → Quit Docker Desktop, run `docker-wsl-start`

### WSL Networking Considerations

**Accessing containers from Windows host:**
- Docker Desktop: `localhost:PORT` works automatically
- WSL Docker Engine: May need to use WSL's IP (`hostname -I`) or configure `.wslconfig` with `localhostForwarding=true`

**Accessing containers from another machine (e.g., SSH'd into WSL):**
- Use SSH port forwarding: `ssh -L 8080:localhost:8080 user@host`
- Or access via Windows host's network IP (requires Docker Desktop or port forwarding setup)

---

## Known Issues & Fixes

### PEP 668: Externally Managed Python Environment

Ubuntu 24.04+ blocks `pip install` for system Python. The install script handles this by:
- Using `apt install python3-pandas` on Linux/WSL
- Or using pyenv-managed Python where pip works normally

### Docker socket conflicts

If `docker ps` hangs after switching between Docker Desktop and WSL Docker:
```bash
sudo systemctl stop docker.socket docker.service
sudo rm -f /var/run/docker.sock
sudo systemctl start docker.service
```

### pyenv installed but not detected

The install script checks both `command -v pyenv` and `~/.pyenv` directory to avoid reinstall attempts.

---

## Additional Resources

- Detailed per-tool install instructions: [install-reference.md](install-reference.md)
