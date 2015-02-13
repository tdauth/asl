library AStructCoreGeneralHashTable

	/**
	 * Provides access to a single hashtable instance.
	 * ASL internally uses \ref thistype.global() instance. Do not use this method to prevent conflicts with the ASL!
	 * There are various methods which allow you to save values of different types or attach them on handles since handle objects do have an unique key (use \ref GetHandleId()).
	 * \note Note that string hash values are usually used as keys since this structure had used native type \ref gamecache before which uses string mission keys and labels.
	 * \note For default \ref hashtable like access you can use methods with postfix "ByInteger".
	 * \author Tamino Dauth
	 * \sa wrappers
	 * \sa containers
	 */
	struct AHashTable
		// static members
		private static thistype m_global
		// members
		private hashtable m_hashTable

		//! textmacro AHashTableOperationMacro takes TYPE, TYPENAME, METHODTYPENAME, SAVELOADSUFFIX, HAVEREMOVESUFFIX
			public method set$TYPENAME$ByInteger takes integer parentKey, integer childKey, $TYPE$ value returns nothing
				call Save$TYPENAME$$SAVELOADSUFFIX$(this.m_hashTable, parentKey, childKey, value)
			endmethod

			public method set$TYPENAME$ takes string key, string label, $TYPE$ value returns nothing
				call this. set$TYPENAME$ByInteger(StringHash(key), StringHash(label), value)
			endmethod

			public method $METHODTYPENAME$ByInteger takes integer parentKey, integer childKey returns $TYPE$
				return Load$TYPENAME$$SAVELOADSUFFIX$(this.m_hashTable, parentKey, childKey)
			endmethod

			public method $METHODTYPENAME$ takes string key, string label returns $TYPE$
				return this.$METHODTYPENAME$ByInteger(StringHash(key), StringHash(label))
			endmethod

			public method has$TYPENAME$ByInteger takes integer parentKey, integer childKey returns boolean
				return HaveSaved$HAVEREMOVESUFFIX$(this.m_hashTable, parentKey, childKey)
			endmethod

			public method has$TYPENAME$ takes string key, string label returns boolean
				return this.has$TYPENAME$ByInteger(StringHash(key), StringHash(label))
			endmethod

			public method remove$TYPENAME$ByInteger takes integer parentKey, integer childKey returns nothing
				call RemoveSaved$HAVEREMOVESUFFIX$(this.m_hashTable, parentKey, childKey)
			endmethod

			public method remove$TYPENAME$ takes string key, string label returns nothing
				call this.remove$TYPENAME$ByInteger(StringHash(key), StringHash(label))
			endmethod

			public method setHandle$TYPENAME$ByInteger takes handle whichHandle, integer childKey, $TYPE$ value returns nothing
				call Save$TYPENAME$$SAVELOADSUFFIX$(this.m_hashTable, GetHandleId(whichHandle), childKey, value)
			endmethod

			public method setHandle$TYPENAME$ takes handle whichHandle, string label, $TYPE$ value returns nothing
				call this.setHandle$TYPENAME$ByInteger(whichHandle, StringHash(label), value)
			endmethod

			public method handle$TYPENAME$ByInteger takes handle whichHandle, integer childKey returns $TYPE$
				return Load$TYPENAME$$SAVELOADSUFFIX$(this.m_hashTable, GetHandleId(whichHandle), childKey)
			endmethod

			public method handle$TYPENAME$ takes handle whichHandle, string label returns $TYPE$
				return this.handle$TYPENAME$ByInteger(whichHandle, StringHash(label))
			endmethod

			public method hasHandle$TYPENAME$ByInteger takes handle whichHandle, integer childKey returns boolean
				return HaveSaved$HAVEREMOVESUFFIX$(this.m_hashTable, GetHandleId(whichHandle), childKey)
			endmethod

			public method hasHandle$TYPENAME$ takes handle whichHandle, string label returns boolean
				return this. hasHandle$TYPENAME$ByInteger(whichHandle, StringHash(label))
			endmethod

			public method removeHandle$TYPENAME$ByInteger takes handle whichHandle, integer childKey returns nothing
				call RemoveSaved$HAVEREMOVESUFFIX$(this.m_hashTable, GetHandleId(whichHandle), childKey)
			endmethod

			public method removeHandle$TYPENAME$ takes handle whichHandle, string label returns nothing
				call this.removeHandle$TYPENAME$ByInteger(whichHandle, StringHash(label))
			endmethod
		//! endtextmacro

		//! runtextmacro AHashTableOperationMacro("integer", "Integer", "integer", "", "Integer")
		//! runtextmacro AHashTableOperationMacro("boolean", "Boolean", "boolean", "", "Boolean")
		//! runtextmacro AHashTableOperationMacro("real", "Real", "real", "", "Real")
		//! runtextmacro AHashTableOperationMacro("string", "Str", "string", "", "String")

		//! runtextmacro AHashTableOperationMacro("player", "Player", "player", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("widget", "Widget", "widget", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("destructable", "Destructable", "destructable", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("item", "Item", "item", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("unit", "Unit", "unit", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("ability", "Ability", "ability", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("timer", "Timer", "timer", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("trigger", "Trigger", "trigger", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("triggercondition", "TriggerCondition", "triggerCondition", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("triggeraction", "TriggerAction", "triggerAction", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("event", "TriggerEvent", "triggerEvent", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("force", "Force", "force", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("group", "Group", "group", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("location", "Location", "location", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("rect", "Rect", "rect", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("boolexpr", "BooleanExpr", "boolexpr", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("sound", "Sound", "sound", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("effect", "Effect", "effect", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("unitpool", "UnitPool", "unitPool", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("itempool", "ItemPool", "itemPool", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("quest", "Quest", "quest", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("questitem", "QuestItem", "questitem", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("defeatcondition", "DefeatCondition", "defeatCondition", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("timerdialog", "TimerDialog", "timerDialog", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("leaderboard", "Leaderboard", "leaderboard", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("multiboard", "Multiboard", "multiboard", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("multiboarditem", "MultiboardItem", "multiboardItem", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("trackable", "Trackable", "trackable", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("dialog", "Dialog", "dialog", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("button", "Button", "button", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("texttag", "TextTag", "textTag", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("lightning", "Lightning", "lightning", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("image", "Image", "image", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("ubersplat", "Ubersplat", "ubersplat", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("region", "Region", "region", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("fogstate", "FogState", "fogState", "Handle", "Handle")
		//! runtextmacro AHashTableOperationMacro("fogmodifier", "FogModifier", "fogModifier", "Handle", "Handle")
		///! runtextmacro AHashTableOperationMacro("agent", "Agent", "agent", "Handle", "Handle") /// \todo Missing native
		//! runtextmacro AHashTableOperationMacro("hashtable", "Hashtable", "hashtable", "Handle", "Handle")

		/// Flushes all data of the hashtable.
		public method flush takes nothing returns nothing
			call FlushParentHashtable(this.m_hashTable)
		endmethod

		public method flushKeyByInteger takes integer key returns nothing
			call FlushChildHashtable(this.m_hashTable, key)
		endmethod

		/// Flushes all data of a hashtable key.
		public method flushKey takes string key returns nothing
			call this.flushKeyByInteger(StringHash(key))
		endmethod

		public method flushHandle takes handle whichHandle returns nothing
			call FlushChildHashtable(this.m_hashTable, GetHandleId(whichHandle))
		endmethod

		//! textmacro AHashTableDestructionMacro takes TYPE, TYPENAME, DESTRUCTIONNAME
			public method destroy$TYPENAME$ takes $TYPE$ $TYPENAME$ returns nothing
				call this.flushHandle($TYPENAME$)
				call $DESTRUCTIONNAME$$TYPENAME$($TYPENAME$)
			endmethod
		//! endtextmacro

		//! runtextmacro AHashTableDestructionMacro("trigger", "Trigger", "Destroy")
		//! runtextmacro AHashTableDestructionMacro("timer", "Timer", "Destroy")
		//! runtextmacro AHashTableDestructionMacro("unit", "Unit", "Remove")
		//! runtextmacro AHashTableDestructionMacro("item", "Item", "Remove")
		//! runtextmacro AHashTableDestructionMacro("destructable", "Destructable", "Remove")

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			// members
			set this.m_hashTable = InitHashtable()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// members
			call this.flush()
			set this.m_hashTable = null
		endmethod

		private static method onInit takes nothing returns nothing
			// static members
			set AHashTable.m_global = 0
		endmethod

		/**
		 * Global hash table is used by the ASL itself.
		 * \warning Please do not use this method to prevent conflicts with the ASL.
		 * The global hash table is used in all ASL systems to store data of handles for example.
		 * For example whenever a system uses triggers which are created for specific instance of an object
		 * the reference "this" can be stored using the trigger's handle ID as hash key.
		 * When the trigger is run it loads the reference from the global hash table again using handle ID of the triggering trigger.
		 */
		public static method global takes nothing returns thistype
			if (thistype.m_global == 0) then
				set thistype.m_global = thistype.create()
			endif
			return thistype.m_global
		endmethod
	endstruct

endlibrary