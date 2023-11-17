#SingleInstance Force

If not (A_Args.Length = 2)
{
  MsgBox "Error"
  Return
}
Else
{
  Run A_Args[1]

  BlockInput 1

  Loop
  {
    If WinExist("Installer Language")
    {
      WinActivate
      Send "{Enter}"
    }

    Sleep 100

    If WinExist("PortableApps.com Installer", "This wizard")
    {
      WinActivate
      Send "{Enter}"
    }

    Sleep 100

    If WinExist("PortableApps.com Installer", "License Agreement")
    {
      WinActivate
      ControlSend "{Enter}", "Agree"
      ; Send "{Tab}"
      ; Send "{Space}"
      ; Send "{Enter}"
    }

    Sleep 100

    If WinExist("PortableApps.com Installer", "Choose Components")
    {
      WinActivate
      ; Check all components. 2N+1 times
      Send "{Down}"
      Send "{Space}"
      Send "{Down}"
      Send "{Space}"
      Send "{Down}"
      Send "{Space}"
      Send "{Down}"
      Send "{Space}"
      Send "{Down}"
      Send "{Space}"
      Send "{Down}"
      Send "{Space}"
      Send "{Down}"
      Send "{Space}"
      Send "{Down}"
      Send "{Space}"
      Send "{Down}"
      Send "{Space}"
      Send "{Down}"
      Send "{Space}"
      Send "{Down}"
      Send "{Space}"
      
      Send "{Enter}"
    }

    Sleep 100

    If WinExist("PortableApps.com Installer", "Choose Install Location")
    {
      WinActivate
      ; A_Clipboard := StrReplace(A_Args[2], '"')
      ; Send "^v"
      Send "{Enter}"
    }

    Sleep 100

    If WinExist("PortableApps.com Installer", "Finish")
    {
      Send "{Enter}"
      Break
    }

  }

}
BlockInput 0
Return