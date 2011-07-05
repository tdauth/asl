library AStructCoreContainersIterator requires AStructCoreContainersSimpleIterator

	struct AIterator extends ASimpleIterator

		public stub method previous takes nothing returns nothing
			if (not this.isValid()) then
				return
			endif
			set this.m_node = this.node().previous()
		endmethod

		public stub method hasPrevious takes nothing returns boolean
			return this.isValid() and this.node().previous() != 0
		endmethod
	endstruct

endlibrary