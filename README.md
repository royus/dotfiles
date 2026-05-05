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
├── linux/           Linux / WSL configs (.bashrc, .bash_profile, .inputrc)
├── mac/             macOS configs (Karabiner, BetterTouchTool)
├── windows/         Windows AutoHotkey scripts (eucalyn layout)
├── apps/            cross-platform app configs (Vimium, ...)
└── docs/            setup notes
```

## Linked files per OS

| File | linux | wsl | mac |
|---|:-:|:-:|:-:|
| `.vimrc` | ✓ | ✓ | ✓ |
| `linux/.bashrc` | ✓ | ✓ | – |
| `linux/.bash_profile` | ✓ | ✓ | – |
| `linux/.inputrc` | ✓ | ✓ | – |

## Eucalyn layout reference

### Base layer (typed character per QWERTY-labeled key)

```
┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
│ Q │ W │ , │ . │ ; │ M │ R │ D │ Y │ P │
├───┼───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ A │ O │ E │ I │ U │ G │ T │ K │ S │ N │
├───┼───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ Z │ X │ C │ V │ F │ B │ H │ J │ L │ / │
└───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘
```

Unchanged from QWERTY: `Q W P A K Z X C V /`.

### Arrow layer (hold 英数 or かな on macOS, 無変換 or カタひら on Windows)

Layer trigger is on physical key positions (independent of the base remap).

```
┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
│   │   │PgU│   │   │   │   │   │   │   │
├───┼───┼───┼───┼───┼───┼───┼───┼───┼───┤
│   │Hom│PgD│End│   │ ← │ ↓ │ ↑ │ → │   │
├───┼───┼───┼───┼───┼───┼───┼───┼───┼───┤
│   │   │   │   │   │   │   │   │   │   │
└───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘
```

`Backspace` while layer held → forward `Delete`.

Tap (no other key) → sends `英数` / `かな` (IME toggle).

## Per-OS setup notes

- `docs/windows-notes.md` — Windows GUI settings (Excel / PowerPoint / IME) and AutoHotkey setup
- `docs/mac-notes.md` — macOS system settings, app config import (Karabiner / BetterTouchTool / Eucalyn)
