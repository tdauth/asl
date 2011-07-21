/**
* ASL 2.0
*/
library AStructCoreMeeleInventory requires AInterfaceSerializationSerializable

	/**
	* This structure is used to store all item information of one slot in inventory.
	*/
	struct AInventoryItemData extends ASerializable
		// dynamic members
		private integer m_itemTypeId
		private integer m_charges
		private integer m_dropId
		private boolean m_invulnerable
		private real m_life
		private boolean m_pawnable
		private player m_player
		private integer m_userData
		private boolean m_visible
		private itemtype m_itemType

		public method setItemTypeId takes integer itemTypeId returns nothing
			set this.m_itemTypeId = itemTypeId
		endmethod

		public method itemTypeId takes nothing returns integer
			return this.m_itemTypeId
		endmethod

		public method setCharges takes integer charges returns nothing
			set this.m_charges = IMaxBJ(charges, 0)
		endmethod

		public method charges takes nothing returns integer
			return this.m_charges
		endmethod

		public method setDropId takes integer dropId returns nothing
			set this.m_dropId = dropId
		endmethod

		public method dropId takes nothing returns integer
			return this.m_dropId
		endmethod

		public method setInvulnerable takes boolean invulnerable returns nothing
			set this.m_invulnerable = invulnerable
		endmethod

		public method invulnerable takes nothing returns boolean
			return this.m_invulnerable
		endmethod

		public method setLife takes real life returns nothing
			set this.m_life = life
		endmethod

		public method life takes nothing returns real
			return this.m_life
		endmethod

		public method setPawnable takes boolean pawnable returns nothing
			set this.m_pawnable = pawnable
		endmethod

		public method pawnable takes nothing returns boolean
			return this.m_pawnable
		endmethod

		public method setPlayer takes player user returns nothing
			set this.m_player = user
		endmethod

		public method player takes nothing returns player
			return this.m_player
		endmethod

		public method setUserData takes integer userData returns nothing
			set this.m_userData = userData
		endmethod

		public method userData takes nothing returns integer
			return this.m_userData
		endmethod

		public method setVisible takes boolean visible returns nothing
			set this.m_visible = visible
		endmethod

		public method visible takes nothing returns boolean
			return this.m_visible
		endmethod

		public method setItemType takes itemtype itemType returns nothing
			set this.m_itemType = itemType
		endmethod

		public method itemType takes nothing returns itemtype
			return this.m_itemType
		endmethod

		public method assignFromItem takes item whichItem, unit whichUnit returns nothing
			// dynamic members
			set this.m_itemTypeId = GetItemTypeId(whichItem)
			set this.m_charges = GetItemCharges(whichItem)
			set this.m_dropId = GetUnitTypeId(whichUnit)
			set this.m_invulnerable = IsItemInvulnerable(whichItem)
			set this.m_life = GetWidgetLife(whichItem)
			set this.m_pawnable = IsItemPawnable(whichItem)
			set this.m_player = GetItemPlayer(whichItem)
			set this.m_userData = GetItemUserData(whichItem)
			set this.m_visible = IsItemVisible(whichItem)
			set this.m_itemType = GetItemType(whichItem)
		endmethod

		public method assignToItem takes item usedItem returns nothing
			call SetItemCharges(usedItem, this.m_charges)
			call SetItemDropID(usedItem, this.m_dropId)
			call SetItemInvulnerable(usedItem, this.m_invulnerable)
			call SetWidgetLife(usedItem, this.m_life)
			call SetItemPawnable(usedItem, this.m_pawnable)
			call SetItemPlayer(usedItem, this.m_player, true)
			call SetItemUserData(usedItem, this.m_userData)
			call SetItemVisible(usedItem, this.m_visible)
		endmethod

		public method createItem takes real x, real y returns item
			local item result = CreateItem(this.m_itemTypeId, x, y)
			call this.assignToItem(result)
			return result
		endmethod

		public method createForUnit takes unit whichUnit returns item
			local item result = this.createItem(GetUnitX(whichUnit), GetUnitY(whichUnit))
			call UnitAddItem(whichUnit, result)
			return result
		endmethod

		public method createForUnitInSlot takes unit whichUnit, integer slot returns item
			local item result = UnitAddItemToSlotById(whichUnit, this.m_itemTypeId, slot)
			call this.assignToItem(result)
			return result
		endmethod

		public method addItemDataCharges takes thistype other returns integer
			call this.setCharges(this.charges() + other.charges())
			return this.charges()
		endmethod

		public method removeItemDataCharges takes thistype other returns integer
			call this.setCharges(this.charges() - other.charges())
			return this.charges()
		endmethod

		public method store takes gamecache cache, string missionKey, string labelPrefix returns nothing
			call StoreInteger(cache, missionKey, labelPrefix + "ItemTypeId", this.m_itemTypeId)
			call StoreInteger(cache, missionKey, labelPrefix + "Charges", this.m_charges)
			call StoreInteger(cache, missionKey, labelPrefix + "DropId", this.m_dropId)
			call StoreBoolean(cache, missionKey, labelPrefix + "Invulnerable", this.m_invulnerable)
			call StoreReal(cache, missionKey, labelPrefix + "Life", this.m_life)
			call StoreBoolean(cache, missionKey, labelPrefix + "Pawnable", this.m_pawnable)
			call StoreInteger(cache, missionKey, labelPrefix + "PlayerId", GetPlayerId(this.m_player))
			call StoreInteger(cache, missionKey, labelPrefix + "UserData", this.m_userData)
			call StoreBoolean(cache, missionKey, labelPrefix + "Visible", this.m_visible)
		endmethod

		public method restore takes gamecache cache, string missionKey, string labelPrefix returns nothing
			set this.m_itemTypeId = GetStoredInteger(cache, missionKey, labelPrefix + "ItemTypeId")
			set this.m_charges = GetStoredInteger(cache, missionKey, labelPrefix + "Charges")
			set this.m_dropId = GetStoredInteger(cache, missionKey, labelPrefix + "DropId")
			set this.m_invulnerable = GetStoredBoolean(cache, missionKey, labelPrefix + "Invulnerable")
			set this.m_life = GetStoredReal(cache, missionKey, labelPrefix + "Life")
			set this.m_pawnable = GetStoredBoolean(cache, missionKey, labelPrefix + "Pawnable")
			set this.m_player = Player(GetStoredInteger(cache, missionKey, labelPrefix + "PlayerId"))
			set this.m_userData = GetStoredInteger(cache, missionKey, labelPrefix + "UserData")
			set this.m_visible = GetStoredBoolean(cache, missionKey, labelPrefix + "Visible")
		endmethod
		
		public method save takes hashtable whichHashtable, integer parentKey, string labelPrefix returns nothing
			call SaveInteger(whichHashtable, parentKey, StringHash(labelPrefix + "ItemTypeId"), this.itemTypeId())
			call SaveInteger(whichHashtable, parentKey, StringHash(labelPrefix + "Charges"), this.charges())
			call SaveInteger(whichHashtable, parentKey, StringHash(labelPrefix + "DropId"), this.dropId())
			call SaveBoolean(whichHashtable, parentKey, StringHash(labelPrefix + "Invulnerable"), this.invulnerable())
			call SaveReal(whichHashtable, parentKey, StringHash(labelPrefix + "Life"), this.life())
			call SaveBoolean(whichHashtable, parentKey, StringHash(labelPrefix + "Pawnable"), this.pawnable())
			call SaveInteger(whichHashtable, parentKey, StringHash(labelPrefix + "PlayerId"), GetPlayerId(this.player()))
			call SaveInteger(whichHashtable, parentKey, StringHash(labelPrefix + "UserData"), this.userData())
			call SaveBoolean(whichHashtable, parentKey, StringHash(labelPrefix + "Visible"), this.visible())
		endmethod
		
		public method load takes hashtable whichHashtable, integer parentKey, string labelPrefix returns nothing
			/// \todo ADD!
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_itemTypeId = 0
			set this.m_charges = 0
			set this.m_dropId = 0
			set this.m_invulnerable = false
			set this.m_life = 0.0
			set this.m_pawnable = false
			set this.m_player = null
			set this.m_userData = 0
			set this.m_visible = false
			set this.m_itemType = 0
			return this
		endmethod

		public static method createByItem takes item whichItem, unit whichUnit return thistype
			local thistype this = thistype.create()
			call this.assignFromItem(whichItem, whichUnit)
			return this
		endmethod

		public static method createRestored takes gamecache cache, string missionKey, string labelPrefix returns thistype
			local thistype this = thistype.allocate()
			call this.restore(cache, missionKey, labelPrefix)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// members
			set this.m_itemType = null
		endmethod
	endstruct

	private struct AInventoryPage
		private AInventory m_inventory
		private integer m_index
		private AInventoryItemData array m_itemData[bj_MAX_INVENTORY]

		public method index takes nothing returns integer
			return this.m_index
		endmethod

		public method itemData takes integer slot returns AInventoryItemData
