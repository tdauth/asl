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

		/**
		 * Creates an item based on the item inventory data at a given position.
		 * \param x The X coordinate of the position.
		 * \param y The Y coordinate of the position.
		 * \return Returns a newly created item.
		 */
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

		/**
		 * Assigns all stored data to another item except the item type ID since it cannot be changed dynamically.
		 * \param usedItem The item which the data is assigned to.
		 */
		public method assignToItem takes item usedItem returns nothing
			debug if (this.m_itemTypeId != GetItemTypeId(usedItem)) then
			debug call Print("Item type " + GetObjectName(this.m_itemTypeId) + " does not equal " + GetObjectName(GetItemTypeId(usedItem)))
			debug endif
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

		/**
		 * Creates a inventory item data based on item \p usedItem and carrying unit \p usedUnit.
		 */
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
	 * \todo Test if shop events work even with a full inventory. At the moment the player has to select the shop but computer controlled players won't do that. For human players it should work.
	 */
	struct AInventory extends AAbstractCharacterSystem
		// static constant members, useful for GUIs
		/**
		 * No empty slot is required since picking up items with full inventory is supported as well as buying items with a full inventory as long as the shop is selected by the player before.
		 * If no empty slot is used the items however can not be dropped with all stacks at once (which the empty slot was used for).
		 */
		public static constant integer maxEquipmentTypes = 6 /// \ref AItemType.equipmentTypeAmulet gets the last two slots. Therefore two amulets can be carried. \todo \ref AItemType.maxEuqipmentTypes, vJass bug
		public static constant integer maxRucksackItems = 90
		public static constant integer maxRucksackPages = 30 //maxRucksackItems / maxRucksackItemsPerPage
		public static constant integer previousPageItemSlot = 4
		public static constant integer nextPageItemSlot = 5
		/**
		 * Leave one slot empty that the character can always pick up an item.
		 */
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
		private static string m_textPreviousPageIsFull
		private static string m_textNextPageIsFull
		// static members
		private static timer m_pickupTimer
		private static boolean m_pickupTimerHasStarted
		private static item array m_targetItem[12] // TODO bj_MAX_PLAYERS
		
		// dynamic members
		private integer array m_equipmentItemTypeId[thistype.maxEquipmentTypes]
		
		// members
		private AInventoryItemData array m_equipmentItemData[thistype.maxEquipmentTypes]
		private AInventoryItemData array m_rucksackItemData[thistype.maxRucksackItems]
		private trigger m_openTrigger
		private trigger m_orderTrigger
		private trigger m_useTrigger // show next page, show previous page, disable in equipment
		private trigger m_pickupOrderTrigger
		/**
		 * Since we use all slots in the inventory we have to manually create a pickup function.
		 * Unfortunately this does not work for buying items which would still lead to the error "inventory is full" if all slots are used.
		 * Therefore whenever the player selects a shop to buy items, all items in the slots are hidden.
		 * When the shop is deselected the items will be shown again.
		 *
		 * Since the player cannot interact with the inventory anyway when selecting a shop this does not bother the player.
		 * @{
		 */
		private trigger m_shopSelectionTrigger
		private unit m_shop
		private trigger m_shopDeselectionTrigger
		/**
		 * @}
		 */
		private trigger m_pickupTrigger
		private trigger m_dropTrigger
		private integer m_rucksackPage
		private boolean m_rucksackIsEnabled

		//! runtextmacro optional A_STRUCT_DEBUG("\"AInventory\"")
		
		/**
		 * Sets the item type of a placeholder item for equipment type \p equipmentType to \p itemTypeId.
		 * If the item type ID is not 0 the placeholder item will be shown whenever there is no item equipped of that certain type instead of an empty slot.
		 */
		public method setEquipmentTypePlaceholder takes integer equipmentType, integer itemTypeId returns nothing
			set this.m_equipmentItemTypeId[equipmentType] = itemTypeId
		endmethod
		
		public method equipmentTypePlaceholder takes integer equipmentType returns integer
			return this.m_equipmentItemTypeId[equipmentType]
		endmethod

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

		/**
		 * \return Returns the total number of charges from all equipped item of typ \p itemTypeId.
		 * \note Usually each equipment item has only one charge.
		 */
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
		
		/// \return Returns the rucksack item index by the slot number.
		public method rucksackItemIndex takes integer slot returns integer
			return this.m_rucksackPage * thistype.maxRucksackItemsPerPage + slot
		endmethod
		
		/// Just required for the move order and for item dropping.
		private static method hasItemIndex takes item usedItem returns boolean
			return AHashTable.global().hasHandleInteger(usedItem, "AInventory_index")
		endmethod

		/// Just required for the move order and for item dropping.
		private static method clearItemIndex takes item usedItem returns nothing
			debug if (not thistype.hasItemIndex(usedItem)) then
			debug call Print("Item " + GetItemName(usedItem) + " has no item index on removal.")
			debug endif
			call AHashTable.global().removeHandleInteger(usedItem, "AInventory_index")
		endmethod

		/// Just required for the move order and for item dropping.
		private static method setItemIndex takes item usedItem, integer index returns nothing
			call AHashTable.global().setHandleInteger(usedItem, "AInventory_index", index)
		endmethod

		/// Just required for the move order and for item dropping.
		private static method itemIndex takes item usedItem returns integer
			if (not thistype.hasItemIndex(usedItem)) then
				return -1
				debug call Print("Item " + GetItemName(usedItem) + " has no item index on getting it.")
			endif
			return AHashTable.global().handleInteger(usedItem, "AInventory_index")
		endmethod
		
		/**
		 * Removes item from unit \p whichUnit even if it is paused and disables the drop event during the removal.
		 */
		private method unitRemoveItem takes unit whichUnit, item whichItem returns nothing
			local boolean isBeingPaused
			// Workaround (character inventory system has to work - adding items - when character is being paused e. g. during talks)
			if (IsUnitPaused(whichUnit)) then
				set isBeingPaused = true
				call PauseUnit(whichUnit, false)
			else
				set isBeingPaused = false
			endif
			
			call DisableTrigger(this.m_dropTrigger)
			
			call RemoveItem(whichItem)
			
			if (isBeingPaused) then
				call PauseUnit(whichUnit, true)
			endif
			
			call EnableTrigger(this.m_dropTrigger)
		endmethod
		
		/**
		 * Drops item without firing the drop event for the system and even if the character's unit is paused.
		 * TODO It seems that the drop event is fired anyway.
		 * TODO UnitDropItemPoint() does not always succeed but it always returns true.
		 */
		private method unitDropItemPoint takes unit whichUnit, item whichItem, real x, real y returns boolean
			local boolean result
			local boolean isBeingPaused
			// Workaround (character inventory system has to work - adding items - when character is being paused e. g. during talks)
			if (IsUnitPaused(whichUnit)) then
				set isBeingPaused = true
				call PauseUnit(whichUnit, false)
			else
				set isBeingPaused = false
			endif
			
			call DisableTrigger(this.m_dropTrigger)
			
			/*
			 * Tests showed that UnitDropItemPoint() does not always succeed but always returns true.
			 * It is safer to call UnitRemoveItem() instead.
			 * Old code: set result = UnitDropItemPoint(whichUnit, whichItem, x, y)
			*/
			call UnitRemoveItem(whichUnit, whichItem)
			set result = true
			
			debug if (result and UnitHasItem(whichUnit, whichItem)) then
			debug call this.print("Unit " + GetUnitName(whichUnit) + " still has item " + GetItemName(whichItem) + " although dropped.")
			debug endif
			
			if (isBeingPaused) then
				call PauseUnit(whichUnit, true)
			endif
			
			call EnableTrigger(this.m_dropTrigger)
			
			return result
		endmethod

		/**
		 * Adds one item of type \p itemType to unit \p whichUnit into slot \p slot without firing the pickup event for this system and even if the character's unit is paused.
		 * \return Returns true if the item has been added to the slot successfully.
		 * \note If there is already an item in the slot it will be dropped and therefore the drop trigger might be disabled and enabled again.
		 */
		private method unitAddItemToSlotById takes unit whichUnit, integer itemType, integer slot returns boolean
			local boolean result
			local boolean isBeingPaused
			// Workaround (character inventory system has to work - adding items - when character is being paused e. g. during talks)
			if (IsUnitPaused(whichUnit)) then
				set isBeingPaused = true
				call PauseUnit(whichUnit, false)
			else
				set isBeingPaused = false
			endif
			
			debug call Print("Disable pickup trigger in unitAddItemToSlotById()")
			call DisableTrigger(this.m_pickupTrigger)
			
			if (UnitItemInSlot(whichUnit, slot) != null) then
				debug call this.print("Unit " + GetUnitName(whichUnit) + " has already an item in slot " + I2S(slot))
				if (not this.unitDropItemPoint(whichUnit, UnitItemInSlot(whichUnit, slot), GetUnitX(this.character().unit()), GetUnitY(this.character().unit()))) then
					debug call this.print("Unknown error on dropping the item")
				endif
			endif
			
			set result = UnitAddItemToSlotById(whichUnit, itemType, slot)
			
			if (isBeingPaused) then
				call PauseUnit(whichUnit, true)
			endif
			
			call EnableTrigger(this.m_pickupTrigger)
			
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
				
				if (not this.rucksackIsEnabled()) then
					// show place holder
					call this.showEquipmentPlaceholder.evaluate(equipmentType)
				endif
				
				call itemType.onUnequipItem.evaluate(characterUnit, equipmentType)
				call this.checkEquipment.evaluate() // added
				set characterUnit = null
			endif
		endmethod
		
		/**
		 * Clears the rucksack slot \p index without dropping or removing the item from the unit's inventory.
		 * It simply destroys the corresponding \ref AInventoryItemData instance.
		 * \return Returns true if there has been an instance at the given index. Otherwise it returns false.
		 */
		private method clearRucksackSlot takes integer index returns boolean
			if (this.m_rucksackItemData[index] != 0) then
				call this.m_rucksackItemData[index].destroy()
				set this.m_rucksackItemData[index] = 0
				
				return true
			endif
			
			return false
		endmethod

		/**
		 * Clears rucksack item at \p index and drops it if specified.
		 * \param drop If this value is true the item will be dropped by the character. Otherwise it simply will be removed.
		 */
		private method clearRucksackItem takes integer index, boolean drop returns nothing
			local item slotItem
			if (this.m_rucksackIsEnabled and this.m_rucksackPage == this.itemRucksackPage(index)) then
				set slotItem = UnitItemInSlot(this.character().unit(), this.rucksackItemSlot(index))
				if (slotItem != null) then
					call thistype.clearItemIndex(slotItem)
					
					if (drop) then
						call this.unitDropItemPoint(this.character().unit(), slotItem, GetUnitX(this.character().unit()), GetUnitY(this.character().unit()))
						if (GetItemType(slotItem) != ITEM_TYPE_CHARGED) then
							call SetItemCharges(slotItem, GetItemCharges(slotItem) - 1)
						endif
					else
						call DisableTrigger(this.m_dropTrigger)
						call RemoveItem(slotItem)
						call EnableTrigger(this.m_dropTrigger)
					endif

					set slotItem = null
				endif
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
			local item slotItem = UnitItemInSlot(this.character().unit(), equipmentType)
			local AItemType itemType = 0
			if (slotItem != null) then
				set itemType = AItemType.itemTypeOfItem(slotItem)
				call thistype.clearItemIndex(slotItem)
				call DisableTrigger(this.m_dropTrigger)
				debug call Print("Removing slot item: " + GetItemName(slotItem))
				call RemoveItem(slotItem)
				call EnableTrigger(this.m_dropTrigger)
				// equipped items must always have an item type, otherwise something went wrong
				if (itemType != 0 and addPermanentAbilities) then
					call itemType.addPermanentAbilities(this.character().unit())
				debug elseif (itemType == 0) then
					debug call this.print("Equipped item of equipment type " + I2S(equipmentType) + " has no custom item type which should not be possible.")
				endif
			debug elseif (this.equipmentItemData(equipmentType) != 0) then
				debug call this.print("Equipment type " + I2S(equipmentType) + " is not 0 but has no slot item.")
			endif
			set slotItem = null
		endmethod
		
		private method hideEquipmentPlaceholder takes integer equipmentType returns nothing
			local item slotItem = UnitItemInSlot(this.character().unit(), equipmentType)
			if (slotItem != null) then
				call DisableTrigger(this.m_dropTrigger)
				debug call Print("Removing slot item: " + GetItemName(slotItem))
				call RemoveItem(slotItem)
				call EnableTrigger(this.m_dropTrigger)
			debug elseif (this.equipmentItemData(equipmentType) == 0) then
				debug call this.print("Equipment type placeholder " + I2S(equipmentType) + " is not 0 but has no slot item with type " + GetObjectName(this.m_equipmentItemTypeId[equipmentType]))
			endif
			set slotItem = null
		endmethod

		/**
		 * Hides the equipment.
		 * \param addPermanentAbilities If this value is true the permanent abilities of all equipped item types will be added to the character's unit. Otherwise they disappear with the items.
		 */
		private method disableEquipment takes boolean addPermanentAbilities returns nothing
			local integer i
			set i = 0
			loop
				exitwhen (i == thistype.maxEquipmentTypes)
				if (this.m_equipmentItemData[i] != 0) then
					call this.hideEquipmentItem(i, addPermanentAbilities)
				else
					call this.hideEquipmentPlaceholder(i)
				endif
				set i = i + 1
			endloop
		endmethod

		private method hideRucksackItem takes integer index returns nothing
			local integer slot = this.rucksackItemSlot(index)
			local item slotItem = UnitItemInSlot(this.character().unit(), slot)
			call thistype.clearItemIndex(slotItem)
			call DisableTrigger(this.m_dropTrigger)
			call RemoveItem(slotItem)
			call EnableTrigger(this.m_dropTrigger)
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
		
		private method hidePageItem takes boolean left returns boolean
			local boolean result = false
			local integer slot
			local item slotItem
			
			if (not this.rucksackIsEnabled()) then
				return false
			endif
			
			if (left) then
				set slot = thistype.previousPageItemSlot
			else
				set slot = thistype.nextPageItemSlot
			endif
			
			set slotItem = UnitItemInSlot(this.character().unit(), slot)
			
			if (slotItem == null) then
				return false
			endif
		
			call DisableTrigger(this.m_dropTrigger)
			call RemoveItem(slotItem)
			set slotItem = null
			call EnableTrigger(this.m_dropTrigger)
			
			return true
		endmethod

		private method disableRucksack takes nothing returns nothing
			if (this.m_rucksackIsEnabled) then
				call this.hidePageItem(true)
				call this.hidePageItem(false)
				call this.hideCurrentRucksackPage()
				set this.m_rucksackIsEnabled = false
			debug else
				debug call this.print("Disabling rucksack although it is not even enabled.")
			endif
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
				exitwhen (i == thistype.maxEquipmentTypes)
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
			local item slotItem
			local boolean result = false
			local AItemType itemType = AItemType.itemTypeOfItemTypeId(this.m_equipmentItemData[equipmentType].itemTypeId())
			
			// equipped items must always have an item type
			call itemType.removePermanentAbilities(this.character().unit())

			set result = this.unitAddItemToSlotById(this.character().unit(), this.m_equipmentItemData[equipmentType].itemTypeId(), equipmentType)
			
			// successfully readded
			if (result) then
				set slotItem = UnitItemInSlot(this.character().unit(), equipmentType)
				call this.m_equipmentItemData[equipmentType].assignToItem(slotItem)
				call SetItemDropOnDeath(slotItem, false)
				call thistype.setItemIndex(slotItem, equipmentType)
				set slotItem = null
			// Something went wrong and the item has been dropped instead. Otherwise if disabling and enabling equipment again the items will be duplicated.
			else
				debug call this.print("Something went wrong on showing equipment item of type " + I2S(equipmentType))
				call this.clearEquipmentType(equipmentType)
			endif
		endmethod
		
		private method showEquipmentPlaceholder takes integer equipmentType returns nothing
			local item slotItem
			local boolean result = false
			
			if (this.m_equipmentItemTypeId[equipmentType] != 0) then
				set result = this.unitAddItemToSlotById(this.character().unit(), this.m_equipmentItemTypeId[equipmentType], equipmentType)
				
				// successfully readded
				if (result) then
					set slotItem = UnitItemInSlot(this.character().unit(), equipmentType)
					call SetItemDropOnDeath(slotItem, false)
					call SetItemInvulnerable(slotItem, true)
					call SetItemDroppable(slotItem, false)
					call SetItemPawnable(slotItem, false)
					set slotItem = null
				else
					debug call this.print("Something went wrong on showing equipment item placeholder of type " + I2S(equipmentType))
				endif
			endif
		endmethod

		private method enableEquipment takes nothing returns nothing
			local integer i
			set i = 0
			loop
				exitwhen (i == thistype.maxEquipmentTypes)
				if (this.m_equipmentItemData[i] != 0) then
					call this.showEquipmentItem(i)
				else
					call this.showEquipmentPlaceholder(i)
				endif
				set i = i + 1
			endloop
		endmethod
		
		/**
		 * Shows either left or right page item in the rucksack.
		 */
		private method showPageItem takes boolean left returns boolean
			local boolean result = false
			local integer itemTypeId = 0
			local integer slot
			local item slotItem
			
			if (left) then
				set itemTypeId = thistype.m_leftArrowItemType
				set slot = thistype.previousPageItemSlot
			else
				set itemTypeId = thistype.m_rightArrowItemType
				set slot = thistype.nextPageItemSlot
			endif
			
			if (UnitItemInSlot(this.character().unit(), slot) != null) then
				debug call this.print("Item slot " + I2S(slot) + " for page item is already in use.")
				return false
			endif
			
			debug call Print("Before adding item.")
			
			if (not this.unitAddItemToSlotById(this.character().unit(), itemTypeId, slot)) then
				debug call Print("Something went wrong when readding item " + GetObjectName(itemTypeId) + " to slot " + I2S(slot))
			else
				set result = true
			endif
			
			set slotItem = UnitItemInSlot(this.character().unit(), slot)
			call SetItemDroppable(slotItem, true) // for moving items to next or previous pages
			
			if (not left) then
				call SetItemCharges(slotItem, this.m_rucksackPage + 1)
			endif
			
			set slotItem = null
			
			return result
		endmethod

		/**
		 * \note Call this method only if being sure that there is some item data at \p index in the rucksack.
		 */
		private method showRucksackItem takes integer index returns boolean
			local integer slot = this.rucksackItemSlot(index)
			local item slotItem
			local boolean result = false
			local AItemType itemType = 0
			
			if (this.m_rucksackItemData[index] != 0) then

				set result = this.unitAddItemToSlotById(this.character().unit(), this.m_rucksackItemData[index].itemTypeId(), slot)
				
				// successfully readded
				if (result) then
					set slotItem = UnitItemInSlot(this.character().unit(), slot)
					
					if (slotItem != null) then
						call this.m_rucksackItemData[index].assignToItem(slotItem)
						call SetItemDropOnDeath(slotItem, false)
						set itemType = AItemType.itemTypeOfItemTypeId(this.m_rucksackItemData[index].itemTypeId())
						// rucksack item do not need to have an item type
						if (itemType != 0) then
							call itemType.removePermanentAbilities(this.character().unit())
						endif
						call thistype.setItemIndex(slotItem, index)
						set slotItem = null
					debug else
						debug call this.print("Rucksack item from slot " + I2S(slot) + " is null.")
					endif
				// Something went wrong and the item has been dropped instead. Otherwise if disabling and enabling rucksack again the items will be duplicated.
				else
					debug call this.print("Error: Adding rucksack item with index " + I2S(index) + " failed for unknown reasons.")
					call this.clearRucksackSlot(index)
				endif
			debug else
				debug call this.print("Showing rucksack item of index " + I2S(index) + " which has no item data.")
			endif
			
			return result
		endmethod

		private method showRucksackPage takes integer page, boolean firstCall returns nothing
			local integer i
			local integer exitValue
			local item rightArrowItem
			
			if (page > thistype.maxRucksackPages) then
				debug call this.print("Page value is too big.")
				return
			endif

			if (not firstCall) then
				call this.hideCurrentRucksackPage()
			endif

			set this.m_rucksackPage = page
			// add inventory items
			set i = page * thistype.maxRucksackItemsPerPage
			set exitValue = i + thistype.maxRucksackItemsPerPage
			loop
				exitwhen (i == exitValue)
				if (this.m_rucksackItemData[i] != 0) then
					call this.showRucksackItem(i)
				endif
				set i = i + 1
			endloop

			/*
			 * If this is not a call from  enableRucksack() the rucksack page number has to be updated. Otherwise not.
			 */
			if (not firstCall) then
				set rightArrowItem = UnitItemInSlot(this.character().unit(), thistype.nextPageItemSlot)
				if (rightArrowItem != null) then
					call SetItemCharges(rightArrowItem, page + 1)
					set rightArrowItem = null
				else
					debug call this.print("Missing slot item for right page item at slot " + I2S(thistype.nextPageItemSlot))
					if (not this.showPageItem(false)) then
						debug call this.print("Error on adding right page item.")
					endif
				endif
			endif
		endmethod

		private method enableRucksack takes nothing returns nothing
			local boolean leftResult = false
			local boolean rightResult = false
			
			if (not this.m_rucksackIsEnabled) then
				set this.m_rucksackIsEnabled = true
				
				/*
				 * Make sure the page items are already there when showing the rucksack page for the first time.
				 */
				
				if (not this.showPageItem(true)) then
					debug call this.print("Error on adding left page item.")
				endif
				
				if (not this.showPageItem(false)) then
					debug call this.print("Error on adding right page item.")
				endif
				
				call this.showRucksackPage(this.m_rucksackPage, true)
			debug else
				debug call this.print("Enabling rucksack although it is already enabled.")
			endif
		endmethod
		
		/**
		 * Updates the equipment with the latest placeholders.
		 * Useful after changing them to make sure they are shown.
		 */
		public method updateEquipmentTypePlaceholders takes nothing returns nothing
			local integer i
			if (not this.rucksackIsEnabled()) then
				set i = 0
				loop
					exitwhen (i == thistype.maxEquipmentTypes)
					if (this.equipmentItemData(i) == 0) then
						call this.showEquipmentPlaceholder(i)
					endif
					set i = i + 1
				endloop
			endif
		endmethod

		/**
		 * Shows the current page in the inventory of the character's unit if the rucksack is open.
		 * Otherwise it shows the equipment.
		 * Usually you do not have to call this method. The system handles itself.
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
			if (add and this.m_shop == null) then
				if (not this.m_rucksackIsEnabled) then
					call this.hideEquipmentPlaceholder(equipmentType)
				endif
				call this.showEquipmentItem(equipmentType)
			elseif (this.m_rucksackIsEnabled or this.m_shop != null) then
				// equipped items must always have an item type
				//if (itemType != 0) then
					call itemType.addPermanentAbilities(this.character().unit())
				//endif
			endif
			call itemType.onEquipItem.evaluate(this.character().unit(), equipmentType)
		endmethod

		/**
		 * Sets equipment item of type \p equipmentType to item \p usedItem and removes \p usedItem after that.
		 */
		private method setEquipmentItemByItem takes integer equipmentType, item usedItem, boolean add returns nothing
			local AInventoryItemData inventoryItemData = AInventoryItemData.create(usedItem, this.character().unit())
			call DisableTrigger(this.m_dropTrigger)
			call RemoveItem(usedItem)
			call EnableTrigger(this.m_dropTrigger)
			set usedItem = null
			call this.setEquipmentItem(equipmentType, inventoryItemData, add)
		endmethod

		private method clearEquipmentItem takes integer equipmentType, boolean drop returns nothing
			local item slotItem = null
			local AItemType itemType = 0

			if (not this.m_rucksackIsEnabled) then
				set slotItem = UnitItemInSlot(this.character().unit(), equipmentType)
				if (slotItem != null) then
					call thistype.clearItemIndex(slotItem)

					if (drop) then
						call this.unitDropItemPoint(this.character().unit(), slotItem, GetUnitX(this.character().unit()), GetUnitY(this.character().unit()))
					else
						call DisableTrigger(this.m_dropTrigger)
						call RemoveItem(slotItem)
						call EnableTrigger(this.m_dropTrigger)
					endif

					set slotItem = null
				debug else
					debug call this.print("Missing equipment type slot item although equipment is enabled. Slot: " + I2S(equipmentType) + ".")
				endif
			else
				set itemType = AItemType.itemTypeOfItemTypeId(this.m_equipmentItemData[equipmentType].itemTypeId())
				// equipped items must always have an item type
				if (itemType != 0) then
					call itemType.removePermanentAbilities(this.character().unit())
				debug else
					debug call this.print("Equipment type " + I2S(equipmentType) + " has no item type which should not be possible.")
				endif
			endif
			
			call this.clearEquipmentType(equipmentType)
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
		 * Removes item by type \p itemTypeId \p count times from the inventory.
		 */
		public method removeItemTypeCount takes integer itemTypeId, integer count returns boolean
			local boolean result = true
			local integer i = 0
			loop
				exitwhen (i == count)
				if (not this.removeItemType(itemTypeId)) then
					set result = false
				endif
				set i = i + 1
			endloop
			
			return result
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
			if (add and this.m_shop == null) then
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
			local item equippedItem
			local string itemName

			// sometimes null items will be equipped for example when an item is added which is removed at the same moment
			if (usedItem == null) then
				debug call this.print("Error: Used item is null when equipping it.")
				return false
			endif

			if (UnitHasItem(this.character().unit(), usedItem)) then // already picked up
				if (not this.unitDropItemPoint(this.character().unit(), usedItem, GetUnitX(this.character().unit()), GetUnitY(this.character().unit()))) then
					debug call this.print("Error on dropping item " + GetItemName(usedItem))
				endif
			debug else
				debug call this.print("Unit has no item.")
			endif

			set itemPlayer = GetItemPlayer(usedItem)
			
			if (not thistype.m_allowPickingUpFromOthers and itemPlayer != this.character().player() and IsPlayerPlayingUser(itemPlayer)) then
				if (thistype.m_textOwnedByOther != null) then
					call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textOwnedByOther)
				endif
				set itemPlayer = null

				return false
			endif
			set itemPlayer = null

			set itemType = AItemType.itemTypeOfItem(usedItem)
			set equipmentType = itemType.equipmentType()
			
			if (itemType != 0 and equipmentType != -1) then
				/*
				 * Can be equipped to the equipment type since either no equipment is there or it will be swapped.
				 */
				if (swapWithAlreadyEquipped or this.m_equipmentItemData[equipmentType] == 0 or (equipmentType == AItemType.equipmentTypeAmulet and this.m_equipmentItemData[equipmentType + 1] == 0)) then
					/*
					 * The user specified requirement for the item type must be checked first.
					 */
					if (itemType.checkRequirement(this.character())) then
						/*
						 * Equipment item must be swapped.
						 */
						if (swapWithAlreadyEquipped and this.m_equipmentItemData[equipmentType] != 0 and (equipmentType != AItemType.equipmentTypeAmulet or this.m_equipmentItemData[equipmentType + 1] != 0)) then
							/*
							 * Drop the equipped item and add it to the rucksack.
							 * TODO Do not create a new item but drop the existing item instead.
							 * TODO maybe add to rucksack AFTER equipping the new item? Not really necessary.
							 */
							set equippedItem = this.m_equipmentItemData[equipmentType].createItem(GetUnitX(this.character().unit()), GetUnitY(this.character().unit()))
							call this.addItemToRucksack.evaluate(equippedItem, true, false)
							call this.clearEquipmentItem(equipmentType, false)
							set equippedItem = null
						elseif (equipmentType == AItemType.equipmentTypeAmulet and this.m_equipmentItemData[equipmentType] != 0) then
							// use the second amulet slot
							set equipmentType = equipmentType + 1
						endif
						set itemName = GetItemName(usedItem)
						call this.setEquipmentItemByItem(equipmentType, usedItem, not this.m_rucksackIsEnabled)
						if (showEquipMessage and thistype.m_textEquipItem != null) then
							call this.character().displayMessage(ACharacter.messageTypeInfo, Format(thistype.m_textEquipItem).s(itemName).result())
						endif

						return true
					endif
				endif
			debug elseif (itemType == 0) then
				debug call this.print("Warning: Item \"" + GetItemName(usedItem) + "\" has no custom type.")
			endif
			
			// move to rucksack
			if (not dontMoveToRucksack) then
				return this.addItemToRucksack.evaluate(usedItem, true, true) //if item type is 0 it will be placed in rucksack, too
			elseif (thistype.m_textUnableToEquipItem != null) then
				call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textUnableToEquipItem)
			endif
			
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

		/**
		 * Adds item \p usedItem to the rucksack.
		 * \param dontMoveToEquipment If this value is true the item won't be moved to the equipment if the rucksack is full.
		 * \param showAddMessage If this value is true a message will be shown.
		 * \return Returns true if the item has been added to the rucksack successfully.
		 */
		private method addItemToRucksack takes item usedItem, boolean dontMoveToEquipment, boolean showAddMessage returns boolean
			local integer i
			local player itemPlayer
			local string itemName

			// sometimes null items will be added for example when an item is added which is removed at the same moment
			if (usedItem == null) then
				debug call this.print("Error: Used item is null when adding item to rucksack.")
				return false
			endif
			
			if (UnitHasItem(this.character().unit(), usedItem)) then // already picked up
				if (not this.unitDropItemPoint(this.character().unit(), usedItem, GetUnitX(this.character().unit()), GetUnitY(this.character().unit()))) then
					debug call this.print("Error on dropping item " + GetItemName(usedItem))
				endif
			endif

			/*
			 * If configured that way characters must not pickup items which are owned by other players.
			 * In this case the item stays dropped.
			 */
			set itemPlayer = GetItemPlayer(usedItem)
			
			if (not thistype.m_allowPickingUpFromOthers and itemPlayer != this.character().player() and IsPlayerPlayingUser(itemPlayer)) then
				if (thistype.m_textOwnedByOther != null) then
					call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textOwnedByOther)
				endif
				set itemPlayer = null
				return false
			endif
			set itemPlayer = null

			/*
			 * Now check for a free slot in the rucksack.
			 * Besides slots with the same item type are checked since the items are stackable.
			 */
			set i = 0
			loop
				exitwhen (i == thistype.maxRucksackItems)
				if (this.m_rucksackItemData[i] == 0 or  this.m_rucksackItemData[i].itemTypeId() == GetItemTypeId(usedItem)) then
					set itemName = GetItemName(usedItem)
					call this.setRucksackItemByItem(i, usedItem, this.m_rucksackIsEnabled and this.itemRucksackPage(i) == this.m_rucksackPage)
					if (showAddMessage and thistype.m_textAddItemToRucksack != null) then
						call this.character().displayMessage(ACharacter.messageTypeInfo, Format(thistype.m_textAddItemToRucksack).s(itemName).result())
					endif
					return true
				endif
				set i = i + 1
			endloop

			// equip
			if (not dontMoveToEquipment) then
				return this.equipItem(usedItem, true, false, true)
			// the rucksack is full and the item should not be equipped, for example when the item was added to the rucksack from the equipment
			elseif (thistype.m_textUnableToAddRucksackItem != null) then
				call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textUnableToAddRucksackItem)
			endif
			
			return false
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
		 * \note Both items must be visible and in the inventory. This method assumes that only the items have been swapped recently and not their index data.
		 */
		private method resetItemSlots takes integer currentSlot, integer oldSlot returns boolean
			local item currentItem = UnitItemInSlot(this.character().unit(), currentSlot)
			local item oldItem = UnitItemInSlot(this.character().unit(), oldSlot)
			local boolean paused = IsUnitPaused(this.character().unit())
			local boolean result = true
			
			if (paused) then
				call PauseUnit(this.character().unit(), false)
			endif
			
			debug call this.print("Reset current item " + GetItemName(currentItem) + " with current slot " + I2S(currentSlot) + " and old item " + GetItemName(oldItem) + " with old slot " + I2S(oldSlot))
			
			call DisableTrigger(this.m_orderTrigger)
			if (currentItem != null) then
				if (not IssueTargetOrderById(this.character().unit(), A_ORDER_ID_MOVE_SLOT_0 + oldSlot, currentItem)) then
					debug call this.print("Unknown error on resetting item slots.")
					set result = false
				endif
			elseif (oldItem != null) then
				if (not IssueTargetOrderById(this.character().unit(), A_ORDER_ID_MOVE_SLOT_0 + currentSlot, oldItem)) then
					debug call this.print("Unknown error on resetting item slots.")
					set result = false
				endif
			else
				debug call this.print("Error on resetting item slots: Both slots are empty.")
				set result = false
			endif
			call EnableTrigger(this.m_orderTrigger)
			
			if (paused) then
				call PauseUnit(this.character().unit(), true)
			endif
			
			set currentItem = null
			set oldItem = null
			
			return result
		endmethod

		/**
		 * Moves item \p slotItem with all of its charges to the previous or the next rucksack page which means it will only be moved if the previous or next page has a free slot or a lot where the item can be stacked.
		 * If no free slot or stackable item is found the item will remain as it is at its current slot.
		 * \param slotItem The item which will be moved and must be be part of the rucksack.
		 * \param next If this value is true the item will be moved to the next page. Otherwise it will be moved to the previous page.
		 * \return Returns true if the item has been moved successfully. Otherwise if the item stays at its current slot it returns false.
		 */
		private method moveRucksackItemToPage takes item slotItem, boolean next returns boolean
			local integer oldIndex = thistype.itemIndex(slotItem)
			local integer oldPage = this.itemRucksackPage(oldIndex)
			local integer i = 0
			local integer exitValue = 0
			local boolean result = false

			debug call this.print("Moving item " + GetItemName(slotItem))
			debug call this.print("Old index " + I2S(oldIndex))
			debug call this.print("Old page " + I2S(oldPage))

			if (next) then
				/*
				 * If it is the last page start with the first.
				 */
				if (oldPage == thistype.maxRucksackPages - 1) then
					debug call this.print("Is last page")
					set i = 0
					set exitValue = thistype.maxRucksackItemsPerPage
				else
					set i = (oldPage + 1) * thistype.maxRucksackItemsPerPage
					set exitValue = i + thistype.maxRucksackItemsPerPage
				endif
			else
				/*
				 * If it is the first page start with the last.
				 */
				if (oldPage == 0) then
					debug call this.print("Is first page")
					set i = thistype.maxRucksackItems - 1
					set exitValue = thistype.maxRucksackItems - thistype.maxRucksackItemsPerPage
				else
					set i = oldPage * thistype.maxRucksackItemsPerPage - 1
					set exitValue = i - thistype.maxRucksackItemsPerPage
				endif
			endif
			
			debug call this.print("Start value: " + I2S(i) + " and exit value: " + I2S(exitValue))

			loop
				exitwhen (result or i == exitValue)
				
				// found stack place
				if (this.m_rucksackItemData[i].itemTypeId() == this.m_rucksackItemData[oldIndex].itemTypeId()) then
					call this.m_rucksackItemData[i].setCharges(this.m_rucksackItemData[i].charges() + this.m_rucksackItemData[oldIndex].charges())
					
					/*
					 * Delete old inventory item data since it is not used anymore.
					 */
					call this.clearRucksackSlot(oldIndex)
					
					set result = true
				// found a free place
				elseif (this.m_rucksackItemData[i] == 0) then
					/*
					 * This assigns the item data to a free slot. Therefore it should not be deleted.
					 */
					call this.setRucksackItem(i, this.m_rucksackItemData[oldIndex], this.m_rucksackIsEnabled and this.itemRucksackPage(i) == this.m_rucksackPage)
					
					/*
					 * Clear the old inventory item data entry but do not delete it since it was assigned to the new index.
					 */
					 set this.m_rucksackItemData[oldIndex] = 0
					
					set result = true
				endif
				
				if (next) then
					set i = i + 1
				else
					set i = i - 1
				endif
			endloop
			
			/**
			 * Since all charges are moved at once the whole item must be cleared if it has been moved successfully to another page.
			 */
			if (result) then
				debug call this.print("Removing item " + GetItemName(slotItem))
				debug call this.print("Clearing index " + I2S(oldIndex))
				debug call this.print("After clearing index")
				call thistype.clearItemIndex(slotItem)
				call DisableTrigger(this.m_dropTrigger)
				call RemoveItem(slotItem)
				debug call this.print("After removing item")
				call EnableTrigger(this.m_dropTrigger)
			endif
			
			set slotItem = null
			
			return result
		endmethod

		private method swapRucksackItemData takes item firstItem, item secondItem returns nothing
			local integer firstIndex = thistype.itemIndex(firstItem)
			local integer secondIndex = thistype.itemIndex(secondItem)
			local AInventoryItemData itemData = this.m_rucksackItemData[firstIndex]
			set this.m_rucksackItemData[firstIndex] = this.m_rucksackItemData[secondIndex]
			call thistype.setItemIndex(firstItem, secondIndex)
			set this.m_rucksackItemData[secondIndex] = itemData
			call thistype.setItemIndex(secondItem, firstIndex)
		endmethod

		private method moveRucksackItem takes item movedItem, integer slot returns nothing
			local unit characterUnit = this.character().unit()
			local item targetItem
			local integer oldIndex = thistype.itemIndex(movedItem)
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
			// swap
			else
				call this.swapRucksackItemData(movedItem, targetItem)
			endif
			set characterUnit = null
			set targetItem = null
		endmethod

		private static method triggerConditionOpen takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return this.character().unit() == GetTriggerUnit() and GetSpellAbilityId() == thistype.m_openRucksackAbilityId
		endmethod

		private static method triggerActionOpen takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			
			if (this.rucksackIsEnabled()) then
				call this.disableRucksack()
				call this.enableEquipment()
			else
				call this.disableEquipment(true)
				call this.enableRucksack()
			endif
		endmethod

		/**
		 * The open trigger registers that the \ref thistype.m_openRucksackAbilityId is being cast and changes to the rucksack if the equipment is shown or to the equipment
		 * if the rucksack is shown.
		 */
		private method createOpenTrigger takes nothing returns nothing
			set this.m_openTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_openTrigger, EVENT_PLAYER_UNIT_SPELL_CAST)
			call TriggerAddCondition(this.m_openTrigger, Condition(function thistype.triggerConditionOpen))
			call TriggerAddAction(this.m_openTrigger, function thistype.triggerActionOpen)
			call AHashTable.global().setHandleInteger(this.m_openTrigger, "this", this)
		endmethod

		private static method triggerConditionOrder takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return this.character().unit() == GetTriggerUnit() and GetIssuedOrderId() >= A_ORDER_ID_MOVE_SLOT_0 and GetIssuedOrderId() <= A_ORDER_ID_MOVE_SLOT_5
		endmethod
		
		/**
		 * All orders are recognized after they are done so this method is called by a 0 seconds timer.
		 */
		private static method timerFunctionOrder takes nothing returns nothing
			local thistype this = thistype(AHashTable.global().handleInteger(GetExpiredTimer(), "this"))
			local item usedItem = AHashTable.global().handleItem(GetExpiredTimer(), "item")
			local integer newSlot = AHashTable.global().handleInteger(GetExpiredTimer(), "slot")
			local integer oldSlot
			local integer index = -1
			local integer charges = 0
			
			debug call this.print("Moving item " + GetItemName(usedItem) + " to slot " + I2S(newSlot))

			if (this.rucksackIsEnabled()) then
				//debug call this.print("Rucksack is enabled.")
				/*
				 * If a page item is moved it will be reset immediately.
				 */
				if (GetItemTypeId(usedItem) == thistype.m_leftArrowItemType and newSlot != thistype.previousPageItemSlot) then
					debug call Print("Moving left item to slot " + I2S(newSlot))
					call this.resetItemSlots(newSlot, thistype.previousPageItemSlot)
					if (thistype.m_textMovePageItem != null) then
						call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textMovePageItem)
					endif
				elseif (GetItemTypeId(usedItem) == thistype.m_rightArrowItemType and newSlot != thistype.nextPageItemSlot) then
					debug call Print("Moving right item to slot " + I2S(newSlot))
					call this.resetItemSlots(newSlot, thistype.nextPageItemSlot)
					if (thistype.m_textMovePageItem != null) then
						call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textMovePageItem)
					endif
				// move item previous - player drops an item on the previous page item
				elseif (GetItemTypeId(usedItem) != thistype.m_leftArrowItemType and newSlot == thistype.previousPageItemSlot) then
					set index = thistype.itemIndex(usedItem)
					set oldSlot = this.rucksackItemSlot(index)
					if (this.resetItemSlots(newSlot, oldSlot)) then
						if (not this.moveRucksackItemToPage(usedItem, false)) then
							call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textPreviousPageIsFull)
						endif
					endif
				// move item next - player drops an item on the next page item
				elseif (GetItemTypeId(usedItem) != thistype.m_rightArrowItemType and newSlot == thistype.nextPageItemSlot) then
					set index = thistype.itemIndex(usedItem)
					set oldSlot = this.rucksackItemSlot(index)
					if (this.resetItemSlots(newSlot, oldSlot)) then
						if (not this.moveRucksackItemToPage(usedItem, true)) then
							call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textNextPageIsFull)
						endif
					endif
				// drop with all charges instead of one - moves the item to a free slot in rucksack which is not used by the rucksack
				elseif (newSlot >= thistype.maxRucksackItemsPerPage and GetItemTypeId(usedItem) != thistype.m_leftArrowItemType and GetItemTypeId(usedItem) != thistype.m_rightArrowItemType) then
					debug call Print("Drop with all charges.")
					set index = thistype.itemIndex(usedItem)
					debug call Print("Rucksack item index: " + I2S(index))
				
					if (this.unitDropItemPoint(this.character().unit(), usedItem, GetUnitX(this.character().unit()), GetUnitY(this.character().unit()))) then
						if (index != -1) then
							debug call Print("Clearing rucksack slot " + I2S(index))
							set charges = this.m_rucksackItemData[index].charges()
							call this.clearRucksackSlot(index)
							debug call Print("After clearing rucksack slot " + I2S(index))
						endif
						call thistype.clearItemIndex(usedItem)

						/*
						 * Do only reset the charges to 0 if exactly one item is dropped for an item which usually is not stacked.
						 */
						if (GetItemType(usedItem) != ITEM_TYPE_CHARGED and charges == 1) then
							call SetItemCharges(usedItem, 0)
						endif
						
						/*
						 * When an item is dropped explicitely the owner should be set to the default item owner, so anyone can pick it up.
						 */
						call SetItemPlayer(usedItem, Player(PLAYER_NEUTRAL_PASSIVE), true)
					debug else
						debug call this.print("Unknown error on dropping item.")
					endif
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
			set usedItem = null
			call PauseTimer(GetExpiredTimer())
			call AHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod

		private static method triggerActionOrder takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local integer newSlot = GetIssuedOrderId() - A_ORDER_ID_MOVE_SLOT_0
			local item usedItem = GetOrderTargetItem()
			local timer whichTimer = CreateTimer()
			debug call Print("move item " + GetItemName(usedItem))
			call AHashTable.global().setHandleInteger(whichTimer, "this", this)
			call AHashTable.global().setHandleItem(whichTimer, "item", usedItem)
			call AHashTable.global().setHandleInteger(whichTimer, "slot", newSlot)
			call TimerStart(whichTimer, 0.0, false, function thistype.timerFunctionOrder)
		endmethod

		/*
		 * Moving the item in the inventory generates an order target event with the unit itself as target.
		 * This trigger is used for the following actions:
		 * equip, add to rucksack, move item next, move item previous, stack items, destack item, swap items
		 */
		private method createOrderTrigger takes nothing returns nothing
			set this.m_orderTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_orderTrigger, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
			call TriggerAddCondition(this.m_orderTrigger, Condition(function thistype.triggerConditionOrder))
			call TriggerAddAction(this.m_orderTrigger, function thistype.triggerActionOrder)
			call AHashTable.global().setHandleInteger(this.m_orderTrigger, "this", this)
		endmethod
		
		/**
		 * \return Returns true if all visible slots of the character's inventory are full.
		 */
		private method inventoryIsFull takes nothing returns boolean
			local integer size = UnitInventorySize(this.character().unit())
			local integer i = 0
			loop
				exitwhen (i == size)
				if (UnitItemInSlot(this.character().unit(), i) == null) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod
		
		private static method triggerConditionPickupOrder takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return this.character().unit() == GetTriggerUnit() and GetIssuedOrderId() == A_ORDER_ID_SMART and GetOrderTargetItem() != null and not IsItemPowerup(GetOrderTargetItem()) and this.inventoryIsFull()
		endmethod
		
		/**
		 * This code is directly taken from the system "EasyItemStacknSplit v2.7.4 and allows picking up items even if the inventory is full.
		 */
		private static method timerFunctionPickup takes nothing returns nothing
			local thistype this = 0
			local boolean noTargets = true
			local unit character
			local real x
			local real y
			local integer order
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (thistype.m_targetItem[i] != null) then
					set character = ACharacter.playerCharacter(Player(i)).unit()
					if (GetWidgetLife(character) > 0.0 and GetWidgetLife(thistype.m_targetItem[i]) > 0.0 and not IsItemOwned(thistype.m_targetItem[i])) then
						if (GetUnitCurrentOrder(character) == 851986) then
							set x = GetItemX(thistype.m_targetItem[i]) - GetUnitX(character)
							set y = GetItemY(thistype.m_targetItem[i]) - GetUnitY(character)
							
							if (x * x + y * y <= 22500) then
								call IssueImmediateOrder(character, "stop")
								// TODO play fake sound
								call SetUnitFacing(character, bj_RADTODEG * Atan2(GetItemY(thistype.m_targetItem[i]) - GetUnitY(character), GetItemX(thistype.m_targetItem[i]) - GetUnitX(character)))
								set this = ACharacter.playerCharacter(Player(i)).inventory()
								call this.addItem(thistype.m_targetItem[i])
								set thistype.m_targetItem[i] = null
							endif
						endif
					else
						set thistype.m_targetItem[i] = null
					endif
					set character = null
					
					if (thistype.m_targetItem[i] != null) then
						set noTargets = false
					endif
				endif
				set i = i + 1
			endloop
			if (noTargets) then
				set thistype.m_pickupTimerHasStarted = false
				call PauseTimer(GetExpiredTimer())
			endif
		endmethod
		
		private static method triggerActionPickupOrder takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			set thistype.m_targetItem[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] = GetOrderTargetItem()
			// TODO check if there is a stackable or free slot in the rucksack/equipment
			if (not thistype.m_pickupTimerHasStarted) then
				set thistype.m_pickupTimerHasStarted = true
				call TimerStart(thistype.m_pickupTimer, 0.05, true, function thistype.timerFunctionPickup)
			endif
			debug call Print("Picking up item " + GetItemName(GetOrderTargetItem()) + " with full inventory.")
			call IssuePointOrder(GetTriggerUnit(), "move", GetItemX(GetOrderTargetItem()), GetItemY(GetOrderTargetItem()))
		endmethod
		
		private method createPickupOrderTrigger takes nothing returns nothing
			set this.m_pickupOrderTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_pickupOrderTrigger, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
			call TriggerAddCondition(this.m_pickupOrderTrigger, Condition(function thistype.triggerConditionPickupOrder))
			call TriggerAddAction(this.m_pickupOrderTrigger, function thistype.triggerActionPickupOrder)
			call AHashTable.global().setHandleInteger(this.m_pickupOrderTrigger, "this", this)
		endmethod
		
		private static method triggerConditionIsShop takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return GetTriggerUnit() != this.character().unit() and this.character().isMovable() and GetUnitAbilityLevel(GetTriggerUnit(), 'Aneu') > 0 and this.m_shop == null
		endmethod
		
		private static method triggerActionSelectShop takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local integer i
			set this.m_shop = GetTriggerUnit()
			debug call Print("Selected shop " + GetUnitName(this.m_shop))
			// Make sure an empty page is open for one single buy slot, don't allow other players to place items there wrongly
			if (this.rucksackIsEnabled()) then
				set i = 0
				loop
					exitwhen (i == thistype.maxRucksackItemsPerPage)
					if (this.rucksackItemData(this.rucksackItemIndex(i)) != 0) then
						call this.hideRucksackItem(this.rucksackItemIndex(i))
					endif
					set i = i + 1
				endloop
				call this.hidePageItem(true)
				call this.hidePageItem(false)
			else
				set i = 0
				loop
					exitwhen (i == thistype.maxEquipmentTypes)
					if (this.equipmentItemData(i) != 0) then
						call this.hideEquipmentItem(i, true) // add abilities to make sure the unit still has them
					else
						call this.hideEquipmentPlaceholder(i)
					endif
					set i = i + 1
				endloop
			endif
		endmethod
		
		private method createShopSelectionTrigger takes nothing returns nothing
			set this.m_shopSelectionTrigger = CreateTrigger()
			call TriggerRegisterPlayerUnitEvent(this.m_shopSelectionTrigger, this.character().player(), EVENT_PLAYER_UNIT_SELECTED, null)
			call TriggerAddCondition(this.m_shopSelectionTrigger, Condition(function thistype.triggerConditionIsShop))
			call TriggerAddAction(this.m_shopSelectionTrigger, function thistype.triggerActionSelectShop)
			call AHashTable.global().setHandleInteger(this.m_shopSelectionTrigger, "this", this)
		endmethod
		
		private static method triggerConditionIsCurrentShop takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return GetTriggerUnit() == this.m_shop
		endmethod
		
		private static method triggerActionDeselectShop takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local integer i
			debug call Print("Deselecting shop")
			set this.m_shop = null
			if (this.rucksackIsEnabled()) then
				set i = 0
				loop
					exitwhen (i == thistype.maxRucksackItemsPerPage)
					if (this.rucksackItemData(this.rucksackItemIndex(i)) != 0) then
						call this.showRucksackItem(this.rucksackItemIndex(i))
					endif
					set i = i + 1
				endloop
				call this.showPageItem(true)
				call this.showPageItem(false)
			else
				set i = 0
				loop
					exitwhen (i == thistype.maxEquipmentTypes)
					if (this.equipmentItemData(i) != 0) then
						call this.showEquipmentItem(i)
					else
						call this.showEquipmentPlaceholder(i)
					endif
					set i = i + 1
				endloop
			endif
		endmethod
		
		private method createShopDeselectionTrigger takes nothing returns nothing
			set this.m_shopDeselectionTrigger = CreateTrigger()
			call TriggerRegisterPlayerUnitEvent(this.m_shopDeselectionTrigger, this.character().player(), EVENT_PLAYER_UNIT_DESELECTED, null)
			call TriggerAddCondition(this.m_shopDeselectionTrigger, Condition(function thistype.triggerConditionIsCurrentShop))
			call TriggerAddAction(this.m_shopDeselectionTrigger, function thistype.triggerActionDeselectShop)
			call AHashTable.global().setHandleInteger(this.m_shopDeselectionTrigger, "this", this)
		endmethod

		private static method triggerConditionIsNoPowerup takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return GetTriggerUnit() == this.character().unit() and not IsItemIdPowerup(GetItemTypeId(GetManipulatedItem()))
		endmethod

		private static method triggerActionPickup takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			/*
			 * Tests have shown the the unit has the item without any trigger sleep.
			 * UnitHasItem() returns always true. There is no need of a 0 timer here.
			 */
			call this.addItem(GetManipulatedItem())
		endmethod

		private method createPickupTrigger takes nothing returns nothing
			set this.m_pickupTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_pickupTrigger, EVENT_PLAYER_UNIT_PICKUP_ITEM) // pawn?
			call TriggerAddCondition(this.m_pickupTrigger, Condition(function thistype.triggerConditionIsNoPowerup))
			call TriggerAddAction(this.m_pickupTrigger, function thistype.triggerActionPickup)
			call AHashTable.global().setHandleInteger(this.m_pickupTrigger, "this", this)
		endmethod
		
		private static method timerFunctionShowPageItem takes nothing returns nothing
			local thistype this = thistype(AHashTable.global().handleInteger(GetExpiredTimer(), "this"))
			local boolean left = AHashTable.global().handleBoolean(GetExpiredTimer(), "left")
			call this.showPageItem(left)
			call PauseTimer(GetExpiredTimer())
			call AHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod
		
		private static method timerFunctionRemoveOneCharge takes nothing returns nothing
			local thistype this = thistype(AHashTable.global().handleInteger(GetExpiredTimer(), "this"))
			local integer index = AHashTable.global().handleInteger(GetExpiredTimer(), "index")
			call this.setRucksackItemCharges(index, this.m_rucksackItemData[index].charges() - 1)
			call PauseTimer(GetExpiredTimer())
			call AHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod

		private static method triggerActionDrop takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local integer index = this.itemIndex(GetManipulatedItem())
			local boolean left
			local timer whichTimer
			debug call this.print("Dropping item " + GetItemName(GetManipulatedItem()) + " in trigger " + I2S(GetHandleId(GetTriggeringTrigger())))
			debug if (not UnitHasItem(GetTriggerUnit(), GetManipulatedItem())) then
			debug call this.print("Unit has dropped item successfully.")
			debug else
			debug call this.print("Unit still has item")
			debug endif
			/*
			 * Tests detected that the unit still has the item when it is dropped.
			 * Without any TriggerSleepAction() call it is still in the inventory.
			 *
			 * Removing the dropped item should work without TriggerSleepAction() BUT will cause a recursion, so this trigger should be disabled.
			 *
			 * Adding an item immediately to the unit after removing the item GetManipulatedItem() does NOT work.
			 *
			 * One solution is to start a 0 timer, not TriggerSleepAction() since it has a low resolution and after the 0 timer has expired to reset the page item.
			 */
			
			if (this.rucksackIsEnabled()) then
				// page items
				if (GetItemTypeId(GetManipulatedItem()) == thistype.m_leftArrowItemType or GetItemTypeId(GetManipulatedItem()) == thistype.m_rightArrowItemType) then
					debug call Print("Reset page item")
					set left = GetItemTypeId(GetManipulatedItem()) == thistype.m_leftArrowItemType
					call this.unitRemoveItem(GetTriggerUnit(), GetManipulatedItem())
					if (thistype.m_textDropPageItem != null) then
						call this.character().displayMessage(ACharacter.messageTypeError, thistype.m_textDropPageItem)
					endif
					/*
					 * Wait 0 seconds to add a new item to the inventory.
					 * Adding a new item immediately does not work.
					 */
					set whichTimer = CreateTimer()
					call AHashTable.global().setHandleInteger(whichTimer, "this", this)
					call AHashTable.global().setHandleBoolean(whichTimer, "left", left)
					call TimerStart(whichTimer, 0.0, false, function thistype.timerFunctionShowPageItem)
				elseif (index != -1) then
					// destack and drop
					if (this.m_rucksackItemData[index].charges() > 1) then
						debug call Print("Destacking and dropping item " + GetItemName(GetManipulatedItem()))
						if (GetItemType(GetManipulatedItem()) == ITEM_TYPE_CHARGED) then
							debug call Print("Is charged so 1")
							call SetItemCharges(GetManipulatedItem(), 1)
						else
							debug call Print("Is not charged so 0")
							call SetItemCharges(GetManipulatedItem(), 0)
						endif
						/*
						* When an item is dropped explicitely the owner should be set to the default item owner, so anyone can pick it up.
						*/
						call SetItemPlayer(GetManipulatedItem(), Player(PLAYER_NEUTRAL_PASSIVE), true)
						
						/*
						 * Wait 0 seconds until the item is actually dropped and show the old item with minus one charge.
						 */
						set whichTimer = CreateTimer()
						call AHashTable.global().setHandleInteger(whichTimer, "this", this)
						call AHashTable.global().setHandleInteger(whichTimer, "index", index)
						call TimerStart(whichTimer, 0.0, false, function thistype.timerFunctionRemoveOneCharge)
					// drop
					else
						// do not drop by this function since unit could also give the item to another character
						call this.m_rucksackItemData[index].destroy()
						set this.m_rucksackItemData[index] = 0

						if (GetItemType(GetManipulatedItem()) != ITEM_TYPE_CHARGED) then
							call SetItemCharges(GetManipulatedItem(), 0)
						endif
						/*
						* When an item is dropped explicitely the owner should be set to the default item owner, so anyone can pick it up.
						*/
						call SetItemPlayer(GetManipulatedItem(), Player(PLAYER_NEUTRAL_PASSIVE), true)
					endif
				debug else
					debug call this.print("Item has no index. Doing nothing.")
				endif
			// unequip and drop
			else
				if (index != -1) then
					call this.clearEquipmentType(index)
				debug else
					debug call this.print("Item has no index. Doing nothing.")
				endif
			endif
		endmethod

		// drop, destack and drop, unequip and drop
		private method createDropTrigger takes nothing returns nothing
			set this.m_dropTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_dropTrigger, EVENT_PLAYER_UNIT_DROP_ITEM)
			call TriggerAddCondition(this.m_dropTrigger, Condition(function thistype.triggerConditionIsNoPowerup))
			call TriggerAddAction(this.m_dropTrigger, function thistype.triggerActionDrop)
			call AHashTable.global().setHandleInteger(this.m_dropTrigger, "this", this)
		endmethod

		private static method triggerConditionUse takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return GetTriggerUnit() == this.character().unit() and this.m_rucksackIsEnabled
		endmethod
		
		private static method timerFunctionRefreshCharges takes nothing returns nothing
			local thistype this = thistype(AHashTable.global().handleInteger(GetExpiredTimer(), "this"))
			local integer index = AHashTable.global().handleInteger(GetExpiredTimer(), "index")
			// if an item is used but the character is being stopped since the spell condition doesn't work, the charges become 0! this refresh prevents this error
			call this.refreshRucksackItemCharges(index)
			call PauseTimer(GetExpiredTimer())
			call AHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod

		private static method triggerActionUse takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local integer itemTypeId = GetItemTypeId(GetManipulatedItem())
			local integer index
			local timer whichTimer

			// show next page
			if (itemTypeId == thistype.m_rightArrowItemType) then
				call this.showNextRucksackPage()
			// show previous page
			elseif (itemTypeId == thistype.m_leftArrowItemType) then
				call this.showPreviousRucksackPage()
			// usual item
			else
				set index = thistype.itemIndex(GetManipulatedItem())
				// usable items have to be charged!
				if (GetItemType(GetManipulatedItem()) == ITEM_TYPE_CHARGED) then
					debug call this.print("Used usable item!")
					// if an item is used by decreasing its number of charges (not to 0!) we have to decrease our number, too
					call this.m_rucksackItemData[index].setCharges(this.m_rucksackItemData[index].charges() - 1)
					// use == drop
					/// Drop action is called when last charge is used!!!
				endif
				// if an item is used but the character is being stopped since the spell condition doesn't work, the charges become 0! this refresh prevents this error
				// wait until the item is actually used and the charges change
				set whichTimer = CreateTimer()
				call AHashTable.global().setHandleInteger(whichTimer, "this", this)
				call AHashTable.global().setHandleInteger(whichTimer, "index", index)
				call TimerStart(whichTimer, 0.0, false, function thistype.timerFunctionRefreshCharges)
			endif
		endmethod

		private method createUseTrigger takes nothing returns nothing
			set this.m_useTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_useTrigger, EVENT_PLAYER_UNIT_USE_ITEM)
			call TriggerAddCondition(this.m_useTrigger, Condition(function thistype.triggerConditionUse))
			call TriggerAddAction(this.m_useTrigger, function thistype.triggerActionUse)
			call AHashTable.global().setHandleInteger(this.m_useTrigger, "this", this)
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character)
			// members
			set this.m_rucksackPage = 0
			set this.m_rucksackIsEnabled = false

			/*
			 * Make sure that the character's unit has the rucksack ability. Otherwise it cannot change to the rucksack.
			 */
			if (GetUnitAbilityLevel(this.character().unit(), thistype.m_openRucksackAbilityId) == 0) then
				call UnitAddAbility(this.character().unit(), thistype.m_openRucksackAbilityId)
			endif

			call this.createOpenTrigger()
			call this.createOrderTrigger()
			call this.createPickupOrderTrigger()
			call this.createShopSelectionTrigger()
			call this.createShopDeselectionTrigger()
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
		
		private method destroyPickupOrderTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_pickupOrderTrigger)
			set this.m_pickupOrderTrigger = null
		endmethod
		
		private method destroyShopSelectionTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_shopSelectionTrigger)
			set this.m_shopSelectionTrigger = null
		endmethod
		
		private method destroyShopDeselectionTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_shopDeselectionTrigger)
			set this.m_shopDeselectionTrigger = null
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
					set this.m_equipmentItemData[i] = 0
				endif
				set i = i + 1
			endloop
			set i = 0
			loop
				exitwhen (i == thistype.maxRucksackItems)
				if (this.m_rucksackItemData[i] != 0) then
					call this.m_rucksackItemData[i].destroy()
					set this.m_rucksackItemData[i] = 0
				endif
				set i = i + 1
			endloop
			call UnitRemoveAbility(this.character().unit(), thistype.m_openRucksackAbilityId)

			call this.destroyOpenTrigger()
			call this.destroyOrderTrigger()
			call this.destroyPickupOrderTrigger()
			call this.destroyShopSelectionTrigger()
			call this.destroyShopDeselectionTrigger()
			call this.destroyPickupTrigger()
			call this.destroyDropTrigger()
			call this.destroyUseTrigger()
		endmethod

		/**
		 * \param leftArrowItemType This value should by the item type id of an item which is usable but not chargable. It will be used for a button item to change to the left page in rucksack.
		 * \param rightArrowItemType The item type ID for the item which must be usable and is used as item to change to the right page in the rucksack.
		 * \param openRucksackAbilityId This ability is added to the character's unit automatically when inventory is created. When it is casted rucksack/equipment is opened.
		 * \param allowPickingUpFromOthers If this value is true characters are allowed to pick up items which are owned by other playing users (human controlled).
		 */
		public static method init takes integer leftArrowItemType, integer rightArrowItemType, integer openRucksackAbilityId, boolean allowPickingUpFromOthers, string textUnableToEquipItem, string textEquipItem, string textUnableToAddRucksackItem, string textAddItemToRucksack, string textUnableToMoveRucksackItem, string textDropPageItem, string textMovePageItem, string textOwnedByOther, string textPreviousPageIsFull, string textNextPageIsFull returns nothing
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
			
			set thistype.m_textPreviousPageIsFull = textPreviousPageIsFull
			set thistype.m_textNextPageIsFull = textNextPageIsFull
		endmethod
		
		private static method onInit takes nothing returns nothing
			local integer i
			set thistype.m_pickupTimer = CreateTimer()
			set thistype.m_pickupTimerHasStarted = false
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set thistype.m_targetItem[i] = null
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary