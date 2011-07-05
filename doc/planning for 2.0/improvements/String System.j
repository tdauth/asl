
/**
* Autosize functions
*/
function StringFormatDialogMessage takes string whichString returns string
endfunction

function MultiboardItemSizeByString takes string whichString returns real
endfunction

/// @todo RemoveString and ReplaceString should do their actions for ALL found strings!!!!

function StringRemoveCharPool takes string whichString, string charPool returns string
	local integer i = 1
	loop
		exitwhen (i >= StringLength(charPool))
		set whichString = RemoveString(whichString, SubString(charPool, i - 1, i))
		set i = i + 1
	endloop
	return whichString
endfunction

/// Removes all whitespaces in string.
function StringTrim takes string whichString returns string
	return StringRemoveCharPool(whichString, AWhiteSpaceCharacters)
endfunction

function StringTrimLeft takes string whichString returns string
	local integer i = 1
	loop
		if (i >= StringLength(whichString)) then
			return null
		elseif (not IsStringWhiteSpace(SubString(whichString, i - 1, i))) then
			return SubString(whichString, i - 1, StringLength(whichString))
		endif
		set i = i + 1
	endloop
	return null
endfunction

function StringTrimRight takes string whichString returns string
	local integer i = StringLength(whichString)
	loop
		if (i <= 0) then
			return null
		elseif (not IsStringWhiteSpace(SubString(whichString, i - 1, i))) then
			return SubString(whichString, 0, i)
		endif
		set i = i - 1
	endloop
	return null
endfunction

function StringLeft takes string whichString, integer number returns string
	set number = IMinBJ(number, StringLength(whichString)
	return SubString(0, number)
endfunction

function StringRight takes string whichString, integer number returns string
	set number = IMinBJ(number, StringLength(whichString)
	return SubString(StringLength(whichString) - number, StringLength(whichString))
endfunction

function StringAppend takes string whichString, string other returns string
	return whichString + other
endfunction

function StringPrepend takes string whichString, string other returns string
	return other + whichString
endfunction

function StringRepeated takes string whichString, integer number returns string
	local string result = ""
	local integer i = 0
	loop
		exitwhen (i == number)
		set result = result + whichString
		set i = i + 1
	endloop
	return result
endfunction

/// Appends ' ' characters if size is larger than original size.
function StringResize takes string whichString, integer size returns string
	set size = IMaxBJ(0, size)
	if (size < StringLength(whichString) then
		return SubString(0, size)
	elseif (size > StringLength(whichString)) then
		return whichString + StringRepeated(" ", size - StringLength(whichString))
	endif
	return whichString
endfunction

/// Truncates string at the given position.
function StringTruncate takes string whichString, integer position returns string
	set position = IMaxBJ(0, position)
	return SubString(whichString, 0, position + 1)
endfunction