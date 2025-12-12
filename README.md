# ⚡ ephur's Zsh Configuration

A highly optimized, purpose-built Zsh configuration focused on **startup speed**, **modular organization**, and a clean, reproducible shell experience across multiple platforms (macOS, WSL, Linux distros).

---

## 🚀 Features

- 🧠 **Sub-150ms startup time** (measured consistently with benchmarking)
- 🔌 **Antidote plugin manager** (compiled + cached for maximum speed)
- 📦 **Modular `includes/` directory structure**
  - Early/late phase loading for ordered control
  - Hooks and custom completions
- 🐍 full, but optimized **pyenv + goenv** support (deferred loading for performance)
- 🧭 **zoxide**, **fzf**, for a great UX
- 🧼 Automatic `.zwc` compilation and caching of everything
- 🧪 Easy benchmarking with `benchzshy.sh` and `zsh_profile.py`
- 💻 Works across macOS, WSL, any Linux distro I've tried
- 🔒 Private `secrets.zsh` support
- 🛠 Easy setup with only `git` and `antitode` required
- ⚡️ Lightning fast PowerLevel 10k prompt with **no slowdowns** from plugins

---

## 🛠 Setup

```bash
cd ${HOME}
git clone https://github.com/ephur/zshrc.git .zsh
ln -s .zsh/zshrc .zshrc
```

---

## 🧩 Plugin Management

Powered by [Antidote](https://getantidote.github.io/):

- All plugins listed in `antidote_plugins_darwin.txt` or `antidote_plugins_linux.txt`
- Precompiled via `update_zsh_plugins` function
- No runtime `antidote load`, just direct cache sourcing

---

## 🧪 Benchmarking

Run this to benchmark shell startup:

```bash
time zsh -i --login -c echo
```

You should see results well below **150ms** real time.

---

## 🔐 Secrets

To include private content (tokens, keys, aliases):

Create a file at:

```bash
~/.zsh/secrets.zsh
```

This is sourced if present, but **not included** in the repo.

## 🫣 Not secrets, but not commitable

To include extra functions you can't commit, or are bespoke to your environment, create a file at:

```bash
~/.zsh/work.zsh
```

This is sourced after `secrets.zsh` and can contain any customizations you need.
This file is also **not included** in the repo.

---

## 📂 Structure

- `includes/init.zsh` — core functions and setup
- `includes/early_*.zsh` — sourced before completions
- `includes/late_*.zsh` — sourced after completion setup
- `cache/` — holds precompiled and generated artifacts

## 📖 Quick Reference

For a complete list of available functions, aliases, and commands, see the **[CHEATSHEET.md](CHEATSHEET.md)** or run:

```bash
zhelp           # Display full cheatsheet
zhelp git       # Show git functions only
zhelp aws       # Show AWS functions only
```

---

## 🧠 Philosophy

> Fast. Modular. Predictable. Built for terminal-first productivity.
