library AStructCoreContainersSimpleIterator requires AStructCoreContainersSimpleNode

	struct ASimpleIterator[A_ITERATOR_SIZE]
		private ASimpleNode m_node

		/**
		* \note For internal usage only.
		*/
		public method node takes nothing returns ASimpleNode
			return this.m_node
		endmethod

		public stub method isValid takes nothing returns boolean
			return this.m_node != 0
		endmethod

		public stub method next takes nothing returns nothing
			if (not this.isValid()) then
				return
			endif
			set this.m_node = this.node().next()
		endmethod

		public stub method hasNext takes nothing returns boolean
			return this.isValid() and this.node().next() != 0
		endmethod
		
		public method distanceTo takes thistype other returns integer
			local integer result = 0
			local ASimpleNode node
			
			if (not this.isValid()) then
				return -1
			endif
			
			loop
				set node = node.next()
				
				if (node == 0) then
					return -1
				endif
				
				set result = result + 1
				
				exitwhen (node = other.node())
			endloop
			
			return result
		endmethod

		public static method create takes ASimpleNode node returns thistype
			local thistype this = thistype.allocate()
			set this.m_node = node
			return this
		endmethod

		public static method maxSize takes nothing returns integer
			return A_ITERATOR_SIZE
		endmethod
		
		public static method distance takes thistype first, thistype second returns integer
			return first.distanceTo(second)
		endmethod
	endstruct

endlibrary