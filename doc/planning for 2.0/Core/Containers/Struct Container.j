library AStructCoreContainersContainer requires AStructCoreContainersReverseIterator, AStructCoreContainersSimpleContainer

	struct AContainer extends ASimpleContainer

		public method reverseBegin takes nothing returns AReverseIterator
			return AReverseIterator.create(this.getBack())
		endmethod

		public method reverseEnd takes nothing returns AReverseIterator
			return AReverseIterator.create(this.getFront())
		endmethod

		/**
		* Erases element at position \p position and increases iterator.
		* \note Note that the iterator can become invalid by this operation.
		*/
		public method eraseIncrease takes AIteratorInterface position returns nothing
			local ANode node = position.node()
			call node.previous().setNext(node.next())
			call node.next().setPrevious(node.previous())
			call position.setNode(node.next())
			call node.destroy()
		endmethod

		/**
		* Erases element at position \p position and decreases iterator.
		* \note Note that the iterator can become invalid by this operation.
		*/
		public method eraseDecrease takes AIteratorInterface position returns nothing
			local ANode node = position.node()
			call node.previous().setNext(node.next())
			call node.next().setPrevious(node.previous())
			call position.setNode(node.previous())
			call node.destroy()
		endmethod

		/**
		* Inserts all elements from range \p range before position \p position.
		*/
		public method splice takes AIteratorInterface position, ARange range returns nothing
		endmethod

		/**
		* Inserts all elements from container \p other before position \p position.
		*/
		public method spliceOther takes AIteratorInterface position, thistype other returns nothing
		endmethod

		/**
		* Splices all elements from range \p range before first element of container.
		*/
		public method spliceFront takes ARange range returns nothing
		endmethod

		/**
		* Splices all elements from container \p other before first element of container.
		*/
		public method spliceOtherFront takes thistype other returns nothing
		endmethod

		/**
		* Splices all elements from range \p range after last element of container.
		*/
		public method spliceBack takes ARange range returns nothing
		endmethod

		/**
		* Splices all elements from container \p other after last element of container.
		*/
		public method spliceOtherBack takes thistype other returns nothing
		endmethod

		/**
		* \copydoc ASimpleContainer#range
		*/
		public method reverseRange takes nothing returns ARange
			return ARange.create(this.reverseBegin(), this.reverseEnd())
		endmethod
	endstruct

endlibrary