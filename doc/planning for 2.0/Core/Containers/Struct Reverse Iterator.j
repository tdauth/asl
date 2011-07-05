library AStructCoreContainersReverseIterator requires AStructCoreContainersIterator

	struct AReverseIterator extends AIterator

		public stub method next takes nothing returns nothing
			if (not this.isValid()) then
				return
			endif
			set this.m_node = this.node().previous()
		endmethod

		public stub method previous takes nothing returns nothing
			if (not this.isValid()) then
				return
			endif
			set this.m_node = this.node().next()
		endmethod

		public stub method hasNext takes nothing returns boolean
			return this.isValid() and this.node().previous() != 0
		endmethod

		public stub method hasPrevious takes nothing returns boolean
			return this.isValid() and this.node().next() != 0
		endmethod
	endstruct

endlibrary