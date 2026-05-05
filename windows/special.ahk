#Requires AutoHotkey v2.0

;;Specials
sc079::Enter
[::Backspace
sc073::RShift
sc07d::\
]::[
\::]

;;Layers
FnKeys := ["sc07b", "sc070"]

sc07b::F13
sc070::F14

; 複合キーのホットキー登録
for key in FnKeys {
    Hotkey(key " & h", (*) => Send("{Left}"))
    Hotkey(key " & j", (*) => Send("{Down}"))
    Hotkey(key " & k", (*) => Send("{Up}"))
    Hotkey(key " & l", (*) => Send("{Right}"))
    Hotkey(key " & s", (*) => Send("{Home}"))
    Hotkey(key " & f", (*) => Send("{End}"))
    Hotkey(key " & e", (*) => Send("{PgUp}"))
    Hotkey(key " & d", (*) => Send("{PgDn}"))
    Hotkey(key " & m", (*) => Send("{AppsKey}"))
    Hotkey(key " & Backspace", (*) => Send("{Delete}"))
}
