library ALibraryCoreInterfaceMultiboard

	function ShowMultiboardForPlayer takes player whichPlayer, multiboard whichMultiboard, boolean show returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call MultiboardDisplay(whichMultiboard, show)
		endif
	endfunction

	function MultiboardSuppressDisplayForPlayer takes player whichPlayer, boolean flag returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call MultiboardSuppressDisplay(flag)
		endif
	endfunction

endlibrary