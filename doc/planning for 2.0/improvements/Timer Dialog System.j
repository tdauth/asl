function TimerDialogSetTitleColorToPlayerColor takes timerdialog timerDialog, playercolor playerColor, integer alpha returns nothing
function TimerDialogSetTimeColorToPlayerColor takes timerdialog timerDialog, playercolor playerColor, integer alpha returns nothing

function TimerDialogSetSpeedToTimeOfDayScale takes timerdialog timerDialog returns nothing
	call TimerDialogSetSpeed(timerDialog, GetTimeOfDayScale())
endfunction

function TimerDialogDisplayForForce takes boolean show, timerdialog timerDialog, force whichForce returns nothing
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		// Use only local code (no net traffic) within this block to avoid desyncs.
		call TimerDialogDisplay(timerDialog, show)
	endif
endfunction

/**
* Melee function.
* \todo Add custom race support to MeleeGetCrippledTimerMessage
*/
function TimerDialogSetTitleToCrippledTimerMessage takes timerdialog timerDialog, player whichPlayer returns nothing
	call TimerDialogSetTitle(timerDialog, MeleeGetCrippledTimerMessage(whichPlayer))
endfunction