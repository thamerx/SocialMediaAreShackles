#SingleInstance force

	msgbox Free shakles given every 2 and a half hours
	shakleConsumed := false
	shakles := 0
	ShakleResetMaxTime := 9001000
Loop
{
	Process, Exist,  shakle.exe 
	pleaseNewShakle := ErrorLevel
	;msgbox %ErrorLevel%

	if (pleaseNewShakle != 0)
	{
		shakleConsumed := true
	}else
		{
			if (shakleConsumed)
			{
				EnvAdd,shakles,1, Seconds, 
				if (shakles > (ShakleResetMaxTime))
					{
							SetTimer, giveFreeShakle, -5
							shakleConsumed := false
							shakles := 0

					}
			}
		}
		
		
	ScrollLockIsDown := GetKeyState("sc046", "P")
	if (ScrollLockIsDown)
	{
		
		preSetupShowtime := (ShakleResetMaxTime - shakles )
		setupShowtime := preSetupShowtime/1000

		h := floor(setupShowtime // 60 // 60)
		setupShowtime := setupShowtime- (h*3600)
		m := floor(setupShowtime// 60)
		setupShowtime := setupShowtime-(m*60)
		s := floor(setupShowtime)
		displayedTime := Format2Digits(h) ":" Format2Digits(m) ":" Format2Digits(s)
		
				msgbox %displayedTime%

	}
	sleep 1
}


giveFreeShakle:
	FileCopy, D:\PleaseBeGoodBoy\shakle.exe, C:\Users\thamer\Desktop\Shakles\shakle.exe
    msgbox Gained 1 free shakle
return


Format2Digits(_val)
{
	_val += 100
	StringRight _val, _val, 2
	Return _val
}

