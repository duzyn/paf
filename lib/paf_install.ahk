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
    If WinExist("Portable", "select a language")
    {
      WinActivate
      Send "{Enter}"
    }

    Sleep 100

    If WinExist("PortableApps.com Installer", "This wizard")
      or WinExist("PortableApps.com Installer", "向导")
    {
      WinActivate
      Send "{Enter}"
    }

    Sleep 100

    If WinExist("PortableApps.com Installer", "License Agreement")
    {
      WinActivate
      ControlSend "{Enter}", "Agree"
    }
    If WinExist("PortableApps.com Installer", "协议")
    {
      WinActivate
      ControlSend "{Enter}", "接受"
    }

    Sleep 100

    If WinExist("PortableApps.com Installer", "Choose Components")
      or WinExist("PortableApps.com Installer", "组件")
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
      or WinExist("PortableApps.com Installer", "位置")
    {
      WinActivate
      ; A_Clipboard := StrReplace(A_Args[2], '"')
      ; Send "^v"
      Send "{Enter}"
    }

    Sleep 100

    If WinExist("PortableApps.com Installer", "Finish")
      or  WinExist("PortableApps.com Installer", "完成")
    {
      Send "{Enter}"
      Break
    }

  }

}
BlockInput 0
Return