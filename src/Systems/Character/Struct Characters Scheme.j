library AStructSystemsCharacterCharactersScheme requires optional ALibraryCoreDebugMisc, AStructCoreInterfaceMultiboardBar, ALibraryCoreInterfaceMisc, ALibraryCoreInterfaceMultiboard, AStructSystemsCharacterCharacter

	/// \todo Should be contained by \ref ACharactersScheme, vJass bug.
	function interface ACharactersSchemeMaxExperience takes unit hero returns integer

	/**
	 * Characters scheme uses one multiboard to display information about all playing characters.
	 * These information can be:
	 * <ul>
	 * <li>player name</li>
	 * <li>class</li>
	 * <li>level</li>
	 * <li>experience until next level</li>
	 * <li>life</li>
	 * <li>mana</li>
	 * <li>gold</li>
	 * </ul>
	 * \todo Make player rows more dynamic (add struct like ACharactersSchemeRow) that they can be moved and hidden.
	 * \todo Add resources lumber and supply.
	 * \todo Set more default values (for icons etc.)
	 */
	struct ACharactersScheme
		// static construction members
		private static real m_refreshRate
		private static boolean m_showPlayerName
		private static boolean m_showUnitName
		private static boolean m_showLevel
		private static integer m_experienceLength
		private static ACharactersSchemeMaxExperience m_experienceFormula
		private static integer m_hitPointsLength
		private static integer m_manaLength
		private static boolean m_showGold
		private static string m_textTitle
		private static string m_textLevel
		private static string m_textLeftGame
		private static string m_iconGold
		// static dynamic members
		private static real m_firstColumnWidth
		private static real m_goldColumnWidth
		// static members
		private static trigger m_refreshTrigger
		private static multiboard m_multiboard
		private static AMultiboardBar array m_experienceBar[12] /// \todo \ref bj_MAX_PLAYERS
		private static AMultiboardBar array m_hitPointsBar[12] /// \todo \ref bj_MAX_PLAYERS, vJass bug
		private static AMultiboardBar array m_manaBar[12] /// \todo \ref bj_MAX_PLAYERS
		/**
		 * Stores the row number starting with 0 for each player.
		 * If a player has no row because he has no character it stores -1.
		 */
		private static integer array m_playerRow[12] /// \todo \ref bj_MAX_PLAYERS
		/**
		 * Stores if a row has been destroyed.
		 * This is true for rows of players who have left the game.
		 */
		private static boolean array m_destroyed[12] /// \todo \ref bj_MAX_PLAYERS
		/**
		 * Stores the limit number of players which have an active row.
		 */
		private static integer m_maxPlayers
		/**
		 * Stores the column index where the gold values are shown.
		 */
		private static integer m_goldColumn

		//! runtextmacro optional A_STRUCT_DEBUG("\"ACharactersScheme\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method firstColumnExists takes nothing returns boolean
			return thistype.m_showPlayerName or thistype.m_showUnitName or thistype.m_showLevel
		endmethod

		private static method firstColumnString takes ACharacter character returns string
			local string text = ""
			if (thistype.m_showPlayerName) then
				set text = GetColoredPlayerName(character.player())
			endif
			if (thistype.m_showUnitName) then
				set text = text + " [" + GetUnitName(character.unit()) + "]"
			endif
			if (thistype.m_showLevel) then
				if (IsUnitType(character.unit(), UNIT_TYPE_HERO)) then
					set text = text + " - " + thistype.m_textLevel + " " + I2S(GetHeroLevel(character.unit()))
				// if hero has overtaken an enemy etc.
				else
					set text = text + " - " + thistype.m_textLevel + " " + I2S(GetUnitLevel(character.unit()))
				endif
			endif
			return text
		endmethod
		
		private static method firstColumnWidth takes nothing returns real
			return thistype.m_firstColumnWidth
		endmethod
		
		private static method goldColumWidth takes nothing returns real
			return thistype.m_goldColumnWidth
		endmethod

		private static method triggerActionRefresh takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.m_maxPlayers)
				// renew OpLimit with .evaluate() since the method call is quite long.
				call thistype.refreshPlayerRow.evaluate(i)
				set i = i + 1
			endloop
		endmethod
		
		private static method refreshPlayerRow takes integer index returns nothing
			local integer row
			local real firstColumnWidth = thistype.firstColumnWidth()
			local real goldColumWidth = thistype.goldColumWidth()
			local multiboarditem multiboardItem
			local string columnString
			if ((IsPlayerPlayingUser(Player(index)) and ACharacter.playerCharacter(Player(index)) != 0) or (ACharacter.shareOnPlayerLeaves() and ACharacter.playerCharacter(Player(index)) != 0)) then
				set row = thistype.m_playerRow[GetPlayerId(Player(index))]
				if (thistype.firstColumnExists()) then
					set multiboardItem = MultiboardGetItem(thistype.m_multiboard, row, 0)
					set columnString = thistype.firstColumnString(ACharacter.playerCharacter(Player(index)))
					call MultiboardSetItemValue(multiboardItem, columnString)
					call MultiboardSetItemWidth(multiboardItem, firstColumnWidth)
					call MultiboardReleaseItem(multiboardItem)
					set multiboardItem = null
				endif

				if (IsUnitAliveBJ(ACharacter.playerCharacter(Player(index)).unit())) then
					if (thistype.m_experienceLength > 0) then
						if (IsUnitType(ACharacter.playerCharacter(Player(index)).unit(), UNIT_TYPE_HERO)) then
							call thistype.m_experienceBar[row].setValue(GetHeroXP(ACharacter.playerCharacter(Player(index)).unit()))
							call thistype.m_experienceBar[row].setMaxValue(thistype.m_experienceFormula.evaluate(ACharacter.playerCharacter(Player(index)).unit()))
							call thistype.m_experienceBar[row].refresh()
						endif
					endif

					if (thistype.m_hitPointsLength > 0) then
						call thistype.m_hitPointsBar[row].setValue(GetUnitState(ACharacter.playerCharacter(Player(index)).unit(), UNIT_STATE_LIFE))
						call thistype.m_hitPointsBar[row].setMaxValue(GetUnitState(ACharacter.playerCharacter(Player(index)).unit(), UNIT_STATE_MAX_LIFE))
						// renew OpLimit with .evaluate() since the method call is quite long.
						call thistype.m_hitPointsBar[row].refresh.evaluate()
					endif

					if (thistype.m_manaLength > 0) then
						call thistype.m_manaBar[row].setValue(GetUnitState(ACharacter.playerCharacter(Player(index)).unit(), UNIT_STATE_MANA))
						call thistype.m_manaBar[row].setMaxValue(GetUnitState(ACharacter.playerCharacter(Player(index)).unit(), UNIT_STATE_MAX_MANA))
						// renew OpLimit with .evaluate() since the method call is quite long.
						call thistype.m_manaBar[row].refresh.evaluate()
					endif
				else
					if (thistype.m_hitPointsLength > 0) then
						call thistype.m_hitPointsBar[row].setValue(0)
						call thistype.m_hitPointsBar[row].setMaxValue(1)
						// renew OpLimit with .evaluate() since the method call is quite long.
						call thistype.m_hitPointsBar[row].refresh.evaluate()
					endif

					if (thistype.m_manaLength > 0) then
						call thistype.m_manaBar[row].setValue(0)
						call thistype.m_manaBar[row].setMaxValue(1)
						// renew OpLimit with .evaluate() since the method call is quite long.
						call thistype.m_manaBar[row].refresh.evaluate()
					endif
				endif
				
				if (thistype.m_showGold) then
					set multiboardItem = MultiboardGetItem(thistype.m_multiboard, row, thistype.m_goldColumn)
					set columnString = I2S(GetPlayerState(Player(index), PLAYER_STATE_RESOURCE_GOLD))
					call MultiboardSetItemValue(multiboardItem, columnString)
					call MultiboardSetItemWidth(multiboardItem, goldColumWidth)
					call MultiboardReleaseItem(multiboardItem)
					set multiboardItem = null
				endif
			elseif (thistype.m_playerRow[index] != -1 and not thistype.m_destroyed[thistype.m_playerRow[index]]) then
				set row = thistype.m_playerRow[GetPlayerId(Player(index))]
				if (thistype.firstColumnExists()) then
					set multiboardItem = MultiboardGetItem(thistype.m_multiboard, row, 0)
					call MultiboardSetItemValue(multiboardItem, thistype.m_textLeftGame)
					call MultiboardSetItemWidth(multiboardItem, firstColumnWidth)
					call MultiboardReleaseItem(multiboardItem)
					set multiboardItem = null
				endif

				if (thistype.m_experienceLength > 0) then
					call thistype.m_experienceBar[row].destroy()
					set thistype.m_experienceBar[row] = 0
				endif

				if (thistype.m_hitPointsLength > 0) then
					call thistype.m_hitPointsBar[row].destroy()
					set thistype.m_hitPointsBar[row] = 0
				endif

				if (thistype.m_manaLength > 0) then
					call thistype.m_manaBar[row].destroy()
					set thistype.m_manaBar[row] = 0
				endif

				set thistype.m_destroyed[row] = true
			endif
		endmethod

		private static method createRefreshTrigger takes nothing returns nothing
			set thistype.m_refreshTrigger = CreateTrigger()
			call TriggerRegisterTimerEvent(thistype.m_refreshTrigger, thistype.m_refreshRate, true)
			call TriggerAddAction(thistype.m_refreshTrigger, function thistype.triggerActionRefresh)
			call DisableTrigger(thistype.m_refreshTrigger)
		endmethod

		/// Call this AFTER character creation/character class selection
		private static method createMultiboard takes nothing returns nothing
			local integer i
			local integer column
			set thistype.m_multiboard = CreateMultiboard()
			call MultiboardDisplay(thistype.m_multiboard, false)
			call MultiboardSetTitleText(thistype.m_multiboard, thistype.m_textTitle)
			set column = thistype.m_experienceLength + thistype.m_hitPointsLength + thistype.m_manaLength
			if (thistype.firstColumnExists()) then
				set column = column + 1
			endif
			if (thistype.m_showGold) then
				set column = column + 1
			endif
			call MultiboardSetColumnCount(thistype.m_multiboard, column)
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				// renew OpLimit with .evaluate() since the method call is quite long.
				if (thistype.createPlayerRow.evaluate(i)) then
					set thistype.m_maxPlayers = i + 1
				endif
				set i = i + 1
			endloop
		endmethod
		
		private static method createPlayerRow takes integer index returns boolean
			local integer row
			local multiboarditem multiboardItem
			local string columnString
			local integer column
			if (ACharacter.playerCharacter(Player(index)) != 0) then
				set thistype.m_playerRow[index] = MultiboardGetRowCount(thistype.m_multiboard)
				set row = thistype.m_playerRow[index]
				set thistype.m_destroyed[row] = false
				call MultiboardSetRowCount(thistype.m_multiboard, MultiboardGetRowCount(thistype.m_multiboard) + 1)

				if (thistype.firstColumnExists.evaluate()) then
					set multiboardItem = MultiboardGetItem(thistype.m_multiboard, row, 0)
					call MultiboardSetItemStyle(multiboardItem, true, false)
					call MultiboardReleaseItem(multiboardItem)
					set multiboardItem = null
				endif

				if (thistype.m_experienceLength > 0) then
					if (thistype.firstColumnExists()) then
						set column = 1
					else
						set column = 0
					endif
					set thistype.m_experienceBar[row] = AMultiboardBar.create(thistype.m_multiboard, column, row, thistype.m_experienceLength, 0.0, true)
				endif

				if (thistype.m_hitPointsLength > 0) then
					if (thistype.m_experienceLength > 0) then
						set column = thistype.m_experienceBar[row].firstFreeField()
					elseif (thistype.firstColumnExists()) then
						set column = 1
					else
						set column = 0
					endif

					set thistype.m_hitPointsBar[row] = AMultiboardBar.create(thistype.m_multiboard, column, row, thistype.m_hitPointsLength, 0.0, true)
				endif

				if (thistype.m_manaLength > 0) then
					if (thistype.m_hitPointsLength > 0) then
						set column = thistype.m_hitPointsBar[row].firstFreeField()
					elseif (thistype.m_experienceLength > 0) then
						set column = thistype.m_experienceBar[row].firstFreeField()
					elseif (thistype.firstColumnExists()) then
						set column = 1
					else
						set column = 0
					endif

					set thistype.m_manaBar[row] = AMultiboardBar.create(thistype.m_multiboard, column, row, thistype.m_manaLength, 0.0, true)
				endif
				
				if (thistype.m_showGold) then
					if (thistype.m_manaLength > 0) then
						set column = thistype.m_manaBar[row].firstFreeField()
					elseif (thistype.m_hitPointsLength > 0) then
						set column = thistype.m_hitPointsBar[row].firstFreeField()
					elseif (thistype.m_experienceLength > 0) then
						set column = thistype.m_experienceBar[row].firstFreeField()
					elseif (thistype.firstColumnExists()) then
						set column = 1
					else
						set column = 0
					endif

					set thistype.m_goldColumn = column
					set multiboardItem = MultiboardGetItem(thistype.m_multiboard, row, column)
					call MultiboardSetItemStyle(multiboardItem, true, true)
					call MultiboardSetItemIcon(multiboardItem, thistype.m_iconGold)
					call MultiboardSetItemValue(multiboardItem, "0")
					call MultiboardReleaseItem(multiboardItem)
					set multiboardItem = null
				endif

				return true
			endif
			
			return false
		endmethod

		/**
		 * Call this method before you use this struct!
		 * Call this after a trigger sleep action, multiboard is created!
		 * Call this AFTER character creation/character class selection
		 * \param refreshRate Should be bigger than 0.0.
		 * \param experienceFormula Function which returns the maximum experience of a hero.
		 */
		public static method init takes real refreshRate, boolean showPlayerName, boolean showUnitName, boolean showLevel, integer experienceLength, ACharactersSchemeMaxExperience experienceFormula, integer hitPointsLength, integer manaLength, boolean showGold, string textTitle, string textLevel, string textLeftGame, string iconGold returns nothing
			local integer i
			// static construction members
			set thistype.m_refreshRate = refreshRate
			debug if (refreshRate <= 0) then
				debug call thistype.staticPrint("Refresh rate is <= 0")
			debug endif
			set thistype.m_showPlayerName = showPlayerName
			set thistype.m_showUnitName = showUnitName
			set thistype.m_showLevel = showLevel
			set thistype.m_experienceLength = experienceLength
			set thistype.m_experienceFormula = experienceFormula
			set thistype.m_hitPointsLength = hitPointsLength
			set thistype.m_manaLength = manaLength
			set thistype.m_showGold = showGold
			set thistype.m_textTitle = textTitle
			set thistype.m_textLevel = textLevel
			set thistype.m_textLeftGame = textLeftGame
			set thistype.m_iconGold = iconGold
			// static dynamic members
			set thistype.m_firstColumnWidth = 0.20
			set thistype.m_goldColumnWidth = 0.04 // must be able to show 1 000 000 gold
			// static members
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set thistype.m_destroyed[i] = true
				set thistype.m_playerRow[i] = -1
				set i = i + 1
			endloop
			call thistype.createRefreshTrigger()
			call thistype.createMultiboard()
		endmethod

		public static method setExperienceBarValueIconForCharacter takes ACharacter character, integer length, string valueIcon returns nothing
			debug if (GetPlayerId(character.player()) >= thistype.m_maxPlayers) then
				debug call thistype.staticPrint("Character " + I2S(character) + " is not contained.")
			debug endif
			call thistype.m_experienceBar[GetPlayerId(character.player())].setValueIcon(length, valueIcon)
		endmethod

		public static method setExperienceBarEmptyIconForCharacter takes ACharacter character, integer length, string emptyIcon returns nothing
			debug if (GetPlayerId(character.player()) >= thistype.m_maxPlayers) then
				debug call thistype.staticPrint("Character " + I2S(character) + " is not contained.")
			debug endif
			call thistype.m_experienceBar[GetPlayerId(character.player())].setEmptyIcon(length, emptyIcon)
		endmethod

		public static method setExperienceBarValueIcon takes integer length, string valueIcon returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.m_maxPlayers)
				if (not thistype.m_destroyed[i]) then
					call thistype.m_experienceBar[i].setValueIcon(length, valueIcon)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method setExperienceBarEmptyIcon takes integer length, string emptyIcon returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.m_maxPlayers)
				if (not thistype.m_destroyed[i]) then
					call thistype.m_experienceBar[i].setEmptyIcon(length, emptyIcon)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method setHitPointsBarValueIconForCharacter takes ACharacter character, integer length, string valueIcon returns nothing
			debug if (GetPlayerId(character.player()) >= thistype.m_maxPlayers) then
				debug call thistype.staticPrint("Character " + I2S(character) + " is not contained.")
			debug endif
			call thistype.m_hitPointsBar[GetPlayerId(character.player())].setValueIcon(length, valueIcon)
		endmethod

		public static method setHitPointsBarEmptyIconForCharacter takes ACharacter character, integer length, string emptyIcon returns nothing
			debug if (GetPlayerId(character.player()) >= thistype.m_maxPlayers) then
				debug call thistype.staticPrint("Character " + I2S(character) + " is not contained.")
			debug endif
			call thistype.m_hitPointsBar[GetPlayerId(character.player())].setEmptyIcon(length, emptyIcon)
		endmethod

		public static method setHitPointsBarValueIcon takes integer length, string valueIcon returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.m_maxPlayers)
				if (not thistype.m_destroyed[i]) then
					call thistype.m_hitPointsBar[i].setValueIcon(length, valueIcon)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method setHitPointsBarEmptyIcon takes integer length, string emptyIcon returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.m_maxPlayers)
				if (not thistype.m_destroyed[i]) then
					call thistype.m_hitPointsBar[i].setEmptyIcon(length, emptyIcon)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method setManaBarValueIconForCharacter takes ACharacter character, integer length, string valueIcon returns nothing
			debug if (GetPlayerId(character.player()) >= thistype.m_maxPlayers) then
				debug call thistype.staticPrint("Character " + I2S(character) + " is not contained.")
			debug endif
			call thistype.m_manaBar[GetPlayerId(character.player())].setValueIcon(length, valueIcon)
		endmethod

		public static method setManaBarEmptyIconForCharacter takes ACharacter character, integer length, string emptyIcon returns nothing
			debug if (GetPlayerId(character.player()) >= thistype.m_maxPlayers) then
				debug call thistype.staticPrint("Character " + I2S(character) + " is not contained.")
			debug endif
			call thistype.m_manaBar[GetPlayerId(character.player())].setEmptyIcon(length, emptyIcon)
		endmethod

		public static method setManaBarValueIcon takes integer length, string valueIcon returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.m_maxPlayers)
				if (not thistype.m_destroyed[i]) then
					call thistype.m_manaBar[i].setValueIcon(length, valueIcon)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method setManaBarEmptyIcon takes integer length, string emptyIcon returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.m_maxPlayers)
				if (not thistype.m_destroyed[i]) then
					call thistype.m_manaBar[i].setEmptyIcon(length, emptyIcon)
				endif
				set i = i + 1
			endloop
		endmethod
		
		public static method setBarWidths takes real width returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.m_maxPlayers)
				if (not thistype.m_destroyed[i]) then
					if (thistype.m_experienceLength > 0) then
						call thistype.m_experienceBar[i].setAllWidths(width)
					endif
					if (thistype.m_hitPointsLength > 0) then
						call thistype.m_hitPointsBar[i].setAllWidths(width)
					endif
					if (thistype.m_manaLength > 0) then
						call thistype.m_manaBar[i].setAllWidths(width)
					endif
				endif
				set i = i + 1
			endloop
		endmethod

		public static method show takes nothing returns nothing
			call thistype.triggerActionRefresh()
			call EnableTrigger(thistype.m_refreshTrigger)
			call MultiboardDisplay(thistype.m_multiboard, true)
		endmethod

		public static method showForPlayer takes player user returns nothing
			call thistype.triggerActionRefresh()
			if (not IsTriggerEnabled(thistype.m_refreshTrigger)) then
				call EnableTrigger(thistype.m_refreshTrigger)
			endif
			call ShowMultiboardForPlayer(user, thistype.m_multiboard, true)
		endmethod

		public static method hide takes nothing returns nothing
			call MultiboardDisplay(thistype.m_multiboard, false)
			call DisableTrigger(thistype.m_refreshTrigger)
		endmethod

		public static method hideForPlayer takes player user returns nothing
			call ShowMultiboardForPlayer(user, thistype.m_multiboard, false)
		endmethod

		public static method maximize takes nothing returns nothing
			call EnableTrigger(thistype.m_refreshTrigger)
			call MultiboardMinimize(thistype.m_multiboard, false)
		endmethod

		public static method minimize takes nothing returns nothing
			call MultiboardMinimize(thistype.m_multiboard, true)
			call DisableTrigger(thistype.m_refreshTrigger)
		endmethod
	endstruct

endlibrary