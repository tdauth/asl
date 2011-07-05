library ATextMacroCoreContainersRange

	//! textmacro A_RANGE takes PREFIX, IDENTIFIER, SIZE, ITERATORTYPE
		struct $IDENTIFIER$[$SIZE$] extends ASimpleContainerInterface
			private $ITERATORTYPE$ m_begin
			private $ITERATORTYPE$ m_end

			public method begin takes nothing returns $ITERATORTYPE$
				return this.m_begin
			endmethod

			public method end takes nothing returns $ITERATORTYPE$
				return this.m_end
			endmethod

			public method isValid takes nothing returns boolean
				return this.begin() != 0 and this.begin().isValid() and this.end() != 0 and this.end().isValid()
			endmethod
			
			public method distance takes nothing returns integer
				return this.begin().distanceTo(this.end())
			endmethod

			public static method create takes $ITERATORTYPE$ begin, $ITERATORTYPE$ end returns thistype
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
	//! endtextmacro

	//! runtextmacro A_RANGE("", "ARange", "50000", "AIteratorInterface")
	//! runtextmacro A_RANGE("", "ASimpleRange", "50000", "ASimpleIteratorInterface")

endlibrary