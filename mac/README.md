# macOS Setup Notes

## System

- Update macOS
- Turn off screen when lid is closed

## Install

- `git`, `brew`
- `karabiner` (Karabiner-Elements)
- `vim`, `fish`
- `mactex`, `lua`, `aspell`, `ctags`

## System Preferences

### Keyboard / Input

- Use Windows-like shortcuts
- Disable live conversion
- Auto-switch input source per document
- Change to half-width space

### Accessibility

- Trackpad → enable drag without lock

## App configs (manual import)

`install.sh` does not link macOS GUI app configs. Import them manually.

### Karabiner-Elements

`mac/.karabiner_macbook.json` — full profile for the MacBook built-in keyboard
(`\` → Return and other remaps). Either import via the Karabiner-Elements UI,
or copy to `~/.config/karabiner/karabiner.json`.

### BetterTouchTool

Import `mac/.btt.json` from BetterTouchTool → Preferences → Manage Presets.

### Eucalyn layout (built-in keyboard only)

See the layout diagrams in the top-level
[README](../README.md#eucalyn-layout-reference).

Copy `mac/.karabiner_eucalyn_macbook.json` to
`~/.config/karabiner/assets/complex_modifications/`, then enable each rule via
Karabiner-Elements → Preferences → Complex modifications → Add rule.

The rules apply only to the MacBook built-in keyboard (external keyboards keep
their hardware layout).

- `japanese_eisuu` / `japanese_kana`:
  - tap → IME toggle (英数 / かな)
  - hold → arrow layer
