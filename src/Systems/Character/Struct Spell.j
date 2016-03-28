/// This library contains the ASpell struct which is used for character spells.
library AStructSystemsCharacterSpell requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, ALibraryCoreEnvironmentUnit, AStructSystemsCharacterAbstractCharacterSystem, AStructSystemsCharacterCharacter

	/// \todo vJass bug, should be a part of \ref ASpell.
	function interface ASpellUpgradeAction takes ASpell spell, integer level returns nothing

	/// \todo vJass bug, should be a part of \ref ASpell.
	function interface ASpellCastCondition takes ASpell spell returns boolean

	/// \todo vJass bug, should be a part of \ref ASpell.
	function interface ASpellCastAction takes ASpell spell returns nothing

	/// This struct represents exactly one spell which is owned by a character.
	/// \todo As there is no multiple inheritance this cannot inherit \ref AUnitSpell.
	struct ASpell extends AAbstractCharacterSystem
		// construction members
		private integer m_ability
		private ASpellUpgradeAction m_upgradeAction
		private ASpellCastCondition m_castCondition
		private ASpellCastAction m_castAction
		// members
		private trigger m_upgradeTrigger
		/**
		 * The channel trigger is used to check the condition first and stop the character if the condition is not fullfilled.
		 * In this case \ref m_canCast is set to false and therefore the cast trigger blocks the action.
		 */
		private trigger m_channelTrigger
		private trigger m_castTrigger
		/*
		 * Flag which stores if the spell can even be cast.
		 * This flag is set on the channel event from the condition.
		 * It is checked in the cast trigger.
		 */
		private boolean m_canCast

		//! runtextmacro optional A_STRUCT_DEBUG("\"ASpell\"")

		// construction members

		public method ability takes nothing returns integer
			return this.m_ability
		endmethod

		public method upgradeAction takes nothing returns ASpellUpgradeAction
			return this.m_upgradeAction
		endmethod

		public method castCondition takes nothing returns ASpellCastCondition
			return this.m_castCondition
		endmethod

		public method castAction takes nothing returns ASpellCastAction
			return this.m_castAction
		endmethod

		// convenience methods

		/**
		 * \return Returns the name of the corresponding ability.
		 */
		public method name takes nothing returns string
			return GetObjectName(this.m_ability)
		endmethod

		public method increaseLevel takes nothing returns nothing
			call IncUnitAbilityLevel(this.character().unit(), this.m_ability)
		endmethod

		public method decreaseLevel takes nothing returns nothing
			call DecUnitAbilityLevel(this.character().unit(), this.m_ability)
		endmethod

		/**
		 * Sets the spell's ability level to \p level.
		 * Can be overwritten as stub method to change the behaviour.
		 */
		public stub method setLevel takes integer level returns nothing
			call SetUnitAbilityLevel(this.character().unit(), this.m_ability, level)
		endmethod

		public method level takes nothing returns integer
			return GetUnitAbilityLevel(this.character().unit(), this.m_ability)
		endmethod

		/**
		 * Adds the corresponding ability \ref ability() to the character's unit.
		 */
		public method add takes nothing returns boolean
			return UnitAddAbility(this.character().unit(), this.m_ability)
		endmethod

		/**
		 * Removes the corresponding ability \ref ability() from the character's unit.
		 */
		public method remove takes nothing returns boolean
			return UnitRemoveAbility(this.character().unit(), this.m_ability)
		endmethod

		// methods

		public stub method store takes gamecache cache, string missionKey, string labelPrefix returns nothing
			call super.store(cache, missionKey, labelPrefix)
			call StoreInteger(cache, missionKey, labelPrefix + "Ability", this.m_ability)
			call StoreInteger(cache, missionKey, labelPrefix + "UpgradeAction", this.m_upgradeAction)
			call StoreInteger(cache, missionKey, labelPrefix + "CastCondition", this.m_castCondition)
			call StoreInteger(cache, missionKey, labelPrefix + "CastAction", this.m_castAction)
		endmethod

		public stub method restore takes gamecache cache, string missionKey, string labelPrefix returns nothing
			call super.restore(cache, missionKey, labelPrefix)
			set this.m_ability = GetStoredInteger(cache, missionKey, labelPrefix + "Ability")
			set this.m_upgradeAction = GetStoredInteger(cache, missionKey, labelPrefix + "UpgradeAction")
			set this.m_castCondition = GetStoredInteger(cache, missionKey, labelPrefix + "CastCondition")
			set this.m_castAction = GetStoredInteger(cache, missionKey, labelPrefix + "CastAction")
		endmethod

		//Make it available
		public method enable takes nothing returns nothing
			call EnableTrigger(this.m_upgradeTrigger)
			call EnableTrigger(this.m_channelTrigger)
			call EnableTrigger(this.m_castTrigger)
		endmethod

		public method disable takes nothing returns nothing
			call DisableTrigger(this.m_upgradeTrigger)
			call DisableTrigger(this.m_channelTrigger)
			call DisableTrigger(this.m_castTrigger)
		endmethod

		public stub method onUpgradeAction takes nothing returns nothing
			if (this.m_upgradeAction != 0) then
				call this.m_upgradeAction.execute(this, GetLearnedSkillLevel())
			endif
		endmethod

		/**
		 * Called by .evaluate().
		 * If this does not return true the spell cast is canceled.
		 * By default this evaluates the \ref castCondition().
		 */
		public stub method onCastCondition takes nothing returns boolean
			return (this.m_castCondition == 0 or this.m_castCondition.evaluate(this))
		endmethod

		/**
		 * Called by .execute().
		 * By default this executes the \ref castAction().
		 */
		public stub method onCastAction takes nothing returns nothing
			if (this.m_castAction != 0) then
				debug call Print("Running action (is not zero).")
				call this.m_castAction.execute(this)
			endif
		endmethod

		private static method triggerConditionRightAbility takes nothing returns boolean
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, 0)
			local boolean result = (GetLearnedSkill() == this.m_ability)
			set triggeringTrigger = null
			return result
		endmethod

		private static method triggerActionUpgrade takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, 0)
			call this.onUpgradeAction.execute()
			set triggeringTrigger = null
		endmethod

		/// \todo upgradeAction won't be called correctly
		private method createUpgradeTrigger takes nothing returns nothing
			set this.m_upgradeTrigger = CreateTrigger()
			// TODO support repick by replacing event
			call TriggerRegisterUnitEvent(this.m_upgradeTrigger, this.character().unit(), EVENT_UNIT_HERO_SKILL)
			call TriggerAddCondition(this.m_upgradeTrigger, Condition(function thistype.triggerConditionRightAbility))
			call TriggerAddAction(this.m_upgradeTrigger, function thistype.triggerActionUpgrade)
			call AHashTable.global().setHandleInteger(this.m_upgradeTrigger, 0, this)
		endmethod
		
		private static method triggerConditionChannel takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local boolean result = GetTriggerUnit() == this.character().unit() and GetSpellAbilityId() != null and GetSpellAbilityId() == this.m_ability
			set this.m_canCast = result
			if (result) then
				set result = this.onCastCondition()
				set this.m_canCast = result
				if (not result) then
					//taken from wc3jass.com
					//call PauseUnit(this.character().unit(), true)
					call IssueImmediateOrder(this.character().unit(), "stop")
					//call PauseUnit(this.character().unit(), false)
					debug call Print("Stop: " + GetAbilityName(this.ability()))
				endif
			endif
			return false
		endmethod
		
		private method createChannelTrigger takes nothing returns nothing
			set this.m_channelTrigger = CreateTrigger()
			// never use ENDCAST since GetSpellTargetX() etc. won't work anymore
			call TriggerRegisterAnyUnitEventBJ(this.m_channelTrigger, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
			call TriggerAddCondition(this.m_channelTrigger, Condition(function thistype.triggerConditionChannel))
			call AHashTable.global().setHandleInteger(this.m_channelTrigger, 0, this)
		endmethod
		
		private static method triggerConditionCast takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local boolean result = GetTriggerUnit() == this.character().unit() and GetSpellAbilityId() != null and GetSpellAbilityId() == this.m_ability
			if (result) then
				debug if (this.m_canCast) then
					debug call this.print("Can cast")
				debug else
					debug call this.print("Cannot cast")
				debug endif
				return this.m_canCast
			endif
			return result
		endmethod

		private static method triggerActionCast takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.onCastAction.execute()
		endmethod

		private method createCastTrigger takes playerunitevent castEvent returns nothing
			set this.m_castTrigger = CreateTrigger()
			// never use ENDCAST since GetSpellTargetX() etc. won't work anymore
			call TriggerRegisterAnyUnitEventBJ(this.m_castTrigger, castEvent)
			call TriggerAddCondition(this.m_castTrigger, Condition(function thistype.triggerConditionCast))
			call TriggerAddAction(this.m_castTrigger, function thistype.triggerActionCast)
			call AHashTable.global().setHandleInteger(this.m_castTrigger, 0, this)
		endmethod

		/**
		 * \param character Used character.
		 * \param usedAbility The ability which has to be casted by the unit of the character to run the cast action and which has to be skilled for the unit of the character to run the teach action.
		 * \param castEvent Use EVENT_PLAYER_UNIT_SPELL_CHANNEL for regular spells since event data such as GetSpellTargetX() does work with this event. In other cases such as removing the cast ability EVENT_PLAYER_UNIT_SPELL_ENDCAST is recommended but event data does not work with this one.
		 */
		public static method create takes ACharacter character, integer usedAbility, ASpellUpgradeAction upgradeAction, ASpellCastCondition castCondition, ASpellCastAction castAction, playerunitevent castEvent returns thistype
			local thistype this = thistype.allocate(character)
			// construction members
			set this.m_ability = usedAbility
			set this.m_upgradeAction = upgradeAction
			set this.m_castCondition = castCondition
			set this.m_castAction = castAction
			// members
			set this.m_canCast = false

			call character.addSpell(this)

			call this.createUpgradeTrigger()
			// conditions have always to be checked on a channel event that the spell order can be stopped before mana consumption and cooldown!
			call this.createChannelTrigger()
			call this.createCastTrigger(castEvent)

			return this
		endmethod

		/// Use this constructor if you either don't any event response functions or you overwrite the stub methods.
		public static method createSimple takes ACharacter character, integer whichAbility returns thistype
			return thistype.create(character, whichAbility, 0, 0, 0, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod

		public static method createRestored takes ACharacter character, gamecache cache, string missionKey, string labelPrefix returns thistype
			local thistype this = thistype.allocate(character)
			return this
		endmethod

		private method destroyUpgradeTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_upgradeTrigger)
			set this.m_upgradeTrigger = null
		endmethod
		
		private method destroyChannelTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_channelTrigger)
			set this.m_channelTrigger = null
		endmethod

		private method destroyCastTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_castTrigger)
			set this.m_castTrigger = null
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.character().removeSpell(this)

			call this.destroyUpgradeTrigger()
			call this.destroyChannelTrigger()
			call this.destroyCastTrigger()
		endmethod

		/**
		 * This static method can be used in an exitwhen() statement to determine when to stop the loop on an enemy target \p target.
		 * When the target gets killed or becomes spell immune spell effects have to stop.
		 * This should be used for negative effects.
		 * For positive effects on allies you can use \ref allyTargetLoopCondition().
		 */
		public static method enemyTargetLoopCondition takes unit target returns boolean
			return IsUnitDeadBJ(target) or IsUnitSpellImmune(target)
		endmethod

		public static method enemyTargetLoopConditionResistant takes unit target returns boolean
			return thistype.enemyTargetLoopCondition(target) or IsUnitSpellResistant(target)
		endmethod

		public static method allyTargetLoopCondition takes unit target returns boolean
			return IsUnitDeadBJ(target)
		endmethod

		public static method allyChannelLoopCondition takes unit target returns boolean
			return IsUnitDeadBJ(target) or IsUnitType(target, UNIT_TYPE_STUNNED)
		endmethod
	endstruct

endlibrary