library AStructCoreContainersSimpleNode

	struct ASimpleNode[A_NODE_SIZE]
		private thistype m_next

		public stub method setNext takes thistype next returns nothing
			set this.m_next = next
		endmethod

		public stub method next takes nothing returns thistype
			return this.m_next
		endmethod

		public stub method hasNext takes nothing returns boolean
			return this.next() != 0
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			set this.m_next = 0
			return this
		endmethod

		public static method maxSize takes nothing returns integer
			return A_NODE_SIZE
		endmethod
	endstruct

endlibrary