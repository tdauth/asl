/**
* \author Vexorian, Tamino Dauth
* \link http://www.wc3c.net/showthread.php?t=108065
* Powerup items don't get removed automatically by the game, they instead
* just leave a small item in the map, this caused memory leaks but - worse -
* it also makes areas of your map where a lot of tomes have been used lag a lot.
*/
library ALibraryCoreEnvironmentPowerupFix

static if (DEBUG_MODE) then
	globals
		private integer PowerupFixCounter = 0
	endglobals

	/// Use this function to get the number of fixes in game.
	function GetPowerupFixes takes nothing returns integer
		return PowerupFixCounter
	endfunction
endif

	private function TriggerConditionFix takes nothing returns boolean
		if (GetWidgetLife(GetManipulatedItem()) == 0) then
			call RemoveItem(GetManipulatedItem())
			debug set PowerupFixCounter = PowerupFixCounter + 1
		endif

		return false
	endfunction

	private module TempModule

		private method onInit takes nothing returns nothing
			local trigger whichTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DROP_ITEM)
			call TriggerAddCondition(whichTrigger, Condition(function TriggerConditionFix))
		endmethod

	endmodule

	private struct TempStruct
		implement TempModule
	endstruct

endlibrary