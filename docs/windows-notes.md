# Windows Setup Notes

GUI settings for the Windows environment.

## Excel

- `File` → `Options` → `Quick Access Toolbar` → `Home Tab` → `Select Objects`

## PowerPoint

- `File` → `Options` → `Advanced`
  - Uncheck **"When selecting, automatically select entire word"**
- `File` → `Options` → `Quick Access Toolbar` → `Drawing Tools` → `Align Center` / `Middle`

## IME

Legacy IME, because on the laptop's built-in keyboard the taps of `無変換` /
`カタカナ/ひらがな` are emitted by `special.ahk` as F13 / F14 (hold = arrow
layer; AHK suppresses the key's own function), and only the legacy IME can
bind arbitrary keys.

- `General` → `Compatibility` → **On**
- `Advanced` → `General`
  - `Space` → **Always Half Width**
  - `Key Template` → `Advanced`
    - `BackSpace`: `Converted-RevAll`
    - `F13`: `NoInput-IMEOff` / `Others-HalfAlphanumeric`
    - `F14`: `NoInput-IMEOn` / `Others-Katakana`

Cost: no dark candidate window (the `Appearance` → `Theme` setting exists only
on the new IME).

Alternatives evaluated and rejected (2026-08-10):

- New IME: one function per key, no notion of input state. Cannot express
  "convert while composing" or "BackSpace reverts to the reading".
- Google Japanese Input: bindings are state-aware, but its candidate window
  ignores the system dark theme — the one thing the move was for.

If the new IME is ever needed: have `special.ahk` emit `変換` / `無変換`
instead of F13 / F14 (`sc07b::vk1Csc079`, `sc070::vk1Dsc07B`), bind them to
IME-off / IME-on under `Key and touch customization`, and put F7 / F10 / Esc
on the arrow layer in place of the composing-state bindings.

## Eucalyn layout (AutoHotkey v2)

AHK is used **only on the laptop, and only for its built-in keyboard**;
external keyboards keep their hardware layout and AHK is not run on other
machines. See the layout diagrams in the top-level
[README](../README.md#eucalyn-layout-reference).

1. Install AutoHotkey v2: <https://www.autohotkey.com/>
2. Run `windows/main.ahk` (it `#Include`s `eucalyn.ahk` and `special.ahk`).
3. To start at login: place a shortcut to `main.ahk` in
   `shell:startup` (`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`).

The arrow-layer trigger keys on Windows are `無変換` → F13 and `カタカナ/ひらがな`
→ F14 (the IME-toggle behavior is configured separately under [IME](#ime)
above).

## Caps Lock

Turn Caps Lock **off** with `Shift` rather than the `Caps Lock` key, so a stuck
Caps Lock can be cleared without a key the keyboard may not expose.

- `Settings` → `Time & language` → `Typing` → `Advanced keyboard settings` →
  `Input language hot keys` → `Advanced Key Settings` →
  `To turn off Caps Lock` → **Press the SHIFT key**

Windows 11 moved this entry under `Typing`; it is no longer on the
`Language & region` page. Direct open:
`rundll32.exe Shell32.dll,Control_RunDLL input.dll,,{C07337D3-DB2C-4D0B-9A93-B722A6C106E2}`

Only the *off* direction moves to `Shift`; `Caps Lock` still turns it on. Chosen
over remapping the key away entirely (PowerToys / Scancode Map) because it needs
no resident software and no reboot.
