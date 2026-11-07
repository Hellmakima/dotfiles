#Requires AutoHotkey v2.0
#SingleInstance

#e::{
    if WinExist("ahk_exe FPilot.exe") {
        WinActivate
        WinWaitActive("ahk_exe FPilot.exe", , 2)
    } else {
        Run "C:\Users\Sufiyan Attar\AppData\Local\Voidstar\FilePilot\FPilot.exe"
        WinWaitActive("ahk_exe FPilot.exe", , 2)
    }
}

; minimize current window
#m::WinMinimize "A"

; close current window
#w::WinKill "A"

#+s::Run '"C:\Program Files\Sublime Text\sublime_text.exe" "C:\Users\Sufiyan Attar\Documents\AutoHotkey\winplus.ahk"'

#f::{
    Click "800 500"
    MouseMove 2000, 500
}

#s::
{
    sublimePath := "C:\Program Files\Sublime Text\sublime_text.exe"
    selected := []
    shell := ComObject("Shell.Application")
    static flip := 0 ; 0 -> file1, 1 -> file2
    taskFile1 := "D:\back\task.md"
    taskFile2 := "C:\Users\Sufiyan Attar\Desktop\a.py"
    sublime := "C:\Program Files\Sublime Text\sublime_text.exe"

    ; if sublime active -> toggle
    if WinActive("ahk_exe sublime_text.exe") {
        file := flip ? taskFile1 : taskFile2
        flip := !flip
        Run '"' sublime '" "' file '"'
        return
    }

    ; otherwise, check active Explorer
    activeHwnd := WinActive("A")

    for window in shell.Windows {
        try {
            if (window.HWND = activeHwnd) {
                if (window.Name = "File Explorer") {
                    sel := window.Document.SelectedItems
                    if (sel && sel.Count > 0) {
                        for item in sel {
                            selected.Push(item.Path)
                        }
                    }
                }
                break
            }
        } catch {
        }
    }

    ; :( doen't work for file pilot


    if (selected.Length > 0) {
        for path in selected {
            Run '"' sublimePath '" "' path '"'
        }
    } else {
        if WinExist("ahk_exe sublime_text.exe")
            WinActivate
        else
            Run sublimePath
    }
}

#c::{
    codePath := "C:\Users\Sufiyan Attar\AppData\Local\Programs\Microsoft VS Code\Code.exe"
    shell := ComObject("Shell.Application")
    selected := []

    ; if VS Code active -> just activate it
    if WinActive("ahk_exe Code.exe") {
        WinActivate
        return
    }

    activeHwnd := WinActive("A")

    ; otherwise, check active Explorer
    for window in shell.Windows {
        try {
            if (window.HWND = activeHwnd) {
                if (window.Name = "File Explorer") {
                    sel := window.Document.SelectedItems
                    if (sel && sel.Count > 0) {
                        for item in sel {
                            selected.Push(item.Path)
                        }
                    }
                }
                break
            }
        } catch {
        }
    }

    if (selected.Length > 0) {
        for path in selected {
            Run '"' codePath '" "' path '"'
        }
    } else {
        if WinExist("ahk_exe Code.exe")
            WinActivate
        else
            Run codePath
    }
}


#q::{
    if WinExist("ahk_exe mstsc.exe") {
        WinActivate
    } else {
        Run "C:\WINDOWS\system32\mstsc.exe"
    }
}

#n::{
    if WinExist("ahk_exe notepad.exe") {
        WinActivate
    } else {
        Run "notepad"
    }
}

#t::{
    if WinExist("ahk_exe powershell.exe") {
        WinActivate
    } else {
        Run "powershell -NoLogo -WorkingDirectory ~"
    }
}

; win shift t for terminal as admin
#+t:: ; win + shift + t
{
    Run '*RunAs powershell.exe'
}
