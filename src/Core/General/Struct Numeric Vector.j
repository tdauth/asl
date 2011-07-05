library AStructCoreGeneralNumericVector requires AStructCoreGeneralVector

	/**
	 * Text macro which can generate a numeric container based on a vector structure (usually generated with \ref A_VECTOR).
	 * Provides various numeric functions which help users to calculate values based on their container elements.
	 * \todo At the moment many functions don't work because of the corrupted JassHelper implementation.
	 */
	//! textmacro A_NUMERIC_VECTOR takes STRUCTPREFIX, NAME, PARENTNAME, ELEMENTTYPE

		$STRUCTPREFIX$ struct $NAME$ extends $PARENTNAME$
			public static constant string parentName = "$PARENTNAME$"
			
			public method max takes nothing returns $ELEMENTTYPE$
				local integer i = 0
				local $ELEMENTTYPE$ result = 0
				loop
					exitwhen (i == this.size())
					if (this[i] > result) then
						set result = this[i]
					endif
					set i = i + 1
				endloop
				return result
			endmethod

			public method min takes nothing returns $ELEMENTTYPE$
				local integer i
				local $ELEMENTTYPE$ result
				if (this.empty()) then
					return 0
				endif
				set result = this[0]
				set i = 1
				loop
					exitwhen (i == this.size())
					if (this[i] < result) then
						set result = this[i]
					endif
					set i = i + 1
				endloop
				return result
			endmethod

			public method sum takes nothing returns $ELEMENTTYPE$
				local integer i = 0
				local $ELEMENTTYPE$ result = 0
				loop
					exitwhen (i == this.size())
					set result = result + this[i]
					set i = i + 1
				endloop
				return result
			endmethod

			/// \todo FIXME JassHelper bug.
			public method add takes $ELEMENTTYPE$ value returns nothing
				local integer i = 0
				debug call PrintMethodError("$NAME$", this, "add", "JassHelper bug!")
				loop
					exitwhen (i == this.size())
					//set this[i] = this[i] + value
					set i = i + 1
				endloop
			endmethod

			/// \todo FIXME JassHelper bug.
			public method substract takes $ELEMENTTYPE$ value returns nothing
				local integer i = 0
				debug call PrintMethodError("$NAME$", this, "substract", "JassHelper bug!")
				loop
					exitwhen (i == this.size())
					//set this[i] = this[i] - value
					set i = i + 1
				endloop
			endmethod

			/// \todo FIXME JassHelper bug.
			public method multiply takes $ELEMENTTYPE$ value returns nothing
				local integer i = 0
				debug call PrintMethodError("$NAME$", this, "multiply", "JassHelper bug!")
				loop
					exitwhen (i == this.size())
					//set this[i] = this[i] * value
					set i = i + 1
				endloop
			endmethod

			/// \todo FIXME JassHelper bug.
			public method divide takes $ELEMENTTYPE$ value returns nothing
				local integer i = 0
				debug call PrintMethodError("$NAME$", this, "divide", "JassHelper bug!")
				loop
					exitwhen (i == this.size())
					//set this[i] = this[i] / value
					set i = i + 1
				endloop
			endmethod

			public method greaterThan takes thistype other returns boolean
				return this.sum() > other.sum()
			endmethod

			public method lessThan takes thistype other returns boolean
				return this.sum() < other.sum()
			endmethod

			public method equal takes thistype other returns boolean
				return this.sum() == other.sum()
			endmethod

			public method unequal takes thistype other returns boolean
				return this.sum() != other.sum()
			endmethod
		endstruct

	//! endtextmacro

	//! runtextmacro A_NUMERIC_VECTOR("", "AIntegerNumericVector", "AIntegerVector", "integer")
	//! runtextmacro A_NUMERIC_VECTOR("", "ARealNumericVector", "ARealVector", "real")

endlibrary