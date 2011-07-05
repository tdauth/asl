library AStructCoreInterfacePlayerSelection requires optional ALibraryCoreDebugMisc, AStructCoreGeneralGroup

	struct APlayerSelection
		// construction members
		private player m_player
		// members
		private AGroup m_group

		//! runtextmacro optional A_STRUCT_DEBUG("\"APlayerSelection\"")

		// construction members

		public method player takes nothing returns player
			return this.m_player
		endmethod

		// members

		public method group takes nothing returns AGroup
			return this.m_group
		endmethod

		// methods

		public method store takes nothing returns nothing
			call this.m_group.units().clear()
			call SyncSelections()
			call this.m_group.addUnitsSelected(this.m_player, null)
		endmethod

		public method restore takes nothing returns nothing
			call this.m_group.selectOnlyForPlayer(this.m_player) /// \todo Desync for player?
		endmethod

		public static method create takes player user returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_player = user
			// members
			set this.m_group = AGroup.create()
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// construction members
			set this.m_player = null
			// members
			call this.m_group.destroy()
		endmethod
	endstruct

endlibrary