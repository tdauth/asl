library bla

	//! textmacro A_CONTAINER_FUNCTION_INTERFACES takes PREFIX, IDENTIFIER, VALUETYPE
		function interface $IDENTIFIER$UnaryFunction takes $VALUETYPE$ value returns nothing

		function interface $IDENTIFIER$BinaryFunction takes $VALUETYPE$ value0, $VALUETYPE$ value1 returns nothing

		function interface $IDENTIFIER$UnaryPredicate takes $VALUETYPE$ value returns boolean

		function interface $IDENTIFIER$BinaryPredicate takes $VALUETYPE$ value0, $VALUETYPE$ value1 returns boolean

		function interface $IDENTIFIER$Generator takes nothing returns $VALUETYPE$

		function interface $IDENTIFIER$UnaryOperation takes $VALUETYPE$ value returns $VALUETYPE$

		function interface $IDENTIFIER$BinaryOperation takes $VALUETYPE$ value0, $VALUETYPE$ value1 returns $VALUETYPE$
	//! endtextmacro



	// integer
	//! runtextmacro A_CONTAINER_FUNCTION_INTERFACES("", "Integer", "integer")

	//! runtextmacro A_CONTAINER_ITERATOR("", "ASimple", "A")
	//! runtextmacro A_CONTAINER("", "ASimpleContainer", "AContainer")
endlibrary