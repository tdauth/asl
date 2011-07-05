library AStructCoreMeleeIdSet requires AStructCoreContainersIntegerSet, AStructCoreMeleeAbstractIdItem

	/**
	* Set of \ref AAbstractIdItem instances.
	* One single set can only generate one single id from multiple id items.
	* For multiple id generation use #AIdTable.
	* \sa AAbstractIdItem, AIdTable
	*/
	struct AIdSet extends AIntegerSet

		public method addItem takes AAbstractIdItem idItem returns nothing
			call this.insert(idItem)
		endmethod

		public method removeItem takes AAbstractIdItem idItem returns nothing
			call this.erase(idItem)
		endmethod

		public method totalChance takes nothing returns integer
			local AIntegerSetIterator iterator = this.begin()
			local integer total = 0
			loop
				exitwhen (not iterator.isValid())
				set total = total + AAbstractIdItem(iterator.value()).chance()
				call iterator.next()
			endloop
			call iterator.destroy()
			return total
		endmethod

		/**
		* \return Returns 0 if no valid item id was found.
		*/
		public method generate takes nothing returns integer
			local integer chance
			local integer sum
			local integer result
			local AIntegerSetIterator iterator
			if (this.m_items.empty()) then
				return 0
			endif
			set chance = GetRandomInt(1, this.totalChance())
			set sum = 0
			set result = 0
			set iterator = this.begin()
			loop
				set sum = sum + AAbstractIdItem(iterator.data()).chance()
				if (AAbstractIdItem(iterator.data()).chance() <= sum) then
					set result = AAbstractIdItem(iterator.data()).generate()
					exitwhen (true)
				endif
				call iterator.next()
				exitwhen (not iterator.isValid())
			endloop
			call iterator.destroy()

			return result
		endmethod
	endstruct

endlibrary