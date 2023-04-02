#Requires AutoHotKey v2
;;;;;; While holding a modifier key:
;;;;;; hold a key to store (copy)
;;;;;; press a key to paste as text what you stored with that same key
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; github.com/DDanDev;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;


;Custom settings:
;Time in ms to hold keys to save selection to that key
waitT := 200

;Keynames you want to use as "clippers". Check ahk docs for names of keys!
keyNames := ["Numpad1", "Numpad2", "Numpad3", "Numpad4", "Numpad5", "Numpad6", "Numpad7", "Numpad8", "Numpad9"]
;What modifier to hold while clicking or holding your clipper keys.
modifier := "Control"


;;;;;;;;;;;;;;;;;;;
downUpCounters := Map()
stores := Map()
for (keyName in keyNames) {
    Hotkey("*" . keyName, handleHK)
    downUpCounters["*" . keyName] := [0, 0]
    stores["*" . keyName] := ""
}
alreadyset := false

handleHK(keyName) {
    global
    if GetKeyState(modifier) {
        Critical
        if (!alreadyset) {
            alreadyset := true
            SetTimer(() => clipper(keyName), -waitT)
        }
        downUpCounters[keyName][1] += 1
        if (KeyWait(SubStr(keyName, 2), "T" . String(waitT / 1000))) {
            downUpCounters[keyName][2] += 1
        }
        Critical("Off")
        KeyWait(SubStr(keyName, 2))
    } else {
        SendInput("{Blind}{" SubStr(keyName, 2) "}")
    }
}

clipper(keyName) {
    global
    Critical
    local previousclip := A_Clipboard
    A_Clipboard := ""
    Sleep(1)
    if (downUpCounters[keyName][2] > 0) {
        A_Clipboard := stores[keyName]
        ClipWait(1)
        Loop downUpCounters[keyName][1] {
            if GetKeyState("Control") {
                Send("{Blind}{v}")
            } else {
                Send("^v")
            }
        }
    } else if (downUpCounters[keyName][2] = 0) {
        if GetKeyState("Control") {
            Send("{Blind}{c}")
        } else {
            Send("^c")
        }
        ClipWait(1)
        stores[keyName] := A_Clipboard
    }
    downUpCounters[keyName][1] := "0"
    downUpCounters[keyName][2] := "0"
    alreadyset := false
    Sleep(waitT / 2)
    A_Clipboard := previousclip
}