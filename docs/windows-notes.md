# Windows Setup Notes

GUI settings for the Windows environment.

## Excel

- `File` → `Options` → `Quick Access Toolbar` → `Home Tab` → `Select Objects`

## PowerPoint

- `File` → `Options` → `Advanced`
  - Uncheck **"When selecting, automatically select entire word"**
- `File` → `Options` → `Quick Access Toolbar` → `Drawing Tools` → `Align Center` / `Middle`

## IME

### Requirements

What must hold. Independent of which IME version provides it.

| #  | Behavior |
| -- | -- |
| R1 | `無変換` — hold = arrow layer, tap = IME **off** |
| R2 | `カタカナ/ひらがな` — hold = arrow layer, tap = IME **on** |
| R3 | While composing: convert to half-width alphanumeric / to katakana |
| R4 | `BackSpace` reverts a converted string all the way back to its reading |
| R5 | Space is always half width |

### Current means: legacy IME

The arrow layer is built from AHK custom combinations (`sc07b & h`, see
`../windows/special.ahk`). AHK suppresses a prefix key's native function, and
keeping it with `~` would fire the IME toggle every time the arrow layer is
used. So the tap has to emit some *other* key — hence F13 / F14 — and the IME
has to be told what F13 / F14 mean. Only the legacy IME can bind arbitrary keys.

- `General` → `Compatibility` → **On** — a means, not a requirement
- `Advanced` → `General`
  - `Space` → **Always Half Width** (R5)
  - `Key Template` → `Advanced`
    - `BackSpace`: `Converted-RevAll` (R4)
    - `F13`: `NoInput-IMEOff` / `Others-HalfAlphanumeric` (R1, R3)
    - `F14`: `NoInput-IMEOn` / `Others-Katakana` (R2, R3)

Cost of this means: the legacy IME has no dark candidate window. The
`Appearance` → `Theme` setting exists only on the new IME.

### Alternative means: new IME — evaluated and rejected (2026-08-10)

Rejected because the new IME binds one function per key, with no notion of
input state. R3 and R4 cannot be expressed at all, and R3 is used constantly.
Trading it for a dark candidate window is not worth it. Recorded here so the
evaluation is not repeated. Details below.

Google Japanese Input was also evaluated and rejected. Its key bindings *are*
state-aware (直接入力 / 入力文字なし / 変換前入力中 / 変換中) and would cover
R1–R4, but its Windows candidate window is drawn with fixed light colors and
does not follow the system dark theme, so it does not solve the one problem the
move was for. Reopen only if Mozc's Windows renderer gains theming.

**Conclusion: there is currently no way to satisfy R1–R4 and have a dark
candidate window. Staying on the legacy IME.**

#### Rejected wiring for the new IME (reference only)

Kept so the design does not have to be rediscovered. This is **not** what
`special.ahk` does today; the current wiring is F13 / F14 as described above.

The new IME can only bind 無変換 / 変換 / Ctrl+Space / Shift+Space. Rather than
teaching the IME about F13 / F14, let AHK emit the keycodes the new IME already
understands:

- `special.ahk`: `sc07b::vk1Csc079` (emits 変換), `sc070::vk1Dsc07B` (emits
  無変換) — crossed over to avoid a self-remap, vk+sc so the signal is identical
  to the real key
- IME → `Key and touch customization`: `変換` = **IME-off**, `無変換` = **IME-on**

R1, R2, R5 are fully covered. R3 falls back to F7 / F10 and R4 to Esc, both of
which can live on the arrow layer.

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