static if (DEBUG_MODE) then
			if (slot < 0 or slot >= bj_MAX_INVENTORY) then
				call this.print("Invalid slot: " + I2S(slot))
				return 0
			endif
endif
			return this.m_itemData[slot]
		endmethod

		private method addItem takes integer itemTypeId, integer slot returns item
			local item result
			call DisableTrigger(this.m_pickupTrigger)
			set result = UnitAddItemToSlotById(this.inventory().unit(), itemTypeId, slot)
			call EnableTrigger(this.m_pickupTrigger)
			return result
		endmethod

		private method removeItem takes integer slot returns nothing
			call DisableTrigger(this.m_dropTrigger)
			call RemoveItem(UnitItemInSlot(this.inventory().unit(), slot)
			call EnableTrigger(this.m_dropTrigger)
		endmethod

		private method item takes integer slot returns item
			return UnitItemInSlot(this.inventory().unit(), slot)
		endmethod

		public method refreshSlot takes integer slot returns nothing
			local item whichItem
			if (inventory.currentPage() != this.m_index) then
				return
			endif
			if (this.itemData(slot).charges() == 0) then
				call this.removeItem(slot)
			else
				if (this.itemData(slot).itemTypeId() != GetItemTypeId(this.item(slot))) then
					call this.removeItem(slot)
					set whichItem = this.addItem(this.itemData(slot).itemTypeId(), slot)
				else
					set whichItem = this.item(slot)
				endif
				call this.itemData(slot).assignToItem(whichItem)
			endif
		endmethod

		public method refresh takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_INVENTORY)
				call this.refreshSlot(i)
				set i = i + 1
			endloop
		endmethod

		public method setCharges takes integer slot, integer charges returns boolean
			if (this.itemData(slot) == 0) then
				return false
			endif
			call this.itemData(slot).setCharges(charges)
			call this.refreshSlot(slot)
			return true
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			local integer i
			set this.m_index = 0
			set i = 0
			loop
				exitwhen (i == bj_MAX_INVENTORY)
				set this.m_itemData[i] = 0
				set i = i + 1
			endloop

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_INVENTORY)
				if (this.m_itemData[i] != 0) then
					call this.m_itemData[i].destroy()
				endif
				set i = i + 1
			endloop
		endmethod
	endstruct

	/**
	 * Provides access to a virtual-based unit inventory which is highly extensible.
	 * It can make use of up to six different inventory slots which is limited by Warcraft III's engine but it supports paging splitting everything up into nearly unlimited inventory item pages (maximum positive size of \ref integer).
	 * Additionally it supports using and only transporting items (like Warcraft's ability does).
	 * By extending this structure you could support features like custom item types or recepts (for RPGs).
	 */
	struct AInventory
		public static constant integer chargesErrorZero = -1 /// Returned when charges count is 0.
		public static constant integer chargesErrorRequirement = -2 /// Returned when requirement is not filled.
		public static constant integer chargesErrorMissing = -3 /// Returned when item type id is not contained.
		public static constant integer chargesErrorFull = -4 /// Returned when inventory is full but has to have at least one free slot.
		// dynamic members
		private boolean m_usesItems
		private unit m_unit
		private AIntegerMap m_pages /// Map of \ref AInventoryPage instances with indices as key.
		private AInventoryPage m_currentPage

		/**
		 * This event method is being called when value \ref thistype#usesItems is being changed.
		 * In its default behaviour it enables or disables all item effects for the corresponding unit.
		 */
		public stub method onUsesItems takes boolean usesItems returns nothing
			/// \todo Enable/disable item effects
		endmethod

		/**
		 * \param usesItems If this value is true all items affect on the inventory's unit.
		 * If value changes properly \ref thistype#onUsesItems is called.
		 */
		public method setUsesItems takes boolean usesItems returns nothing
			if (usesItems == this.m_usesItems) then
				return
			endif
			call this.onUsesItems.evaluate(usesItems)
			set this.m_usesItems = usesItems
		endmethod

		public method usesItems takes nothing returns boolean
			return this.m_usesItems
		endmethod

		private method page takes integer index returns AInventoryPage
