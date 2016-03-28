/**
 * ADialogVote extends AVote and makes it possible to start votes via dialogs.
 * Provide two default actions: onVote and onResult which can display user-defined messages.
 * Remove static init method and members.
 * Add member m_duration of type \ref ADuration which indicates the vote's duration.
 * Add settings for displaying a timer dialog to players if voting is time limited.
 * Drop function interface and corresponding result aciton (stub method overwriting only).
 */

library AStructSystemsGuiVote

	private struct AVoteChoice
		private string m_message
		private integer m_votes

		public method message takes nothing returns string
			return this.m_message
		endmethod

		public method vote takes nothing returns nothing
			set this.m_votes = this.m_votes + 1
		endmethod

		public method removeVote takes nothing returns nothing
			set this.m_votes = this.m_votes - 1
		endmethod

		public method votes takes nothing returns integer
			return this.m_votes
		endmethod

		public static method create takes string message returns thistype
			local thistype this = thistype.allocate()
			set this.m_message = message
			set this.m_votes = 0
			return this
		endmethod
	endstruct

	private struct AVotePlayer
		private player m_player
		private integer m_choice

		public method player takes nothing returns player
			return this.m_player
		endmethod

		public method vote takes integer choice returns nothing
			set this.m_choice = choice
		endmethod

		public method choice takes nothing returns integer
			return this.m_choice
		endmethod

		public static method create takes player whichPlayer returns thistype
			local thistype this = thistype.allocate()
			set this.m_player = whichPlayer
			set this.m_choice = -1
			return this
		endmethod
	endstruct

	/**
	 * Provides simple vote functionality for players by using Warcraft 3 dialogs.
	 * Players can be added and removed dynamically.
	 * Use \ref AVote#setRecognizePlayerLeavings to prevent endless votes when a player leaves the game.
	 * The vote's result action can be specified by extending your custom struct by \ref AVote and overwriting \ref AVote#onResult.
	 * Votes has to be started by using \ref AVote#start.
	 * \note There should always be only one running vote per player. Use \ref AVote#playerVote to get a player's running vote and \ref AVote#runs to check if the vote is running.
	*/
	struct AVote
		// dynamic members
		private boolean m_recognizePlayerLeavings
		private ADuration m_duration
		private boolean m_showDurationTimerDialog /// Default value should be true. Timer dialog is only shown if duration delayed (\ref ADuration#delayed()).
		// members
		private boolean m_runs
		private AIntegerVector m_choices /// \ref AVoteChoice
		private AIntegerVector m_players /// \ref AVotePlayer
		private trigger m_leaveTrigger
		private timer m_timer
		private timerdialog m_timerDialog
		
		//! runtextmacro A_STRUCT_DEBUG("\"AVote\"")

		// dynamic members

		public method setMessage takes string message returns nothing
			set this.m_message = message
		endmethod

		public method message takes nothing returns string
			return this.m_message
		endmethod

		private static method triggerActionPlayerLeaves takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.removePlayer(GetTriggerPlayer())
		endmethod

		public method setRecognizePlayerLeavings takes boolean flag returns nothing
			local integer i
			set this.m_recognizePlayerLeavings = flag
			if (flag and this.m_leaveTrigger == null) then
				set this.m_leaveTrigger = CreateTrigger()
				set i = 0
				loop
					exitwhen (i == this.m_players.size())
					call TriggerRegisterPlayerEvent(this.m_leaveTrigger, AVotePlayer(this.m_players[i]).player(), EVENT_PLAYER_LEAVE)
					set i = i + 1
				endloop
				call TriggerAddAction(this.m_leaveTrigger, function thistype.triggerActionPlayerLeaves)
				call AHashTable.global().setHandleInteger(this.m_leaveTrigger, 0, this)
			elseif (not flag and this.m_leaveTrigger != null) then
				call AHashTable.global().destroyTrigger(this.m_leaveTrigger)
				set this.m_leaveTrigger = null
			endif
		endmethod

		public method recognizePlayerLeavings takes nothing returns boolean
			return this.m_recognizePlayerLeavings
		endmethod

		// members

		public method runs takes nothing returns boolean
			return this.m_runs
		endmethod

		// method

		public stub method onResult takes nothing returns nothing
		endmethod

		public method result takes nothing returns integer
			local integer result = 0
			local integer i = 1
			loop
				exitwhen (i == this.m_choices.size())
				if (AVoteChoice(this.m_choices[i]).votes() > AVoteChoice(this.m_choices[result]).votes()) then
					set result = i
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		private method playerIndex takes player whichPlayer returns integer
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (AVotePlayer(this.m_players[i]).player() == whichPlayer) then
					return i
				endif
				set i = i + 1
			endloop
			return -1
		endmethod

		private method player takes player whichPlayer returns AVotePlayer
			local integer index = this.playerIndex(whichPlayer)
			if (index != -1) then
				return AVotePlayer(this.m_players[index])
			endif
			return 0
		endmethod

		/**
		* @return Returns the vote's result. If there isn't any yet it returns -1.
		*/
		public method addVote takes player whichPlayer, integer choice returns integer
			local AVotePlayer data = this.player(whichPlayer)
			local integer i
			local integer result = 0
			if (data == 0 or choice < 0 or choice >= this.m_choices.size()) then
				return -1
			endif
			call AVoteChoice(this.m_choices[choice]).vote()
			call data.vote(choice)
			// show message
			set i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (AVotePlayer(this.m_players[i]).player() != whichPlayer) then
					call DisplayTimedTextToPlayer(whichPlayer, 0.0, 0.0, thistype.m_messageDuration, Format(thistype.m_voteMessage).s(GetPlayerName(whichPlayer)).s(AVoteChoice(this.m_choices[choice]).message()).i(AVoteChoice(this.m_choices[choice]).votes()).result())
				endif
				if (AVotePlayer(this.m_players[i]).choice() == -1) then
					set result = -1
				endif
				set i = i + 1
			endloop
			if (result == -1) then
				return -1
			endif
			set result = this.result()
			set i = 0
			loop
				exitwhen (i == this.m_players.size())
				call AHashTable.global().removeHandleInteger(AVotePlayer(this.m_players[i]).player(), "AVote")
				call DisplayTimedTextToPlayer(AVotePlayer(this.m_players[i]).player(), 0.0, 0.0, thistype.m_messageDuration, Format(thistype.m_resultMessage).s(AVoteChoice(this.m_choices[result]).message()).i(AVoteChoice(this.m_choices[result]).votes()).result())
				set i = i + 1
			endloop
			call this.onResult()
			set this.m_runs = false
			return result
		endmethod

		/// @return Returns player's whichPlayer running vote. If there is no running vote for player whichPlayer it returns 0.
		public static method playerVote takes player whichPlayer returns thistype
			return AHashTable.global().handleInteger(whichPlayer, "AVote")
		endmethod

		private static method dialogButtonActionVote takes ADialogButton dialogButton returns nothing
			local thistype vote = thistype.playerVote(dialogButton.dialog().player())
			if (vote != 0) then
				call vote.addVote(dialogButton.dialog().player(), dialogButton.index())
			endif
		endmethod

		public stub method start takes nothing returns nothing
			local integer i = 0
			local integer j
			set this.m_runs = true
			loop
				exitwhen (i == this.m_players.size())
				debug if (thistype.playerVote(AVotePlayer(this.m_players[i]).player()) != 0) then
					debug call this.print("Player " + GetPlayerName(AVotePlayer(this.m_players[i]).player()) + " does already have a running vote.")
				debug endif
				call AHashTable.global().setHandleInteger(AVotePlayer(this.m_players[i]).player(), A_HASHTABLE_KEY_VOTE, this)
				call AGui.playerGui(AVotePlayer(this.m_players[i]).player()).dialog().clear()
				call AGui.playerGui(AVotePlayer(this.m_players[i]).player()).dialog().setMessage(this.m_message)
				set j = 0
				loop
					exitwhen (j == this.m_choices.size())
					call AGui.playerGui(AVotePlayer(this.m_players[i]).player()).dialog().addDialogButton(AVoteChoice(this.m_choices[j]).message(), 0, thistype.dialogButtonActionVote)
					set j = j + 1
				endloop
				call AGui.playerGui(AVotePlayer(this.m_players[i]).player()).dialog().show()
				set i = i + 1
			endloop
		endmethod

		public method addPlayer takes player whichPlayer returns integer
			if (this.m_leaveTrigger != null) then
				call TriggerRegisterPlayerEvent(this.m_leaveTrigger, whichPlayer, EVENT_PLAYER_LEAVE)
			endif
			call this.m_players.pushBack(AVotePlayer.create(whichPlayer))
			return this.m_players.backIndex()
		endmethod

		public method addForce takes force whichForce returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (IsPlayerInForce(Player(i), whichForce)) then
					call this.addPlayer(Player(i))
				endif
				set i = i + 1
			endloop
		endmethod

		/// @todo Remove event, impossible.
		public method removePlayer takes player whichPlayer returns boolean
			local integer index = this.playerIndex(whichPlayer)
			if (index != -1) then
				if (AVotePlayer(this.m_players[index]).choice() != -1) then
					call AVoteChoice(this.m_choices[AVotePlayer(this.m_players[index]).choice()]).removeVote()
				endif
				call this.m_players.erase(index)
				return true
			endif
			return false
		endmethod

		/// @return Returns the choice player whichPlayer voted for. If player whichPlayer is not a member of the vote or he hasn't already voted yet it returns -1.
		public method playerChoice takes player whichPlayer returns integer
			local AVotePlayer data = this.player(whichPlayer)
			if (data == 0) then
				return -1
			endif
			return data.choice()
		endmethod

		public method addChoice takes string message returns integer
			call this.m_choices.pushBack(AVoteChoice.create(message))
			return this.m_choices.backIndex()
		endmethod

		public method choiceMessage takes integer choice returns string
			if (choice < 0 or choice >= this.m_choices.size()) then
				return null
			endif
			return AVoteChoice(this.m_choices[choice]).message()
		endmethod

		public method choiceVotes takes integer choice returns integer
			if (choice < 0 or choice >= this.m_choices.size()) then
				return 0
			endif
			return AVoteChoice(this.m_choices[choice]).votes()
		endmethod

		public static method create takes string message returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_message = message
			set this.m_resultAction = 0
			set this.m_recognizePlayerLeavings = false
			// members
			set this.m_runs = false
			set this.m_players = AIntegerVector.create()
			set this.m_choices = AIntegerVector.create()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			local integer i
			if (this.m_runs) then
				set i = 0
				loop
					exitwhen (i == this.m_players.size())
					call AHashTable.global().removeHandleInteger(AVotePlayer(this.m_players[i]).player(), "AVote")
					set i = i + 1
				endloop
			endif
			// dynamic members
			if (this.m_leaveTrigger != null) then
				call AHashTable.global().destroyTrigger(this.m_leaveTrigger)
				set this.m_leaveTrigger = null
			endif
			// members
			//! runtextmacro A_DESTROY("this.m_players", "AVotePlayer")
			//! runtextmacro A_DESTROY("this.m_choices", "AVoteChoice")
		endmethod
	endstruct
	
	struct ADialogVote extends AVote
		// dynamic members
		private string m_dialogMessage

		// dynamic members

		public method setDialogMessage takes string dialogMessage returns nothing
			set this.m_dialogMessage = dialogMessage
		endmethod

		public method dialogMessage takes nothing returns string
			return this.m_dialogMessage
		endmethod

		private static method dialogButtonActionVote takes ADialogButton dialogButton returns nothing
			local thistype vote = thistype.playerVote(dialogButton.dialog().player())
			if (vote != 0) then
				call vote.addVote(dialogButton.dialog().player(), dialogButton.index())
			endif
		endmethod

		public stub method start takes nothing returns nothing
			local integer i = 0
			local integer j
			call super.start()
			loop
				exitwhen (i == this.m_players.size())
				call AGui.playerGui(AVotePlayer(this.m_players[i]).player()).dialog().clear()
				call AGui.playerGui(AVotePlayer(this.m_players[i]).player()).dialog().setMessage(this.dialogMessage())
				set j = 0
				loop
					exitwhen (j == this.m_choices.size())
					call AGui.playerGui(AVotePlayer(this.m_players[i]).player()).dialog().addDialogButton(AVoteChoice(this.m_choices[j]).message(), 0, thistype.dialogButtonActionVote)
					set j = j + 1
				endloop
				call AGui.playerGui(AVotePlayer(this.m_players[i]).player()).dialog().show()
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary