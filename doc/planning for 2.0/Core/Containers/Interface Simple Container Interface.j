library AInterfaceCoreContainersSimpleContainerInterface

	/**
	 * Interface for uni-directional iterator types.
	 */
	interface ASimpleContainerInterface
		public method begin takes nothing returns ASimpleIteratorInterface
		public method end takes nothing returns ASimpleIteratorInterface

		public method empty takes nothing returns boolean
		public method reverse takes nothing returns nothing
		public method clear takes nothing returns nothing
		public method unique takes nothing returns nothing

		/**
		 * Erases element at position \p position and increases iterator.
		 * \note Note that the iterator can become invalid by this operation.
		 */
		public method eraseIncrease takes ASimpleIteratorInterface position returns nothing
		/**
		 * Returns a newly created range instance which covers the whole range of the container.
		 * You will have to clear the begin and end iterators yourself!
		 * \sa ARange#destroyAll
		 */
		public method range takes nothing returns ASimpleRange
		/**
		 * Swaps the containers' contents.
		 */
		public method swap takes thistype other returns nothing
		/**
		 * Removes all elements contained by other container \p other.
		 */
		public method removeOther takes thistype other returns nothing
		/**
		 * Removes all elements contained by range \p range.
		 */
		public method removeRange takes ASimpleRange range returns nothing
	endinterface

endlibrary