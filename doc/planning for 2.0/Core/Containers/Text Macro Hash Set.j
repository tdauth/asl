library ATextMacroCoreContainersHashSet requires ALibraryCoreContainersHashes

	/**
	 * A standard container composed of unique keys (containing at most one of each key value) in which the elements' keys are the elements themselves.
	 * Meets the requirements of a container, and unordered associative container.
	 */
	//! textmacro A_HASH_SET takes PREFIX, IDENTIFIER, BASE, VALUETYPE, NULLVALUE, HASHFUNCTION
		$PREFIX$ struct $IDENTIFIER$ extends $BASE$


		endstruct
	//! endtextmacro


	//! runtextmacro A_HASH_SET("", "AIntegerHashSet", "AIntegerContainer", "integer", "0", "IntegerHash")
	//! runtextmacro A_HASH_SET("", "AStringHashSet", "AIntegerContainer", "integer", "0", "StringHash")

endlibrary