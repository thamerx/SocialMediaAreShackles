#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent
#singleinstance force

; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

shakleConsumed := false
allowedMinutes := 150
;shown = false //rip killed by not using :=

;InputBox, allowedMinutes , "Time",,,100, 100

;Compensation := 0

;endTime := A_Now
;endTime += %allowedMinutes%  , Minutes


;------------
Gui,Points:+AlwaysOnTop +Disabled -SysMenu +Owner  ; +Owner avoids a taskbar button.
Gui Points:-Caption
Gui Points:Font, s9 w30 c8000FF, Bookman Old Style
Gui Points:Add, Text, x7 y0 h20 w55 center vpoints
Gui,Points:Color, EEAA99



;----------

Gui, Timer:+AlwaysOnTop +Disabled -SysMenu +Owner  ; +Owner avoids a taskbar button.
Gui Timer:-Caption
Gui Timer:Font, s10.2 w30 c8000FF, Bookman Old Style
Gui Timer:Add, Text, x7 y0 h20 w55 center vtime
Gui, Timer:Color, EEAA99
;GUI, Show, x860 y0 AutoSize, active



SetTitleMatchMode, 2
SetTimer TicTac, 1000
; Fallthrough

	remainingTimeOneNoteDependent := allowedMinutes*60
	remainingTime := allowedMinutes*60
	
	;EnvSub remainingTimeOneNoteDependent, %A_Now%, Seconds
	;EnvSub remainingTime, %A_Now%, Seconds

	IniRead, points, %A_WorkingDir%\points.ini:Stream:$DATA, Money, points,0 


	lastTimePointsAdded := 10000 ; has to be so high at start cause i'm lazy
	;remainingTime -= %A_Now%
	
	
TicTac:

	;remainingTime := endTime
		;Compensation += 10

	;anowWithCompensation := %A_Now% + Compensation
	;EnvSub remainingTime, %anowWithCompensation%, Seconds
	remainingTime -= 1
	
	Process, Exist,  shackle.exe 
	hasShakleitsFine := ErrorLevel

	if WinActive("‎- OneNote for Windows 10")
	{
	
										remainingTimeOneNoteDependent -= 1

			if (remainingTime < lastTimePointsAdded-5)
				{
								points := points+1
								lastTimePointsAdded := remainingTime
								IniWrite, %points%, %A_WorkingDir%\points.ini:Stream:$DATA, Money, points
								

				}

			;remainingTimeOneNoteDependent := remainingTime
			Gui, Timer:Color, 2E8B57
			Gui, Points:Color, 2E8B57
		
	}
	else
		{
		
		

		
		if (remainingTime < lastTimePointsAdded-15) AND (hasShakleitsFine == 0)
				{
				
				
								inactivity_limit_ms := 1000*60*35
								;msgbox hello %inactivity_limit_ms%
								

								if A_TimeIdleMouse < %inactivity_limit_ms%
								{
									points := points-1
									;msgbox hello %inactivity_limit_ms%
									;msgbox %A_TimeIdlePhysical%
								}

								lastTimePointsAdded := remainingTime
								IniWrite, %points%, %A_WorkingDir%\points.ini:Stream:$DATA, Money, points
								SetTimer, closeGames, -5
								
								;remainingTime := remainingTimeOneNoteDependent ;i'm sorry gotta do so
				

				}

		;remainingTime := remainingTimeOneNoteDependent
		Gui, Timer:Color, EEAA99
		Gui, Points:Color, EEAA99

		}
	_remainingTimeOneNoteDependent := remainingTimeOneNoteDependent
		h := floor(_remainingTimeOneNoteDependent // 60 // 60)
		_remainingTimeOneNoteDependent := _remainingTimeOneNoteDependent- (h*3600)
		m := floor(_remainingTimeOneNoteDependent// 60)
		_remainingTimeOneNoteDependent := _remainingTimeOneNoteDependent-(m*60)
		s := floor(_remainingTimeOneNoteDependent)
		displayedTime := Format2Digits(h) ":" Format2Digits(m) ":" Format2Digits(s)
		
	GuiControl , Timer: , time, %displayedTime%
	GuiControl , Points: , points, %points%

	
	Process, Exist,  shackle.exe 
	pleaseNewShakle := ErrorLevel
	;msgbox %ErrorLevel%

	if (pleaseNewShakle != 0)
	{
		shakleConsumed := true
	}
		else
		{
			if (shakleConsumed)
			{
				
					
							SetTimer, resetGiveAshakle, -5
							;SetTimer, giveAshakle, -5

							shakleConsumed := false

					
			}
			

		}
		
		

	
	if(remainingTimeOneNoteDependent<0)
	{
		SetTimer, giveAshakle, -5
	}
	

Return

GuiClose:
;GuiEscape:

ExitApp

guiShown := false

;---------
	sc046::

	If !guiShown
	{
		GUI, Timer:Show, x860 y0 AutoSize, active
		GUI, Points:Show, x1835 y0 AutoSize, active
		guiShown := true
	}
		else
		{
		GUI, Timer:hide 
		GUI, Points:hide
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

giveAshakle:
		GuiControl,Timer: , time, Shackle!
		SetTimer TicTac, off
			FileCopy, %A_WorkingDir%\shackle.exe, %A_Desktop%\Shackles\shackle.exe
			msgbox Gained 1 free shackle
		allowedMinutes := allowedMinutes

		;endTime := A_Now
		;endTime += %allowedMinutes%, Minutes
		remainingTimeOneNoteDependent := allowedMinutes*60
		remainingTime := allowedMinutes*60
		SetTimer TicTac, 1000

return


resetGiveAshakle:
		GuiControl,Timer: , time, reset!
		SetTimer TicTac, off
		allowedMinutes := allowedMinutes
		;endTime := A_Now
		;endTime += %allowedMinutes%, Minutes
		remainingTimeOneNoteDependent := allowedMinutes*60
		remainingTime := allowedMinutes*60
		
		SetTimer TicTac, 1000
return


closeGames:
			Process, Close  , RocketLeague.exe
return
