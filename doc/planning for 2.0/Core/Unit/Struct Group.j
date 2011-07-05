library AStructCoreUnitGroup requires ATextMacroCoreContainersSet, ALibraryCoreUnitMisc

	struct AGroupIterator extends AUnitSetIterator
	endstruct

	/**
	* This struct is kind of wrapper for data type \ref group. Since group does not allow
	* direct accesses to internally stored units it's very annoying to get any group member
	* which is not the first one.
	* You'll always have to iterate the whole group, remove the first member and copying it into
	* another group which should replace your first one in the end.
	* This process has to go on until you found your required unit.
	* Another possibility is to use filters but they have to be global functions and therefore
	* you will either have to attach data anywhere or have to use a global variable.
	* Instead of using filter functions this struct allows you direct access to a vector
	* which contains all units.
	* Additionally it provides various addGroup methods which do use the GroupEnum functions from Jass.
	* Methods like \ref AGroup#removeUnitsOfPlayer or \ref AGroup#removeAlliesOfUnit are very useful for spell functions.
	* The only disadvantage of this struct is that it is a little bit slower than using native type group (especially when adding other groups e. g. by using \ref AGroup#addUnitsOfType).
	*/
	struct AGroup extends AUnitSet
		// methods

		/**
		* Adds all units contained by group \p other at the end of group.
		*/
		public method addOther takes thistype other returns nothing
			call this.spliceOtherBack(other)
		endmethod

		/**
		* Removes all units contained by group \p other.
		*/
		public method removeOther takes thistype other returns nothing
			call this.removeOther(other)
		endmethod

		/**
		* Adds unit \p whichUnit at the end of group.
		*/
		public method addUnit takes unit whichUnit returns nothing
			call this.pushBack(whichUnit)
		endmethod

		/**
		* Removes all group entries of unit \p whichUnit.
		*/
		public method removeUnit takes unit whichUnit returns nothing
			call this.remove(whichUnit)
		endmethod

		/**
		* \sa AContainerInterface#empty
		*/
		public method isEmpty takes nothing returns boolean
			return this.empty()
		endmethod

		public method isInRect takes rect whichRect returns boolean
			local AGroupIterator iterator
			if (this.empty()) then
				return false
			endif
			set iterator = this.begin()
			loop
				exitwhen (not iterator.isValid()
				if (not RectContainsUnit(whichRect, iterator.data()) then
					call iterator.destroy()
					return false
				endif
				call iterator.next()
			endloop
			call iterator.destroy()
			return true
		endmethod

		public method isInRegion takes region whichRegion returns boolean
			local AGroupIterator iterator
			if (this.empty()) then
				return false
			endif
			set iterator = this.begin()
			loop
				exitwhen (not iterator.isValid()
				if (not IsUnitInRegion(whichRegion, iterator.data()) then
					call iterator.destroy()
					return false
				endif
				call iterator.next()
			endloop
			call iterator.destroy()
			return true
		endmethod

		/**
		* \sa AContainerInterface#random, GroupPickRandomUnit
		*/
		public method pickRandomUnit takes nothing returns unit
			return this.random()
		endmethod

		/**
		* Creates a new Warcraft-3-like group from the group.
		* \return Returns a newly created group.
		*/
		public method toGroup takes nothing returns group
			local group whichGroup = CreateGroup()
			call this.fillGroup(whichGroup)
			return whichGroup
		endmethod

		/**
		* \sa AUnitList#forEach
		*/
		public method forGroup takes AUnitListUnaryFunction forFunction returns nothing
			call this.forEach(forFunction)
		endmethod

		/**
		* \sa AGroup#removeFromGroup, AGroup#fillGroup
		*/
		public method addToGroup takes group whichGroup returns nothing
			local AGroupIterator iterator = this.begin()
			loop
				exitwhen (not iterator.isValid())
				call GroupAddUnit(whichGroup, iterator.data())
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		public method removeFromGroup takes group whichGroup returns nothing
			local AGroupIterator iterator = this.begin()
			loop
				exitwhen (not iterator.isValid())
				call GroupRemoveUnit(whichGroup, iterator.data())
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		/**
		* Fills an existing Warcraft-3-like group with all members of the group.
		* \note The target group is cleared before!
		* \param whichGroup Group which is filled with all group members.
		* \sa AGroup#addToGroup
		*/
		public method fillGroup takes group whichGroup returns nothing
			call GroupClear(whichGroup)
			call this.addToGroup(whichGroup)
		endmethod

		/**
		* Adds all units of group \p whichGroup to the group.
		* \sa AGroup#addGroupClear, AGroup#addGroupDestroy, AGroup#removeGroup
		*/
		public method addGroup takes group whichGroup returns nothing
			local unit firstOfGroup
			loop
				exitwhen (IsUnitGroupEmptyBJ(whichGroup))
				set firstOfGroup = FirstOfGroupSave(whichGroup)
				call this.pushBack(firstOfGroup)
				call GroupRemoveUnit(whichGroup, firstOfGroup)
				set firstOfGroup = null
			endloop
			call GroupClear(whichGroup)
			call this.addToGroup(whichGroup)
		endmethod

		/**
		* Adds all units of group \p whichGroup to the group and clears it afterwards.
		* \note This is much faster than calling \ref AGroup#addGroup and \ref GroupClear since a group has always to be cleared when adding it to an AGroup instance.
		*/
		public method addGroupClear takes group whichGroup returns nothing
			local unit firstOfGroup
			loop
				exitwhen (IsUnitGroupEmptyBJ(whichGroup))
				set firstOfGroup = FirstOfGroupSave(whichGroup)
				call this.m_units.pushBack(firstOfGroup)
				call GroupRemoveUnit(whichGroup, firstOfGroup)
				set firstOfGroup = null
			endloop
			call GroupClear(whichGroup)
		endmethod

		/**
		* Adds all units of group \p whichGroup to the group and destroys it afterwards.
		* \note This is much faster than calling \ref AGroup#addGroup and \ref DestroyGroup since a group has always to be cleared when adding it to an AGroup instance.
		*/
		public method addGroupDestroy takes group whichGroup returns nothing
			call this.addGroupClear(whichGroup)
			call DestroyGroup(whichGroup)
		endmethod

		public method removeGroup takes group whichGroup returns nothing
			local group copy = CreateGroup()
			local unit firstOfGroup
			call GroupAddGroup(whichGroup, copy)
			loop
				exitwhen (IsUnitGroupEmptyBJ(copy))
				set firstOfGroup = FirstOfGroupSave(copy)
				call this.remove(firstOfGroup)
				call GroupRemoveUnit(copy, firstOfGroup)
				set firstOfGroup = null
			endloop
			call GroupClear(copy)
			call DestroyGroup(copy)
		endmethod

		/**
		* Removes all units of group \p whichGroup from the group and clears it afterwards.
		* \note This is much faster than calling \ref AGroup#removeGroup and \ref GroupClear since a group has always to be copied when adding it to an AGroup instance if it should not be cleared.
		*/
		public method removeGroupClear takes group whichGroup returns nothing
			local unit firstOfGroup
			loop
				exitwhen (IsUnitGroupEmptyBJ(whichGroup))
				set firstOfGroup = FirstOfGroupSave(whichGroup)
				call this.remove(firstOfGroup)
				call GroupRemoveUnit(whichGroup, firstOfGroup)
				set firstOfGroup = null
			endloop
			call GroupClear(whichGroup)
		endmethod

		/**
		* Removes all units of group \p whichGroup from the group and destroys it afterwards.
		* \note This is much faster than calling \ref AGroup#removeGroup and \ref DestroyGroup since a group has always to be copied when adding it to an AGroup instance if it should not be cleared.
		*/
		public method removeGroupDestroy takes group whichGroup returns nothing
			call this.removeGroupClear(whichGroup)
			call DestroyGroup(whichGroup)
		endmethod

		public method addUnitsOfType takes string unitTypeName, boolexpr filter returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsOfType(whichGroup, unitTypeName, filter)
			call this.addGroupDestroy(whichGroup)
			set whichGroup = null
		endmethod

		public method addUnitsOfPlayer takes player whichPlayer, boolexpr filter returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsOfPlayer(whichGroup, whichPlayer, filter)
			call this.addGroupDestroy(whichGroup)
			set whichGroup = null
		endmethod

		public method addUnitsOfTypeCounted takes string unitTypeName, boolexpr filter, integer countLimit returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsOfTypeCounted(whichGroup, unitTypeName, filter, countLimit)
			call this.addGroupDestroy(whichGroup)
			set whichGroup = null
		endmethod

		public method addUnitsInRect takes rect whichRect, boolexpr filter returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsInRect(whichGroup, whichRect, filter)
			call this.addGroupDestroy(whichGroup)
			set whichGroup = null
		endmethod

		public method addUnitsInRectCounted takes rect whichRect, boolexpr filter, integer countLimit returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsInRectCounted(whichGroup, whichRect, filter, countLimit)
			call this.addGroupDestroy(whichGroup)
			set whichGroup = null
		endmethod

		public method addUnitsInRange takes real x, real y, real radius, boolexpr filter returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsInRange(whichGroup, x, y, radius, filter)
			call this.addGroupDestroy(whichGroup)
			set whichGroup = null
		endmethod

		public method addUnitsInRangeOfLocation takes location whichLocation, real radius, boolexpr filter returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsInRangeOfLoc(whichGroup, whichLocation, radius, filter)
			call this.addGroupDestroy(whichGroup)
			set whichGroup = null
		endmethod

		public method addUnitsInRangeCounted takes real x, real y, real radius, boolexpr filter, integer countLimit returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsInRangeCounted(whichGroup, x, y, radius, filter, countLimit)
			call this.addGroupDestroy(whichGroup)
			set whichGroup = null
		endmethod

		public method addUnitsInRangeOfLocationCounted takes location whichLocation, real radius, boolexpr filter, integer countLimit returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsInRangeOfLocCounted(whichGroup, whichLocation, radius, filter, countLimit)
			call this.addGroupDestroy(whichGroup)
			set whichGroup = null
		endmethod

		public method addUnitsSelected takes player whichPlayer, boolexpr filter returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsSelected(whichGroup, whichPlayer, filter)
			call this.addGroupDestroy(whichGroup)
			set whichGroup = null
		endmethod

		public method immediateOrder takes string order returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupImmediateOrder(whichGroup, order)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method immediateOrderById takes integer order returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupImmediateOrderById(whichGroup, order)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method pointOrder takes string order, real x, real y returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupPointOrder(whichGroup, order, x, y)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method locationOrder takes string order, location whichLocation returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupPointOrderLoc(whichGroup, order, whichLocation)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method pointOrderById takes integer order, real x, real y returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupPointOrderById(whichGroup, order, x, y)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method locationOrderById takes integer order, location whichLocation returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupPointOrderByIdLoc(whichGroup, order, whichLocation)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method targetOrder takes string order, widget targetWidget returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupTargetOrder(whichGroup, order, targetWidget)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		public method targetOrderById takes integer order, widget targetWidget returns boolean
			local group whichGroup = this.group()
			local boolean result = GroupTargetOrderById(whichGroup, order, targetWidget)
			call DestroyGroup(whichGroup)
			set whichGroup = null
			return result
		endmethod

		/**
		* \return Returns true if all members of the group are the same as in group \p whichGroup or if both groups are empty.
		*/
		public method isEqualToGroup takes group whichGroup returns boolean
			local AGroupIterator iterator = this.begin()
			loop
				exitwhen (not iterator.isValid())
				if (not IsUnitInGroup(iterator.data(), whichGroup)) then
					call iterator.destroy()
					return false
				endif
				call iterator.next()
			endloop
			call iterator.destroy()
			return true
		endmethod

		/**
		* \return Returns true if all members of the group are the same as in group \p other. Returns false if the group is empty.
		*/
		public method isInOther takes thistype other returns boolean
			if (this.empty()) then
				return false
			endif
			return this.isEqualToOther(other)
		endmethod

		/**
		* \return Returns true if all members of the group are the same as in group \p whichGroup. Returns false if the group is empty.
		*/
		public method isInGroup takes group whichGroup returns boolean
			if (this.empty()) then
				return false
			endif
			return this.isEqualToGroup(whichGroup)
		endmethod

		/**
		* \return Returns true if all members of the group are dead. Returns false if the group is empty.
		*/
		public method isDead takes nothing returns boolean
			local AGroupIterator iterator
			if (this.empty()) then
				return false
			endif
			set iterator = this.begin()
			loop
				exitwhen (not iterator.isValid())
				if (not IsUnitDeadBJ(iterator.data())) then
					return false
				endif
				call iterator.next()
			endloop
			return true
		endmethod

		/**
		* \return Returns true if all members of the group are alive. Returns false if the group is empty.
		*/
		public method isAlive takes nothing returns boolean
			local AGroupIterator iterator
			if (this.empty()) then
				return false
			endif
			set iterator = this.begin()
			loop
				exitwhen (not iterator.isValid())
				if (IsUnitDeadBJ(iterator.data())) then
					return false
				endif
				call iterator.next()
			endloop
			return true
		endmethod

		public method hasUnitsOfPlayer takes player whichPlayer returns boolean
			local AGroupIterator iterator = this.begin()
			loop
				exitwhen (not iterator.isValid())
				if (GetOwningPlayer(iterator.data()) == whichPlayer) then
					call iterator.destroy()
					return true
				endif
				call iterator.next()
			endloop
			call iterator.destroy()
			return false
		endmethod

		public method hasUnitsOfForce takes force whichForce returns boolean
			local AGroupIterator iterator = this.begin()
			loop
				exitwhen (not iterator.isValid())
				if (IsPlayerInForce(GetOwningPlayer(iterator.data()), whichForce)) then
					call iterator.destroy()
					return true
				endif
				call iterator.next()
			endloop
			call iterator.destroy()
			return false
		endmethod

		public method removeUnitsOfPlayer takes player whichPlayer returns nothing
			local AGroupIterator iterator = this.begin()
			loop
				exitwhen (not iterator.isValid())
				if (GetOwningPlayer(iterator.data()) == whichPlayer) then
					call this.eraseIncrease(iterator)
				else
					call iterator.next()
				endif
			endloop
			call iterator.destroy()
		endmethod

		public method removeUnitsOfForce takes force whichForce returns nothing
			local AGroupIterator iterator = this.begin()
			loop
				exitwhen (not iterator.isValid())
				if (IsPlayerInForce(GetOwningPlayer(iterator.data()), whichForce)) then
					call this.eraseIncrease(iterator)
				else
					call iterator.next()
				endif
			endloop
			call iterator.destroy()
		endmethod

		public method hasAlliesOfPlayer takes player whichPlayer returns boolean
			local player owner
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				set owner = GetOwningPlayer(this.m_units[i])
				if (IsPlayerAlly(owner, whichPlayer)) then
					set owner = null
					return true
				endif
				set i = i + 1
				set owner = null
			endloop
			return false
		endmethod

		public method hasAlliesOfUnit takes unit whichUnit returns boolean
			local player owner = GetOwningPlayer(whichUnit)
			local boolean result = this.hasAlliesOfPlayer(owner)
			set owner = null
			return result
		endmethod

		public method removeAlliesOfPlayer takes player whichPlayer returns nothing
			local player owner
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				set owner = GetOwningPlayer(this.m_units[i])
				if (IsPlayerAlly(owner, whichPlayer)) then
					call this.m_units.erase(i)
				else
					set i = i + 1
				endif
				set owner = null
			endloop
		endmethod

		public method removeAlliesOfUnit takes unit whichUnit returns nothing
			local player owner = GetOwningPlayer(whichUnit)
			call this.removeAlliesOfPlayer(owner)
			set owner = null
		endmethod

		public method hasEnemiesOfPlayer takes player whichPlayer returns boolean
			local player owner
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				set owner = GetOwningPlayer(this.m_units[i])
				if (not IsPlayerAlly(owner, whichPlayer)) then
					set owner = null
					return true
				endif
				set i = i + 1
				set owner = null
			endloop
			return false
		endmethod

		public method hasEnemiesOfUnit takes unit whichUnit returns boolean
			local player owner = GetOwningPlayer(whichUnit)
			local boolean result = this.hasEnemiesOfPlayer(owner)
			set owner = null
			return result
		endmethod

		public method removeEnemiesOfPlayer takes player whichPlayer returns nothing
			local player owner
			local integer i = 0
			loop
				exitwhen (i == this.m_units.size())
				set owner = GetOwningPlayer(this.m_units[i])
				if (not IsPlayerAlly(owner, whichPlayer)) then
					call this.m_units.erase(i)
				else
					set i = i + 1
				endif
				set owner = null
			endloop
		endmethod

		public method removeEnemiesOfUnit takes unit whichUnit returns nothing
			local player owner = GetOwningPlayer(whichUnit)
			call this.removeEnemiesOfPlayer(owner)
			set owner = null
		endmethod

		/**
		*
		*/
		public method select takes nothing returns nothing
			local AGroupIterator iterator = this.begin()
			loop
				exitwhen (not iterator.isValid())
				call SelectUnit(iterator.data(), true)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		public method deselect takes nothing returns nothing
			local AGroupIterator iterator = this.begin()
			loop
				exitwhen (i == this.m_units.size())
				call SelectUnit(iterator.data(), false)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		public method selectOnly takes nothing returns nothing
			call ClearSelection()
			call this.select()
		endmethod

		public method selectForPlayer takes player whichPlayer returns nothing
			if (whichPlayer == GetLocalPlayer()) then
				call this.select()
			endif
		endmethod

		public method deselectForPlayer takes player whichPlayer returns nothing
			if (whichPlayer == GetLocalPlayer()) then
				call this.deselect()
			endif
		endmethod

		public method selectOnlyForPlayer takes player whichPlayer returns nothing
			if (whichPlayer == GetLocalPlayer()) then
				call this.selectOnly()
			endif
		endmethod

		public method selectForForce takes force whichForce returns nothing
			if (IsPlayerInForce(GetLocalPlayer(), whichPlayer)) then
				call this.select()
			endif
		endmethod

		public method deselectForForce takes force whichForce returns nothing
			if (IsPlayerInForce(GetLocalPlayer(), whichPlayer)) then
				call this.deselect()
			endif
		endmethod

		public method selectOnlyForForce takes force whichForce returns nothing
			if (IsPlayerInForce(GetLocalPlayer(), whichPlayer)) then
				call this.selectOnly()
			endif
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			return this
		endmethod

		public static method createWithGroup takes group whichGroup returns thistype
			local thistype this = thistype.create()
			call this.addGroup(whichGroup)
			return this
		endmethod

		public static method createWithGroupClear takes group whichGroup returns thistype
			local thistype this = thistype.create()
			call this.addGroupClear(whichGroup)
			return this
		endmethod

		public static method createWithGroupDestroy takes group whichGroup returns thistype
			local thistype this = thistype.create()
			call this.addGroupDestroy(whichGroup)
			return this
		endmethod

		public static method unitsOfType takes string unitTypeName, boolexpr filter returns thistype
			local thistype this = thistype.create()
			call this.addUnitsOfType(unitTypeName, filter)
			return this
		endmethod

		public static method unitsOfPlayer takes player whichPlayer, boolexpr filter returns thistype
			local thistype this = thistype.create()
			call this.addUnitsOfPlayer(whichPlayer, filter)
			return this
		endmethod

		public static method unitsOfTypeCounted takes string unitTypeName, boolexpr filter, integer countLimit returns thistype
			local thistype this = thistype.create()
			call this.addUnitsOfTypeCounted(unitTypeName, filter, countLimit)
			return this
		endmethod

		public static method unitsInRect takes rect whichRect, boolexpr filter returns thistype
			local thistype this = thistype.create()
			call this.addUnitsInRect(whichRect, filter)
			return this
		endmethod

		public static method unitsInRectCounted takes rect whichRect, boolexpr filter, integer countLimit returns thistype
			local thistype this = thistype.create()
			call this.addUnitsInRectCounted(whichRect, filter, countLimit)
			return this
		endmethod

		public static method unitsInRange takes real x, real y, real radius, boolexpr filter returns thistype
			local thistype this = thistype.create()
			call this.addUnitsInRange(x, y, radius, filter)
			return this
		endmethod

		public static method unitsInRangeOfLocation takes location whichLocation, real radius, boolexpr filter returns thistype
			local thistype this = thistype.create()
			call this.addUnitsInRangeOfLocation(whichLocation, radius, filter)
			return this
		endmethod

		public static method unitsInRangeCounted takes real x, real y, real radius, boolexpr filter, integer countLimit returns thistype
			local thistype this = thistype.create()
			call this.addUnitsInRangeCounted(x, y, radius, countLimit)
			return this
		endmethod

		public static method unitsInRangeOfLocationCounted takes location whichLocation, real radius, boolexpr filter, integer countLimit returns thistype
			local thistype this = thistype.create()
			call this.addUnitsInRangeOfLocationCounted(whichLocation, radius, filter, countLimit)
			return this
		endmethod

		public static method unitsSelected takes player whichPlayer, boolexpr filter returns thistype
			local thistype this = thistype.create()
			call this.addUnitsSelected(whichPlayer, filter)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod
		
		public method operator< takes thistype other returns unit
			return super(this) < super(other)
		endmethod
		
		public method operator[]= takes integer index, unit whichUnit returns nothing
			return super[index] = whichUnit
		endmethod
		
		public method operator[] takes integer index returns unit
			return super[index]
		endmethod
	endstruct

endlibrary