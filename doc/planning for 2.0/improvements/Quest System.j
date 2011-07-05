function QuestSetEnabledForPlayer takes player whichPlayer, quest whichQuest, boolean enabled returns nothing
	if (whichPlayer == GetLocalPlayer()) then
		call QuestSetEnabled(whichQuest, enabled)
	endif
endfunction

function QuestSetEnabledForForce takes force whichForce, quest whichQuest, boolean enabled returns nothing
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		call QuestSetEnabled(whichQuest, enabled)
	endif
endfunction

* Make the whole quest system force-based.
