library AStructCoreContainersNode requires AStructCoreContainersSimpleNode

	struct ANode extends ASimpleNode
		private thistype m_previous

		public stub method setPrevious takes thistype previous returns nothing
			set this.m_previous = previous
		endmethod

		public stub method previous takes nothing returns nothing
			return this.m_previous
		endmethod

		public stub method hasPrevious takes nothing returns boolean
			return this.previous() != 0
		endmethod
	endstruct

endlibrary