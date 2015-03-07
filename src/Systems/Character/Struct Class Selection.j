library AStructSystemsCharacterClassSelection requires optional ALibraryCoreDebugMisc, ALibraryCoreEnvironmentUnit, AStructCoreGeneralHashTable, ALibraryCoreGeneralPlayer, ALibraryCoreInterfaceCinematic, ALibraryCoreInterfaceMisc, ALibraryCoreInterfaceMultiboard, AStructSystemsCharacterCharacter, AStructSystemsCharacterClass

	/// \todo Should be part of \ref AClassSelection, vJass bug.
	function interface AClassSelectionSelectClassAction takes ACharacter character, AClass class, boolean last returns nothing

	/// \todo Should be part of \ref AClassSelection, vJass bug.
	function interface AClassSelectionCharacterCreationAction takes AClassSelection classSelection, unit whichUnit returns ACharacter

	/**
	 * \brief Simple class selection for the player's character which offers keyboard selection and a multiboard with information about the corresponding class as well as automatic camera view and unit rotation updates.
	 *
	 * The class selection creates the corresponding unit of the class and updates the camera of the player to a fixed view.
	 * It displays a multiboard with the name and a description of the class.
	 * The arrow keys can be used to change the currently displayed class.
	 * The escape key can be used to select the currently displayed class.
	 * It may rotate the shown class unit automatically.
	 *
	 * There is various stub methods which can be overwritten in a sub struct to change the class selection's behaviour.
	 * Besides functions can be passed using \ref AClassSelectionSelectClassAction and \ref AClassSelectionCharacterCreationAction function interfaces to set the behaviour
	 * without extending AClassSelection in a custom struct.
	 *
	 * \sa AClass
	 */
	struct AClassSelection
		// static construction members
		private static camerasetup m_cameraSetup
		private static boolean m_hideUserInterface
		private static real m_x
		private static real m_y
		private static real m_facing
		private static real m_refreshRate
		private static real m_rotationAngle
		private static AClass m_firstClass
		private static AClass m_lastClass
		private static string m_strengthIconPath
		private static string m_agilityIconPath
		private static string m_intelligenceIconPath
		private static string m_textTitle
		private static string m_textStrength
		private static string m_textAgility
		private static string m_textIntelligence
		// static members
		private static thistype array m_playerClassSelection[12] /// \todo \ref bj_MAX_PLAYERS, JassHelper bug
		private static integer m_stack //required for the start game action
		// dynamic members
		private real m_startX
		private real m_startY
		private real m_startFacing
		private boolean m_showAttributes
		private AClassSelectionSelectClassAction m_selectClassAction
		private AClassSelectionCharacterCreationAction m_characterCreationAction
		// construction members
		private player m_user
		// members
		private unit m_classUnit
		private trigger m_leaveTrigger
		private trigger m_refreshTrigger
		private trigger m_changePreviousTrigger
		private trigger m_changeNextTrigger
		private trigger m_selectTrigger
		private multiboard m_infoSheet
		private AClass m_class

		//! runtextmacro optional A_STRUCT_DEBUG("\"AClassSelection\"")

		public static method playerClassSelection takes player whichPlayer returns thistype
			return thistype.m_playerClassSelection[GetPlayerId(whichPlayer)]
		endmethod
		
		// dynamic members
		
		/**
		 * Sets the X coordinate of the start position for the created character.
		 * \param startX The X coordinate of the start position for the created character.
		 */
		public method setStartX takes real startX returns nothing
			set this.m_startX = startX
		endmethod

		public method startX takes nothing returns real
			return this.m_startX
		endmethod
		
		/**
		 * Sets the Y coordinate of the start position for the created character.
		 * \param startY The Y coordinate of the start position for the created character.
		 */
		public method setStartY takes real startY returns nothing
			set this.m_startY = startY
		endmethod

		public method startY takes nothing returns real
			return this.m_startY
		endmethod
		
		/**
		 * Sets the start facing angle for the created character.
		 * \param startFacing The start facing angle for the created character.
		 */
		public method setStartFacing takes real startFacing returns nothing
			set this.m_startFacing = startFacing
		endmethod

		public method startFacing takes nothing returns real
			return this.m_startFacing
		endmethod
		
		/**
		 * If this attribute is set to true it shows the classes' attributes per level in the multiboard.
		 * The attributes per level can be set in \ref AClass.
		 */
		public method setShowAttributes takes boolean showAttributes returns nothing
			set this.m_showAttributes = showAttributes
		endmethod
		
		public method showAttributes takes nothing returns boolean
			return this.m_showAttributes
		endmethod
		
		public method selectClassAction takes nothing returns AClassSelectionSelectClassAction
			return this.m_selectClassAction
		endmethod
		
		public method characterCreationAction takes nothing returns AClassSelectionCharacterCreationAction
			return this.m_characterCreationAction
		endmethod

		// construction members

		public method player takes nothing returns player
			return this.m_user
		endmethod
		
		// members
		
		/**
		 * \return Returns the currently displayed unit of the selected class in the class selection.
		 * \note The unit changes every time another class is selected.
		 */
		public method classUnit takes nothing returns unit
			return this.m_classUnit
		endmethod
		
		/**
		 * \return Returns the currently selected class.
		 */
		public method class takes nothing returns AClass
			return this.m_class
		endmethod

		// methods
		
		/**
		 * Is called via .evaluate() whenever a class is being selected.
		 * By default it evaluates \ref selectClassAction() if it is not 0.
		 * \param last Is true if this is the last class to be selected by a player.
		 */
		public stub method onSelectClass takes ACharacter character, AClass class, boolean last returns nothing
			if (this.selectClassAction() != 0) then
				call this.selectClassAction().evaluate(character, class, last)
			endif
		endmethod
		
		/**
		 * Is called via .evaluate() to create a character whenever one is selected by a class and unit.
		 * By default it calls \ref characterCreationAction() via .evaluate().
		 * If \ref characterCreationAction() is 0 it creates a \ref ACharacter instance from the corresponding player and unit.
		 */
		public stub method onCharacterCreation takes AClassSelection classSelection, unit whichUnit returns ACharacter
			if (this.characterCreationAction() != 0) then
				return this.characterCreationAction().evaluate(classSelection, whichUnit)
			endif
			
			return ACharacter.create(classSelection.player(), whichUnit)
		endmethod
		
		/**
		 * Is called by .evaluate() whenever a class unit is created for a class.
		 * \param whichUnit The created unit of the corresponding class.
		 */
		public stub method onCreate takes unit whichUnit returns nothing
		endmethod
		
		/**
		 * Is called by .evaluate() whenever a player leaves the game who has an active class selection.
		 * It is called before the class selection had been destroyed or the class had been selected automatically and after the control had been shared.
		 */
		public stub method onPlayerLeaves takes player whichPlayer, boolean last returns nothing
		endmethod

		/**
		 * Selects the currently displayed class for the corresponding player and creates a character based on it.
		 * Calls \ref selectClassAction() with .execute().
		 */
		public method selectClass takes nothing returns nothing
			local integer i
			local ACharacter character = 0
			local unit whichUnit = this.m_class.generateUnit(this.m_user, this.startX(), this.startY(), this.startFacing())
			
			set character = this.onCharacterCreation.evaluate(this, whichUnit)
			call ACharacter.setPlayerCharacterByCharacter(character)

			if (GetPlayerController(this.m_user) == MAP_CONTROL_COMPUTER or (GetPlayerSlotState(this.m_user) == PLAYER_SLOT_STATE_LEFT and ACharacter.shareOnPlayerLeaves())) then
				call character.shareControl(true)
				// show info sheet since multiboard with team resources is displayed!
				set i = 0
				loop
					exitwhen (i == bj_MAX_PLAYERS)
					if (IsPlayerPlayingUser(Player(i)) and ACharacter.playerCharacter(Player(i)) == 0) then
						call ShowMultiboardForPlayer(Player(i), thistype.playerClassSelection(Player(i)).m_infoSheet, true)
					endif
					set i = i + 1
				endloop
			endif
			if (thistype.m_hideUserInterface) then
				call SetUserInterfaceForPlayer(this.m_user, true, true)
			endif
			call ResetToGameCameraForPlayer(this.m_user, 0.0)
			call character.setClass(this.m_class)
			call this.onSelectClass.evaluate(character, this.class(), thistype.m_stack == 1)
			debug call Print("Destroy it!")
			call this.destroy()
		endmethod

		private method selectRandomClass takes nothing returns nothing
			set this.m_class = GetRandomInt(thistype.m_firstClass, thistype.m_lastClass)
			call this.selectClass()
		endmethod

		private method mostLineCharacters takes AStringVector initialVector returns integer
			local AStringVector vector = AStringVector.createByOther(initialVector)
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == vector.size())
				if (StringLength(vector[i]) > result) then
					set result = StringLength(vector[i])
				endif
				set i = i + 1
			endloop
			call vector.destroy()
			return result
		endmethod

		private method refreshInfoSheet takes nothing returns nothing
			local integer count = 0
			local integer i
			local multiboarditem multiboardItem
			local string strengthText
			local string agilityText
			local string intelligenceText
			local AStringVector strings = AStringVector.create()
			local integer index = 0

			if (this.showAttributes()) then
				set count = 3
				set strengthText = RWArg(thistype.m_textStrength, this.class().strPerLevel(), 0, 2)
				set agilityText = RWArg(thistype.m_textAgility, this.class().agiPerLevel(), 0, 2)
				set intelligenceText = RWArg(thistype.m_textIntelligence, this.class().intPerLevel(), 0, 2)
				call strings.pushBack(strengthText)
				call strings.pushBack(agilityText)
				call strings.pushBack(intelligenceText)
			endif

			set i = 0
			loop
				exitwhen(i == this.m_class.descriptionLines())
				call strings.pushBack(this.m_class.descriptionLine(i))
				set i = i + 1
			endloop

			//call MultiboardClear(this.m_infoSheet) // clears not everything?!
			call DestroyMultiboard(this.m_infoSheet)
			set this.m_infoSheet = null
			set this.m_infoSheet = CreateMultiboard()
			call MultiboardSetItemsWidth(this.m_infoSheet, this.mostLineCharacters(strings) * 0.005)
			call MultiboardSetColumnCount(this.m_infoSheet, 1)
			call strings.destroy()

			if (this.m_class.descriptionLines() > 0) then
				set count = count + this.m_class.descriptionLines()
			endif

			call MultiboardSetRowCount(this.m_infoSheet, count)
			call MultiboardSetTitleText(this.m_infoSheet, IntegerArg(IntegerArg(StringArg(thistype.m_textTitle, GetUnitName(this.m_classUnit)), this.m_class), thistype.m_lastClass - thistype.m_firstClass + 1))
			if (this.showAttributes()) then
				// strength
				set multiboardItem = MultiboardGetItem(this.m_infoSheet, 0, 0)
				call MultiboardSetItemStyle(multiboardItem, true, true)
				call MultiboardSetItemIcon(multiboardItem, thistype.m_strengthIconPath)
				call MultiboardSetItemValue(multiboardItem, strengthText)
				call MultiboardReleaseItem(multiboardItem)
				set multiboardItem = null
				// agility
				set multiboardItem = MultiboardGetItem(this.m_infoSheet, 1, 0)
				call MultiboardSetItemStyle(multiboardItem, true, true)
				call MultiboardSetItemIcon(multiboardItem, thistype.m_agilityIconPath)
				call MultiboardSetItemValue(multiboardItem, agilityText)
				call MultiboardReleaseItem(multiboardItem)
				set multiboardItem = null
				// intelligence
				set multiboardItem = MultiboardGetItem(this.m_infoSheet, 2, 0)
				call MultiboardSetItemStyle(multiboardItem, true, true)
				call MultiboardSetItemIcon(multiboardItem, thistype.m_intelligenceIconPath)
				call MultiboardSetItemValue(multiboardItem, intelligenceText)
				call MultiboardReleaseItem(multiboardItem)
				set multiboardItem = null
				set index = 3
			endif

			if (this.m_class.descriptionLines() > 0) then

				set i = 0
				loop
					exitwhen(i == this.m_class.descriptionLines())
					set multiboardItem = MultiboardGetItem(this.m_infoSheet, index, 0)
					call MultiboardSetItemStyle(multiboardItem, true, false)
					call MultiboardSetItemValue(multiboardItem, this.m_class.descriptionLine(i))
					call MultiboardReleaseItem(multiboardItem)
					set multiboardItem = null
					set i = i + 1
					set index = index + 1
				endloop
			endif
			call ShowMultiboardForPlayer(this.m_user, this.m_infoSheet, true)
		endmethod

		private method createUnit takes nothing returns nothing
			if (this.m_classUnit != null) then
				call RemoveUnit(this.m_classUnit)
				set this.m_classUnit = null
			endif
			set this.m_classUnit = CreateUnit(this.m_user, this.m_class.unitType(), thistype.m_x, thistype.m_y, thistype.m_facing)
			call SetUnitInvulnerable(this.m_classUnit, true)
			// make sure that the unit does not move or do anything else
			call SetUnitMoveSpeed(this.m_classUnit, 0.0) // should not be moved but be rotatable, the map Azeroth Grandprix uses a movement speed of 0.0 but a rotation rate of 0.10 for the selectable cars
			// do not block units from other players by the unit's pathing
			call SetUnitPathing(this.m_classUnit, false)
			/// \todo Has to be set although unit is being paused?!
			if (IsUnitType(this.m_classUnit, UNIT_TYPE_HERO)) then
				call SuspendHeroXP(this.m_classUnit, true)
			endif
			// refresh position
			call SetUnitPosition(this.m_classUnit, thistype.m_x, thistype.m_y)
			call ShowUnit(this.m_classUnit, false)
			call ShowUnitForPlayer(this.m_user, this.m_classUnit, true)
			call SetUnitAnimation(this.m_classUnit, this.m_class.animation())
			call PlaySoundFileForPlayer(this.m_user, this.m_class.soundPath())
			//call SetCameraTargetControllerNoZForPlayer(this.user, this.classUnit, 0.0, 0.0, false)
			if (not thistype.m_hideUserInterface) then
				call SelectUnitForPlayerSingle(this.m_classUnit, this.m_user)
			endif

			call this.refreshInfoSheet()
			
			call this.onCreate.evaluate(this.m_classUnit)
		endmethod

		public method show takes nothing returns nothing
			if (GetPlayerController(this.m_user) == MAP_CONTROL_COMPUTER or GetPlayerSlotState(this.m_user) == PLAYER_SLOT_STATE_LEFT) then
				call this.selectRandomClass()
			else
				call ClearScreenMessagesForPlayer(this.m_user)
				if (thistype.m_hideUserInterface) then
					call SetUserInterfaceForPlayer(this.m_user, false, true)
				endif
				call this.createUnit()
			endif
		endmethod

		private static method triggerActionPlayerLeaves takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, "this")
			local player whichPlayer
			local integer i
			if (ACharacter.shareOnPlayerLeaves()) then
				set i = 0
				loop
					exitwhen (i == bj_MAX_PLAYERS)
					if (i != GetPlayerId(this.m_user)) then
						set whichPlayer = Player(i)
						call SetPlayerAlliance(this.m_user, whichPlayer, ALLIANCE_SHARED_CONTROL, true)
						set whichPlayer = null
					endif
					set i = i + 1
				endloop
			endif
			call this.onPlayerLeaves.evaluate(GetTriggerPlayer(), thistype.m_stack == 1)
			if (ACharacter.destroyOnPlayerLeaves()) then
				call this.destroy()
			/*
			 * If the character is not destroyed when the player leaves a class is selected automatically.
			 */
			else
				call this.selectClass()
			endif
			set triggeringTrigger = null
		endmethod

		private method createLeaveTrigger takes nothing returns nothing
			set this.m_leaveTrigger = CreateTrigger()
			call TriggerRegisterPlayerEvent(this.m_leaveTrigger, this.m_user, EVENT_PLAYER_LEAVE)
			call TriggerAddAction(this.m_leaveTrigger, function thistype.triggerActionPlayerLeaves)
			call AHashTable.global().setHandleInteger(this.m_leaveTrigger, "this", this)
		endmethod

		private static method triggerActionRefresh takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, "this")
			debug if (thistype.m_cameraSetup != null) then
				call CameraSetupApplyForPlayer(true, thistype.m_cameraSetup, this.m_user, 0.0)
			debug else
				debug call this.print("No camera object.")
			debug endif
			call SetUnitFacingTimed(this.m_classUnit, GetUnitFacing(this.m_classUnit) + thistype.m_rotationAngle, thistype.m_refreshRate)
			set triggeringTrigger = null
		endmethod

		private method createRefreshTrigger takes nothing returns nothing
			if (thistype.m_refreshRate > 0.0) then
				set this.m_refreshTrigger = CreateTrigger()
				call TriggerRegisterTimerEvent(this.m_refreshTrigger, thistype.m_refreshRate, true)
				call TriggerAddAction(this.m_refreshTrigger, function thistype.triggerActionRefresh)
				call AHashTable.global().setHandleInteger(this.m_refreshTrigger, "this", this)
			endif
		endmethod
		
		/**
		 * Changes to the previous class in selection.
		 */
		public method changeToPrevious takes nothing returns nothing
			if (this.m_class == thistype.m_firstClass) then
				set this.m_class = thistype.m_lastClass
			else
				set this.m_class = this.m_class - 1
			endif
			call this.createUnit()
		endmethod
		
		/**
		 * Changes to the next class in selection.
		 */
		public method changeToNext takes nothing returns nothing
			if (this.m_class == thistype.m_lastClass) then
				set this.m_class = thistype.m_firstClass
			else
				set this.m_class = this.m_class + 1
			endif
			call this.createUnit()
		endmethod

		private static method triggerActionChangeToPrevious takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			call this.changeToPrevious()
		endmethod

		private method createChangePreviousTrigger takes nothing returns nothing
			set this.m_changePreviousTrigger = CreateTrigger()
			call TriggerRegisterKeyEventForPlayer(this.m_user, this.m_changePreviousTrigger, AKeyLeft, true)
			call TriggerAddAction(this.m_changePreviousTrigger, function thistype.triggerActionChangeToPrevious)
			call AHashTable.global().setHandleInteger(this.m_changePreviousTrigger, "this", this)
		endmethod

		private static method triggerActionChangeToNext takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			call this.changeToNext()
		endmethod

		private method createChangeNextTrigger takes nothing returns nothing
			set this.m_changeNextTrigger = CreateTrigger()
			call TriggerRegisterKeyEventForPlayer(this.m_user, this.m_changeNextTrigger, AKeyRight, true)
			call TriggerAddAction(this.m_changeNextTrigger, function thistype.triggerActionChangeToNext)
			call AHashTable.global().setHandleInteger(this.m_changeNextTrigger, "this", this)
		endmethod

		private static method triggerActionSelectClass takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			call this.selectClass()
		endmethod

		private method createSelectTrigger takes nothing returns nothing
			set this.m_selectTrigger = CreateTrigger()
			call TriggerRegisterKeyEventForPlayer(this.m_user, this.m_selectTrigger, AKeyEscape, true)
			call TriggerAddAction(this.m_selectTrigger, function thistype.triggerActionSelectClass)
			call AHashTable.global().setHandleInteger(this.m_selectTrigger, "this", this)
		endmethod

		private method createInfoSheet takes nothing returns nothing
			set this.m_infoSheet = CreateMultiboard()
		endmethod

		public static method create takes player user returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_startFacing = 0.0
			set this.m_startX = 0.0
			set this.m_startY = 0.0
			set this.m_showAttributes = false
			set this.m_selectClassAction = 0
			set this.m_characterCreationAction = 0
			// construction members
			set this.m_user = user
			// members
			set this.m_class = thistype.m_firstClass
			// static members
			set thistype.m_playerClassSelection[GetPlayerId(user)] = this
			set thistype.m_stack = thistype.m_stack + 1

			call this.createLeaveTrigger()
			call this.createRefreshTrigger()
			call this.createChangePreviousTrigger()
			call this.createChangeNextTrigger()
			call this.createSelectTrigger()
			call this.createInfoSheet()
			return this
		endmethod

		private method destroyLeaveTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_leaveTrigger)
			set this.m_leaveTrigger = null
		endmethod

		private method destroyRefreshTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_refreshTrigger)
			set this.m_refreshTrigger = null
		endmethod

		private method destroyChangePreviousTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_changePreviousTrigger)
			set this.m_changePreviousTrigger = null
		endmethod

		private method destroyChangeNextTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_changeNextTrigger)
			set this.m_changeNextTrigger = null
		endmethod

		private method destroySelectTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_selectTrigger)
			set this.m_selectTrigger = null
		endmethod

		private method destroyInfoSheet takes nothing returns nothing
			call DestroyMultiboard(this.m_infoSheet)
			set this.m_infoSheet = null
		endmethod

		private method removeClassUnit takes nothing returns nothing
			call RemoveUnit(this.m_classUnit)
			set this.m_classUnit = null
		endmethod

		private method onDestroy takes nothing returns nothing
			// construction members
			set this.m_user = null
			// static members
			set thistype.m_stack = thistype.m_stack - 1

			call this.destroyLeaveTrigger()
			call this.destroyRefreshTrigger()
			call this.destroyChangePreviousTrigger()
			call this.destroyChangeNextTrigger()
			call this.destroySelectTrigger()
			call this.destroyInfoSheet()
			call this.removeClassUnit()
		endmethod

		public static method init takes camerasetup cameraSetup, boolean hideUserInterface, real x, real y, real facing, real refreshRate, real rotationAngle, AClass firstClass, AClass lastClass, string strengthIconPath, string agilityIconPath, string intelligenceIconPath, string textTitle, string textStrength, string textAgility, string textIntelligence returns nothing
			local integer i
			// static construction members
			set thistype.m_cameraSetup = cameraSetup
			set thistype.m_hideUserInterface = hideUserInterface
			set thistype.m_x = x
			set thistype.m_y = y
			set thistype.m_facing = facing
			set thistype.m_refreshRate = refreshRate
			set thistype.m_rotationAngle = rotationAngle
			set thistype.m_firstClass = firstClass
			set thistype.m_lastClass = lastClass
			set thistype.m_strengthIconPath = strengthIconPath
			set thistype.m_agilityIconPath = agilityIconPath
			set thistype.m_intelligenceIconPath = intelligenceIconPath
			set thistype.m_textTitle = textTitle
			set thistype.m_textStrength = textStrength
			set thistype.m_textAgility = textAgility
			set thistype.m_textIntelligence = textIntelligence
			//static members
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set thistype.m_playerClassSelection[i] = 0
				set i = i + 1
			endloop
			set thistype.m_stack = 0
		endmethod
	endstruct

endlibrary