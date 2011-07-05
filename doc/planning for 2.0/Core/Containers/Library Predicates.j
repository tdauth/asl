library ALibraryCoreContainersPredicates

	function IntegerLessThan takes integer a, integer b returns boolean
		return a < b
	endfunction

	function HandleLessThan takes handle a, handle b returns boolean
		return GetHandleId(a) < GetHandleId(b)
	endfunction

endlibrary