/// This library contains the \ref AUnitSpell structure which is used for custom unit spells.
library AStructCoreEnvironmentUnitSpell requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, ALibraryCoreEnvironmentUnit

	/// \todo vJass bug, should be a part of \ref AUnitSpell.
	function interface AUnitSpellUpgradeAction takes AUnitSpell spell, integer level returns nothing

	/// \todo vJass bug, should be a part of \ref AUnitSpell.
	function interface AUnitSpellCastCondition takes AUnitSpell spell returns boolean

	/// \todo vJass bug, should be a part of \ref AUnitSpell.
	function interface AUnitSpellCastAction takes AUnitSpell spell returns nothing

	/**
	 * This structure represents exactly one custom spell which can be casted by any unit.
	 * Custom spells can use conditions and custom actions in form of function objects or overwritten stub methods.
	 * \sa ASpell
	 * \todo As there is no multiple inheritance \ref ASpell cannot use this as parent structure.
	 */
	struct AUnitSpell
		// construction members
		private integer m_ability
		private AUnitSpellUpgradeAction m_upgradeAction
		private AUnitSpellCastCondition m_castCondition
		private AUnitSpellCastAction m_castAction
		// members
		private trigger m_upgradeTrigger
		private trigger m_castTrigger

		//! runtextmacro optional A_STRUCT_DEBUG("\"AUnitSpell\"")

		// construction members

		public method ability takes nothing returns integer
			return this.m_ability
		endmethod

		public method upgradeAction takes nothing returns AUnitSpellUpgradeAction
			return this.m_upgradeAction
		endmethod

		public method castCondition takes nothing returns AUnitSpellCastCondition
			return this.m_castCondition
		endmethod

		public method castAction takes nothing returns AUnitSpellCastAction
			return this.m_castAction
		endmethod

		// convenience methods

		public method name takes nothing returns string
			return GetObjectName(this.ability())
		endmethod

		// methods

		public stub method store takes gamecache cache, string missionKey, string labelPrefix returns nothing
			call StoreInteger(cache, missionKey, labelPrefix + "Ability", this.ability())
			call StoreInteger(cache, missionKey, labelPrefix + "UpgradeAction", this.upgradeAction())
			call StoreInteger(cache, missionKey, labelPrefix + "CastCondition", this.castCondition())
			call StoreInteger(cache, missionKey, labelPrefix + "CastAction", this.castAction())
		endmethod

		public stub method restore takes gamecache cache, string missionKey, string labelPrefix returns nothing
			set this.m_ability = GetStoredInteger(cache, missionKey, labelPrefix + "Ability")
			set this.m_upgradeAction = GetStoredInteger(cache, missionKey, labelPrefix + "UpgradeAction")
			set this.m_castCondition = GetStoredInteger(cache, missionKey, labelPrefix + "CastCondition")
			set this.m_castAction = GetStoredInteger(cache, missionKey, labelPrefix + "CastAction")
		endmethod

		//Make it available
		public method enable takes nothing returns nothing
			call EnableTrigger(this.m_upgradeTrigger)
			call EnableTrigger(this.m_castTrigger)
		endmethod

		public method disable takes nothing returns nothing
			call DisableTrigger(this.m_upgradeTrigger)
			call DisableTrigger(this.m_castTrigger)
		endmethod

		public stub method onUpgradeAction takes nothing returns nothing
			if (this.m_upgradeAction != 0) then
				call this.m_upgradeAction.execute(this, GetLearnedSkillLevel())
			endif
		endmethod

		public stub method onCastCondition takes nothing returns boolean
			return (this.m_castCondition == 0 or this.m_castCondition.evaluate(this))
		endmethod

		public stub method onCastAction takes nothing returns nothing
			if (this.m_castAction != 0) then
				call this.m_castAction.execute(this)
			endif
		endmethod

		private static method triggerConditionRightAbility takes nothing returns boolean
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, 0)
			local boolean result = (GetLearnedSkill() == this.ability())
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
			local conditionfunc conditionFunction
			local triggercondition triggerCondition
			local triggeraction triggerAction
			set this.m_upgradeTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_upgradeTrigger, EVENT_PLAYER_HERO_SKILL)
			set conditionFunction = Condition(function thistype.triggerConditionRightAbility)
			set triggerCondition = TriggerAddCondition(this.m_upgradeTrigger, conditionFunction)
			set triggerAction = TriggerAddAction(this.m_upgradeTrigger, function thistype.triggerActionUpgrade)
			call AHashTable.global().setHandleInteger(this.m_upgradeTrigger, 0, this)
			set conditionFunction = null
			set triggerCondition = null
			set triggerAction = null
		endmethod

		private static method triggerConditionCast takes nothing returns boolean
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, 0)
			local boolean result = (GetSpellAbilityId() == this.m_ability)
			if (result) then
				set result = this.onCastCondition()
				if (not result) then
					//taken from wc3jass.com
					//call PauseUnit(this.character().unit(), true)
					call IssueImmediateOrder(GetTriggerUnit(), "stop")
					//call PauseUnit(this.character().unit(), false)
				endif
			endif
			set triggeringTrigger = null
			return result
		endmethod

		private static method triggerActionCast takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, 0)
			call this.onCastAction.execute()
			set triggeringTrigger = null
		endmethod

		private method createCastTrigger takes playerunitevent castEvent returns nothing
			local conditionfunc conditionFunction
			local triggercondition triggerCondition
			local triggeraction triggerAction
			set this.m_castTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_castTrigger, castEvent)
			set conditionFunction = Condition(function thistype.triggerConditionCast)
			set triggerCondition = TriggerAddCondition(this.m_castTrigger, conditionFunction)
			set triggerAction = TriggerAddAction(this.m_castTrigger, function thistype.triggerActionCast)
			call AHashTable.global().setHandleInteger(this.m_castTrigger, 0, this)
			set conditionFunction = null
			set triggerCondition = null
			set triggerAction = null
		endmethod

		/**
		 * \param character Used character.
		 * \param usedAbility The ability which has to be casted by the unit of the character to run the cast action and which has to be skilled for the unit of the character to run the teach action.
		 */
		public static method create takes integer usedAbility, ASpellUpgradeAction upgradeAction, ASpellCastCondition castCondition, ASpellCastAction castAction, playerunitevent castEvent returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_ability = usedAbility
			set this.m_upgradeAction = upgradeAction
			set this.m_castCondition = castCondition
			set this.m_castAction = castAction

			call this.createUpgradeTrigger()
			call this.createCastTrigger(castEvent)

			return this
		endmethod

		/// Use this constructor if you either don't any event response functions or you overwrite the stub methods.
		public static method createSimple takes integer whichAbility returns thistype
			return thistype.create(whichAbility, 0, 0, 0, EVENT_PLAYER_UNIT_SPELL_ENDCAST)
		endmethod

		public static method createRestored takes gamecache cache, string missionKey, string labelPrefix returns thistype
			local thistype this = thistype.allocate()
			call this.restore(cache, missionKey, labelPrefix)
			return this
		endmethod

		private method destroyUpgradeTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_upgradeTrigger)
			set this.m_upgradeTrigger = null
		endmethod

		private method destroyCastTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_castTrigger)
			set this.m_castTrigger = null
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.destroyUpgradeTrigger()
			call this.destroyCastTrigger()
		endmethod

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