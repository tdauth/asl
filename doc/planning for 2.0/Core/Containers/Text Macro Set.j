library ATextMacroCoreContainersSet

	/**
	 * A standard container composed of unique keys (containing at most one of each key value) in which the elements' keys are the elements themselves.
	 * Meets the requirements of a container, and ordered associative container.
	 */
	//! textmacro A_SET takes PREFIX, IDENTIFIER, BASE, VALUETYPE, NULLVALUE, COMPARER
		$PREFIX$ struct $IDENTIFIER$ extends $BASE$
		
			/// \todo Insert by comparing with other values using $COMPARER$.
			public stub method insert takes $VALUETYPE$ value returns nothing
			endmethod

		endstruct
	//! endtextmacro

	//! runtextmacro A_SET("", "AIntegerSet", "AIntegerContainer", "integer", "0", "IntegerLessThan")
endlibrary