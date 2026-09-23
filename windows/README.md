# Windows Setup Notes

GUI settings for the Windows environment.

## Automated Settings (Script)

Run `./setup.ps1` to automatically apply:
- System and App theme: Dark mode
- Taskbar clock: Show seconds

## Base Setup

- Manually configure keyboard, mouse, and Wi-Fi connection.

## Language and Region (English UI + Japanese Input)

Set Windows UI and apps to English while keeping the Japanese IME as the default input method.

### 1. Language & Region

1. Open **Settings** > **Time & language** > **Language & region**.
2. Add `English (United States)` to **Preferred languages** and drag it to the top of the list.
3. Leave **Region** > **Country or region** as `Japan`.

### 2. Default Input Method Override

1. Open **Settings** > **Time & language** > **Typing** > **Advanced keyboard settings**.
2. Set **Override for default input method** to `Japanese - Microsoft IME`.

### 3. Date & Time Format

1. Open **Settings** > **Time & language** > **Date & time** > **Change date and time formats** (or navigate to **Region** settings in Control Panel).

| Field            | Value                      |
|------------------|----------------------------|
| Calendar         | Gregorian Calendar         |
| First day of week | Monday                    |
| Short date       | `yyyy-MM-dd`               |
| Long date        | `dddd, MMMM d, yyyy`       |
| Short time       | `H:mm`                     |
| Long time        | `H:mm:ss`                  |

(For assigning F13/F14 to IME-Off/IME-On, see the [IME](#ime) section below.)
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

Run **only on the laptop, and only while its built-in keyboard is in use**.
Unlike Karabiner, AHK cannot tell keyboards apart, so it remaps an external
keyboard too; stop it when one is attached. Not run on other machines. See the
layout diagrams in the top-level
[README](../README.md#eucalyn-layout-reference).

1. Install AutoHotkey v2: <https://www.autohotkey.com/>
2. Run `ahk/main.ahk` (it `#Include`s `eucalyn.ahk` and `special.ahk`).
3. To start at login: place a shortcut to `ahk/main.ahk` in
   `shell:startup` (`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`).

What the taps of `無変換` / `カタカナ/ひらがな` do is configured under
[IME](#ime) above.

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