static if (DEBUG_MODE) then
			if (not this.m_pages.containsKey(index)) then
				call this.printMethodError("page", "Wrong page index: " + I2S(index) + ".")
				return 0
			endif
endif
			return this.m_pages[index]
		endmethod

		public method addPage takes nothing returns integer
			call this.m_pages.[this.m_pages.size()] = AInventoryPage.create()
			return this.m_pages.size() - 1
		endmethod

		public method removePage takes integer index returns nothing
			call AInventoryPage(this.m_pages.[index]).destroy()
			call this.m_pages.erase(index)
		endmethod

		public method pages takes nothing returns integer
			return this.m_pages.size()
		endmethod

		public method setPages takes integer count returns nothing
			if (count < this.pages()) then
				loop
					exitwhen (this.pages() == count)
					call this.removePage(this.m_pages.size() - 1)
				endloop
			else
				loop
					exitwhen (this.pages() == count)
					call this.addPage()
				endloop
			endif
		endmethod

		public method currentPage takes nothing returns integer
			return this.m_currentPage.index()
		endmethod

		/**
		 * Event handler method which is called after inventory's page is changed (e. g. by calling method \ref thistype#changePage).
		 * \note Is executed.
		 */
		public stub method onChangePage takes integer page returns nothing
		endmethod

		public method changePage takes integer page returns boolean
			if (this.m_pages.containsKey(page) and page != this.m_currentPage.index()) then
				set this.m_currentPage = this.page(index)
				call this.m_currentPage.refresh()
				call this.onChangePage(page).execute()
			endif
			return false
		endmethod
		
		/**
		 * \return Returns first pair of corresponding inventory page (\ref AInventoryPage) and item data (\ref AInventoryItemData) which contains item(s) of item type id \p itemTypeId.
		 */
		public method pair takes integer itemTypeId returns AIntegerPair
		endmethod
		
		public method freePair takes nothing returns AIntegerPair
		endmethod

		/**
		 * \return Returns pair of pair of corresponding inventory page (\ref AInventoryPage) and page slot. If no valid slot has been found or inventory was simply unable to get more items (does not already contain an item with item type id) an error code is returned.
		 * Here's a list of valid error codes:
		 * <ul>
		 * <li>\ref thistype#chargesErrorZero </li>
		 * <li>\ref thistype#chargesErrorRequirement </li>
		 * <li>\ref thistype#chargesErrorMissing </li>
		 * <li>\ref thistype#chargesErrorFull </li>
		 * </ul>
		 * \note Result is newly allocated and has to be destroyed manually!
		 * \sa AInventoryPage#addCharges
		 */
		public method addCharges takes integer itemTypeId, integer charges returns AIntegerPair
			local AItemType itemType
			local AIntegerPair pair /// pair of corresponding inventory page (\ref AInventoryPage) and item data (\ref AInventoryItemData)
			local AIntegerPair result

			if (charges == 0) then
				return thistype.chargesErrorZero
			endif

			set itemType = AItemType.itemTypeOfItemTypeId(itemTypeId)


			if (itemType != 0) then
				if (this.m_checkItemTypeRequirement and not itemType.checkRequirement(this.unit())) then
					return thistype.chargesErrorRequirement
				endif
				if (itemType.maxCharges() != 0) then
					set charges = IMinBJ(itemType.maxCharges(), charges)
				endif
			endif

			set pair = this.pair(itemTypeId)

			if (pair == -1) then
				if (charges > 0) then
					set pair = this.freePair()
				else
					return thistype.chargesErrorMissing
				endif
			endif

			if (pair == -1) then
				return thistype.chargesErrorFull
			endif
			set result = AInventoryPage(pair.first()).addCharges(pair.second(), AInventoryItemData(pair.second()).charges() + charges)
			call pair.destroy()
			return result
		endmethod

		public stub method enable takes nothing returns nothing
			local thistype inventory = AHashTable.global().handleInteger(this.m_unit, "AInventory")
			local AIntegerMapIterator iterator
			if (inventory != 0) then
				call inventory.disable()
			endif
			call AHashTable.global().setHandleInteger(this.m_unit, "AInventory", this)
			if (this.m_currentPage != 0) then
				call this.m_currentPage.enable()
			endif
		endmethod

		public stub method disable takes nothing returns nothing
		endmethod

		public static method create takes unit whichUnit returns thistype
			local thistype this = thistype.allocate()
			set this.m_unit = whichUnit
			set this.m_pages = AIntegerMap.create()
			set this.m_currentPage = 0
			return this
		endmethod
	endstruct

endlibrary