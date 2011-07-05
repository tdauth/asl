library AStructCoreContainersSimpleRange requires AStructCoreContainersSimpleIterator

	/**
	 * Provides access to a uni-directional range.
	 * \sa ARange
	 */
	struct ASimpleRange
		private ASimpleIterator m_begin
		private ASimpleIterator m_end

		public method begin takes nothing returns ASimpleIterator
			return this.m_begin
		endmethod

		public method end takes nothing returns ASimpleIterator
			return this.m_end
		endmethod

		public method isValid takes nothing returns boolean
			return this.begin() != 0 and this.begin().isValid() and this.end() != 0 and this.end().isValid()
		endmethod

		public static method create takes ASimpleIterator begin, ASimpleIterator end returns thistype
			local thistype this = thistype.allocate()
			set this.m_begin = begin
			set this.m_end = end
			return this
		endmethod

		/**
		 * Usually iterators are not being destroyed when range is.
		 * This method destroys them, too!
		 */
		public method destroyAll takes nothing returns nothing
			if (this.begin() != 0) then
				call this.begin().destroy()
			endif
			if (this.end() != 0) then
				call this.end().destroy()
			endif
			call this.destroy()
		endmethod
	endstruct

endlibrary