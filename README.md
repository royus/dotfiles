# dotfiles

Personal dotfiles. Supports WSL / Linux / macOS.

## Install

```sh
git clone https://github.com/royus/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh --dry-run   # preview what will be linked
./install.sh             # apply
```

`install.sh` auto-detects the OS / WSL and symlinks the appropriate files
into `$HOME`. Existing files are moved aside to `*.bak.YYYYMMDDHHMMSS`
(idempotent — safe to re-run).

## Directory layout

```
dotfiles/
├── install.sh       installer script
├── .vimrc           Vim config (all platforms)
├── linux/           Linux / WSL configs (.bashrc, .vifm/, .xmonad/, ...)
├── mac/             macOS configs (Karabiner, BetterTouchTool)
├── apps/            cross-platform app configs (Vimium, ...)
├── docs/            setup notes
└── template/        code templates
```

## Linked files per OS

| File | linux | wsl | mac |
|---|:-:|:-:|:-:|
| `.vimrc` | ✓ | ✓ | ✓ |
| `linux/.bashrc` | ✓ | ✓ | – |
| `linux/.bash_profile` | ✓ | ✓ | – |
| `linux/.inputrc` | ✓ | ✓ | – |
| `linux/.config.fish` | ✓ | ✓ | – |
| `linux/.latexmkrc` | ✓ | ✓ | – |
| `linux/.vifm/vifmrc` | ✓ | ✓ | – |
| `linux/.Xresources` | ✓ | – | – |
| `linux/.xinitrc` | ✓ | – | – |
| `linux/.xmonad/*.hs` | ✓ | – | – |

## macOS manual setup

`install.sh` does not link macOS GUI app configs. Import them manually:

### Karabiner-Elements

Two variants are provided for different keyboards:

- `mac/.karabiner_hhkb.json` — for HHKB (sends 英数/かな when option is tapped alone)
- `mac/.karabiner_macbook.json` — for the MacBook built-in keyboard (`\` → Return and other remaps)

Either import via the Karabiner-Elements UI, or copy to `~/.config/karabiner/karabiner.json`.

### BetterTouchTool

Import `mac/.btt.json` from BetterTouchTool → Preferences → Manage Presets.

## Notes

- `docs/windows-notes.md` — Windows GUI settings (Excel / PowerPoint / IME)
- `docs/mac-notes.md` — macOS notes
- `docs/linux-notes/` — Linux environment notes
