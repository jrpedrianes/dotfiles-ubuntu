# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Chezmoi-based Ubuntu dotfiles managing both user (`$HOME`) and root (`/`) system configuration. Based on [@felipecrs/dotfiles](https://github.com/felipecrs/dotfiles/tree/master).

## Architecture

**Two-tier provisioning:** chezmoi manages `home/` (user dotfiles applied to `$HOME`), which triggers `rootmoi` to apply `root/` (system config applied to `/` with sudo).

```
home/                              # User config (chezmoi source, set by .chezmoiroot)
├── .chezmoi.yaml.tmpl            # Interactive config (name, email, GNOME detection)
├── .chezmoiexternal.yaml         # GitHub archives: oh-my-zsh, starship, lazydocker, etc.
├── .chezmoitemplates/            # Shared utilities (scripts-library, GitHub version helpers)
├── .chezmoiscripts/              # User provisioning scripts
├── dot_local/bin/                # rootmoi wrapper, full-upgrade script
└── dot_config/, dot_shell/, ...  # Dotfiles

root/                              # System config (applied via rootmoi as sudo)
├── .chezmoiexternal.yaml         # GPG keys for APT repos + docker-credential-secretservice
├── .chezmoitemplates -> ../home/.chezmoitemplates  # Symlink to shared templates
├── .chezmoiscripts/              # System provisioning scripts
└── etc/apt/sources.list.d/       # Third-party APT sources (templated)
```

**Execution flow:** `install.sh` → chezmoi init (home/) → user scripts run → `run_after_20` invokes rootmoi → root scripts run.

## Key Patterns

### Adding a new APT package
Add the package name to `root/.chezmoiscripts/run_after_10-install-apt-packages.sh.tmpl` in the `wanted_packages` array.

### Adding a new third-party APT repository
Three files needed:
1. **GPG key** in `root/.chezmoiexternal.yaml` — download key, pipe through `gpg --dearmor`
2. **Source file** in `root/etc/apt/sources.list.d/` — use `.sources.tmpl` (DEB822 format) for new repos
3. **Package** in `root/.chezmoiscripts/run_after_10-install-apt-packages.sh.tmpl`

Template variables for sources: `{{ .chezmoi.arch }}`, `{{ .chezmoi.osRelease.versionCodename }}`, `{{ .chezmoi.osRelease.id }}`.

### Adding a new GitHub binary tool
Add entry to `home/.chezmoiexternal.yaml` using `includeTemplate "get-github-latest-version"` for version resolution. Uses `{{ .chezmoi.arch }}` or `{{ .uname_arch }}` for platform-specific downloads.

### Removing an APT package
Add to `root/.chezmoiscripts/run_before_30-uninstall-apt-packages.sh.tmpl` in `unwanted_packages` array (runs before install).

### Scripts-library (`home/.chezmoitemplates/scripts-library`)
Shared by all scripts via `{{ template "scripts-library" }}`. Provides:
- `c()` / `c_exec()` — log-and-execute wrappers
- `sudo()` — smart elevation (detects root, prompts if needed)
- `is_apt_package_installed()` — idempotency check
- `log_task()`, `log_error()`, `log_info()` — colored logging
- `not_during_test()` — skip in test mode (`DOTFILES_TEST=true`)

### Script naming convention
`run_{before|after|onchange}_{NN}-{description}.sh.tmpl` — NN controls execution order. `onchange` scripts use `sha256sum` of watched content to trigger only when content changes.

## Commands

```bash
# Bootstrap from scratch
./install.sh

# Apply changes after editing
chezmoi apply

# Apply with fresh external resources (bypass 10-min cache)
chezmoi apply -R

# Debug mode
DOTFILES_DEBUG=true chezmoi apply

# Test mode (skips certain operations)
DOTFILES_TEST=true chezmoi apply
```

## Commit Convention

Use [conventional commits](https://www.conventionalcommits.org/). Never add Co-Authored-By or AI attribution.
