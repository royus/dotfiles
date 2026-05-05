# Windows Setup Notes

GUI settings for the Windows environment.

## Excel

- `File` → `Options` → `Quick Access Toolbar` → `Home Tab` → `Select Objects`

## PowerPoint

- `File` → `Options` → `Advanced`
  - Uncheck **"When selecting, automatically select entire word"**
- `File` → `Options` → `Quick Access Toolbar` → `Drawing Tools` → `Align Center` / `Middle`

## IME

- `General` → `Predictive Input` → **Off**
- `General` → `Compatibility` → **On**
- `Advanced` → `General`
  - `Space` → **Always Half Width**
  - `Key Template` → `Advanced`
    - `BackSpace`: `Converted-RevAll`
    - `F13`: `NoInput-IMEOff` / `Others-HalfAlphanumeric`
    - `F14`: `NoInput-IMEOn`  / `Others-Katakana`

## Eucalyn layout (AutoHotkey v2)

Used on the laptop where the keyboard cannot be replaced. See the layout
diagrams in the top-level [README](../README.md#eucalyn-layout-reference).

1. Install AutoHotkey v2: <https://www.autohotkey.com/>
2. Run `windows/main.ahk` (it `#Include`s `eucalyn.ahk` and `special.ahk`).
3. To start at login: place a shortcut to `main.ahk` in
   `shell:startup` (`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`).

The arrow-layer trigger keys on Windows are `無変換` → F13 and `カタカナ/ひらがな`
→ F14 (the IME-toggle behavior is configured separately under [IME](#ime)
above).
