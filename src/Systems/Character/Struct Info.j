library AStructSystemsCharacterInfo requires optional ALibraryCoreDebugMisc, ALibraryCoreEnvironmentSound, ALibraryCoreGeneralPlayer, AStructCoreInterfaceThirdPersonCamera, ALibraryCoreInterfaceCinematic, ALibraryCoreInterfaceMisc, ALibraryCoreMathsUnit, AStructSystemsCharacterCharacter, AStructSystemsCharacterTalk, AStructSystemsCharacterVideo

	/**
	 * The interface for functions whiche are used as conditions for infos.
	 * If they return false the info is not shown.
	 * Since the function returns a value it is called by .evaluate().
	 * \param info The info which should be shown.
	 * \param character The character who the info is shown to.
	 * \return Returns true if the info is shown. Otherwise it returns false and the info is hidden.
	 * \todo Shoud be a static member of \ref AInfo, vJass bug.
	 */
	function interface AInfoCondition takes AInfo info, ACharacter character returns boolean

	/**
	 * The interface for functions which are used as actions run when an info
	 * is selected by the user.
	 * Since the action is executed it is called by .execute().
	 * \param info The info which has been selected by the user.
	 * \param character The character which is talking to the NPC.
	 * \todo Shoud be a static member of \ref AInfo, vJass bug.
	 */
	function interface AInfoAction takes AInfo info, ACharacter character returns nothing

	/**
	 * \brief Members of talks are called informations or just infos. Each info can be imagined like a choice for the character's owner displayed in the talk's dialog.
	 * Informations can have conditions (\ref AInfoCondition) and actions (\ref AInfoAction) just like triggers.
	 * If their condition returns false they won't be shown to the user.
	 * If they are chosen or run automatically (important infos) by or for the user their action is called.
	 * Permanent infos will be checked each time when displayed and shown if their condition returns true.
	 * Otherwise (if not permanent) infos which were chosen one time won't be displayed anymore even if their condition would return true.
	 * This behaviour is implemented since most times it will be useful to offer infos only one time to any character's owner.
	 * Important infos aren't displayed as choice. If their condition returns true their action is run immediately when they're going to be displayed.
	 * Use \ref speech() or \ref speech2() to provide talks in info actions.
	 * \ref initSpeechSkip() can be used to provide skipable speeches.
	 * \sa ATalk
	 * \internal Don't move around any info's since they are refered by their indices!
	 */
	struct AInfo
		// static members
		private static trigger m_skipTrigger
		public static boolean array m_playerHasSkipped[12] /// \todo bj_MAX_PLAYERS Do not use.
		// dynamic members
		private boolean m_permanent
		private boolean m_important
		private AInfoCondition m_condition
		private AInfoAction m_action
		private string m_description
		// construction members
		private ATalk m_talk
		// members
		/// ADialogButton instances.
		private ADialogButton array m_dialogButtons[12] /// \todo bj_MAX_PLAYERS
		private integer m_talkIndex // store index for faster removal
		private boolean array m_hasBeenShownToCharacter[12] /// \todo bj_MAX_PLAYERS

		//! runtextmacro optional A_STRUCT_DEBUG("\"AInfo\"")

		// dynamic members

		/**
		 * Permanent infos won't be hidden if they were displayed already to the character's owner.
		 * \sa permanent()
		 */
		public method setPermanent takes boolean permanent returns nothing
			set this.m_permanent = permanent
		endmethod

		/**
		 * \sa setPermanent()
		 */
		public method permanent takes nothing returns boolean
			return this.m_permanent
		endmethod

		/**
		 * Important infos won't be displayed as \ref button in the talk's \ref dialog rather than run immediately when \ref show() is called.
		 * Therefore you should check important infos seperately when showing multiple infos.
		 * \sa important()
		 */
		public method setImportant takes boolean important returns nothing
			set this.m_important = important
		endmethod

		/**
		 * \sa setImportant()
		 */
		public method important takes nothing returns boolean
			return this.m_important
		endmethod

		/**
		 * An info's condition is evaluated whenever it should be displayed using \ref show().
		 * \sa condition()
		 */
		public method setCondition takes AInfoCondition cond returns nothing
			set this.m_condition = cond
		endmethod

		/**
		 * \sa setCondition()
		 */
		public method condition takes nothing returns AInfoCondition
			return this.m_condition
		endmethod

		/**
		 * An info's action is executed whenever it should be run using \ref show() or \ref run() (without any checks).
		 */
		public method setAction takes AInfoAction action returns nothing
			set this.m_action = action
		endmethod

		/**
		 * \sa setAction()
		 */
		public method action takes nothing returns AInfoAction
			return this.m_action
		endmethod

		/**
		 * An info's description is displayed as \ref button text whenever the info is shown in a \ref dialog.
		 * \sa description()
		 */
		public method setDescription takes string description returns nothing
			set this.m_description = description
		endmethod

		/**
		 * \sa setDescription()
		 */
		public method description takes nothing returns string
			return this.m_description
		endmethod

		// construction members

		/**
		 * \return Returns the info's corresponding talk which is defined on its construction.
		 */
		public method talk takes nothing returns ATalk
			return this.m_talk
		endmethod

		// members

		/**
		 * \param whichPlayer The player which the info is shown to.
		 * \return Returns true if the info is shown as \ref button in the talk's dialog.
		 * \sa dialogButtonIndex()
		 * \sa show()
		 */
		public method isShown takes player whichPlayer returns boolean
			return this.m_dialogButtons[GetPlayerId(whichPlayer)] != 0
		endmethod

		/**
		 * \return Returns the corresponding index of the info's \ref button. Returns -1 if the button isn't shown.
		 * \sa isShown()
		 * \sa show()
		 */
		public method dialogButtonIndex takes player whichPlayer returns integer
			if (not this.isShown(whichPlayer)) then
				return -1
			endif
			return ADialogButton(this.m_dialogButtons[GetPlayerId(whichPlayer)]).index()
		endmethod
		
		/**
		 * \return Returns true if the info has been shown to \p whichPlayer.
		 * \sa hasBeenShownToCharacter()
		 * \sa hasBeenShownToCharacter()
		 */
		public method hasBeenShownToPlayer takes player whichPlayer returns boolean
			return this.m_hasBeenShownToCharacter[GetPlayerId(whichPlayer)]
		endmethod

		/**
		 * \return Returns true if the info has been shown to \p character.
		 * \sa hasBeenShownToCharacter()
		 * \sa hasBeenShownToPlayer()
		 */
		public method hasBeenShownToCharacter takes ACharacter character returns boolean
			return this.hasBeenShownToPlayer(character.player())
		endmethod

		/**
		 * The info's index in its corresponding talk info container.
		 * \sa talk()
		 */
		public method index takes nothing returns integer
			return this.m_talkIndex
		endmethod

		// methods

		/**
		 * Calls the info's action via .execute().
		 * Afterwards it will be registered as shown for the corresponding player.
		 * \sa action()
		 * \sa hasBeenShownToCharacter()
		 * \sa show()
		 */
		public method run takes ACharacter character returns nothing
			set this.m_hasBeenShownToCharacter[GetPlayerId(character.player())] = true
			call this.action().execute(this, character)
		endmethod

		private static method dialogButtonActionRunInfo takes ADialogButton dialogButton returns nothing
			local ACharacter character = ACharacter.playerCharacter(dialogButton.dialog().player())
			local ATalk talk = character.talk()
			local thistype info = talk.getInfoByDialogButtonIndex(dialogButton.index(), character.player())
			call talk.clear(character.player()) // NOTE necessary that all infos will return false for isShown()!
			call info.run(character)
		endmethod
		
		private method createDialogButton takes player whichPlayer returns ADialogButton
			if (this.m_dialogButtons[GetPlayerId(whichPlayer)] == 0) then
				set this.m_dialogButtons[GetPlayerId(whichPlayer)] = AGui.playerGui(whichPlayer).dialog().addDialogButtonIndex(this.description(), thistype.dialogButtonActionRunInfo)
			endif
			
			return this.m_dialogButtons[GetPlayerId(whichPlayer)]
		endmethod

		/**
		 * Shows the information by detecting if it's important, permanent and if it has been shown already.
		 * \return Returns true if the info's action is run or it's displayed as \ref button. Otherwise it returns false.
		 * \note As this only adds the button to the corresponding player's dialog you still have to show the dialog. This can be done by calling \ref ATalk.show(). Besides, there are some convenient functions such as \ref ATalk.showRange() which do call some info's show methods as well as \ref ATalk.show().
		 * \note Since the info's action is executed this won't necessarily return true after the info's action has finished.
		 * \sa hide()
		 * \sa run()
		 */
		public method show takes ACharacter character returns boolean
			local boolean result = false
			if (this.permanent() or not this.hasBeenShownToCharacter(character)) then
				if (this.important()) then
					if (this.condition() == 0 or this.condition().evaluate(this, character)) then
						set result = true
						call this.run(character)
					endif
				else
					if (this.condition() == 0 or this.condition().evaluate(this, character)) then
						set result = true
						call this.createDialogButton(character.player())
					endif
				endif
			endif
			return result
		endmethod

		/**
		 * \todo This method is intended to hide the displayed \ref button but this cannot be done with any native function.
		 * \sa show()
		 */
		public method hide takes player whichPlayer returns nothing
			// NOTE we cannot remove dialog buttons
			set this.m_dialogButtons[GetPlayerId(whichPlayer)] = 0
		endmethod

		/**
		 * \param talk The info's corresponding talk to which it is added on construction. Use \ref index() to get its assigned index.
		 * \param description This string is displayed as button text whenenver the info is shown in a \ref dialog.
		 * \note All properties except \p talk can be changed after construction.
		 */
		public static method create takes ATalk talk, boolean permanent, boolean important, AInfoCondition condition, AInfoAction action, string description returns thistype
			local thistype this = thistype.allocate()
			local integer i
			// dynamic members
			set this.m_permanent = permanent
			set this.m_important = important
			set this.m_condition = condition
			set this.m_action = action
			set this.m_description = description
			// construction members
			set this.m_talk = talk
			// members
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set this.m_dialogButtons[i] = 0
				set this.m_hasBeenShownToCharacter[i] = false
				set i = i + 1
			endloop
			set this.m_talkIndex = talk.addInfoInstance(this)
			
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_talk.removeInfoInstanceByIndex(this.m_talkIndex)
		endmethod
	endstruct

	globals
		private integer skipKey
		private real skipCheckInterval
		private boolean array playerHasSkipped[12] /// \todo bj_MAX_PLAYERS, vJass bug.
		private trigger skipTrigger = null
	endglobals

	private function triggerConditionSkip takes nothing returns boolean
		return ACharacter.playerCharacter(GetTriggerPlayer()).talk() != 0 and not playerHasSkipped[GetPlayerId(GetTriggerPlayer())]
	endfunction

	// skipping actions are handled in speech function itself
	private function triggerActionSkip takes nothing returns nothing
		set playerHasSkipped[GetPlayerId(GetTriggerPlayer())] = true
	endfunction

	/**
	 * Call this function before using \ref speech() to provide skipable talks.
	 * Whenenver the talk's listening player presses \p key one single \ref speech() call will be skipped.
	 * As functions cannot be interrupted immediately it needs \p checkInterval for a periodic time interval whenever it's checked if the player has skipped the speech.
	 * \sa speech()
	 * \sa speech2()
	 * \sa ATalk
	 * \sa AInfo
	 */
	function initSpeechSkip takes integer key, real checkInterval returns nothing
		local integer i
		if (not KeyIsValid(key)) then
			debug call PrintFunctionError("initSpeechSkip", "Invalid key " + I2S(key))
			set key = AKeyEscape
		endif
		set skipKey = key
		set skipCheckInterval = checkInterval
		if (skipTrigger != null) then
			return
		endif
		set skipTrigger = CreateTrigger()
		set i = 0
		loop
			exitwhen (i == bj_MAX_PLAYERS)
			set playerHasSkipped[i] = false
			if (IsPlayerPlayingUser(Player(i))) then
				call TriggerRegisterKeyEventForPlayer(Player(i), skipTrigger, key, true)
			endif
			set i = i + 1
		endloop
		call TriggerAddCondition(skipTrigger, Condition(function triggerConditionSkip))
		call TriggerAddAction(skipTrigger, function triggerActionSkip)
	endfunction
	
	private function SetSpeechVolumeGroupsImmediateForPlayer takes player whichPlayer returns nothing
		call VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UNITMOVEMENT,  bj_SPEECH_VOLUME_UNITMOVEMENT)
		call VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UNITSOUNDS,    bj_SPEECH_VOLUME_UNITSOUNDS)
		call VolumeGroupSetVolume(SOUND_VOLUMEGROUP_COMBAT,        bj_SPEECH_VOLUME_COMBAT)
		call VolumeGroupSetVolume(SOUND_VOLUMEGROUP_SPELLS,        bj_SPEECH_VOLUME_SPELLS)
		call VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UI,            bj_SPEECH_VOLUME_UI)
		call VolumeGroupSetVolume(SOUND_VOLUMEGROUP_MUSIC,         bj_SPEECH_VOLUME_MUSIC)
		call VolumeGroupSetVolume(SOUND_VOLUMEGROUP_AMBIENTSOUNDS, bj_SPEECH_VOLUME_AMBIENTSOUNDS)
		call VolumeGroupSetVolume(SOUND_VOLUMEGROUP_FIRE,          bj_SPEECH_VOLUME_FIRE)
	endfunction
	
	private function VolumeGroupResetForPlayer takes player whichPlayer returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call VolumeGroupReset()
		endif
	endfunction

	/**
	 * Shows a single speech from whether the character's unit or the talk's unit (NPC).
	 * If third person system is enabled (\ref ATalk.useThirdPerson()) the camera will target the current spokesperson.
	 * \param toCharacter If this value is true the NPC is the spokesperson. Otherwise the character is the spokesperson.
	 * \param text The text which is displayed as cinematic transmission. The spokesperson's name is shown in front of the text, as well.
	 * \param usedSound If this value is null the speech will take \ref bj_NOTHING_SOUND_DURATION. Otherwise the sound's duration is detected automatically.
	 * \note The whole speech is visible and audible for the character's owner only!
	 * \note If the character's talk log is enabled this function will add the corresponding log entry.
	 * \note Methods are often called in their own threads by using .execute automatically -> \ref TriggerSleepAction() problem. Therefore this is provieded as function not as method.
	 * \sa initSpeechSkip()
	 * \sa speech2()
	 * \sa ATalkLog
	 */
	function speech takes AInfo info, ACharacter character, boolean toCharacter, string text, sound usedSound returns nothing
		local real duration
		local player user = character.player()
		local unit speaker
		local string name
		local unit listener
		local player speakerOwner
		local boolean useThirdPerson = info.talk().useThirdPerson(character)
		call waitForVideo(1.0) // do not show any speeches during video
		if (toCharacter) then
			set speaker = info.talk().unit()
			set name = info.talk().name()
			set listener = character.unit()
			set speakerOwner = GetOwningPlayer(info.talk().unit())
		else
			set speaker = character.unit()
			set name = GetPlayerName(character.player())
			set listener = info.talk().unit()
			set speakerOwner = character.player()
		endif
		if (usedSound != null) then
			call SetSpeechVolumeGroupsImmediateForPlayer(user)
			set duration = GetSoundDurationBJ(usedSound)
			call PlaySoundForPlayer(user, usedSound)
		else
			set duration = bj_NOTHING_SOUND_DURATION
		endif
		if (useThirdPerson) then
			call AThirdPersonCamera.playerThirdPersonCamera(user).resetCamAoa()
			call AThirdPersonCamera.playerThirdPersonCamera(user).resetCamRot()
			call AThirdPersonCamera.playerThirdPersonCamera(user).enable(listener, 0.0)
		endif
		call SetCinematicSceneForPlayer(user, GetUnitTypeId(speaker), speakerOwner, name, text, duration, duration)
		if (character.talkLog() != 0) then
			call character.talkLog().addSpeech(info, toCharacter, text, usedSound)
		endif
		if (skipTrigger == null) then
			call TriggerSleepAction(duration)
		else
			set playerHasSkipped[GetPlayerId(user)] = false
			loop
				exitwhen (duration <= 0.0)
				if (playerHasSkipped[GetPlayerId(user)]) then
					set playerHasSkipped[GetPlayerId(user)] = false
					// TODO stop sound for player only
					if (usedSound != null) then
						call StopSound(usedSound, false, false) // stop sound since speech could have been skipped by player
					endif
					call EndCinematicSceneForPlayer(user)
					exitwhen (true)
				endif
				call TriggerSleepAction(skipCheckInterval)
				set duration = duration - skipCheckInterval
			endloop
		endif
		call waitForVideo(1.0) // do not show any speeches during video
		call VolumeGroupResetForPlayer(user)
		if (useThirdPerson) then
			call AThirdPersonCamera.playerThirdPersonCamera(user).disable()
		endif
		set user = null
		set speaker = null
		set listener = null
		set speakerOwner = null
	endfunction

	/**
	 * This version uses a sound file path instead of a sound handle and assigns the sound's position to the spokesperson's position.
	 * \sa initSpeechSkip()
	 * \sa speech()
	 */
	function speech2 takes AInfo info, ACharacter character, boolean toCharacter, string text, string soundFilePath returns nothing
		local sound whichSound = CreateSound(soundFilePath, false, false, true, 12700, 12700, "")
		if (toCharacter) then
			call SetSoundPosition(whichSound, GetUnitX(info.talk().unit()), GetUnitY(info.talk().unit()), GetUnitZ(info.talk().unit()))
		else
			call SetSoundPosition(whichSound, GetUnitX(character.unit()), GetUnitY(character.unit()), GetUnitZ(character.unit()))
		endif
		call speech(info, character, toCharacter, text, whichSound)
		call KillSoundWhenDone(whichSound)
		set whichSound = null
	endfunction

endlibrary