---
title: WSL2 SSH Remote Development with Cursor and VS Code
date: 2026-02-28
updated: 2026-02-28
tags: [ssh, wsl, cursor, vscode, remote-development, windows]
category: tooling
language: bash
pattern: operational
---

# WSL2 SSH Remote Development with Cursor and VS Code

## Context

When developing from macOS and needing to use the compute and filesystem of a Windows 11 machine, connecting via SSH into WSL2 provides the best balance of performance, compatibility, and editor integration. VS Code supports Remote Tunnels and Remote-SSH to Windows natively, but Cursor (a VS Code fork) has known stability issues with both — Remote Tunnels is unsupported entirely, and Remote-SSH to a Windows target frequently fails to install Cursor Server. Targeting a Linux environment via WSL2 sidesteps these issues.

## Summary

Install WSL2 on Windows 11, run OpenSSH Server inside the Linux environment, forward a port from Windows to WSL2, and connect from Cursor or VS Code on macOS via Remote-SSH. Clone repos onto the native WSL2 ext4 filesystem (not `/mnt/c/`) for best I/O performance.

## Details

### Step 1: Install OpenSSH Server in WSL2

```bash
sudo apt update && sudo apt install -y openssh-server
```

The default config listens on port 22. Verify after starting:

```bash
sudo service ssh start
ss -tlnp | grep ssh
```

### Step 2: Set Up Port Forwarding from Windows to WSL2

WSL2 runs in its own virtual network. Windows must forward external traffic into it.

Get the WSL internal IP from a WSL shell:

```bash
hostname -I | awk '{print $1}'
```

In an **elevated PowerShell** on Windows, add the port proxy rule (using port 2222 externally to avoid conflicting with Windows' own SSH server on port 22):

```powershell
netsh interface portproxy add v4tov4 listenport=2222 listenaddress=0.0.0.0 connectport=22 connectaddress=<WSL_IP>
```

### Step 3: Open the Windows Firewall

In the same elevated PowerShell:

```powershell
New-NetFirewallRule -DisplayName "WSL SSH" -Direction Inbound -LocalPort 2222 -Protocol TCP -Action Allow
```

### Step 4: Copy SSH Keys from macOS

From the Mac terminal:

```bash
ssh-copy-id -p 2222 <user>@<windows-host>
```

Verify passwordless login:

```bash
ssh -p 2222 <user>@<windows-host>
```

### Step 5: Connect from Cursor or VS Code

1. Open Command Palette
2. Select **Remote-SSH: Connect to Host**
3. Enter `<user>@<windows-host> -p 2222`
4. Select **Linux** as the remote platform when prompted

The editor installs its server component inside WSL2 and opens a remote window with full terminal, filesystem, and extension support.

### Step 6: Clone Repos to the Native Filesystem

For best performance, keep working trees on the WSL2 ext4 filesystem:

```bash
mkdir -p ~/repos
cd ~/repos
git clone <repo-url>
```

Avoid `/mnt/c/` for active development — every file operation crosses the 9P protocol bridge to NTFS, making git, file watchers, and IntelliSense 3-10x slower.

## Common Issues

- **Connection timeout from macOS**: Port forwarding is missing or points to the wrong WSL IP. Verify with `netsh interface portproxy show all` in PowerShell and confirm the WSL IP matches `hostname -I` inside WSL.

- **`kex_exchange_identification: Connection reset by peer`**: The port proxy is forwarding to the wrong port inside WSL. Ensure `connectport` matches the port sshd is actually listening on (default: 22). Check with `ss -tlnp | grep ssh`.

- **WSL IP changes on reboot**: WSL2 assigns a new internal IP on each Windows restart. The `netsh` port proxy must be updated. Automate with a Windows startup script:

```powershell
# Save as C:\scripts\wsl-ssh-forward.ps1 and add to Task Scheduler
$wslIp = (wsl hostname -I).Trim()
netsh interface portproxy delete v4tov4 listenport=2222 listenaddress=0.0.0.0
netsh interface portproxy add v4tov4 listenport=2222 listenaddress=0.0.0.0 connectport=22 connectaddress=$wslIp
```

- **SSH server not running after reboot**: WSL2 doesn't persist services across restarts. Add to your `.bashrc` or create a `/etc/wsl.conf` boot command:

```ini
# /etc/wsl.conf
[boot]
command = service ssh start
```

- **Cursor fails to install server**: If the built-in Anysphere Remote SSH extension fails, try the community `open-remote-ssh` extension from Open VSX:

```bash
curl -L "https://open-vsx.org/api/jeanp413/open-remote-ssh/0.0.44/file/jeanp413.open-remote-ssh-0.0.44.vsix" -o open-remote-ssh.vsix
cursor --install-extension open-remote-ssh.vsix
```

- **`powershell.exe` not found from root in WSL**: Use the full path `/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe`, or run Windows commands from a non-root WSL user where interop paths are set.

## Filesystem Performance Notes

| Location | I/O Type | Relative Speed |
|----------|----------|----------------|
| `~/repos` (ext4) | Native Linux | Fastest |
| `/mnt/c/...` (NTFS via 9P) | Cross-boundary | 3-10x slower |
| `\\wsl$\` (from Windows) | Cross-boundary | Similar to /mnt/c |

For backup of WSL repos to Windows (e.g., for iDrive), use rsync to a Windows-side folder rather than working directly on `/mnt/c/`:

```bash
rsync -av ~/repos/ /mnt/c/Backups/wsl-repos/
```

## VS Code vs Cursor: Remote Feature Comparison

| Feature | VS Code | Cursor |
|---------|---------|--------|
| Remote-SSH (Linux target) | Stable | Stable |
| Remote-SSH (Windows target) | Stable | Buggy |
| Remote Tunnels | Supported | Not available |
| SSH to WSL2 via port forward | Works | Works |

## Related

- [SSH Helper Functions](../topics/tooling/ssh-helper-functions.md)
- [Microsoft: Get started with OpenSSH Server](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse)
- [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview)
- [Cursor Remote SSH Forum Discussion](https://forum.cursor.com/t/does-cursor-support-remote-ssh/7620)

---

*Source: Documented from hands-on setup session (original date: 2026-02-28)*
