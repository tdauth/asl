library ATextMacroCoreGeneralInit

	/**
	* All statements between the A_MAIN and A_END_MAIN statements will be called as early as possible in the map's main function (before destructables, items, units and triggers are created).
	* The only way to call something earlier is to inject or hook functions that are called before NewSoundEnvironment (e .g. SetCameraBounds).
	* \n Main scopes can not be placed in other scopes!
	* \n This won't work if you inject the map's main function and prevent it from calling NewSoundEnvironment.
	* \p IDENTIFIER Each main scope needs a unique identifier.
	* \p REQUIREMENT Requirement has to be written like "requires <identifier>". If a main scope requires another main scope it will be executed after that one (CHECK IF JASSHELPER MOVES HOOKS THAT WAY!!!).
	*/
	//! textmacro A_MAIN takes IDENTIFIER, REQUIREMENT
		library $IDENTIFIER$ $REQUIREMENT$

			hook NewSoundEnvironment MyInitFunction

			globals
				private boolean hasBeenInitialized = false
			endglobals

			private function MyInitFunction takes string g returns nothing
				if (hasBeenInitialized) then
					return
				endif
				set hasBeenInitialized = true
	//! endtextmacro

	//! textmacro A_END_MAIN
			endfunction
		endlibrary
	//! endtextmacro

	/**
	* All statements between the A_CONFIG and A_END_CONFIG statements will be called as early as possible in the map's config function (description and teams are set).
	* The only way to call something earlier is to inject or hook functions that are called before SetMapName.
	* \n Config scopes can not be placed in other scopes!
	* \n This won't work if you inject the map's config function and prevent it from calling SetMapName.
	* \p IDENTIFIER Each config scope needs a unique identifier.
	* \p REQUIREMENT Requirement has to be written like "requires <identifier>". If a config scope requires another config scope it will be executed after that one (CHECK IF JASSHELPER MOVES HOOKS THAT WAY!!!).
	*/
	//! textmacro A_CONFIG takes IDENTIFIER, REQUIREMENT
		library $IDENTIFIER$ $REQUIREMENT$

		hook SetMapName MyInitFunction

		globals
			private boolean hasBeenInitialized = false
		endglobals

		private function MyInitFunction takes string g returns nothing
			if (hasBeenInitialized) then
				return
			endif
			set hasBeenInitialized = true
	//! endtextmacro

	//! textmacro A_END_CONFIG
			endfunction
		endlibrary
	//! endtextmacro

endlibrary