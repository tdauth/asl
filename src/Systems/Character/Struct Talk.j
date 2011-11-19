library AStructSystemsCharacterTalk requires ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, AStructCoreGeneralList, AStructCoreGeneralVector, ALibraryCoreInterfaceMisc, ALibraryCoreMathsHandle, AStructSystemsCharacterCharacter

	/// \todo Should be a part of \ref ATalk, vJass bug.
	function interface ATalkStartAction takes ATalk talk returns nothing

	/**
	 * \brief Talks are a kind of dialogs with NPCs (\ref unit) which are implemented by using the Warcraft III \ref dialog natives.
	 * This means that choices in form of dialog buttons are shown to a specific character owner.
	 * If the owner presses any button an user-defined function will be called where the user can define the whole talk using functions like \ref speech() or \ref speech2(), for instance.
	 * One talk contains one or several infos (\ref AInfo). Those infos contain the user-defined function and an user-defined condition.
	 * Conditions of infos can be used to determine if the info should be displayed making talks more flexible.
	 * Besides they can have various other properties.
	 * For example, they can be enabled or disabled dynamically during the game using \ref enable() and \ref disable().
	 * Each character's current talk can be refered by \ref ACharacter.talk().
	 * Here's a list of additional features provided by ATalk:
	 * <ul>
	 * <li>activation on player order - \ref setOrderId(), \ref setMaxOrderDistance(), \ref setOrderErrorMessage()</li>
	 * <li>talk effect which can be disabled during cinematic sequences - \ref setEffectPath(), \ref setDisableEffectInCinematicMode()</li>
	 * <li>hiding user interface during talk - \ref setHideUserInterface()</li>
	 * </ul>
	 * Whenever a talk is opened by \ref openForCharacter() its corresponding start action is called which can be defined in constructor or using \ref setStartAction() at runtime.
	 * Usually you use show methods such like \ref showRange() in your custom start action to show various infos.
	 * \note Note that only one character owner can use one talk at the same time. There is no support for several characters talking to the same NPC, yet.
	 * \note Contained infos are stored using \ref AIntegerVector since infos are defined on talk creation, usually and therefore never changed dynamically during the game. To hide infos you can use your custom info condition functions!
	 * \sa AInfo
	 * \sa AVideo
	 * \sa ACharacter
	 * \internal Don't move around any info's since they are refered by their indices!
	 */
	struct ATalk
		// static constant members
		public static constant integer defaultOrderId = OrderId("smart")
		public static constant real defaultMaxOrderDistance = 250.0
		public static constant string defaultOrderErrorMessage = A_TEXT_TARGET_TALKS_ALREADY /// German: "Ziel unterhält sich bereits".
		public static constant string defaultEffectPath = "Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl"
		public static constant boolean defaultDisableEffectInCinematicMode = true
		public static constant boolean defaultHideUserInterface = false
		// static members
		private static AIntegerList m_cinematicTalks = 0 /// \note allocated on request, not in \ref thistype.init() anymore!
		// dynamic members
		private integer m_orderId
		private real m_maxOrderDistance
		private string m_orderErrorMessage
		private string m_effectPath
		private boolean m_disableEffectInCinematicMode
		private boolean m_hideUserInterface
		private ATalkStartAction m_startAction
		// construction members
		private unit m_unit
		// members
		private AIntegerVector m_infos
		private ACharacter m_character
		private boolean m_isEnabled
		private trigger m_orderTrigger
		private effect m_effect

		//! runtextmacro optional A_STRUCT_DEBUG("\"ATalk\"")

		// dynamic members

		/**
		 * \return Returns the talk's corresponding order id of the order which has to be issued to the character's unit by its owner to start the talk. If this value is 0 there won't be any possibility to start the talk by an issued order.
		 * \sa defaultOrderId
		 * \sa setOrderId()
		 * \sa hasOrder()
		 */
		public method orderId takes nothing returns integer
			return this.m_orderId
		endmethod

		/**
		 * \return Returns true if the talk has any specified order. Otherwise it returns false and it is not possible to start the talk by an issued order.
		 * \sa defaultOrderId
		 * \sa setOrderId()
		 * \sa orderId()
		 */
		public method hasOrder takes nothing returns boolean
			return this.orderId() != 0
		endmethod

		/**
		 * If order-based activation is present you can define a distance in which the character's unit has to be when the order is being issued.
		 * \param distance If this value is 0 or smaller, distance check is ignored.
		 * Use \ref setOrderId() to enable order-based activation.
		 * Use \ref setOrderErrorMessage() to specify an error message in case of talks which are already in use.
		 * \sa defaultMaxOrderDistance
		 * \sa maxOrderDistance()
		 * \sa hasMaxOrderDistance()
		 */
		public method setMaxOrderDistance takes real distance returns nothing
			debug if (distance <= 50.0 and distance > 0.0) then
				debug call this.print("Warning: Small distance with value of " + R2S(distance))
			debug endif
			set this.m_maxOrderDistance = distance
		endmethod

		/**
		 * \sa defaultMaxOrderDistance
		 * \sa setMaxOrderDistance()
		 * \sa hasMaxOrderDistance()
		 */
		public method maxOrderDistance takes nothing returns real
			return this.m_maxOrderDistance
		endmethod

		/**
		 * \sa defaultMaxOrderDistance
		 * \sa setMaxOrderDistance()
		 * \sa maxOrderDistance()
		 */
		public method hasMaxOrderDistance takes nothing returns boolean
			return this.maxOrderDistance() > 0.0
		endmethod

		/**
		 * This message is send to a character's owner when he would enable a talk through order-based activation but fails because the talk is already in use by another player's character.
		 * It's send using \ref ACharacter.messageTypeError.
		 * \param message If this value is null there won't be any message.
		 * \sa defaultOrderErrorMessage
		 * \sa orderErrorMessage()
		 * \sa hasOrderErrorMessage()
		 */
		public method setOrderErrorMessage takes string message returns nothing
			set this.m_orderErrorMessage = message
		endmethod

		/**
		 * \sa defaultOrderErrorMessage
		 * \sa setOrderErrorMessage()
		 * \sa hasOrderErrorMessage()
		 */
		public method orderErrorMessage takes nothing returns string
			return this.m_orderErrorMessage
		endmethod

		/**
		 * \sa defaultOrderErrorMessage
		 * \sa setOrderErrorMessage()
		 * \sa orderErrorMessage()
		 */
		public method hasOrderErrorMessage takes nothing returns boolean
			return this.orderErrorMessage() != null
		endmethod

		/**
		 * \return Returns the talk's effect path.
		 * \sa defaultEffectPath
		 * \sa setEffectPath()
		 * \sa hasEffect()
		 */
		public method effectPath takes nothing returns string
			return this.m_effectPath
		endmethod

		/**
		 * \return Returns true if any effect path is set.
		 * \sa defaultEffectPath
		 * \sa setEffectPath()
		 * \sa effectPath()
		 */
		public method hasEffect takes nothing returns boolean
			return this.effectPath() != null
		endmethod

		/**
		 * \sa defaultDisableEffectInCinematicMode
		 * \sa setDisableEffectInCinematicMode()
		 */
		public method disableEffectInCinematicMode takes nothing returns boolean
			return this.m_disableEffectInCinematicMode
		endmethod

		/**
		 * \sa defaultHideUserInterface
		 * \sa setHideUserInterface()
		 */
		public method hideUserInterface takes nothing returns boolean
			return this.m_hideUserInterface
		endmethod

		/**
		 * Sets the corresponding start action which is called in \ref showStartPage().
		 * \sa startAction()
		 */
		public method setStartAction takes ATalkStartAction startAction returns nothing
			set this.m_startAction = startAction
		endmethod

		public method startAction takes nothing returns ATalkStartAction
			return this.m_startAction
		endmethod

		// construction members

		/// \return Returns the NPC's unit.
		public method unit takes nothing returns unit
			return this.m_unit
		endmethod

		// members

		/// \return Returns the character which is talking currently to the NPC.
		public method character takes nothing returns ACharacter
			return this.m_character
		endmethod

		/**
		 * \return Returns true if the talk is enabled currently. Disabled talks cannot be used by any player.
		 * \sa enable()
		 * \sa disable()
		 */
		public method isEnabled takes nothing returns boolean
			return this.m_isEnabled
		endmethod

		//methods

		/**
		 * \return Returns true if talk is currently in use by any character.
		 * \sa isClosed()
		 */
		public method isOpen takes nothing returns boolean
			return this.character() != 0
		endmethod

		/**
		 * \return Returns true if no character talks to the NPC at the moment.
		 * \sa isOpen()
		 */
		public method isClosed takes nothing returns boolean
			return this.character() == 0
		endmethod

		/**
		 * Runs the start action with the curresponding talk as parameter.
		 * This method is called in \ref openForCharacter() to show the character's owner the talk's start page.
		 * \sa setStartAction()
		 * \sa startAction()
		 */
		public method showStartPage takes nothing returns nothing
			if (this.startAction() != 0) then
				call this.startAction().execute(this) // create buttons
			endif
		endmethod

		/**
		 * Shows the talk's Warcraft III \ref dialog.
		 * If no info has been added start page is shown automatically.
		 */
		public method show takes nothing returns nothing
			if (AGui.playerGui(this.m_character.player()).dialog().dialogButtons() > 0) then
				call AGui.playerGui(this.m_character.player()).dialog().show()
			debug else
				debug call this.print("No infos to be displayed in dialog.")
			endif
		endmethod

		/**
		 * Shows a range of infos and a Warcraft III \ref dialog.
		 * \sa showUntil()
		 * \sa showAll()
		 * \sa show()
		 * \sa hide()
		 */
		public method showRange takes integer first, integer last returns nothing
			local integer i = first
