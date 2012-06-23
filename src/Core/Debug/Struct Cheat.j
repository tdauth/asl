/// \author Tamino Dauth
library AStructCoreDebugCheat requires ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, ALibraryCoreGeneralPlayer

	/// \todo Should be a part of \ref ACheat, vJass bug.
	function interface ACheatOnCheatAction takes ACheat cheat returns nothing

	/**
	 * ACheat provides simple cheat functionality. Cheats are strings which has to be entered by one player into the chat and which are connected to a user-defined function called "action" using interface \ref ACheatOnCheatAction which is called via .execute() immediately after the cheat was sent to the screen.
	 *
	 * Some cheats might have arguments. For example, you could create a cheat  called "setlevel" which
	 * expects a level value after the cheat expression.
	 * Since you can create cheats without requiring exact match on entered chat string, arguments can be passed, as well.
	 * Use \ref thistype#arguments() to get them in your custom function.
	 *
	 * \note Note that you can use \ref GetEventPlayerChatString() in the corresponding function to read the whole entered chat string.
	 */
	struct ACheat
		// construction members
		private string m_cheat
		private boolean m_exactMatch
		private ACheatOnCheatAction m_action
		// members
		private trigger m_cheatTrigger

		//! runtextmacro optional A_STRUCT_DEBUG("\"ACheat\"")

		// construction members

		public method cheat takes nothing returns string
			return this.m_cheat
		endmethod

		public method exactMatch takes nothing returns boolean
			return this.m_exactMatch
		endmethod

		// methods

		/**
		 * \return Returns the whole entered cheat without the cheat expression itself refered as cheat arguments.
		 * For example, if player has entered "setlevel 3 all" and "setlevel" is the actual cheat this would return "3 all".
		 * \note This doesn only works if \ref exactMatch() is false.
		 * \todo Use more flexible tokenizer. What about cheats which do have some tokens before???
		 */
		public method argument takes nothing returns string
			return SubString(GetEventPlayerChatString(), StringLength(this.m_cheat) + 1, StringLength(GetEventPlayerChatString()))
		endmethod

		private static method triggerActionCheat takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, "this")
			call this.m_action.execute(this)
			set triggeringTrigger = null
		endmethod

		private method createCheatTrigger takes nothing returns nothing
			local integer i
			local player user
			local event triggerEvent
			local triggeraction triggerAction
			set this.m_cheatTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (IsPlayerPlayingUser(user)) then
					set triggerEvent = TriggerRegisterPlayerChatEvent(this.m_cheatTrigger, user, this.m_cheat, this.m_exactMatch)
					set triggerEvent = null
				endif
				set user = null
				set i = i + 1
			endloop
			set triggerAction = TriggerAddAction(this.m_cheatTrigger, function thistype.triggerActionCheat)
			set triggerAction = null
			call AHashTable.global().setHandleInteger(this.m_cheatTrigger, "this", this)
		endmethod

		/**
		 * \param cheat String value a player has to enter into the chat.
		 * \param exactMatch If this value is false user does not have to enter the exact string of \p cheat to run the cheat. For example if the cheat string is "setlevel" "setlevel 1000" would work, as well.
		 * \param action The function which will be called when any player enters cheat string. Consider that it is called via .execute() not .evaluate()!
		 */
		public static method create takes string cheat, boolean exactMatch, ACheatOnCheatAction action returns thistype
			local thistype this = thistype.allocate()
			debug if (cheat == null) then
				debug call this.print("cheat is empty.")
			debug endif
			debug if (action == 0) then
				debug call this.print("action is 0.")
			debug endif
			// construction members
			set this.m_cheat = cheat
			set this.m_exactMatch = exactMatch
			set this.m_action = action

			call this.createCheatTrigger()
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_cheatTrigger)
			set this.m_cheatTrigger = null
		endmethod
	endstruct

endlibrary