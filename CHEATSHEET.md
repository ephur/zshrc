# Zsh Configuration Cheatsheet

Quick reference for all custom functions, aliases, and commands available in this zsh configuration.

---

## 📋 Table of Contents

- [Git Functions](#git-functions)
- [AWS Functions](#aws-functions)
- [Kubernetes Functions](#kubernetes-functions)
- [1Password Functions](#1password-functions)
- [Network Functions](#network-functions)
- [System Functions](#system-functions)
- [Utility Functions](#utility-functions)
- [Shell Functions](#shell-functions)
- [Aliases](#aliases)
  - [Modern Tool Replacements](#modern-tool-replacements)
  - [Git Shortcuts](#git-shortcuts)
  - [Safe Defaults](#safe-defaults)
  - [Tmux](#tmux)
  - [Package Management](#package-management)
  - [Miscellaneous](#miscellaneous)
- [Key Bindings](#key-bindings)
- [Environment Variables](#environment-variables)

---

## Git Functions

### `retag`
Re-tag and force push a git tag.

```bash
retag <tag-name>

# Example
retag v1.0.0
```

---

## AWS Functions

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

---

## Kubernetes Functions

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

---

## 1Password Functions

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

## Network Functions

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

---

## System Functions

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

## Utility Functions

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

### `codec`
Get video codec information using ffmpeg.

```bash
codec <video-file>

# Example
codec movie.mp4
codec video.mkv
```

---

## Shell Functions

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

---

## Aliases

### Modern Tool Replacements

Smart aliases that use modern alternatives when available:

| Alias | Command | Tool |
|-------|---------|------|
| `ls` | `lsd` or `exa` | Modern ls replacement |
| `ll` | `lsd -Al` or `exa -al --git` | Long listing |
| `cat` | `bat` | Syntax-highlighted cat |
| `vi` | `nvim` | Neovim |
| `kubectl` | `kubecolor` | Colored kubectl output |
| `du` | `dust -bd 1` | Modern du |

### Git Shortcuts

```bash
gpthis              # Push current branch to origin
gpthisdown          # Push current branch to downstream
gpfthis             # Force push current branch to origin
```

### Safe Defaults

```bash
rm                  # Aliased to 'rm -i' (interactive)
mv                  # Aliased to 'mv -i' (interactive)
cp                  # Aliased to 'cp -i' (interactive)
mkdir               # Aliased to 'mkdir -p' (create parents)
```

### Tmux

```bash
tmux                # Start tmux with 256 color support
tnew                # Create new default session
tlist               # List all sessions
tk                  # Kill default session
```

### Package Management (dnf systems)

```bash
di <package>        # Install package (sudo dnf install)
dr <package>        # Remove package (sudo dnf remove)
ds <query>          # Search packages (dnf search)
```

### Miscellaneous

```bash
path                # Display PATH with one entry per line
libpath             # Display LD_LIBRARY_PATH with one entry per line
dirs                # Show directory stack with numbers
rmpyc               # Remove all .pyc files recursively
ipsort              # Sort IP addresses correctly
grep                # Colored output by default
ssh                 # Force xterm-256color TERM
rootme              # Sudo to root with zsh and zoxide support
```

**Linux (non-WSL) only:**
```bash
pbcopy              # Copy to clipboard (via xsel)
pbpaste             # Paste from clipboard (via xsel)
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
