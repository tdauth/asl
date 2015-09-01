library ALibraryCoreInterfaceCinematic

	/**
	 * \author Tamino Dauth
	 * \todo Test it!
	 * \sa EndCinematicScene()
	 * \sa CancelCineSceneBJ()
	 */
	function EndCinematicSceneForPlayer takes player whichPlayer returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call EndCinematicScene()
		endif
	endfunction

	/**
	 * Smaller function than the real function \ref SetCinematicSceneBJ()
	 * You don't have to use player forces.
	 * \sa SetCinematicSceneBJ()
	 * \sa TransmissionFromUnitWithNameBJ()
	 */
	function SetCinematicSceneForPlayer takes player user, integer unitType, player owner, string title, string text, real sceneTime, real voiceTime returns nothing
		local player localPlayer = GetLocalPlayer()
		local playercolor playerColour = GetPlayerColor(owner)
		if (user == localPlayer) then
			call SetCinematicScene(unitType, playerColour, title, text, sceneTime, voiceTime)
		endif
		set localPlayer = null
		set playerColour = null
	endfunction

	/**
	 * Does not init cinematic behaviour, wait for sound and ping the minimap.
	 * \author Tamino Dauth
	 * \sa TransmissionFromUnitTypeWithNameBJ()
	 * \sa TransmissionFromUnit()
	 * \sa TransmissionFromUnitWithName()
	 */
	function TransmissionFromUnitType takes integer unitType, player owner, string name, string text, sound playedSound returns nothing
		local playercolor playerColor = GetPlayerColor(owner)
		local real time
		/*
		 * This has to be set for skipping a cinematic sound properly with CancelCineSceneBJ().
		 */
		set bj_cineSceneLastSound = playedSound
		if (playedSound != null) then
			set time = GetSoundDurationBJ(playedSound)
			call StartSound(playedSound)
		else
			set time = bj_NOTHING_SOUND_DURATION
		endif
		// bj_TRANSMISSION_PORT_HANGTIME keeps the unit's portrait
		call SetCinematicScene(unitType, playerColor, name, text, time + bj_TRANSMISSION_PORT_HANGTIME, time)
		set playerColor = null
	endfunction
	
	/**
	 * Same differences like \ref TransmissionFromUnitType() and additionally does not add unit's indicator.
	 * Similar to \ref TransmissionFromUnit() but you can specify the unit's name. This is useful for heroes for example.
	 * \author Tamino Dauth
	 * \sa TransmissionFromUnitWithNameBJ()
	 * \sa TransmissionFromUnitType()
	 * \sa TransmissionFromUnit()
	 */
	function TransmissionFromUnitWithName takes unit usedUnit, string unitName, string text, sound playedSound returns nothing
		call TransmissionFromUnitType(GetUnitTypeId(usedUnit), GetOwningPlayer(usedUnit), unitName, text, playedSound)
	endfunction

	/**
	 * Same differences like \ref TransmissionFromUnitType() and additionally does not add unit's indicator.
	 * \author Tamino Dauth
	 * \sa TransmissionFromUnitWithNameBJ()
	 * \sa TransmissionFromUnitType()
	 * \sa TransmissionFromUnitWithName()
	 */
	function TransmissionFromUnit takes unit usedUnit, string text, sound playedSound returns nothing
		call TransmissionFromUnitWithName(usedUnit, GetUnitName(usedUnit), text, playedSound)
	endfunction

	/**
	 * Shows a transmission with text \p text and sound \p playedSound from unit \p usedUnit for player \p usedPlayer.
	 * \param playedSound If this value is null sound duration will be \ref bj_NOTHING_SOUND_DURATION.
	 * \author Tamino Dauth
	 */
	function TransmissionFromUnitForPlayer takes player usedPlayer, unit usedUnit, string text, sound playedSound returns nothing
		local player localPlayer = GetLocalPlayer()
		local player owner = GetOwningPlayer(usedUnit)
		local playercolor playerColor = GetPlayerColor(owner)
		local real time
		/*
		 * This has to be set for skipping a cinematic sound properly with CancelCineSceneBJ().
		 */
		set bj_cineSceneLastSound = playedSound
		if (playedSound != null) then
			set time = GetSoundDurationBJ(playedSound)
		else
			set time = bj_NOTHING_SOUND_DURATION
		endif
		if (usedPlayer == localPlayer) then
			if (playedSound != null) then
				call StartSound(playedSound)
			endif
			call SetCinematicScene(GetUnitTypeId(usedUnit), playerColor, GetUnitName(usedUnit), text, time, time)
		endif
		set localPlayer = null
		set owner = null
		set playerColor = null
	endfunction

	/**
	 * \sa GetTransmissionDuration()
	 */
	function GetSimpleTransmissionDuration takes sound playedSound returns real
		if (playedSound != null) then
			return GetSoundDurationBJ(playedSound)
		endif
		return bj_NOTHING_SOUND_DURATION
	endfunction

	/**
	 * Alternate function without using forces.
	 * \sa ClearTextMessagesBJ()
	 * \sa ClearTextMessages()
	 */
	function ClearScreenMessagesForPlayer takes player user returns nothing
		local player localPlayer = GetLocalPlayer()
		if (user == localPlayer) then
			call ClearTextMessages()
		endif
		set localPlayer = null
	endfunction

	/**
	 * \sa ShowInterface()
	 * \sa ShowInterfaceForceOn()
	 * \sa ShowInterfaceForceOff()
	 */
	function SetInterfaceForPlayer takes player whichPlayer, boolean show, real fadeDuration returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call ShowInterface(show, fadeDuration)
		endif
	endfunction

	/**
	 * \sa EnableUserControl()
	 * \sa SetUserControlForceOn()
	 * \sa SetUserControlForceOff()
	 */
	function SetUserControlForPlayer takes player whichPlayer, boolean enable returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call EnableUserControl(enable)
		endif
	endfunction

	/**
	 * Alternate function without using forces. Combines functions \ref SetUserUIForPlayer() and \ref SetUserControlForPlayer().
	 * \sa SetInterfaceForPlayer()
	 * \sa SetUserControlForPlayer()
	 * \sa SetUserControlForceOn()
	 * \sa SetUserControlForceOff()
	 * \sa ShowInterfaceForceOn()
	 * \sa ShowInterfaceForceOff()
	 * \sa ShowInterface()
	 * \sa EnableUserControl()
	*/
	function SetUserInterfaceForPlayer takes player user, boolean show, boolean enableControl returns nothing
		local player localPlayer = GetLocalPlayer()
		if (user == localPlayer) then
			call ShowInterface(show, 1.0) // never use 0.0!
			call EnableUserControl(enableControl)
		endif
		set localPlayer = null
	endfunction

endlibrary