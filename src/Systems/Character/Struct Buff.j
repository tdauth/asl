library AStructSystemsCharacterBuff requires AStructCoreGeneralHashTable, AStructCoreGeneralVector

	/**
	 * Provides acces to buff type which can be added as buff instance several times to one single unit.
	 * Buff ID should be a custom ability ID of an aura which only affects the caster himself to create real buff effect in Warcraft III.
	 * A useful ability is 'Aasl' which allows you to create positive and negative buffs depending on its real value.
	 * \note If you remove a unit and \ref thistype.remove() is never called te stored buff counter leaks.
	 */
	struct ABuff
		// construction members
		private integer m_buffId
		// members
		private AUnitVector m_targets
		private integer m_index
		
		public stub method onAdd takes unit source, unit whichUnit, integer index returns nothing
		endmethod
		
		public stub method onRemove takes unit source, unit whichUnit, integer index returns nothing
		endmethod

		/**
		 * Use this method to check whether specific buff effects should be removed from unit.
		 */
		public method count takes unit whichUnit returns integer
			debug call Print("Before getting count")
			return AHashTable.global().handleInteger(whichUnit, "ABuff" + I2S(this) + "Count")
		endmethod

		public method add takes unit source, unit whichUnit returns integer
			local integer count = this.count(whichUnit)
			debug call Print("ABuff count of unit " + GetUnitName(whichUnit) + ": " + I2S(count))
			call this.m_targets.pushBack(whichUnit)
			if (count == 0) then
				debug call Print("ABuff Adding ability: " + GetObjectName(this.m_buffId))
				call UnitAddAbility(whichUnit, this.m_buffId)
				call UnitMakeAbilityPermanent(whichUnit, true, this.m_buffId) // bleibt auch bei Verwandlungen
			endif
			set count = count + 1
			call AHashTable.global().setHandleInteger(whichUnit, "ABuff" + I2S(this) + "Count", count)
			call this.onAdd.evaluate(source, whichUnit, count - 1)
			return this.m_targets.backIndex()
		endmethod

		public method remove takes unit source, unit whichUnit returns nothing
			local integer count = this.count(whichUnit)
			call this.onRemove.evaluate(source, whichUnit, count)
			call this.m_targets.remove(whichUnit)
			set count = count - 1
			call AHashTable.global().setHandleInteger(whichUnit, "ABuff" + I2S(this) + "Count", count)
			if (count == 0) then
				debug call Print("ABuff Removing ability: " + GetObjectName(this.m_buffId))
				call AHashTable.global().removeHandleInteger(whichUnit, "ABuff" + I2S(this) + "Count")
				call UnitRemoveAbility(whichUnit, this.m_buffId)
			endif
		endmethod

		public static method create takes integer buffId returns thistype
			local thistype this = thistype.allocate()
			set this.m_buffId = buffId
			set this.m_targets = AUnitVector.create()
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_targets.destroy()
			// TODO clean from all targets
		endmethod
	endstruct

endlibrary