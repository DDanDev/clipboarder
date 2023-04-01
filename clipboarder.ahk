#Requires AutoHotKey v2
;;;;;; hold to store, click to paste
waitT := -200

downUpCounters := Map("*Numpad1", [0, 0], "*Numpad2", [0, 0], "*Numpad3", [0, 0], "*Numpad4", [0, 0], "*Numpad5", [0, 0], "*Numpad6", [0, 0], "*Numpad7", [0, 0], "*Numpad8", [0, 0], "*Numpad9", [0, 0],)
stores := Map()

Hotkey("*Numpad1", handleHK)
Hotkey("*Numpad2", handleHK)
Hotkey("*Numpad3", handleHK)
Hotkey("*Numpad4", handleHK)
Hotkey("*Numpad5", handleHK)
Hotkey("*Numpad6", handleHK)
Hotkey("*Numpad7", handleHK)
Hotkey("*Numpad8", handleHK)
Hotkey("*Numpad9", handleHK)


handleHK(keyName)
{
    global
    if GetKeyState("Control")
    {
        SetTimer(() => clipper(keyName), waitT)
        downUpCounters[keyName][1] += 1
        KeyWait(SubStr(keyName, 2))
        if (downUpCounters[keyName][1] > 0)
            downUpCounters[keyName][2] += 1
    }
    else
    {
        SendInput("{Blind}{" SubStr(keyName, 2) "}")
    }
}

clipper(keyName)
{
    global
    if (downUpCounters[keyName][1] > 0 and downUpCounters[keyName][2] > 0)
    {
        local previousclip := A_Clipboard
        A_Clipboard := stores[keyName]
        Loop Max(downUpCounters[keyName][1], downUpCounters[keyName][2])
        {
            if GetKeyState("Control")
            {
                Send("{BLind}v")
            }
            else {
                Send("^v")
            }
        }
        Sleep(100)
        A_Clipboard := previousclip
        local previousclip := ""
    }
    if (downUpCounters[keyName][1] > 0 and downUpCounters[keyName][2] = 0)
    {
        local previousclip := A_Clipboard
        A_Clipboard := ""
        if GetKeyState("Control") {
            Send("{BLind}c")
            ClipWait(1)
        }
        else {
            Send("{Control down}c")
            ClipWait(1)
            Send("{Control up}")
        }
        stores[keyName] := A_Clipboard
        Sleep(100)
        A_Clipboard := previousclip
        local previousclip := ""
    }
    downUpCounters[keyName][1] := "0"
    downUpCounters[keyName][2] := "0"
}