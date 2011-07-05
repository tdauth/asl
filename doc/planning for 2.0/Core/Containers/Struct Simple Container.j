library AStructCoreContainersSimpleContainer requires AInterfaceCoreContainersSimpleContainerInterface

	struct ASimpleContainer[A_CONTAINER_SIZE] extends ASimpleContainerInterface
		private ASimpleNode m_front /// \todo Should protected!
		private ASimpleNode m_back /// \todo Should protected!

		/// \note Protected.
		public stub method setFront takes ASimpleNode front returns nothing
			set this.m_front = front
		endmethod

		/// \note Protected.
		public stub method getFront takes nothing returns ASimpleNode
			return this.m_front
		endmethod

		/// \note Protected.
		public stub method setBack takes ASimpleNode back returns nothing
			set this.m_back = back
		endmethod

		/// \note Protected.
		public stub method getBack takes nothing returns ASimpleNode
			return this.m_back
		endmethod

		public stub method begin takes nothing returns ASimpleIterator
			return ASimpleIterator.create(this.m_front)
		endmethod

		public stub method end takes nothing returns ASimpleIterator
			return ASimpleIterator.create(this.m_back)
		endmethod

		public stub method empty takes nothing returns boolean
			return this.m_front == 0
		endmethod
		
		public stub method reverse takes nothing returns nothing
		endmethod
		
		public stub method clear takes nothing returns nothing
		endmethod
		
		public stub method unique takes nothing returns nothing
		endmethod
		
		/**
		* Erases element at position \p position and increases iterator.
		* \note Note that the iterator can become invalid by this operation.
		*/
		public stub method eraseIncrease takes ASimpleIteratorInterface position returns nothing
		

		/**
		* \return Returns a newly created range instance which covers the whole range of the container.
		* You will have to clear the begin and end iterators yourself!
		* \sa ARange#destroyAll
		*/
		public stub method range takes nothing returns ASimpleRange
			return ASimpleRange.create(this.begin(), this.end())
		endmethod

		public stub method count takes nothing returns integer
			local ASimpleIterator iterator = this.begin()
			local integer result = 0
			loop
				exitwhen (not iterator.isValid())
				call iterator.next()
			endloop
			call iterator.destroy()
			return result
		endmethod

		/**
		* Swaps the containers' contents.
		* \todo If you use the simple swap method, existing iterators won't be affected!!!
		*/
		public method swap takes thistype other returns nothing
			local ASimpleNode tmp = other.front()
			call other.setFront(this.front())
			call this.setFront(tmp)
			set tmp = other.back()
			call other.setBack(this.back())
			call this.setBack(tmp)
		endmethod

		/**
		* Removes all elements contained by other container \p other.
		*/
		public method removeOther takes thistype other returns nothing
		endmethod

		/**
		* Removes all elements contained by range \p range.
		*/
		public method removeRange takes ASimpleRange range returns nothing
		endmethod
	endstruct

endlibrary