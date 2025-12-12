# Zsh Configuration Cheatsheet

Quick reference for all custom functions, aliases, and commands available in this zsh configuration.

---

## 📋 Table of Contents

- [Git Commands](#git-commands)
- [AWS Commands](#aws-commands)
- [Kubernetes Commands](#kubernetes-commands)
- [Docker Commands](#docker-commands)
- [1Password Commands](#1password-commands)
- [Network Commands](#network-commands)
- [System Commands](#system-commands)
- [File & Archive Commands](#file--archive-commands)
- [Data Format & Conversion](#data-format--conversion)
- [Shell & Environment](#shell--environment)
- [Modern Tool Replacements](#modern-tool-replacements)
- [Key Bindings](#key-bindings)
- [Environment Variables](#environment-variables)

---

## Git Commands

### `retag`
Re-tag and force push a git tag.

```bash
retag <tag-name>

# Example
retag v1.0.0
```

### `gb`
Interactive branch switcher using fzf.

```bash
gb    # Select branch interactively
```

### `gca`
Quick commit amend without editing message.

```bash
gca    # Amend last commit
```

### `glo`
Show git log with fzf preview.

```bash
glo    # Interactive log viewer
```

### `gnb`
Create branch and push with tracking.

```bash
gnb <branch-name>

# Example
gnb feature/new-api
```

### `gpthis`
Push current branch to origin.

```bash
gpthis
```

### `gpthisdown`
Push current branch to downstream.

```bash
gpthisdown
```

### `gpfthis`
Force push current branch to origin.

```bash
gpfthis
```

---

## AWS Commands

### `awsregion`
Get or set AWS_DEFAULT_REGION.

```bash
awsregion              # Show current region
awsregion us-west-2    # Set region
```

### `unset_aws`
Clear all AWS_* environment variables.

```bash
unset_aws
```

### `awsp`
List and switch AWS profiles (interactive with fzf if available).

```bash
awsp              # Interactive selection (if fzf available)
awsp production   # Switch to specific profile
```

### `whoami-aws`
Show current AWS identity.

```bash
whoami-aws
```

---

## Kubernetes Commands

### `kubeme`
Start minikube with appropriate configuration for the platform.

```bash
kubeme                # Uses default k8s version (v1.19.6)
kubeme v1.21.0        # Use specific version
```

### `docker_kube`
Configure docker to use minikube's docker daemon.

```bash
docker_kube
```

### `kctx` / `kubectx`
Quick context switch with optional filtering.

```bash
kctx                  # Interactive selection
kctx prod             # Switch to 'prod' or filter by 'prod'
kubectx prod          # Alias works the same
```

### `kns` / `kubens`
Quick namespace switch with optional filtering.

```bash
kns                   # Interactive selection
kns default           # Switch to 'default' or filter by 'default'
kubens kube-system    # Alias works the same
```

### `klogs`
Get pod logs with fzf selector.

```bash
klogs    # Select pod interactively
```

### `kexec`
Exec into pod with fzf selector.

```bash
kexec              # Uses /bin/sh
kexec /bin/bash    # Use specific shell
```

### `kpf`
Port forward with fzf selector.

```bash
kpf           # Defaults to 8080:8080
kpf 3000      # Forward 3000:3000
kpf 8080:80   # Forward local 8080 to pod 80
```

---

## Docker Commands

### `dclean`
Clean up dangling images, stopped containers, and unused volumes.

```bash
dclean
```

### `dexec`
Interactive container exec using fzf.

```bash
dexec              # Uses /bin/sh
dexec /bin/bash    # Use specific shell
```

### `dlogs`
Interactive container logs using fzf.

```bash
dlogs    # Select container interactively
```

### `dstop`
Stop all running containers.

```bash
dstop
```

---

## 1Password Commands

### `ops`
Sign in to 1Password account.

```bash
ops <account>

# Example
ops my-account
```

### `opg`
Get password from 1Password and copy to clipboard.

```bash
opg <account> <item-name>

# Example
opg my-account "GitHub"
opg my-account "AWS Console"
```

---

## Network Commands

### `dq`
Query DNS across multiple resolvers (Google, Cloudflare, OpenDNS).

```bash
dq <domain> [record-type]

# Examples
dq google.com           # ANY record
dq google.com A         # A record
dq example.com MX       # MX records
dq example.com TXT      # TXT records
```

### `port`
Check what process is using a port.

```bash
port <port-number>

# Example
port 8080
```

### `myip`
Get public IP address (supports IPv4/IPv6).

```bash
myip      # Default
myip 4    # IPv4 only
myip 6    # IPv6 only
```

### `httptest`
Quick HTTP test with timing information.

```bash
httptest <url>

# Example
httptest https://google.com
```

---

## System Commands

### `nosleep` (macOS only)
Prevent system and display sleep with fullscreen cmatrix.

```bash
nosleep <duration-in-minutes>

# Example
nosleep 30     # Keep awake for 30 minutes
```

### `nolock` (macOS only)
Prevent lock screen with fullscreen cmatrix (allows display sleep).

```bash
nolock <duration-in-minutes>

# Example
nolock 120     # Prevent lock for 2 hours
```

### `nfs_mount`
Mount NFS shares from /etc/nfstab.

```bash
nfs_mount
```

---

## File & Archive Commands

### `ff`
Find files with a pattern in name (case-insensitive).

```bash
ff <pattern>

# Examples
ff "*.txt"
ff config
ff package.json
```

### `fe`
Find files with pattern and execute command on them.

```bash
fe <pattern> [command]

# Examples
fe "*.log" cat          # Cat all log files
fe config file          # Run 'file' on all config files
fe "*.py"               # Run 'file' on all Python files (default)
```

### `extract`
Universal archive extraction.

```bash
extract <archive-file>

# Examples
extract archive.tar.gz
extract file.zip
extract data.7z
```

### `uuid`
Generate UUID (lowercase).

```bash
uuid
```

### `b64e` / `b64d`
Base64 encode/decode.

```bash
b64e "hello world"           # Encode
b64d "aGVsbG8gd29ybGQ="      # Decode
```

### `ts`
Timestamp conversion.

```bash
ts                # Get current timestamp
ts 1638360000     # Convert timestamp to date
```

### `up`
Go up N directories.

```bash
up       # Go up 1 directory
up 3     # Go up 3 directories
```

### `large`
Find largest files/dirs in current directory.

```bash
large       # Show top 20
large 10    # Show top 10
```

### `pkill-fzf`
Kill process by name with fzf selector.

```bash
pkill-fzf    # Select process interactively
```

### `portproc`
Find process using a specific port.

```bash
portproc <port>

# Example
portproc 8080
```

---

## Shell & Environment

### `resrc`
Rebuild zsh cache and restart shell.

```bash
resrc              # Rebuild includes cache only
resrc plugins      # Rebuild all caches including plugins
```

### `t`
Tmux session manager - attach to or create "default" session with predefined windows.

```bash
t                  # Attach to or create default session
```

Creates windows: TerraformDeploy, LegacyDeploy, TFModules, General

### `update_zsh_plugins`
Manually update and recompile all zsh plugins.

```bash
update_zsh_plugins
```

### `zhelp`
Display this cheatsheet.

```bash
zhelp [category]

# Examples
zhelp              # Show full cheatsheet
zhelp git          # Show git functions only
zhelp aws          # Show AWS functions only
```

### `t`
Tmux session manager - attach to or create "default" session.

```bash
t    # Attach to or create default session
```

Creates windows: TerraformDeploy, LegacyDeploy, TFModules, General

### `tmux` / `tnew` / `tlist` / `tk`
Tmux helpers.

```bash
tmux       # Start tmux with 256 color support
tnew       # Create new default session
tlist      # List all sessions
tk         # Kill default session
```

### `path` / `libpath`
Display paths with one entry per line.

```bash
path       # Display PATH
libpath    # Display LD_LIBRARY_PATH
```

### `wttr`
Get weather from wttr.in.

```bash
wttr [location]

# Examples
wttr                    # Default location (San Antonio, TX)
wttr "New York"
wttr Tokyo
wttr "San Francisco"
```

### Safe Defaults

Common commands with safer defaults:

```bash
rm        # Aliased to 'rm -i' (interactive)
mv        # Aliased to 'mv -i' (interactive)
cp        # Aliased to 'cp -i' (interactive)
mkdir     # Aliased to 'mkdir -p' (create parents)
```

### Package Management (dnf systems)

```bash
di <package>    # Install package (sudo dnf install)
dr <package>    # Remove package (sudo dnf remove)
ds <query>      # Search packages (dnf search)
```

### Platform-Specific

**Linux (non-WSL) only:**
```bash
pbcopy              # Copy to clipboard (via xsel)
pbpaste             # Paste from clipboard (via xsel)
rootme              # Sudo to root with zsh and zoxide support
```

---

## Modern Tool Replacements

When these modern tools are installed, the following commands automatically use them:

| Command | Uses | Description |
|---------|------|-------------|
| `ls` | `lsd` or `exa` | Modern ls with colors and icons |
| `ll` | `lsd -Al` or `exa -al --git` | Long listing with git status |
| `cat` | `bat` | Syntax-highlighted file viewer |
| `vi` | `nvim` | Modern Vim |
| `kubectl` | `kubecolor` | Colored kubectl output |
| `du` | `dust -bd 1` | Visual disk usage |
| `grep` | `grep --color=auto` | Colored output |

If the modern tool isn't installed, commands fall back to standard versions.

---

## Data Format & Conversion

### `jpretty`
Pretty print JSON from clipboard or file.

```bash
jpretty data.json    # From file
jpretty              # From clipboard (macOS)
```

### `y2j`
Convert YAML to JSON.

```bash
y2j config.yaml
```

### `j2y`
Convert JSON to YAML.

```bash
j2y data.json
```

### `jqp`
Interactive JQ playground.

```bash
jqp data.json    # Test jq queries interactively
```

---

## Key Bindings

- **VI Mode**: Enabled by default (`bindkey -v`)
- **Edit Command Line**: Press `!` in VI command mode to edit current command in $EDITOR

---

## Environment Variables

### Commonly Used

```bash
$EDITOR             # nvim or vi
$PAGER              # less
$HISTFILE           # ~/.zsh_history
$HISTSIZE           # 100000
$ZSH                # ~/.zsh (config directory)
$ZSH_CACHE_DIR      # ~/.zsh/cache

# Platform Detection
$IS_MACOS           # 1 if macOS, 0 otherwise
$IS_WSL             # 1 if WSL, 0 otherwise
```

### Tool-Specific

```bash
$PYENV_ROOT         # ~/.pyenv
$GOENV_ROOT         # ~/.goenv
$PROJECTS           # ~/Projects (if exists)
$BAT_THEME          # Dracula
$FZF_DEFAULT_OPTS   # Dracula color scheme
```

---

## Performance Tips

1. **Benchmark startup time:**
   ```bash
   time zsh -i --login -c echo
   ```

2. **Full profiling:**
   ```bash
   PROFILE_STARTUP=true zsh -i --login -c echo
   # Output: /tmp/zsh_profile.$$
   ```

3. **Profile everything:**
   ```bash
   PROFILE_ALL=true zsh -i --login -c echo
   ```

4. **Update plugins manually:**
   ```bash
   update_zsh_plugins
   ```

5. **Force full cache rebuild:**
   ```bash
   resrc plugins
   ```

---

## Platform Differences

### macOS
- Uses `gdircolors` from Homebrew
- Homebrew paths: `/opt/homebrew/bin`
- Native `pbcopy`/`pbpaste`
- `caffeinate` available for power management
- `nosleep` and `nolock` functions available

### Linux (non-WSL)
- Uses `dircolors`
- `pbcopy`/`pbpaste` via `xsel`
- No power management functions

### WSL
- Includes Windows paths in PATH
- No `pbcopy`/`pbpaste` aliases
- Native Windows clipboard integration

---

## Configuration Files

### Repository Files
- `~/.zsh/zshrc` - Main entry point
- `~/.zsh/includes/*.zsh` - Modular configuration files
- `~/.zsh/antidote_plugins_{darwin,linux}.txt` - Plugin specifications
- `~/.zsh/CLAUDE.md` - AI assistant documentation
- `~/.zsh/CHEATSHEET.md` - This file

### User Files (Not in Repository)
- `~/.zsh/secrets.zsh` - Private tokens, keys (optional)
- `~/.zsh/work.zsh` - Work-specific customizations (optional)
- `~/.zsh/cache/` - All compiled and generated files

---

## Getting Help

- **This cheatsheet:** `zhelp` or `bat ~/.zsh/CHEATSHEET.md`
- **Function usage:** Most functions show help when called without arguments
- **README:** `bat ~/.zsh/README.md`
- **Claude documentation:** `bat ~/.zsh/CLAUDE.md`

---

*Last updated: 2025-12-11*
