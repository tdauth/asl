library AStructCoreMeleetIdTable requires AStructCoreContainerslIntegerList, AStructCoreMeleeIdSet

	/**
	* List of \ref AIdSet instances.
	* One single table can generate multiple ids from multiple id sets.
	* For single id generation only use \ref AIdSet.
	* \sa AAbstractIdItem, AIdSet
	*/
	struct AIdTable extends AIntegerList

		public method addSet takes AIdGeneratorSet whichSet returns nothing
			call this.pushBack(whichSet)
		endmethod

		public method removeSet takes AIdGeneratorSet whichSet returns nothing
			call this.remove(whichSet)
		endmethod

		public method generate takes nothing returns AIntegerList
			local AIntegerList result = AIntegerList.create()
			local AIntegerListIterator iterator = this.begin()
			local integer itemTypeId
			loop
				exitwhen (not iterator.isValid())
				set id = AAbstractIdGeneratorSet(iterator.data()).generate()
				if (id != 0) then
					call result.pushBack(id)
				endif
				call iterator.next()
			endloop
			call iterator.destroy()
			return result
		endmethod
	endstruct

endlibrary