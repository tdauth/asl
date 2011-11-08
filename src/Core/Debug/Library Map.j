library ALibraryCoreDebugMap requires AStructCoreDebugBenchmark, ALibraryCoreDebugMisc, ACoreString, AStructCoreGeneralMap

	function AMapDebug takes nothing returns nothing
static if (DEBUG_MODE) then
		local AIntegerMap intMap = AIntegerMap.create()
		local AIntegerMapIterator intIterator
		local integer value
		local AUnitMap unitMap = AUnitMap.create()
		local AUnitMapIterator iterator
		call Print("Integer map debug:")
		// integer map
		loop
			exitwhen (intMap.size() == 100)
			set value = GetRandomInt(0, 10000)
			// make sure we do not use keys in use!
			loop
				exitwhen (not intMap.contains(value))
				set value = GetRandomInt(0, 10000)
			endloop
			set intMap[value] = GetRandomInt(0, 10000)
		endloop
		call Print("The following output should contain 100 elements in ascending order ordered by their keys!")
		set intIterator = intMap.begin()
		loop
			exitwhen (intIterator == intMap.end())
			call Print("Key: " + I2S(intIterator.key()) + ", Value: " + I2S(intIterator.data()))
			call intIterator.next()
		endloop
		call intIterator.destroy()

		// unit map
		call Print("Unit map debug:")
		set unitMap["Test"] = null
		call Print("Pushed back one element, map size " + I2S(unitMap.size()) + ".")
		call Print("Unit name " + GetUnitName(unitMap["Test"]) + ".")
		set iterator = unitMap.end()
		call unitMap.erase(iterator)
		call iterator.destroy()
		call Print("Popped back one element, map size " + I2S(unitMap.size()) + ".")

		// set new elements
		loop
			exitwhen(unitMap.size() == 10)
			set unitMap["I" + I2S(unitMap.size() - 1)] = null
		endloop

		call Print("Unit map size " + I2S(unitMap.size()) + " after setting new elements.")

		// clean up
		loop
			exitwhen (unitMap.empty())
			set iterator = unitMap.end()
			call unitMap.erase(iterator)
			call iterator.destroy()
		endloop

		call Print("Unit map size " + I2S(unitMap.size()) + " after cleaning up.")

		call unitMap.destroy()

endif
	endfunction


endlibrary