static if (DEBUG_MODE) then
			if (first < 0 or first >= this.m_infos.size()) then
				call this.print("Wrong first value " + I2S(first) + ".")
			endif
			if (last < 0 or last >= this.m_infos.size()) then
				call this.print("Wrong last value " + I2S(last) + ".")
			endif
endif
			loop
				exitwhen (i > last)
				call AInfo(this.m_infos[i]).show.evaluate()
				set i = i + 1
			endloop
			call this.show()
		endmethod

		/**
		 * Shows all belonging infos including info with index \p last.
		 * \sa showRange()
		 * \sa showAll()
		 * \sa show()
		 * \sa hide()
		 */
		public method showUntil takes integer last returns nothing
			call this.showRange(0, last)
		endmethod

		/**
		 * Shows all belonging infos.
		 * \sa showRange()
		 * \sa showUntil()
		 * \sa show()
		 * \sa hide()
		 */
		public method showAll takes nothing returns nothing
			call this.showUntil(this.m_infos.backIndex())
		endmethod

		/**
		 * Hides the talks dialog for the character's owner.
		 * \sa showRange()
		 * \sa showUntil()
		 * \sa showAll()
		 * \sa show()
		 */
		public method hide takes nothing returns nothing
			call AGui.playerGui(this.m_character.player()).dialog().hide()
		endmethod

		/**
		 * You do not have to clear the dialog anywhere since \ref AInfo clears it whenever an info is runned!
		 */
		public method clear takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_infos.size())
				call AInfo(this.m_infos[i]).hide.evaluate()
				set i = i + 1
			endloop
			call AGui.playerGui(this.m_character.player()).dialog().clear()
		endmethod

		public method addInfo takes boolean permanent, boolean important, AInfoCondition condition, AInfoAction action, string description returns AInfo
			return AInfo.create.evaluate(this, permanent, important, condition, action, description)
		endmethod

		/// \todo Use translated string from Warcraft III.
		public method addBackButton takes AInfoAction action returns AInfo
			return AInfo.create.evaluate(this, true, false, 0, action, A_TEXT_BACK)
		endmethod

		private static method infoActionBackToStartPage takes AInfo info returns nothing
			call info.talk.evaluate().showStartPage()
		endmethod

		/// \todo Use translated string from Warcraft III.
		public method addBackToStartPageButton takes nothing returns AInfo
			return AInfo.create.evaluate(this, true, false, 0, thistype.infoActionBackToStartPage, A_TEXT_BACK)
		endmethod

		/**
		 * \returns Returns if info with index \p index has already been shown to the character which is talking currently to the NPC.
		 * \sa infoHasBeenShownToCharacter()
		 * \sa infoHasBeenShownToPlayer()
		 * \sa AInfo.hasBeenShownToCharacter()
		 */
		public method infoHasBeenShown takes integer index returns boolean
			if (this.isClosed()) then
				return false
			endif
			return AInfo(this.m_infos[index]).hasBeenShownToCharacter.evaluate(this.character().userId())
		endmethod

		/**
		 * \sa infoHasBeenShown()
		 * \sa infoHasBeenShownToPlayer()
		 * \sa AInfo.hasBeenShownToCharacter()
		 */
		public method infoHasBeenShownToCharacter takes integer index, ACharacter character returns boolean
			return AInfo(this.m_infos[index]).hasBeenShownToCharacter.evaluate(character.userId())
		endmethod

		/**
		 * \param whichPlayer Should be the owner of any character.
		 * \sa infoHasBeenShown()
		 * \sa infoHasBeenShownToCharacter()
		 * \sa AInfo.hasBeenShownToCharacter()
		 */
		public method infoHasBeenShownToPlayer takes integer index, player whichPlayer returns boolean
			return AInfo(this.m_infos[index]).hasBeenShownToCharacter.evaluate(GetPlayerId(whichPlayer))
		endmethod

		/**
		 * \return Returns true if third person camera system is enabled for the current character.
		 * \sa character()
		 */
		public method useThirdPerson takes nothing returns boolean
			if (this.character() == 0) then
				return false
			endif
			return ACharacter.useViewSystem() and this.character().view().enableAgain()
		endmethod

		private method hideUserInterfaceForPlayer takes boolean hide returns nothing
			call SetUserInterfaceForPlayer(this.character().player(), false, hide)
		endmethod

		/**
		 * Opens the talks initial dialog by running its start action for owner of \p character.
		 * Both, the NPC and the character are paused and do face each other.
		 * The owner's dialog is cleared automatically and its title is set to the name of the NPC.
		 * \return Returns true if talk has been started properly. Otherwise (for example if it's already in use by another one) it returns false.
		 * \note Usually you don't have to call this method since talks will be activated by a specific unit order.
		 */
		public method openForCharacter takes ACharacter character returns boolean
			if (this.m_character != 0) then
				debug call this.print("Character is not 0.")
				return false
			endif
			set this.m_character = character
			if (this.hideUserInterface()) then
				call this.hideUserInterfaceForPlayer(true)
			endif
			call character.setTalk(this)
			call character.setMovable(false)
			call PauseUnit(this.m_unit, true) // disables routines or something else of NPC
			call SetUnitFacing(character.unit(), GetAngleBetweenUnits(character.unit(), this.m_unit))
			call SetUnitFacing(this.m_unit, GetAngleBetweenUnits(this.m_unit, character.unit()))
			call SetUnitLookAt(character.unit(), "bone_head", this.m_unit, 0.0, 0.0, GetUnitFlyHeight(this.m_unit) + 90.0)
			call SetUnitLookAt(this.m_unit, "bone_head", character.unit(), 0.0, 0.0, GetUnitFlyHeight(character.unit()) + 90.0)
			if (this.useThirdPerson()) then
				call AThirdPersonCamera.playerThirdPersonCamera(character.player()).resetCamAoa()
				call AThirdPersonCamera.playerThirdPersonCamera(character.player()).resetCamRot()
				call AThirdPersonCamera.playerThirdPersonCamera(character.player()).disable()
				call AThirdPersonCamera.playerThirdPersonCamera(character.player()).enable(character.unit(), 0.0)
			endif
			call AGui.playerGui(character.player()).dialog().clear()
			call AGui.playerGui(character.player()).dialog().setMessage(GetUnitName(this.m_unit))
			call this.showStartPage() // create buttons
			return true
		endmethod

		/**
		 * Closes the talk for the current talking character which means that units are unpaused again and the corresponding dialog is cleared if necessary.
		 * Besides unit looking constraints are reset.
		 * \sa openForCharacter()
		 */
		public method close takes nothing returns nothing
			local player characterUser = this.m_character.player()
			if (this.isClosed()) then
				return
			endif
			call AGui.playerGui(characterUser).dialog().clear()
			call ResetUnitLookAt(this.m_character.unit())
			call ResetUnitLookAt(this.m_unit)
			if (this.hideUserInterface()) then
				call this.hideUserInterfaceForPlayer(false)
			endif
			/*
			if (not ACharacter.useViewSystem() or not this.m_character.view().enableAgain()) then
				call AThirdPersonCamera.playerThirdPersonCamera(characterUser).pause()
				call ResetToGameCameraForPlayer(characterUser, 0.0)
			endif
			*/
			call this.m_character.setTalk(0)
			call this.m_character.setMovable(true)
			set this.m_character = 0
			call PauseUnit(this.m_unit, false) //Enables routines or something else
			set characterUser = null
		endmethod

		private static method triggerConditionOpen takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local boolean result = false
			if (GetIssuedOrderId() == this.orderId()) then
				// Is character, if there is shared control or controller is computer player talks can not be used.
				if (GetPlayerSlotState(GetOwningPlayer(GetTriggerUnit())) != PLAYER_SLOT_STATE_LEFT and GetPlayerController(GetOwningPlayer(GetTriggerUnit())) != MAP_CONTROL_COMPUTER and GetTriggerUnit() == ACharacter.playerCharacter(GetOwningPlayer(GetTriggerUnit())).unit()) then
					if (GetOrderTargetUnit() == this.unit()) then
						if (not this.hasMaxOrderDistance() or GetDistanceBetweenUnits(GetTriggerUnit(), GetOrderTargetUnit(), 0.0, 0.0) <= this.maxOrderDistance()) then //Z value is not checked
							set result = (this.character() == 0)
							if (not result and this.hasOrderErrorMessage()) then
								call ACharacter.playerCharacter(GetOwningPlayer(GetTriggerUnit())).displayMessage(ACharacter.messageTypeError, this.orderErrorMessage())
							endif
						endif
					endif
				endif
			endif
			return result
		endmethod

		private static method triggerActionOpen takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			call IssueImmediateOrder(ACharacter.playerCharacter(GetTriggerPlayer()).unit(), "stop")
			call this.openForCharacter(ACharacter.playerCharacter(GetTriggerPlayer()))
		endmethod

		private method updateOrderTrigger takes nothing returns nothing
			if (this.m_orderTrigger != null) then
				call AHashTable.global().destroyTrigger(this.m_orderTrigger)
				set this.m_orderTrigger = null
			endif
			if (this.hasOrder()) then
				set this.m_orderTrigger = CreateTrigger()
				call TriggerRegisterAnyUnitEventBJ(this.m_orderTrigger, EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER)
				call TriggerAddCondition(this.m_orderTrigger, Condition(function thistype.triggerConditionOpen))
				call TriggerAddAction(this.m_orderTrigger, function thistype.triggerActionOpen)
				call AHashTable.global().setHandleInteger(this.m_orderTrigger, "this", this)
				if (not this.isEnabled()) then
					call DisableTrigger(this.m_orderTrigger)
				endif
			endif
		endmethod

		/**
		 * \param orderId If this value is not equal to 0 the talk is enabled for a player's character if the player orders his character unit the given order with the talk's NPC as target (for example "smart"). Otherwise, talk activation on order is disabled.
		 * Use \ref setOrderDistance() to specify the character's required distance to the NPC when order is being issued.
		 * Use \ref setOrderErrorMessage() to specify an error message in case of talks which are already in use.
		 * \sa orderId()
		 * \sa hasOrder()
		 */
		public method setOrderId takes integer orderId returns nothing
			if (orderId == this.orderId()) then
				return
			endif
			set this.m_orderId = orderId
			call this.updateOrderTrigger()
		endmethod

		private static method infoActionExit takes AInfo info returns nothing
			call info.talk.evaluate().close()
		endmethod

		/**
		 * Adds an exit button to the talk's dialog which closes the talk automatically.
		 * \sa close()
		 * \todo Use translated string from Warcraft III.
		 */
		public method addExitButton takes nothing returns AInfo
			return AInfo.create.evaluate(this, true, false, 0, thistype.infoActionExit, A_TEXT_EXIT)
		endmethod

		/**
		 * Enables the talk which means that it can be activated via the specified order again.
		 * If talk effects are used
		 * \sa isEnabled()
		 * \sa disable()
		 */
		public method enable takes nothing returns nothing
			set this.m_isEnabled = true
			if (this.hasOrder()) then
				call EnableTrigger(this.m_orderTrigger)
			endif
			if (this.hasEffect()) then
				set this.m_effect = AddSpecialEffectTarget(this.effectPath(), this.unit(), "overhead")
			endif
		endmethod

		public method disable takes nothing returns nothing
			set this.m_isEnabled = false
			if (this.hasOrder()) then
				call DisableTrigger(this.m_orderTrigger)
			endif
			if (this.hasEffect()) then
				call DestroyEffect(this.m_effect)
				set this.m_effect = null
			endif
		endmethod

		public method isInfoShown takes integer index returns boolean
			return AInfo(this.m_infos[index]).isShown.evaluate()
		endmethod

		/**
		 * \return Returns the number of belonging infos.
		 */
		public method infos takes nothing returns integer
			return this.m_infos.size()
		endmethod

		/// Used by \ref AInfo.
		public method showInfo takes integer index returns boolean
			return AInfo(this.m_infos[index]).show.evaluate()
		endmethod

		/**
		 * \note Returns only shown info!
		 */
		public method getInfoByDialogButtonIndex takes integer dialogButtonIndex returns AInfo
			local integer i = 0
			loop
				exitwhen (i == this.m_infos.size())
				if (AInfo(this.m_infos[i]).isShown.evaluate() and AInfo(this.m_infos[i]).dialogButtonIndex.evaluate() == dialogButtonIndex) then
					return AInfo(this.m_infos[i])
				endif
				set i = i + 1
			endloop
			return 0
		endmethod

		/// Friend relationship to \ref AInfo, do not use.
		public method addInfoInstance takes AInfo info returns integer
			call this.m_infos.pushBack(info)
			return this.m_infos.backIndex()
		endmethod

		/// Friend relationship to \ref AInfo, do not use.
		public method removeInfoInstanceByIndex takes integer index returns nothing
			call this.m_infos.erase(index)
		endmethod

		private method updateEffect takes boolean disabledInCinematicsBefore returns nothing
			if (this.m_effect != null) then
				call DestroyEffect(this.m_effect)
				set this.m_effect = null
			endif
			if (disabledInCinematicsBefore and not this.disableEffectInCinematicMode() and this.hasEffect()) then
				call thistype.m_cinematicTalks.remove(this)
			endif
			if (this.hasEffect()) then
				if (this.isEnabled()) then
					set this.m_effect = AddSpecialEffectTarget(this.effectPath(), this.unit(), "overhead")
				endif
				if (not disabledInCinematicsBefore and this.disableEffectInCinematicMode()) then
					if (thistype.m_cinematicTalks == 0) then
						set thistype.m_cinematicTalks = AIntegerList.create()
					endif
					call thistype.m_cinematicTalks.pushBack(this)
				endif
			endif
		endmethod

		/**
		 * Each talk can have its own effect which is attached to attachment point "overhead" of the talk's unit.
		 * \param effectPath If this value is null, effect is disabled completely.
		 * \sa defaultEffectPath
		 * \sa effectPath()
		 * \sa hasEffect()
		 */
		public method setEffectPath takes string effectPath returns nothing
			if (this.m_effectPath == effectPath) then
				return
			endif
			set this.m_effectPath = effectPath
			call this.updateEffect(this.disableEffectInCinematicMode())
		endmethod

		/**
		 * \param disable If this value is true the talk's effect will be hidden in any \ref AVideo based cinematic sequence.
		 * \sa defaultDisableEffectInCinematicMode
		 * \sa disableEffectInCinematicMode()
		 * \sa AVideo
		 */
		public method setDisableEffectInCinematicMode takes boolean disable returns nothing
			local boolean tmp = this.m_disableEffectInCinematicMode
			if (disable == tmp) then
				return
			endif
			set this.m_disableEffectInCinematicMode = disable
			call this.updateEffect(tmp)
		endmethod

		/**
		 * \param hide If this value is true, user interface is hidden for character's owner during talks.
		 * \sa defaultHideUserInterface
		 * \sa hideUserInterface()
		 */
		public method setHideUserInterface takes boolean hide returns nothing
			if (hide == this.m_hideUserInterface) then
				return
			endif
			set this.m_hideUserInterface = hide
			if (hide and this.isOpen()) then
				call this.hideUserInterfaceForPlayer(true)
			endif
		endmethod

		/**
		 * Creates a new talk for NPC \p whichUnit using start action \p startAction which is called when the talk is started.
		 * All default values are assigned in constructor which are:
		 * <ul>
		 * <li>\ref defaultOrderId </li>
		 * <li>\ref defaultMaxOrderDistance </li>
		 * <li>\ref defaultOrderErrorMessage </li>
		 * <li>\ref defaultEffectPath </li>
		 * <li>\ref defaultDisableEffectInCinematicMode </li>
		 * <li>\ref defaultHideUserInterface </li>
		 * </ul>
		 * \param whichUnit The talk's NPC which can be accessed by \ref unit().
		 * \param startAction The talk's start action which is called in \ref showStartPage() and can be accessed by \ref startAction() and dynamically changed by \ref setStartAction().
		 */
		public static method create takes unit whichUnit, ATalkStartAction startAction returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_orderId = thistype.defaultOrderId
			set this.m_maxOrderDistance = thistype.defaultMaxOrderDistance
			set this.m_orderErrorMessage = thistype.defaultOrderErrorMessage
			set this.m_effectPath = thistype.defaultEffectPath
			set this.m_disableEffectInCinematicMode = thistype.defaultDisableEffectInCinematicMode
			set this.m_hideUserInterface = thistype.defaultHideUserInterface
			// construction members
			set this.m_unit = whichUnit
			set this.m_startAction = startAction
			// members
			set this.m_infos = AIntegerVector.create()
			set this.m_character = 0
			set this.m_isEnabled = true
			set this.m_orderTrigger = null
			set this.m_effect = null

			call this.updateOrderTrigger()
			call this.updateEffect(not this.disableEffectInCinematicMode())
			return this
		endmethod

		private method destroyOrderTrigger takes nothing returns nothing
			if (this.orderId() != 0) then
				// should always be true
				if (this.m_orderTrigger != null) then
					call AHashTable.global().destroyTrigger(this.m_orderTrigger)
					set this.m_orderTrigger = null
				endif
			endif
		endmethod

		private method destroyEffect takes nothing returns nothing
			if (this.hasEffect()) then
				// should always be true
				if (this.m_effect != null) then
					call DestroyEffect(this.m_effect)
					set this.m_effect = null
				endif
				if (this.disableEffectInCinematicMode()) then
					call thistype.m_cinematicTalks.remove(this)
				endif
			endif
		endmethod

		private method destroyInfos takes nothing returns nothing
			loop
				exitwhen (this.m_infos.empty())
				call AInfo(this.m_infos.back()).destroy.evaluate()
			endloop
			call this.m_infos.destroy()
		endmethod

		public method onDestroy takes nothing returns nothing
			// construction members
			set this.m_unit = null

			call this.destroyInfos()
			call this.destroyOrderTrigger()
			call this.destroyEffect()
		endmethod

		/**
		 * Hides all effects of talks which do return true for \ref disableEffectInCinematicMode().
		 * \sa AVideo
		 */
		public static method hideAllEffects takes nothing returns nothing
			local AIntegerListIterator iterator
			if (thistype.m_cinematicTalks == 0) then
				return
			endif
			set iterator = thistype.m_cinematicTalks.begin()
			loop
				exitwhen (not iterator.isValid())
				if (thistype(iterator.data()).m_effect != null) then
					call DestroyEffect(thistype(iterator.data()).m_effect)
					set thistype(iterator.data()).m_effect = null
				endif
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		/**
		 * Shows all effects of talks which do return true for \ref disableEffectInCinematicMode().
		 * \sa AVideo
		 */
		public static method showAllEffects takes nothing returns nothing
			local AIntegerListIterator iterator
			if (thistype.m_cinematicTalks == 0) then
				return
			endif
			set iterator = thistype.m_cinematicTalks.begin()
			loop
				exitwhen (not iterator.isValid())
				call thistype(iterator.data()).updateEffect(true)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod
	endstruct

endlibrary