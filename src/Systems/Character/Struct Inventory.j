library AStructSystemsCharacterInventory requires AStructCoreGeneralHashTable, ALibraryCoreGeneralUnit, AStructCoreStringFormat, AStructSystemsCharacterAbstractCharacterSystem, AStructSystemsCharacterCharacter, AStructSystemsCharacterItemType

	/**
	 * \brief This structure is used to store all item information of one slot in inventory.
	 */
	struct AInventoryItemData
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
		// members
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

		public method itemType takes nothing returns itemtype
			return this.m_itemType
		endmethod

		public method createItem takes real x, real y returns item
			local item result = CreateItem(this.m_itemTypeId, x, y)
			call SetItemCharges(result, this.m_charges)
			call SetItemDropID(result, this.m_dropId)
			call SetItemInvulnerable(result, this.m_invulnerable)
			call SetWidgetLife(result, this.m_life)
			call SetItemPawnable(result, this.m_pawnable)
			call SetItemPlayer(result, this.m_player, true)
			call SetItemUserData(result, this.m_userData)
			call SetItemVisible(result, this.m_visible)
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

		public static method create takes item usedItem, unit usedUnit returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_itemTypeId = GetItemTypeId(usedItem)
			set this.m_charges = GetItemCharges(usedItem)
			set this.m_dropId = GetUnitTypeId(usedUnit)
			set this.m_invulnerable = IsItemInvulnerable(usedItem)
			set this.m_life = GetWidgetLife(usedItem)
			set this.m_pawnable = IsItemPawnable(usedItem)
			set this.m_player = GetItemPlayer(usedItem)
			set this.m_userData = GetItemUserData(usedItem)
			set this.m_visible = IsItemVisible(usedItem)
			// members
			set this.m_itemType = GetItemType(usedItem)
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

	/**
	 * \brief This structure provides an interface to the character's inventory which is based on the default Warcraft III: The Frozen Throne inventory with 6 slots.
	 * A unit ability can be used to open and close rucksack.
	 * Rucksack uses the same interface as equipment since there are only 6 available item slots in Warcraft.
	 * Abilities of equipment will be hold when character is opening his rucksack.
	 * Rucksack item abilities do not affect!
	 * You can only use usable items like potions in rucksack which should always have type \ref ITEM_TYPE_CHARGED!
	 * In rucksack all item charges do start at 1 and there aren't any with 0, so the number of charges is always the real number.
	 * In equipment there shouldn't be any charges.
	 * If you add an item to character triggers will be run and firstly it will be tried to equip added item to character.
	 * If this doesn't work (e. g. it's not an equipable item) it will be added to rucksack.
	 * You do not have to care if rucksack is being opened at that moment.
	 * \note Do not forget to create \ref AItemType instances for all equipable item types!
	 * \todo Use \ref UnitDropItemSlot instead of item removals.
	 * \todo Maybe there should be an implementation of equipment pages, too (for more than 5 equipment types). You could add something like AEquipmentType.
	 */
	struct AInventory extends AAbstractCharacterSystem
		// static constant members, useful for GUIs
		public static constant integer maxEquipmentTypes = 5 /// \todo \ref AItemType.maxEuqipmentTypes, vJass bug
		public static constant integer maxRucksackItems = 128
		public static constant integer maxRucksackPages = 32 //maxRucksackItems / maxRucksackItemsPerPage
		public static constant integer maxRucksackItemsPerPage = 4
		// static construction members
		private static integer m_leftArrowItemType
		private static integer m_rightArrowItemType
		private static integer m_openRucksackAbilityId
		private static boolean m_allowPickingUpFromOthers
		private static string m_textUnableToEquipItem
		private static string m_textEquipItem
		private static string m_textUnableToAddRucksackItem
		private static string m_textAddItemToRucksack
		private static string m_textUnableToMoveRucksackItem
		private static string m_textDropPageItem
		private static string m_textMovePageItem
		private static string m_textOwnedByOther
		// members
		private AInventoryItemData array m_equipmentItemData[thistype.maxEquipmentTypes]
		private AInventoryItemData array m_rucksackItemData[thistype.maxRucksackItems]
		private trigger m_openTrigger
		private trigger m_orderTrigger
		private trigger m_useTrigger // show next page, show previous page, disable in equipment
		private trigger m_pickupTrigger
		private trigger m_dropTrigger
		private integer m_rucksackPage
		private boolean m_rucksackIsEnabled

		//! runtextmacro optional A_STRUCT_DEBUG("\"AInventory\"")

		/**
		 * \return Returns true if the rucksack is open. Otherwise if the equipment is shown it returns false.
		 */
		public method rucksackIsEnabled takes nothing returns boolean
			return this.m_rucksackIsEnabled
		endmethod

		/**
		 * \return Returns the item data of an equipped item of type \p equipmentType. If no item is equipped of that type it should return 0.
		 */
		public method equipmentItemData takes integer equipmentType returns AInventoryItemData
			debug if (equipmentType >= thistype.maxEquipmentTypes or equipmentType < 0) then
				debug call this.print("Wrong equipment type: " + I2S(equipmentType) + ".")
				debug return 0
			debug endif
			return this.m_equipmentItemData[equipmentType]
		endmethod

		/**
		 * \return Returns item data of an item in the rucksack with \p index. If no item is placed under that index it should return 0.
		 */
		public method rucksackItemData takes integer index returns AInventoryItemData
			debug if (index >= thistype.maxRucksackItems or index < 0) then
				debug call this.print("Wrong rucksack index: " + I2S(index) + ".")
				debug return 0
			debug endif
			return this.m_rucksackItemData[index]
		endmethod

		/**
		 * Counts all equipment items and returns the result.
		 * Complexity of O(n).
		 * \return Returns the total number of equipped items.
		 */
		public method totalEquipmentItems takes nothing returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == thistype.maxEquipmentTypes)
				if (this.m_equipmentItemData[i] != 0) then
					set result = result + 1
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		/**
		 * Counts all filled item slots in rucksack and returns the result.
		 * Complexity of O(n).
		 * \note This does not consider any charges! It considers only filled slots.
		 * \note This does not consider any page items.
		 * \return Returns the total number of filled slots in the rucksack. It does not consider any charges in those slots.
		 * \sa totalRucksackItemCharges()
		 */
		public method totalRucksackItems takes nothing returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == thistype.maxRucksackItems)
				if (this.m_rucksackItemData[i] != 0) then
					set result = result + 1
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		/**
		 * Counts all filled item charges in rucksack and returns the result.
		 * Complexity of O(n).
		 * \note This does consider all item charges from all rucksack slots except for the page items.
		 * \return Returns the total number of charges by filled slots in the rucksack.
		 * \sa totalRucksackItems()
		 */
		public method totalRucksackItemCharges takes nothing returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == thistype.maxRucksackItems)
				if (this.m_rucksackItemData[i] != 0) then
					set result = result + this.m_rucksackItemData[i].charges()
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		public method totalRucksackItemTypeCharges takes integer itemTypeId returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == thistype.maxRucksackItems)
				if (this.m_rucksackItemData[i] != 0 and this.m_rucksackItemData[i].itemTypeId() == itemTypeId) then
					set result = result + this.m_rucksackItemData[i].charges()
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		public method totalEquipmentItemTypeCharges takes integer itemTypeId returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == thistype.maxEquipmentTypes)
				if (this.m_equipmentItemData[i] != 0 and this.m_equipmentItemData[i].itemTypeId() == itemTypeId) then
					set result = result + this.m_equipmentItemData[i].charges()
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		public method totalItemTypeCharges takes integer itemTypeId returns integer
			return this.totalRucksackItemTypeCharges(itemTypeId) + this.totalEquipmentItemTypeCharges(itemTypeId)
		endmethod

		/// \return Returns the page of a rucksack item by index.
		public static method itemRucksackPage takes integer index returns integer
			debug if (index >= thistype.maxRucksackItems or index < 0) then
				debug call thistype.staticPrint("Wrong rucksack index: " + I2S(index) + ".")
				debug return 0
			debug endif
			return index / thistype.maxRucksackItemsPerPage
		endmethod

		/// \return Returns the Warcraft inventory slot number by a rucksack item index.
		public method rucksackItemSlot takes integer index returns integer
			debug if (index >= thistype.maxRucksackItems or index < 0) then
				debug call this.print("Wrong rucksack index: " + I2S(index) + ".")
				debug return 0
			debug endif
			return index - this.m_rucksackPage * thistype.maxRucksackItemsPerPage
		endmethod

		/// Just required for the move order and for item dropping.
		private static method clearItemIndex takes item usedItem returns nothing
			call AHashTable.global().removeHandleInteger(usedItem, "AInventory_index")
		endmethod

		/// Just required for the move order and for item dropping.
		private static method setItemIndex takes item usedItem, integer index returns nothing
			call AHashTable.global().setHandleInteger(usedItem, "AInventory_index", index)
		endmethod

		/// Just required for the move order and for item dropping.
		private static method itemIndex takes item usedItem returns integer
			return AHashTable.global().handleInteger(usedItem, "AInventory_index")
		endmethod

		/**
		 * Adds one item of type \p itemType to unit \p whichUnit into slot \p slot.
		 * \return Returns true if the item has been added to the slot successfully.
		 */
		private static method unitAddItemToSlotById takes unit whichUnit, integer itemType, integer slot returns boolean
			local boolean result
			local boolean isBeingPaused
			// Workaround (character inventory system has to work - adding items - when character is being paused e. g. during talks)
			if (IsUnitPaused(whichUnit)) then
				set isBeingPaused = true
				call PauseUnit(whichUnit, false)
			else
				set isBeingPaused = false
			endif
			set result = UnitAddItemToSlotById(whichUnit, itemType, slot)
			if (isBeingPaused) then
				call PauseUnit(whichUnit, true)
			endif
			return result
		endmethod

		private static method unitDropItemPoint takes unit whichUnit, item whichItem, real x, real y returns boolean
			local boolean result
			local boolean isBeingPaused
			// Workaround (character inventory system has to work - adding items - when character is being paused e. g. during talks)
			if (IsUnitPaused(whichUnit)) then
				set isBeingPaused = true
				call PauseUnit(whichUnit, false)
			else
				set isBeingPaused = false
			endif
			set result = UnitDropItemPoint(whichUnit, whichItem, x, y)
			if (isBeingPaused) then
				call PauseUnit(whichUnit, true)
			endif
			return result
		endmethod
		
		/**
		 * Clears equipment type \p equipmentType without dropping or removing the item from the unit's inventory.
		 */
		private method clearEquipmentType takes integer equipmentType returns nothing
			local unit characterUnit
			local AItemType itemType = 0
			if (this.m_equipmentItemData[equipmentType] != 0) then
				set characterUnit = this.character().unit()
				set itemType = AItemType.itemTypeOfItemTypeId(this.m_equipmentItemData[equipmentType].itemTypeId())
				call this.m_equipmentItemData[equipmentType].destroy()
				set this.m_equipmentItemData[equipmentType] = 0
				call itemType.onUnequipItem.execute(characterUnit, equipmentType)
				call this.checkEquipment.evaluate() //added
				set characterUnit = null
			endif
		endmethod
		
		/**
		 * Clears the rucksack slot \p index without dropping or removing the item from the unit's inventory.
		 */
		private method clearRucksackSlot takes integer index returns nothing
			if (this.m_rucksackItemData[index] != 0) then
				call this.m_rucksackItemData[index].destroy()
				set this.m_rucksackItemData[index] = 0
			endif
		endmethod

		private method clearRucksackItem takes integer index, boolean drop returns nothing
			local unit characterUnit
			local item slotItem
			if (this.m_rucksackIsEnabled and this.m_rucksackPage == this.itemRucksackPage(index)) then
				set characterUnit = this.character().unit()
				set slotItem = UnitItemInSlot(characterUnit, this.rucksackItemSlot(index))
				if (slotItem != null) then
					call thistype.clearItemIndex(slotItem)
					call DisableTrigger(this.m_dropTrigger)
					if (drop) then
						call thistype.unitDropItemPoint(characterUnit, slotItem, GetUnitX(characterUnit), GetUnitY(characterUnit))
						if (GetItemType(slotItem) != ITEM_TYPE_CHARGED) then
							call SetItemCharges(slotItem, GetItemCharges(slotItem) - 1)
						endif
					else
						call RemoveItem(slotItem)
					endif
					call EnableTrigger(this.m_dropTrigger)
					set slotItem = null
				endif
				set characterUnit = null
			endif
			call this.clearRucksackSlot(index)
		endmethod

		/// \return Returns the rucksack item index by a Warcraft inventory slot number.
		public method slotRucksackIndex takes integer slot returns integer
			debug if (slot >= thistype.maxRucksackItemsPerPage or slot < 0) then
				debug call this.print("Wrong inventory slot: " + I2S(slot) + ".")
				debug return 0
			debug endif
			return this.m_rucksackPage * thistype.maxRucksackItemsPerPage + slot
		endmethod

		private method hideEquipmentItem takes integer equipmentType, boolean addPermanentAbilities returns nothing
			local unit characterUnit = this.character().unit()
			local item slotItem = UnitItemInSlot(characterUnit, equipmentType)
			local AItemType itemType = AItemType.itemTypeOfItem(slotItem)
			call thistype.clearItemIndex(slotItem)
			call DisableTrigger(this.m_dropTrigger)
			debug call Print("Removing slot item: " + GetItemName(slotItem))
			call RemoveItem(slotItem)
			call EnableTrigger(this.m_dropTrigger)
			// equipped items must always have an item type
			//if (itemType != 0) then
			if (addPermanentAbilities) then
				call itemType.addPermanentAbilities(characterUnit)
			endif
			//endif
			set characterUnit = null
			set slotItem = null
		endmethod

		private method disableEquipment takes boolean addPermanentAbilities returns nothing
			local integer i
			set i = 0
			loop
				exitwhen (i == thistype.maxEquipmentTypes)
				if (this.m_equipmentItemData[i] != 0) then
					call this.hideEquipmentItem(i, addPermanentAbilities)
				endif
				set i = i + 1
			endloop
		endmethod

		private method hideRucksackItem takes integer index returns nothing
			local unit characterUnit = this.character().unit()
			local integer slot = this.rucksackItemSlot(index)
			local item slotItem = UnitItemInSlot(characterUnit, slot)
			call thistype.clearItemIndex(slotItem)
			call DisableTrigger(this.m_dropTrigger)
			call RemoveItem(slotItem)
			call EnableTrigger(this.m_dropTrigger)
			set characterUnit = null
			set slotItem = null
		endmethod

		private method hideCurrentRucksackPage takes nothing returns nothing
			local integer i = this.m_rucksackPage * thistype.maxRucksackItemsPerPage
			local integer exitValue = i + thistype.maxRucksackItemsPerPage
			loop
				exitwhen (i == exitValue)
				if (this.m_rucksackItemData[i] != 0) then
					call this.hideRucksackItem(i)
				endif
				set i = i + 1
			endloop
		endmethod

		private method disableRucksack takes nothing returns nothing
			local unit characterUnit = this.character().unit()
			local item leftArrowItem
			local item rightArrowItem
			set this.m_rucksackIsEnabled = false
			set leftArrowItem = UnitItemInSlot(characterUnit, thistype.maxRucksackItemsPerPage)
			set rightArrowItem = UnitItemInSlot(characterUnit, thistype.maxRucksackItemsPerPage + 1)
			call DisableTrigger(this.m_dropTrigger)
			call RemoveItem(leftArrowItem)
			call RemoveItem(rightArrowItem)
			call EnableTrigger(this.m_dropTrigger)
			call this.hideCurrentRucksackPage()
			set characterUnit = null
			set leftArrowItem = null
			set rightArrowItem = null
		endmethod

		/**
		 * Usually you do not have to call this method. The system handles itself.
		 */
		public stub method disable takes nothing returns nothing
			local integer i
			local AItemType itemType
			call super.disable()
			if (this.m_rucksackIsEnabled) then
				call this.disableRucksack()
			else
				call this.disableEquipment(false)
			endif
			
			/*
			 * Remove permanent abilities to disable them as well.
			 */
			set i = 0
			loop
				exitwhen (i == AItemType.maxEquipmentTypes)
				if (this.equipmentItemData(i) != 0) then
					set itemType = AItemType.itemTypeOfItemTypeId(this.equipmentItemData(i).itemTypeId())
					if (itemType != 0) then
						call itemType.removePermanentAbilities(this.character().unit())
					endif
				endif
				set i = i + 1
			endloop

			/// \todo wait for calling methods above?
			call DisableTrigger(this.m_openTrigger)
			call DisableTrigger(this.m_orderTrigger)
			call DisableTrigger(this.m_pickupTrigger)
			call DisableTrigger(this.m_dropTrigger)
		endmethod

		private method showEquipmentItem takes integer equipmentType returns nothing
			local unit characterUnit = this.character().unit()
			local item slotItem
			local boolean result = false
			local AItemType itemType = AItemType.itemTypeOfItemTypeId(this.m_equipmentItemData[equipmentType].itemTypeId())
			// equipped items must always have an item type
			call itemType.removePermanentAbilities(characterUnit)
			call DisableTrigger(this.m_pickupTrigger)
			set result = thistype.unitAddItemToSlotById(characterUnit, this.m_equipmentItemData[equipmentType].itemTypeId(), equipmentType)
			call EnableTrigger(this.m_pickupTrigger)
			// successfully readded
			if (result) then
				set slotItem = UnitItemInSlot(characterUnit, equipmentType)
				call this.m_equipmentItemData[equipmentType].assignToItem(slotItem)
				call SetItemDropOnDeath(slotItem, false)
				call thistype.setItemIndex(slotItem, equipmentType)
				set slotItem = null
			// Something went wrong and the item has been dropped instead. Otherwise if disabling and enabling equipment again the items will be duplicated.
			else
				call this.clearEquipmentType(equipmentType)
			endif
			set characterUnit = null
		endmethod

		private method enableEquipment takes nothing returns nothing
			local integer i
			set i = 0
			loop
				exitwhen (i == thistype.maxEquipmentTypes)
				if (this.m_equipmentItemData[i] != 0) then
					call this.showEquipmentItem(i)
				endif
				set i = i + 1
			endloop
		endmethod

		private method showRucksackItem takes integer index returns nothing
			local unit characterUnit = this.character().unit()
			local integer slot = this.rucksackItemSlot(index)
			local item slotItem
			local boolean result = false
			local AItemType itemType = AItemType.itemTypeOfItemTypeId(this.m_rucksackItemData[index].itemTypeId())
			call DisableTrigger(this.m_pickupTrigger)
			set result = thistype.unitAddItemToSlotById(characterUnit, this.m_rucksackItemData[index].itemTypeId(), slot)
			call EnableTrigger(this.m_pickupTrigger)
			// successfully readded
			if (result) then
				set slotItem = UnitItemInSlot(characterUnit, slot)
				call this.m_rucksackItemData[index].assignToItem(slotItem)
				call SetItemDropOnDeath(slotItem, false)
				// rucksack item do not need to have an item type
				if (itemType != 0) then
					call itemType.removePermanentAbilities(characterUnit)
				endif
				call thistype.setItemIndex(slotItem, index)
				set slotItem = null
			// Something went wrong and the item has been dropped instead. Otherwise if disabling and enabling rucksack again the items will be duplicated.
			else
				call this.clearRucksackSlot(index)
			endif
			set characterUnit = null
		endmethod

		private method showRucksackPage takes integer page, boolean firstCall returns nothing
			local integer i
			local integer exitValue
			local item rightArrowItem
			debug if (page > thistype.maxRucksackPages) then
				debug call this.print("Page value is too big.")
				debug return
			debug endif

			if (not firstCall) then
				call this.hideCurrentRucksackPage()
			endif

			set this.m_rucksackPage = page
			//add inventory items
			set i = page * thistype.maxRucksackItemsPerPage
			set exitValue = i + thistype.maxRucksackItemsPerPage
			loop
				exitwhen (i == exitValue)
				if (this.m_rucksackItemData[i] != 0) then
					call this.showRucksackItem(i)
				endif
				set i = i + 1
			endloop

			set rightArrowItem = UnitItemInSlot(this.character().unit(), thistype.maxRucksackItemsPerPage + 1)
			call SetItemCharges(rightArrowItem, page + 1)
			set rightArrowItem = null
		endmethod

		private method enableRucksack takes nothing returns nothing
			local unit characterUnit = this.character().unit()
			local item leftArrowItem
			local item rightArrowItem
			local boolean leftResult = false
			local boolean rightResult = false
			set this.m_rucksackIsEnabled = true
			call this.showRucksackPage(this.m_rucksackPage, true)
			call DisableTrigger(this.m_pickupTrigger)
			set leftResult = thistype.unitAddItemToSlotById(characterUnit, thistype.m_leftArrowItemType, thistype.maxRucksackItemsPerPage)
			set rightResult = thistype.unitAddItemToSlotById(characterUnit, thistype.m_rightArrowItemType, thistype.maxRucksackItemsPerPage + 1)
			call EnableTrigger(this.m_pickupTrigger)
			
			if (leftResult) then
				set leftArrowItem = UnitItemInSlot(characterUnit, thistype.maxRucksackItemsPerPage)
				call SetItemDroppable(leftArrowItem, true) //for moving items to next or previous pages
				set leftArrowItem = null
			// TODO remove the item?
			debug else
				debug call Print("Error on adding left arrow item.")
			endif
			
			if (rightResult) then
				set rightArrowItem = UnitItemInSlot(characterUnit, thistype.maxRucksackItemsPerPage + 1)
				call SetItemDroppable(rightArrowItem, true)
				call SetItemCharges(rightArrowItem, this.m_rucksackPage + 1)
				set rightArrowItem = null
			// TODO remove the item?
			debug else
				debug call Print("Error on adding right arrow item.")
			endif
			
			set characterUnit = null
		endmethod

		/**
		 * Shows the current page in the inventory of the character's unit
		 * In general you do not have to call this method. The system handles itself.
		 */
		public stub method enable takes nothing returns nothing
			call super.enable()
			if (this.m_rucksackIsEnabled) then
				call this.enableRucksack()
			else
				call this.enableEquipment()
			endif

			/// \todo wait for calling methods above?
			call EnableTrigger(this.m_openTrigger)
			call EnableTrigger(this.m_orderTrigger)
			call EnableTrigger(this.m_pickupTrigger)
			call EnableTrigger(this.m_dropTrigger)
		endmethod

		/// \return Returns the slot of the equipped item. If no item was found it returns -1.
		public method hasItemEquipped takes integer itemTypeId returns integer
			local integer i = 0
			loop
				exitwhen (i == thistype.maxEquipmentTypes)
				if (this.m_equipmentItemData[i].itemTypeId() == itemTypeId) then
					return i
				endif
				set i = i + 1
			endloop
			return -1
		endmethod

		/// \return Returns the slot of the rucksack item. If not item was found it returns -1.
		public method hasItemTypeInRucksack takes integer itemTypeId returns integer
			local integer i = 0
			loop
				exitwhen (i == thistype.maxRucksackItems)
				if (this.m_rucksackItemData[i].itemTypeId() == itemTypeId) then
					return i
				endif
				set i = i + 1
			endloop
			return -1
		endmethod

		/**
		 * \return Returns true if an item of type \p itemTypeId is either equipped or in the rucksack.
		 * \sa hasItemEquipped() hasItemTypeInRucksack()
		 */
		public method hasItemType takes integer itemTypeId returns boolean
			return this.hasItemEquipped(itemTypeId) != -1 or this.hasItemTypeInRucksack(itemTypeId) != -1
		endmethod

		private method refreshRucksackItemCharges takes integer index returns nothing
			local unit characterUnit
			local integer slot
			local item slotItem
			
			if (this.m_rucksackItemData[index] == 0) then
				return
			endif

			if (this.m_rucksackItemData[index].charges() <= 0) then // all items have charges starting at least with 1 in rucksack
				debug call this.print("Clear rucksack item!")
				call this.clearRucksackItem(index, false)
			// only update charges if item is visible
			elseif (this.m_rucksackIsEnabled and this.m_rucksackPage == this.itemRucksackPage(index)) then
				set characterUnit = this.character().unit()
				set slot = this.rucksackItemSlot(index)
				set slotItem = UnitItemInSlot(characterUnit, slot)
				if (slotItem != null) then
					call SetItemCharges(slotItem, this.m_rucksackItemData[index].charges())
					set slotItem = null
				// item could have been dropped (e. g. in drop trigger action)
				else
					call this.showRucksackItem(index)
				endif
				set characterUnit = null
			endif
		endmethod

		public method setRucksackItemCharges takes integer index, integer charges returns integer
			if (index >= thistype.maxRucksackItems or index < 0 or this.m_rucksackItemData[index] == 0) then
				debug call this.print("Empty rucksack item at index: " + I2S(index) + ".")
				return 0
			endif

			set charges = IMaxBJ(0, charges)
			call this.m_rucksackItemData[index].setCharges(charges)
			// clears the items if charges are equal to 0
			call this.refreshRucksackItemCharges(index)

			return charges
		endmethod

		public stub method store takes gamecache cache, string missionKey, string labelPrefix returns nothing
			local integer i
			call super.store(cache, missionKey, labelPrefix)
			set i = 0
			loop
				exitwhen (i == thistype.maxEquipmentTypes)
				if (this.m_equipmentItemData[i] != 0) then
					call StoreBoolean(cache, missionKey, labelPrefix + "EquipmentItemData" + I2S(i) + "Exists", true)
					call this.m_equipmentItemData[i].store(cache, missionKey, labelPrefix + "EquipmentItemData" + I2S(i))
				endif
				set i = i + 1
			endloop
			set i = 0
			loop
				exitwhen (i == thistype.maxRucksackItems)
				if (this.m_rucksackItemData[i] != 0) then
					call StoreBoolean(cache, missionKey, labelPrefix + "RucksackItemData" + I2S(i) + "Exists", true)
					call this.m_rucksackItemData[i].store(cache, missionKey, labelPrefix + "RucksackItemData" + I2S(i))
				endif
				set i = i + 1
			endloop
			call StoreInteger(cache, missionKey, labelPrefix + "RucksackPage", this.m_rucksackPage)
			call StoreBoolean(cache, missionKey, labelPrefix + "RucksackIsEnabled", this.m_rucksackIsEnabled)
		endmethod

		public stub method restore takes gamecache cache, string missionKey, string labelPrefix returns nothing
			local integer i
			call super.restore(cache, missionKey, labelPrefix)
			set i = 0
			call this.disable()
			loop
				exitwhen (i == thistype.maxEquipmentTypes)
				if (this.m_equipmentItemData[i] != 0) then // clear old
					call this.m_equipmentItemData[i].destroy()
					set this.m_equipmentItemData[i] = 0
				endif
				if (HaveStoredBoolean(cache, missionKey, labelPrefix + "EquipmentItemData" + I2S(i) + "Exists")) then
					set this.m_equipmentItemData[i] = AInventoryItemData.createRestored(cache, missionKey, labelPrefix + "EquipmentItemData" + I2S(i))
				endif
				set i = i + 1
			endloop
			set i = 0
			loop
				exitwhen (i == thistype.maxRucksackItems)
				if (this.m_rucksackItemData[i] != 0) then // clear old
					call this.m_rucksackItemData[i].destroy()
					set this.m_rucksackItemData[i] = 0
				endif
				if (HaveStoredBoolean(cache, missionKey, labelPrefix + "RucksackItemData" + I2S(i) + "Exists")) then
					set this.m_rucksackItemData[i] = AInventoryItemData.createRestored(cache, missionKey, labelPrefix + "RucksackItemData" + I2S(i))
				endif
				set i = i + 1
			endloop
			set this.m_rucksackPage = GetStoredInteger(cache, missionKey, labelPrefix + "RucksackPage")
			set this.m_rucksackIsEnabled = GetStoredBoolean(cache, missionKey, labelPrefix + "RucksackIsEnabled")
			call this.enable()
		endmethod

		private method setEquipmentItem takes integer equipmentType, AInventoryItemData inventoryItemData, boolean add returns nothing
			local AItemType itemType = AItemType.itemTypeOfItemTypeId(inventoryItemData.itemTypeId())
			set this.m_equipmentItemData[equipmentType] = inventoryItemData
			if (add) then
				call this.showEquipmentItem(equipmentType)
			elseif (this.m_rucksackIsEnabled) then
				// equipped items must always have an item type
				//if (itemType != 0) then
					call itemType.addPermanentAbilities(this.character().unit())
				//endif
			endif
			call itemType.onEquipItem.execute(this.character().unit(), equipmentType)
		endmethod

		private method setEquipmentItemByItem takes integer equipmentType, item usedItem, boolean add returns nothing
			local AInventoryItemData inventoryItemData = AInventoryItemData.create(usedItem, this.character().unit())
			call DisableTrigger(this.m_dropTrigger)
			call RemoveItem(usedItem)
			call EnableTrigger(this.m_dropTrigger)
			set usedItem = null
			call this.setEquipmentItem(equipmentType, inventoryItemData, add)
		endmethod

		private method clearEquipmentItem takes integer equipmentType, boolean drop returns nothing
			local unit characterUnit = this.character().unit()
			local item slotItem
			local AItemType itemType = AItemType.itemTypeOfItemTypeId(this.m_equipmentItemData[equipmentType].itemTypeId())

			if (not this.m_rucksackIsEnabled) then
				set slotItem = UnitItemInSlot(characterUnit, equipmentType)
				if (slotItem != null) then
					call thistype.clearItemIndex(slotItem)
					call DisableTrigger(this.m_dropTrigger)
					if (drop) then
						call thistype.unitDropItemPoint(characterUnit, slotItem, GetUnitX(characterUnit), GetUnitY(characterUnit))
					else
						call RemoveItem(slotItem)
					endif
					call EnableTrigger(this.m_dropTrigger)
					set slotItem = null
				endif
			else
				// equipped items must always have an item type
				//if (itemType != 0) then
					call itemType.removePermanentAbilities(characterUnit)
				//endif
			endif
			call this.clearEquipmentType(equipmentType)
			set characterUnit = null
		endmethod
		
		/**
		 * Removes item by type \p itemTypeId completely from the inventory.
		 * \sa hasItemType()
		 */
		public method removeItemType takes integer itemTypeId returns boolean
			local integer i = 0
			loop
				exitwhen (i == thistype.maxEquipmentTypes)
				if (this.m_equipmentItemData[i].itemTypeId() == itemTypeId) then
					call this.clearEquipmentItem(i, false)
				
					return true
				endif
				set i = i + 1
			endloop
			set i = 0
			loop
				exitwhen (i == thistype.maxRucksackItems)
				if (this.m_rucksackItemData[i].itemTypeId() == itemTypeId) then
					debug call Print("Setting item type " + GetObjectName(itemTypeId) + " charges " + I2S(this.m_rucksackItemData[i].charges()) + " -1")
					call this.setRucksackItemCharges(i, this.m_rucksackItemData[i].charges() - 1)
					
					return true
				endif
				set i = i + 1
			endloop
			
			debug call Print("Error: Did not find " + GetObjectName(itemTypeId) + " in inventory!")
			
			return false
		endmethod

		/**
		 * Checks requirements of all equipped items. If some requirements aren't met the checked item is dropped.
		 * This should be called whenever character units attributes which are used for item type requirement change.
		 * Note: Now it should work while rucksack is opened, too.
		 */
		private method checkEquipment takes nothing returns nothing
			local AItemType itemType
			local integer i = 0
			loop
				exitwhen (i == thistype.maxEquipmentTypes)
				if (this.m_equipmentItemData[i] != 0) then
					set itemType = AItemType.itemTypeOfItemTypeId(this.m_equipmentItemData[i].itemTypeId())
					// equipped items must always have an item type
					// itemType != 0 and
					if (not itemType.checkRequirement(this.character())) then
						call this.clearEquipmentItem(i, true)
					endif
				endif
				set i = i + 1
			endloop
		endmethod

		private method setRucksackItem takes integer index, AInventoryItemData inventoryItemData, boolean add returns nothing
			local boolean refreshOnly = false
			if (this.m_rucksackItemData[index] == 0) then
				set this.m_rucksackItemData[index] = inventoryItemData
			else //same type
				call this.m_rucksackItemData[index].setCharges(this.m_rucksackItemData[index].charges() + IMaxBJ(inventoryItemData.charges(), 1))
				call inventoryItemData.destroy()
				set refreshOnly = true
			endif
			if (add) then
				if (not refreshOnly) then
					call this.showRucksackItem(index)
				else
					call this.refreshRucksackItemCharges(index)
				endif
			endif
		endmethod

		private method setRucksackItemByItem takes integer index, item usedItem, boolean add returns nothing
			local AInventoryItemData inventoryItemData = AInventoryItemData.create(usedItem, this.character().unit())
			if (inventoryItemData.charges() == 0) then
				call inventoryItemData.setCharges(1)
			endif
			call DisableTrigger(this.m_dropTrigger)
			call RemoveItem(usedItem)
			call EnableTrigger(this.m_dropTrigger)
			set usedItem = null
			call this.setRucksackItem(index, inventoryItemData, add)
		endmethod

		/**
		 * Tries to equip item \p usedItem to the character's unit.
		 * \param dontMoveToRucksack If this value is true the item is not tried to be added to the rucksack if the equipment does not succeed.
		 * \param swapWithAlreadyEquipped If this value is true it is equipped even if there is already an item equipped of the same type.
		 * \param showEquipMessage If this value is true a message is shown to the owner of the character when the item is equipped successfully.
		 * \return Returns true if the item is equipped successfully. Otherwise if not or if it is added to the rucksack instead it returns false.
		 */
		private method equipItem takes item usedItem, boolean dontMoveToRucksack, boolean swapWithAlreadyEquipped, boolean showEquipMessage returns boolean
			local AItemType itemType
			local integer equipmentType
			local player itemPlayer
			local unit characterUnit
			local item equippedItem
			local string itemName

			// sometimes null items will be equipped for example when an item is added which is removed at the same moment
			if (usedItem == null) then
				return false
			endif

			set itemType = AItemType.itemTypeOfItem(usedItem)
			set equipmentType = itemType.equipmentType()
			set itemPlayer = GetItemPlayer(usedItem)
			set characterUnit = this.character().unit()

			if (not this.m_rucksackIsEnabled and UnitHasItem(characterUnit, usedItem)) then // already picked up
				call DisableTrigger(this.m_dropTrigger)
				call thistype.unitDropItemPoint(characterUnit, usedItem, GetUnitX(characterUnit), GetUnitY(characterUnit))
				call EnableTrigger(this.m_dropTrigger)
			endif

			if (not thistype.m_allowPickingUpFromOthers and itemPlayer != this.character().player() and IsPlayerPlayingUser(itemPlayer)) then
				if (thistype.m_textOwnedByOther != null) then
					call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textOwnedByOther)
				endif
				set itemPlayer = null
				return false
			endif
			set itemPlayer = null

			if (itemType != 0 and equipmentType != -1) then
				if (swapWithAlreadyEquipped or this.m_equipmentItemData[equipmentType] == 0) then
					if (itemType.checkRequirement(this.character())) then
						if (swapWithAlreadyEquipped and this.m_equipmentItemData[equipmentType] != 0) then
							set equippedItem = this.m_equipmentItemData[equipmentType].createItem(GetUnitX(characterUnit), GetUnitY(characterUnit))
							call this.addItemToRucksack.evaluate(equippedItem, true, false)
							call this.clearEquipmentItem(equipmentType, false)
							set equippedItem = null
						endif
						set itemName = GetItemName(usedItem)
						call this.setEquipmentItemByItem(equipmentType, usedItem, not this.m_rucksackIsEnabled)
						if (showEquipMessage and thistype.m_textEquipItem != null) then
							call this.character().displayMessage(ACharacter.messageTypeInfo, Format(thistype.m_textEquipItem).s(itemName).result())
						endif
						set characterUnit = null
						return true
					endif
				endif
			debug elseif (itemType == 0) then
				debug call this.print("Warning: Item \"" + GetItemName(usedItem) + "\" has no custom type.")
			endif
			// move to rucksack
			if (not dontMoveToRucksack) then
				call this.addItemToRucksack.evaluate(usedItem, true, true) //if item type is 0 it will be placed in rucksack, too
			elseif (thistype.m_textUnableToEquipItem != null) then
				call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textUnableToEquipItem)
			endif
			set characterUnit = null
			
			return false
		endmethod
		
		/**
		 * Adds an item to the inventory.
		 * This tries to equip the item first. If this fails because there is already an item equipped or it is not an equipable item the item will be added to the rucksack.
		 * \param whichItem The item which is added.
		 * \return Returns true if the item has been equipped. Otherwise it returns false.
		 */
		public method addItem takes item whichItem returns boolean
			return this.equipItem(whichItem, false, false, true) // try always equipment first!
		endmethod

		private method addItemToRucksack takes item usedItem, boolean dontMoveToEquipment, boolean showAddMessage returns nothing
			local integer i
			local player itemPlayer
			local unit characterUnit
			local string itemName

			// sometimes null items will be added for example when an item is added which is removed at the same moment
			if (usedItem == null) then
				return
			endif

			set itemPlayer = GetItemPlayer(usedItem)
			set characterUnit = this.character().unit()

			if (this.m_rucksackIsEnabled and UnitHasItem(characterUnit, usedItem)) then // already picked up
				call DisableTrigger(this.m_dropTrigger)
				call thistype.unitDropItemPoint(characterUnit, usedItem, GetUnitX(characterUnit), GetUnitY(characterUnit))
				call EnableTrigger(this.m_dropTrigger)
			endif
			set characterUnit = null

			if (not thistype.m_allowPickingUpFromOthers and itemPlayer != this.character().player() and IsPlayerPlayingUser(itemPlayer)) then
				if (thistype.m_textOwnedByOther != null) then
					call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textOwnedByOther)
				endif
				set itemPlayer = null
				return
			endif
			set itemPlayer = null

			set i = 0
			loop
				exitwhen (i == thistype.maxRucksackItems)
				if (this.m_rucksackItemData[i] == 0 or  this.m_rucksackItemData[i].itemTypeId() == GetItemTypeId(usedItem)) then
					set itemName = GetItemName(usedItem)
					call this.setRucksackItemByItem(i, usedItem, this.m_rucksackIsEnabled and this.itemRucksackPage(i) == this.m_rucksackPage)
					if (showAddMessage and thistype.m_textAddItemToRucksack != null) then
						call this.character().displayMessage(ACharacter.messageTypeInfo, Format(thistype.m_textAddItemToRucksack).s(itemName).result())
					endif
					return
				endif
				set i = i + 1
			endloop

			// equip
			if (not dontMoveToEquipment) then
				call this.equipItem(usedItem, true, false, true)
			// the rucksack is full and the item should not be equipped, for example when the item was added to the rucksack from the equipment
			elseif (thistype.m_textUnableToAddRucksackItem != null) then
				call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textUnableToAddRucksackItem)
			endif
		endmethod

		private method showNextRucksackPage takes nothing returns nothing
			if (this.m_rucksackPage == thistype.maxRucksackPages - 1) then
				call this.showRucksackPage(0, false)
			else
				call this.showRucksackPage(this.m_rucksackPage + 1, false)
			endif
		endmethod

		private method showPreviousRucksackPage takes nothing returns nothing
			if (this.m_rucksackPage == 0) then
				call this.showRucksackPage(thistype.maxRucksackPages - 1, false)
			else
				call this.showRucksackPage(this.m_rucksackPage - 1, false)
			endif
		endmethod

		/**
		 * When two item slots have been swapped this method resets them.
		 * This can be useful if an item may not be moved in the inventory like page items or equipped items.
		 */
		private method resetItemSlots takes integer currentSlot, integer oldSlot returns nothing
			local unit characterUnit = this.character().unit()
			local item currentItem = UnitItemInSlot(characterUnit, currentSlot)
			local AInventoryItemData currentItemData = 0
			local integer currentItemIndex
			local item otherItem = UnitItemInSlot(characterUnit, oldSlot)
			local AInventoryItemData otherItemData = 0
			local integer otherItemIndex
			call DisableTrigger(this.m_dropTrigger)
			if (currentItem != null) then
				set currentItemData = AInventoryItemData.create(currentItem, this.character().unit())
				if (currentItemData.itemTypeId() != thistype.m_leftArrowItemType and currentItemData.itemTypeId() != thistype.m_rightArrowItemType) then
					set currentItemIndex = thistype.itemIndex(currentItem)
				endif
				call RemoveItem(currentItem)
				set currentItem = null
			endif
			if (otherItem != null) then
				set otherItemData = AInventoryItemData.create(otherItem, this.character().unit())
				if (otherItemData.itemTypeId() != thistype.m_leftArrowItemType and otherItemData.itemTypeId() != thistype.m_rightArrowItemType) then
					set otherItemIndex = thistype.itemIndex(otherItem)
				endif
				call RemoveItem(otherItem)
				set otherItem = null
			endif
			call EnableTrigger(this.m_dropTrigger)
			call DisableTrigger(this.m_pickupTrigger)
			if (currentItemData != 0) then
				/*
				 * Create old item into old slot.
				 */
				if (thistype.unitAddItemToSlotById(characterUnit, currentItemData.itemTypeId(), oldSlot)) then
					set currentItem = UnitItemInSlot(characterUnit, oldSlot)
					call currentItemData.assignToItem(currentItem)
					if (currentItemData.itemTypeId() != thistype.m_leftArrowItemType and currentItemData.itemTypeId() != thistype.m_rightArrowItemType) then
						call thistype.setItemIndex(currentItem, currentItemIndex)
					endif
					call currentItemData.destroy()
					set currentItem = null
				// TODO remove item?
				debug else
					debug call Print("Error on reseting current old item.")
				endif
			endif
			if (otherItemData != 0) then
				/*
				 * Create old item into old slot.
				 */
				if (thistype.unitAddItemToSlotById(characterUnit, otherItemData.itemTypeId(), currentSlot)) then
					set otherItem = UnitItemInSlot(characterUnit, currentSlot)
					call otherItemData.assignToItem(otherItem)
					if (otherItemData.itemTypeId() != thistype.m_leftArrowItemType and otherItemData.itemTypeId() != thistype.m_rightArrowItemType) then
						call thistype.setItemIndex(otherItem, otherItemIndex)
					endif
					call otherItemData.destroy()
					set otherItem = null
				// TODO remove item?
				debug else
					debug call Print("Error on reseting other old item.")
				endif
			endif
			call EnableTrigger(this.m_pickupTrigger)
		endmethod

		/**
		 * Moves item \p slotItem to the previous or the next rucksack pages which means it will be moved as long as there is a free slot or a slot to which it can be stacked.
		 * If no free slot or stackable item is found the item should be moved to its old position again since if it reaches the last slot it starts at the beginning etc.
		 * \todo Instead of clearing the old slot and moving the whole item only one charge should be moved.
		 */
		private method moveRucksackItemToPage takes item slotItem, boolean next returns nothing
			local unit characterUnit = this.character().unit()
			local integer oldIndex = this.itemIndex(slotItem)
			local integer oldSlot = this.rucksackItemSlot(oldIndex)
			local integer i
			local integer exitValue

			//debug call this.print("Moving item " + GetItemName(slotItem))

			//reset page item (items were swapped) and drop moved item
			call thistype.clearItemIndex(slotItem)
			call DisableTrigger(this.m_dropTrigger)
			call RemoveItem(slotItem)
			call EnableTrigger(this.m_dropTrigger)
			set slotItem = null

			if (next) then
				call this.resetItemSlots(oldSlot, thistype.maxRucksackItemsPerPage + 1)
				set i = oldIndex + thistype.maxRucksackItemsPerPage - oldSlot
				set exitValue = thistype.maxRucksackItems

				if (i == thistype.maxRucksackItems) then
					set i = 0
				endif
			else
				call this.resetItemSlots(oldSlot, thistype.maxRucksackItemsPerPage)
				set i = oldIndex - thistype.maxRucksackItemsPerPage + thistype.maxRucksackItemsPerPage - oldSlot - 1 //test - 1
				set exitValue = 0

				if (i < 0) then
					set i = thistype.maxRucksackItems - 1
				endif
			endif

			loop
				// reached old index, remove dropped slot item and show it again. show error message.
				if (i == oldIndex) then
					//call RemoveItem(slotItem) //do not disable drop triggers, item is dropped
					call this.showRucksackItem(oldIndex)
					if (thistype.m_textUnableToMoveRucksackItem != null) then
						call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textUnableToMoveRucksackItem)
					endif
					exitwhen (true)
				// found stack place
				elseif (this.m_rucksackItemData[i].itemTypeId() == this.m_rucksackItemData[oldIndex].itemTypeId()) then
					call this.m_rucksackItemData[i].setCharges(this.m_rucksackItemData[i].charges() + this.m_rucksackItemData[oldIndex].charges())
					call this.clearRucksackItem(oldIndex, false)
					exitwhen (true)
				// found a free place
				elseif (this.m_rucksackItemData[i] == 0) then
					call this.setRucksackItem(i, this.m_rucksackItemData[oldIndex], this.m_rucksackIsEnabled and this.itemRucksackPage(i) == this.m_rucksackPage)
					set this.m_rucksackItemData[oldIndex] = 0
					exitwhen (true)
				endif
				if (next) then
					set i = i + 1
					if (i == exitValue) then
						set i = 0
					endif
				else
					set i = i - 1
					if (i == exitValue) then
						set i = thistype.maxRucksackItems - 1
					endif
				endif
			endloop
			set characterUnit = null
		endmethod

		private method swapRucksackItemData takes item firstItem, item secondItem returns nothing
			local integer firstIndex = this.itemIndex(firstItem)
			local integer secondIndex = this.itemIndex(secondItem)
			local AInventoryItemData itemData = this.m_rucksackItemData[firstIndex]
			set this.m_rucksackItemData[firstIndex] = this.m_rucksackItemData[secondIndex]
			call thistype.setItemIndex(firstItem, secondIndex)
			set this.m_rucksackItemData[secondIndex] = itemData
			call thistype.setItemIndex(secondItem, firstIndex)
		endmethod

		private method moveRucksackItem takes item movedItem, integer slot returns nothing
			local unit characterUnit = this.character().unit()
			local item targetItem
			local integer oldIndex = this.itemIndex(movedItem)
			local integer newIndex = this.slotRucksackIndex(slot)
			// equip
			if (oldIndex == newIndex) then
				//debug call this.print("Same index: Equip.")
				set movedItem = null
				//debug call this.print("Creating item at characters position and trying to equip.")
				set movedItem = this.m_rucksackItemData[oldIndex].createItem(GetUnitX(characterUnit), GetUnitY(characterUnit))
				call SetItemCharges(movedItem, 0)
				call this.setRucksackItemCharges(oldIndex, this.m_rucksackItemData[oldIndex].charges() - 1)
				call this.equipItem(movedItem, false, true, true) //test
				set characterUnit = null
				return
			endif
			set targetItem = UnitItemInSlot(this.character().unit(), this.rucksackItemSlot(oldIndex))
			// move
			if (targetItem == null) then
				call thistype.setItemIndex(movedItem, newIndex)
				// destack
				if (this.m_rucksackItemData[oldIndex].charges() > 1) then
					call this.m_rucksackItemData[oldIndex].setCharges(this.m_rucksackItemData[oldIndex].charges() - 1)
					call this.showRucksackItem(oldIndex)

					set this.m_rucksackItemData[newIndex] = AInventoryItemData.create(movedItem, this.character().unit())
					call this.setRucksackItemCharges(newIndex, 1)
				// normal movement
				else
					set this.m_rucksackItemData[newIndex] = this.m_rucksackItemData[oldIndex]
					// clear old, do not destroy since data was moved to new index!
					set this.m_rucksackItemData[oldIndex] = 0
				endif
			// stack
			elseif (GetItemTypeId(movedItem) == GetItemTypeId(targetItem)) then
				debug call Print("Stack, target item id :" + I2S(GetHandleId(targetItem)) + " moved item id: " + I2S(GetHandleId(movedItem)))
				call thistype.setItemIndex(movedItem, newIndex)
				call this.m_rucksackItemData[newIndex].addItemDataCharges(this.m_rucksackItemData[oldIndex])
				call this.refreshRucksackItemCharges(newIndex)
				call this.clearRucksackItem(oldIndex, false)
			//swap
			else
				call this.swapRucksackItemData(movedItem, targetItem)
			endif
			set characterUnit = null
			set targetItem = null
		endmethod

		private static method triggerConditionOpen takes nothing returns boolean
			return GetSpellAbilityId() == thistype.m_openRucksackAbilityId
		endmethod

		private static method triggerActionOpen takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, "this")
			if (this.m_rucksackIsEnabled) then
				call this.disableRucksack()
				call this.enableEquipment()
			else
				call this.disableEquipment(true)
				call this.enableRucksack()
			endif
			set triggeringTrigger = null
		endmethod

		private method createOpenTrigger takes nothing returns nothing
			set this.m_openTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_openTrigger, this.character().unit(), EVENT_UNIT_SPELL_CAST)
			call TriggerAddCondition(this.m_openTrigger, Condition(function thistype.triggerConditionOpen))
			call TriggerAddAction(this.m_openTrigger, function thistype.triggerActionOpen)
			call AHashTable.global().setHandleInteger(this.m_openTrigger, "this", this)
		endmethod

		private static method triggerConditionOrder takes nothing returns boolean
			return GetIssuedOrderId() >= A_ORDER_ID_MOVE_SLOT_0 and GetIssuedOrderId() <= A_ORDER_ID_MOVE_SLOT_5
		endmethod

		private static method triggerActionOrder takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, "this")
			local integer newSlot = GetIssuedOrderId() - A_ORDER_ID_MOVE_SLOT_0
			local item usedItem = GetOrderTargetItem()
			local integer oldSlot
			local item targetItem
			local integer itemTypeId
			local integer targetItemTypeId
			debug call Print("move item " + GetItemName(usedItem))
			call TriggerSleepAction(0.0) // wait until order is done, important!
			if (this.rucksackIsEnabled()) then
				//debug call this.print("Rucksack is enabled.")
				if (GetItemTypeId(usedItem) == thistype.m_leftArrowItemType and newSlot != thistype.maxRucksackItemsPerPage) then
					debug call Print("Moving left item to slot " + I2S(newSlot))
					call this.resetItemSlots(newSlot, thistype.maxRucksackItemsPerPage)
					if (thistype.m_textMovePageItem != null) then
						call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textMovePageItem)
					endif
				elseif (GetItemTypeId(usedItem) == thistype.m_rightArrowItemType and newSlot != thistype.maxRucksackItemsPerPage + 1) then
					debug call Print("Moving right item to slot " + I2S(newSlot))
					call this.resetItemSlots(newSlot, thistype.maxRucksackItemsPerPage + 1)
					if (thistype.m_textMovePageItem != null) then
						call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textMovePageItem)
					endif
				// move item previous - player drops an item on the next page item
				elseif (GetItemTypeId(usedItem) != thistype.m_leftArrowItemType and newSlot == thistype.maxRucksackItemsPerPage) then
					call this.moveRucksackItemToPage(usedItem, false)
				// move item next - player drops an item on the previous page item
				elseif (GetItemTypeId(usedItem) != thistype.m_rightArrowItemType and newSlot == thistype.maxRucksackItemsPerPage + 1) then
					call this.moveRucksackItemToPage(usedItem, true)
				// equip item/stack items/swap items
				elseif (newSlot >= 0 and newSlot < thistype.maxRucksackItemsPerPage) then
					call this.moveRucksackItem(usedItem, newSlot)
				endif
			// equipment is enabled
			else
				set oldSlot = thistype.itemIndex(usedItem)
				// reset moved equipped items to their positions
				if (newSlot != oldSlot) then
					call this.resetItemSlots(newSlot, oldSlot)
				// old slot, add to rucksack
				else
					call this.clearItemIndex(usedItem)
					call this.clearEquipmentItem(oldSlot, true)
					call this.addItemToRucksack(usedItem, true, true)
				endif
			endif
			set triggeringTrigger = null
			set usedItem = null
		endmethod

		/*
		 * Moving the item in the inventory generates an order target event with the unit itself as target.
		 * This trigger is used for the following actions:
		 * equip, add to rucksack, move item next, move item previous, stack items, destack item, swap items
		 */
		private method createOrderTrigger takes nothing returns nothing
			set this.m_orderTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_orderTrigger, this.character().unit(), EVENT_UNIT_ISSUED_TARGET_ORDER)
			call TriggerAddCondition(this.m_orderTrigger, Condition(function thistype.triggerConditionOrder))
			call TriggerAddAction(this.m_orderTrigger, function thistype.triggerActionOrder)
			call AHashTable.global().setHandleInteger(this.m_orderTrigger, "this", this)
		endmethod

		private static method triggerConditionIsNoPowerup takes nothing returns boolean
			return  not IsItemIdPowerup(GetItemTypeId(GetManipulatedItem()))
		endmethod

		private static method triggerActionPickup takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, "this")
			local item usedItem = GetManipulatedItem()
			call this.addItem(usedItem)
			set triggeringTrigger = null
			set usedItem = null
		endmethod

		private method createPickupTrigger takes nothing returns nothing
			set this.m_pickupTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_pickupTrigger, this.character().unit(), EVENT_UNIT_PICKUP_ITEM) // pawn?
			call TriggerAddCondition(this.m_pickupTrigger, Condition(function thistype.triggerConditionIsNoPowerup))
			call TriggerAddAction(this.m_pickupTrigger, function thistype.triggerActionPickup)
			call AHashTable.global().setHandleInteger(this.m_pickupTrigger, "this", this)
		endmethod
		
		/**
		 * Resets the a page item when it is being dropped by the character.
		 * \param droppedItem This is expected to be the dropped page item. It will be removed and an item will be readded to the character of the same item type in the correct slot (\ref thistype.maxRucksackItemsPerPage or \ref thistype.maxRucksackItemsPerPage + 1).
		 * \return Returns true if the page item has been readded successfully. Otherwise or if the item has not the item type id of a page item it returns false.
		 */
		private method resetPageItem takes item droppedItem returns boolean
			local boolean result = false
			local integer itemTypeId = GetItemTypeId(droppedItem)
			local integer slot
			debug call this.print("Removing item " + GetItemName(droppedItem))
			if (itemTypeId == thistype.m_leftArrowItemType) then
				set slot = thistype.maxRucksackItemsPerPage
			elseif (itemTypeId == thistype.m_rightArrowItemType) then
				set slot = thistype.maxRucksackItemsPerPage + 1
			else
				debug call this.print("Unknown page item type id: " + GetObjectName(itemTypeId))
			
				return false
			endif
			call RemoveItem(droppedItem)
			set droppedItem = null
			call DisableTrigger(this.m_pickupTrigger)
			if (not thistype.unitAddItemToSlotById(this.character().unit(), itemTypeId, slot)) then
				debug call Print("Something went wrong when readding item " + GetObjectName(itemTypeId) + " to slot " + I2S(slot))
			else
				set result = true
			endif
			
			if (thistype.m_textDropPageItem != null) then
				call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textDropPageItem)
			endif
			if (itemTypeId == thistype.m_rightArrowItemType) then
				set droppedItem = UnitItemInSlot(this.character().unit(), thistype.maxRucksackItemsPerPage + 1)
				call SetItemCharges(droppedItem, this.m_rucksackPage + 1)
				set droppedItem = null
			endif
			
			call EnableTrigger(this.m_pickupTrigger)
			
			return result
		endmethod

		private static method triggerActionDrop takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, "this")
			local item usedItem = GetManipulatedItem()
			local integer index = this.itemIndex(usedItem)
			local unit triggerUnit = GetTriggerUnit()
			debug call this.print("Dropping item " + GetItemName(usedItem) + " in trigger " + I2S(GetHandleId(triggeringTrigger)))
			if (this.rucksackIsEnabled()) then
				// page items
				if (GetItemTypeId(usedItem) == thistype.m_leftArrowItemType) then
					call SetItemPawnable(usedItem, false) // make sure nobody picks it up again
					call TriggerSleepAction(0.0) // wait until it has been dropped
					call this.resetPageItem(usedItem)
				elseif (GetItemTypeId(usedItem) == thistype.m_rightArrowItemType) then
					call SetItemPawnable(usedItem, false) // make sure nobody picks it up again
					call TriggerSleepAction(0.0) // wait until it has been dropped
					call this.resetPageItem(usedItem)
				// destack and drop
				elseif (this.m_rucksackItemData[index].charges() > 1) then
					debug call Print("Destacking and dropping item " + GetItemName(usedItem))
					if (GetItemType(usedItem) == ITEM_TYPE_CHARGED) then
						debug call Print("Is charged so 1")
						call SetItemCharges(usedItem, 1)
					else
						debug call Print("Is not charged so 0")
						call SetItemCharges(usedItem, 0)
					endif
					/*
					 * When an item is dropped explicitely the owner should be set to the default item owner, so anyone can pick it up.
					 */
					call SetItemPlayer(usedItem, Player(PLAYER_NEUTRAL_PASSIVE), false)
					call TriggerSleepAction(0.0) // wait until it has been dropped
					call this.setRucksackItemCharges(index, this.m_rucksackItemData[index].charges() - 1)
				// drop
				else
					// do not drop by this function since unit could also give the item to another character
					call this.m_rucksackItemData[index].destroy()
					set this.m_rucksackItemData[index] = 0

					if (GetItemType(usedItem) != ITEM_TYPE_CHARGED) then
						call SetItemCharges(usedItem, 0)
					endif
					/*
					 * When an item is dropped explicitely the owner should be set to the default item owner, so anyone can pick it up.
					 */
					call SetItemPlayer(usedItem, Player(PLAYER_NEUTRAL_PASSIVE), false)
				endif
			// unequip and drop
			else
				call this.clearEquipmentType(index)
			endif
			set triggeringTrigger = null
			set usedItem = null
			set triggerUnit = null
		endmethod

		// drop, destack and drop, unequip and drop
		private method createDropTrigger takes nothing returns nothing
			set this.m_dropTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_dropTrigger, this.character().unit(), EVENT_UNIT_DROP_ITEM)
			call TriggerAddCondition(this.m_dropTrigger, Condition(function thistype.triggerConditionIsNoPowerup))
			call TriggerAddAction(this.m_dropTrigger, function thistype.triggerActionDrop)
			call AHashTable.global().setHandleInteger(this.m_dropTrigger, "this", this)
		endmethod

		private static method triggerConditionUse takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return this.m_rucksackIsEnabled
		endmethod

		private static method triggerActionUse takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, "this")
			local item usedItem = GetManipulatedItem()
			local integer itemTypeId = GetItemTypeId(usedItem)
			local integer index

			// show next page
			if (itemTypeId == thistype.m_rightArrowItemType) then
				call this.showNextRucksackPage()
			// show previous page
			elseif (itemTypeId == thistype.m_leftArrowItemType) then
				call this.showPreviousRucksackPage()
			// usual item
			else
				set index = thistype.itemIndex(usedItem)
				// usable items have to be charged!
				if (GetItemType(usedItem) == ITEM_TYPE_CHARGED) then
					debug call this.print("Used usable item!")
					// if an item is used by decreasing its number of charges (not to 0!) we have to decrease our number, too
					call this.m_rucksackItemData[index].setCharges(this.m_rucksackItemData[index].charges() - 1)
					// use == drop
					/// Drop action is called when last charge is used!!!
				endif
				call TriggerSleepAction(0.0) // Event isn't fired otherwise!!!
				// if an item is used but the character is being stopped since the spell condition doesn't work, the charges become 0! this refresh prevents this error
				call this.refreshRucksackItemCharges(index)
			endif
			set usedItem = null
			set triggeringTrigger = null
		endmethod

		private method createUseTrigger takes nothing returns nothing
			set this.m_useTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_useTrigger, this.character().unit(), EVENT_UNIT_USE_ITEM)
			call TriggerAddCondition(this.m_useTrigger, Condition(function thistype.triggerConditionUse))
			call TriggerAddAction(this.m_useTrigger, function thistype.triggerActionUse)
			call AHashTable.global().setHandleInteger(this.m_useTrigger, "this", this)
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character)
			// members
			set this.m_rucksackPage = 0
			set this.m_rucksackIsEnabled = false

			if (GetUnitAbilityLevel(this.character().unit(), thistype.m_openRucksackAbilityId) == 0) then
				call UnitAddAbility(this.character().unit(), thistype.m_openRucksackAbilityId)
			endif

			call this.createOpenTrigger()
			call this.createOrderTrigger()
			call this.createPickupTrigger()
			call this.createDropTrigger()
			call this.createUseTrigger()
			
			debug call Print("Creating inventory for character of player " + GetPlayerName(character.player()))
			
			return this
		endmethod

		private method destroyOpenTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_openTrigger)
			set this.m_openTrigger = null
		endmethod

		private method destroyOrderTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_orderTrigger)
			set this.m_orderTrigger = null
		endmethod

		private method destroyPickupTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_pickupTrigger)
			set this.m_pickupTrigger = null
		endmethod

		private method destroyDropTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_dropTrigger)
			set this.m_dropTrigger = null
		endmethod

		private method destroyUseTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_useTrigger)
			set this.m_useTrigger = null
		endmethod

		public method onDestroy takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.maxEquipmentTypes)
				if (this.m_equipmentItemData[i] != 0) then
					call this.m_equipmentItemData[i].destroy()
				endif
				set i = i + 1
			endloop
			set i = 0
			loop
				exitwhen (i == thistype.maxRucksackItems)
				if (this.m_rucksackItemData[i] != 0) then
					call this.m_rucksackItemData[i].destroy()
				endif
				set i = i + 1
			endloop
			call UnitRemoveAbility(this.character().unit(), thistype.m_openRucksackAbilityId)

			call this.destroyOpenTrigger()
			call this.destroyOrderTrigger()
			call this.destroyPickupTrigger()
			call this.destroyDropTrigger()
			call this.destroyUseTrigger()
		endmethod

		/**
		 * \param leftArrowItemType This value should by the item type id of an item which is usable but not chargable. It will be used for a button item to change to the left page in rucksack.
		 * \param openRucksackAbilityId This ability is added to the character's unit automatically when inventory is created. When it is casted rucksack/equipment is opened.
		 * \param allowPickingUpFromOthers If this value is true characters are allowed to pick up items which are owned by other playing users (human controlled).
		 */
		public static method init takes integer leftArrowItemType, integer rightArrowItemType, integer openRucksackAbilityId, boolean allowPickingUpFromOthers, string textUnableToEquipItem, string textEquipItem, string textUnableToAddRucksackItem, string textAddItemToRucksack, string textUnableToMoveRucksackItem, string textDropPageItem, string textMovePageItem, string textOwnedByOther returns nothing
			// static construction members
			set thistype.m_leftArrowItemType = leftArrowItemType
			set thistype.m_rightArrowItemType = rightArrowItemType
			set thistype.m_openRucksackAbilityId = openRucksackAbilityId
			set thistype.m_allowPickingUpFromOthers = allowPickingUpFromOthers
			set thistype.m_textUnableToEquipItem = textUnableToEquipItem
			set thistype.m_textEquipItem = textEquipItem
			set thistype.m_textUnableToAddRucksackItem = textUnableToAddRucksackItem
			set thistype.m_textAddItemToRucksack = textAddItemToRucksack
			set thistype.m_textUnableToMoveRucksackItem = textUnableToMoveRucksackItem
			set thistype.m_textDropPageItem = textDropPageItem
			set thistype.m_textMovePageItem = textMovePageItem
			set thistype.m_textOwnedByOther = textOwnedByOther
		endmethod
	endstruct

endlibrary