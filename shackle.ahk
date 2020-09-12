#NoEnv
#Persistent
#singleinstance force


;----------------

			; Register a function to be called on exit:
			OnExit("ExitFunc")

			; Register an object to be called on exit:
			OnExit(ObjBindMethod(MyObject, "Exiting"))

			ExitFunc(ExitReason, ExitCode)
			{
				if ExitReason not in Logoff,Shutdown
				{
					MsgBox, 4, , Are you sure you want to exit?
					IfMsgBox, No
						return 1  ; OnExit functions must return non-zero to prevent exit.
				}
				;SetTimer, returntoshakle, -1
				; Do not call ExitApp -- that would prevent other OnExit functions from being called.
			}

			class MyObject
			{
				Exiting()
				{
						FileDelete, C:\Windows\System32\Drivers\etc\hosts
						FileCopy, %A_WorkingDir%\free\hosts, C:\Windows\System32\Drivers\etc
						Run cmd /c ipconfig /flushdns
						returntoshakle()
						msgbox done
					
				}
			}
;----------------


SendMode Input
SetWorkingDir %A_ScriptDir%
allowedMinutes :=15
InputBox, allowedMinutes , "Time",,,100, 100


if (allowedMinutes>60)
		{
			allowedMinutes :=60
		}
		
		
FileDelete, C:\Windows\System32\Drivers\etc\hosts
FileCopy, %A_WorkingDir%\shackled\hosts, C:\Windows\System32\Drivers\etc
Run cmd /c ipconfig /flushdns


endTime := A_Now
endTime += %allowedMinutes%, Minutes


Gui, +AlwaysOnTop -Border +LastFound -SysMenu +Owner -Caption -ToolWindow +E0x08000020
Gui -Caption
Gui Font, s10.2 w30 c8000FF, Bookman Old Style
Gui Add, Text, x7 y0 h20 w35 center vtime
Gui, Color, EEAA99
WinSet, Transcolor, FFFFFF 


GUI, Show, x860 y0 AutoSize NA
guiShown := true

SetTimer TicTac, 1000


			TicTac:
				remainingTime := endTime
				EnvSub remainingTime, %A_Now%, Seconds
				h := floor(remainingTime // 60 // 60)
				remainingTime := remainingTime- (h*3600)
				m := floor(remainingTime// 60)
				remainingTime := remainingTime-(m*60)
				s := floor(remainingTime)
				displayedTime := Format2Digits(m) ":" Format2Digits(s)
				GuiControl, , time, %displayedTime%
					if(remainingTime<0)
					{
						returntoshakle()

					}
			Return
			
			



;---------
	+sc046::

	If !guiShown
	{
		GUI, Show, x860 y0 AutoSize NA
		guiShown := true
	}
		else
		{
		GUI, hide 
		guiShown := false
		}

	return
;---------------



Format2Digits(_val)
{
_val += 100
StringRight _val, _val, 2
Return _val
}


returntoshakle()
{
	SetTimer TicTac, off
	GuiControl, , time, DONE!
	send {f5}
	sleep 200
	FileDelete, C:\Windows\System32\Drivers\etc\hosts
	FileCopy, %A_WorkingDir%\free\hosts, C:\Windows\System32\Drivers\etc
	Run cmd /c ipconfig /flushdns
	Install_Path = %A_Desktop%\Shackles

	sleep 500
	;-----
	send {f5}
	sleep 2000
	MsgBox,,Shackle used, Sorry, shackle was used hollow.
	FileMove, %A_ScriptName%, C:\Temp
	FileRemoveDir, %Install_Path%\, 1
	Sleep, 1000
	RemoveSelf = "C:\Temp\%A_ScriptName%"
	Run, %comspec% /c del %RemoveSelf% /q,,hide
	FileCreateDir, %Install_Path%\
	ExitApp
return null
}