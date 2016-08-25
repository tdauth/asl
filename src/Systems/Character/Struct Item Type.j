library AStructSystemsCharacterItemType requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, AStructCoreGeneralVector, ALibraryCoreMathsConversion, AStructSystemsCharacterClass, AStructSystemsCharacterCharacter

	/**
	 * \brief Represents an item type, not an item object!
	 * Custom item types have to exist during the whole game.
	 * They provide more information than is reachable by default JASS item natives.
	 * You can check some usual item type requirements such as character strength, level or class.
	 * Besides you can specify all item type abilities to get real inventory support since
	 * permanent abilities have to be added to character's unit when rucksack/equipment is closed.
	 * Non-equipment item types usually do not have to be created explicity. If an item type
	 * has no custom it is treated like a usual rucksack item.
	 * \note Requirement is only checked by \ref AInventory when item is equipped!
	 * \todo Add struct AEquipmentType as more abstract type.
	 */
	struct AItemType
		// static constant members
		/// Use this as equipment type if it's a rucksack item.
		public static constant integer equipmentTypeNone = -1
		public static constant integer equipmentTypeHeaddress = 0
		public static constant integer equipmentTypeArmour = 1
		public static constant integer equipmentTypePrimaryWeapon = 2
		public static constant integer equipmentTypeSecondaryWeapon = 3
		public static constant integer equipmentTypeAmulet = 4
		//public static constant integer maxEquipmentTypes = 5
		// static construction members
		private static string textLevel
		private static string textStrength
		private static string textAgility
		private static string textIntelligence
		private static string textClass
		// construction members
		private integer m_itemType
		private integer m_equipmentType
		private integer m_requiredLevel
		private integer m_requiredStrength
		private integer m_requiredAgility
		private integer m_requiredIntelligence
		private AClass m_requiredClass
		// members
		private AIntegerVector m_abilities
		private ABooleanVector m_permanent

		//! runtextmacro optional A_STRUCT_DEBUG("\"AItemType\"")

		// construction members

		public method itemType takes nothing returns integer
			return this.m_itemType
		endmethod

		public method equipmentType takes nothing returns integer
			return this.m_equipmentType
		endmethod

		public method requiredLevel takes nothing returns integer
			return this.m_requiredLevel
		endmethod

		public method requiredStrength takes nothing returns integer
			return this.m_requiredStrength
		endmethod

		public method requiredAgility takes nothing returns integer
			return this.m_requiredAgility
		endmethod

		public method requiredIntelligence takes nothing returns integer
			return this.m_requiredIntelligence
		endmethod

		public method requiredClass takes nothing returns AClass
			return this.m_requiredClass
		endmethod

		// methods

		public method addAbility takes integer abilityId, boolean permanent returns integer
			call this.m_abilities.pushBack(abilityId)
			call this.m_permanent.pushBack(permanent)
			return this.m_abilities.backIndex()
		endmethod

		/**
		 * This method can be overwritten to check requirements manually.
		 * It is used by AInventory for instance.
		 */
		public stub method checkRequirement takes ACharacter character returns boolean
			if (GetHeroLevel(character.unit()) < this.m_requiredLevel) then
				call character.displayMessage(ACharacter.messageTypeError, thistype.textLevel)
				return false
			elseif (GetHeroStr(character.unit(), true) < this.m_requiredStrength) then
				call character.displayMessage(ACharacter.messageTypeError, thistype.textStrength)
				return false
			elseif (GetHeroAgi(character.unit(), true) < this.m_requiredAgility) then
				call character.displayMessage(ACharacter.messageTypeError, thistype.textAgility)
				return false
			elseif (GetHeroInt(character.unit(), true) < this.m_requiredIntelligence) then
				call character.displayMessage(ACharacter.messageTypeError, thistype.textIntelligence)
				return false
			elseif (this.m_requiredClass != 0 and character.class() != this.m_requiredClass) then
				call character.displayMessage(ACharacter.messageTypeError, thistype.textClass)
				return false
			endif
			return true
		endmethod
		
		/**
		 * This method is called automatically by \ref AInventory whenever an item is being equipped.
		 * You may overwrite this method to add additionally behaviour.
		 * This method is called by .evaluate() to allow TriggerSleepAction calls.
		 */
		public stub method onEquipItem takes unit whichUnit, integer slot returns nothing
		endmethod
		
		/**
		 * This method is called automatically by \ref AInventory whenever an item is being unequipped.
		 * You may overwrite this method to add additionally behaviour.
		 * This method is called by .evaluate() to allow TriggerSleepAction calls.
		 */
		public stub method onUnequipItem takes unit whichUnit, integer slot returns nothing
		endmethod
		
		/**
		 * This method is called automatically by .evaluate() whenever the permanent abilities are being added to a unit.
		 */
		public stub method onAddPermanentAbilities takes unit who returns nothing
		endmethod

		/**
		 * Adds the permanent abilities of the item type to unit \p who.
		 * \note The abilities are added permanently. On unit transformations they are kept. One must remove them explicitely.
		 */
		public method addPermanentAbilities takes unit who returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_abilities.size())
				if (this.m_permanent[i]) then
					debug call this.print("Adding permanent ability " + GetObjectName(this.m_abilities[i]) + " to unit " + GetUnitName(who))
					call UnitAddAbility(who, this.m_abilities[i])
					// keep on unit transformation
					call UnitMakeAbilityPermanent(who, true, this.m_abilities[i])
				endif
				set i = i + 1
			endloop
			call this.onAddPermanentAbilities.evaluate(who)
		endmethod
		
		/**
		 * This method is called automatically by .evaluate() whenever the permanent abilities are removed from to a unit.
		 */
		public stub method onRemovePermanentAbilities takes unit who returns nothing
		endmethod

		public method removePermanentAbilities takes unit who returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_abilities.size())
				if (this.m_permanent[i]) then
					call UnitRemoveAbility(who, this.m_abilities[i])
				endif
				set i = i + 1
			endloop
			call this.onRemovePermanentAbilities.evaluate(who)
		endmethod

		public method addUsableAbilities takes unit who returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_abilities.size())
				if (not this.m_permanent[i]) then
					call UnitAddAbility(who, this.m_abilities[i])
				endif
				set i = i + 1
			endloop
		endmethod

		public method removeUsableAbilities takes unit who returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_abilities.size())
				if (not this.m_permanent[i]) then
					call UnitRemoveAbility(who, this.m_abilities[i])
				endif
				set i = i + 1
			endloop
		endmethod

		/**
		 * Each custom item type is associated with an item type id when it is created.
		 * Each item type id should only have one custom item type!
		 * \param equipmentType If this value is -1 (\ref AItemType.equipmentTypeNone) it will always be added to rucksack.
		 * \param requiredClass If this value is 0 no specific class is required.
		 */
		public static method create takes integer itemType, integer equipmentType, integer requiredLevel, integer requiredStrength, integer requiredAgility, integer requiredIntelligence, AClass requiredClass returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_itemType = itemType
			set this.m_equipmentType = equipmentType
			set this.m_requiredLevel = requiredLevel
			set this.m_requiredStrength = requiredStrength
			set this.m_requiredAgility = requiredAgility
			set this.m_requiredIntelligence = requiredIntelligence
			set this.m_requiredClass = requiredClass
			// members
			set this.m_abilities = AIntegerVector.create()
			set this.m_permanent = ABooleanVector.create()

			debug if (AHashTable.global().hasInteger(A_HASHTABLE_KEY_ITEMTYPES, itemType)) then
				debug call this.print("Item type " + I2S(itemType) + " already has a custom item type.")
			debug endif
			call AHashTable.global().setInteger(A_HASHTABLE_KEY_ITEMTYPES, itemType, this)
			return this
		endmethod

		public static method createSimple takes integer itemType, integer equipmentType returns thistype
			return thistype.create(itemType, equipmentType, 0, 0, 0, 0, 0)
		endmethod

		/// Custom item types should never be destroyed since they're heavily used by systems like AInventory at game runtime (equipment).
		private method onDestroy takes nothing returns nothing
			// members
			call this.m_abilities.destroy()
			call this.m_permanent.destroy()

			call AHashTable.global().removeInteger(A_HASHTABLE_KEY_ITEMTYPES, this.m_itemType)
		endmethod

		public static method init takes string textLevel, string textStrength, string textAgility, string textIntelligence, string textClass returns nothing
			// static construction members
			set thistype.textLevel = textLevel
			set thistype.textStrength = textStrength
			set thistype.textAgility = textAgility
			set thistype.textIntelligence = textIntelligence
			set thistype.textClass = textClass
		endmethod

		public static method itemTypeIdHasItemType takes integer itemTypeId returns boolean
			return AHashTable.global().hasInteger(A_HASHTABLE_KEY_ITEMTYPES, itemTypeId)
		endmethod

		public static method itemTypeOfItemTypeId takes integer itemTypeId returns thistype
			return AHashTable.global().integer(A_HASHTABLE_KEY_ITEMTYPES, itemTypeId)
		endmethod

		public static method itemTypeOfItem takes item whichItem returns thistype
			return thistype.itemTypeOfItemTypeId(GetItemTypeId(whichItem))
		endmethod
	endstruct

endlibrary