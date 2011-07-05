/**
* Test synchronization.
*/

/**
* \version 1.2
* Improved - synchronization (SyncSelections).
*/
function IsPlayerSelectionEmpty takes player whichPlayer returns boolean
	local group selectedUnits = CreateGroup()
	local boolean result = true
	call SyncSelections()
	call GroupEnumUnitsSelected(selectedUnits, whichPlayer, null)
	if (selectedUnits != null) then
		set result = false
	endif
	call DestroyGroup(selectedUnits)
	set selectedUnits = null
	return result
endfunction

function EnableDragSelectForPlayer takes player whichPlayer, boolean state, boolean ui returns nothing
	if (whichPlayer == GetLocalPlayer()) then
		call EnableDragSelect(state, ui)
	endif
endfunction

function EnableDragSelectForForce takes force whichForce, boolean state, boolean ui returns nothing
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		call EnableDragSelect(state, ui)
	endif
endfunction

function EnablePreSelectForPlayer takes player whichPlayer, boolean state, boolean ui returns nothing
	if (whichPlayer == GetLocalPlayer()) then
		call EnablePreSelect(state, ui)
	endif
endfunction

function EnablePreSelectForForce takes force whichForce, boolean state, boolean ui returns nothing
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		call EnablePreSelect(state, ui)
	endif
endfunction

function EnableSelectForPlayer takes player whichPlayer, boolean state, boolean ui returns nothing
	if (whichPlayer == GetLocalPlayer()) then
		call EnableSelect(state, ui)
	endif
endfunction

function EnableSelectForForce takes force whichForce, boolean state, boolean ui returns nothing
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		call EnableSelect(state, ui)
	endif
endfunction

function GetUnitsSelectedByForce takes force whichForce returns group
	local group g = CreateGroup()
	local integer i = 0
	call SyncSelections()
	loop
		if (IsPlayerInForce(Player(i), whichForce)) then
			call GroupEnumUnitsSelected(g, Player(i), null)
		endif
		set i = i + 1
		exitwhen (i == bj_MAX_PLAYER_SLOTS)
	endloop
	return g
endfunction

/// \sa IsPlayerSelectionEmpty
function IsForceSelectionEmpty takes force whichForce returns boolean
	local group whichGroup = GetUnitsSelectedByForce(whichForce)
	local boolean result = IsUnitGroupEmptyBJ(whichGroup)
	call DestroyGroup(whichGroup)
	set whichGroup = null
	return result
endfunction

/// \sa GetFirstSelectedUnitOfPlayer
function GetFirstSelectedUnitOfForce takes force whichForce returns unit
	local group whichGroup = GetUnitsSelectedByForce(whichForce)
	local unit result = FirstOfGroup(whichGroup)
	call DestroyGroup(whichGroup)
	set whichGroup = null
	return result
endfunction

/// \sa SelectGroupBJ
function SelectGroupSingle takes group whichGroup returns nothing
	call SelectGroupBJ(whichGroup)
endfunction

function SelectGroupAdd takes group whichGroup returns nothing
	call ForGroup(whichGroup, function SelectGroupBJEnum)
endfunction

/// \sa SelectGroupBJEnum
function DeselectGroupEnum takes nothing returns nothing
    call SelectUnit(GetEnumUnit(), false)
endfunction

function SelectGroupRemove takes group whichGroup returns nothing
	call ForGroup(whichGroup, function DeselectGroupEnum)
endmethod

/// \sa SelectGroupForPlayerBJ
function SelectGroupForPlayerSingle takes group whichGroup, player whichPlayer returns nothing
	call SelectGroupForPlayerBJ(whichGroup, whichPlayer)
endfunction

/// \sa SelectGroupRemoveForPlayer, SelectGroupAddForForce, SelectGroupRemoveForForce
function SelectGroupAddForPlayer takes group whichGroup, player whichPlayer returns nothing
	if (GetLocalPlayer() == whichPlayer) then
		// Use only local code (no net traffic) within this block to avoid desyncs.
		call SelectGroupAdd(whichGroup)
	endif
endfunction

/// \sa SelectGroupAddForPlayer, SelectGroupAddForForce, SelectGroupRemoveForForce
function SelectGroupRemoveForPlayer takes group whichGroup, player whichPlayer returns nothing
	if (GetLocalPlayer() == whichPlayer) then
		// Use only local code (no net traffic) within this block to avoid desyncs.
		call SelectGroupRemove(whichGroup)
	endif
endfunction

/**
* \return Returns true if unit \a whichUnit is selected by all players of force \a whichForce.
* \sa IsUnitSelected
*/
function IsUnitSelectedByForce takes unit whichUnit, force whichForce returns nothing
	local boolean result = true
	local integer i = 0
	loop
		if (IsPlayerInForce(Player(i), whichForce)) then
			set result = IsUnitSelected(whichUnit, Player(i))
			exitwhen (not result)
		endif
		set i = i + 1
		exitwhen (i == bj_MAX_PLAYER_SLOTS)
	endloop
	return result
endfunction

/**
* \sa ClearSelection, ClearSelectionForPlayer
*/
function ClearSelectionForForce takes force whichForce returns nothing
    if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
        // Use only local code (no net traffic) within this block to avoid desyncs.
        call ClearSelection()
    endif
endfunction

/**
* \sa SelectUnitForPlayerSingle
*/
function SelectUnitForForceSingle takes unit whichUnit, force whichForce returns nothing
    if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
        // Use only local code (no net traffic) within this block to avoid desyncs.
        call ClearSelection()
        call SelectUnit(whichUnit, true)
    endif
endfunction

/**
* \sa SelectGroupForPlayerSingle
*/
function SelectGroupForForceSingle takes group whichGroup, force whichForce returns nothing
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		// Use only local code (no net traffic) within this block to avoid desyncs.
		call ClearSelection()
		call ForGroup(whichGroup, function SelectGroupBJEnum)
	endif
endfunction

/**
* \sa SelectUnitRemoveForForce, SelectUnitAddForPlayer, SelectUnitRemoveForPlayer
*/
function SelectUnitAddForForce takes unit whichUnit, force whichForce returns nothing
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		// Use only local code (no net traffic) within this block to avoid desyncs.
		call SelectUnit(whichUnit, true)
	endif
endfunction

/**
* \sa SelectUnitAddForForce, SelectUnitAddForPlayer, SelectUnitRemoveForPlayer
*/
function SelectUnitRemoveForForce takes unit whichUnit, force whichForce returns nothing
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		// Use only local code (no net traffic) within this block to avoid desyncs.
		call SelectUnit(whichUnit, false)
	endif
endfunction

/**
* \sa SelectGroupRemoveForForce, SelectGroupAddForPlayer, SelectGroupRemoveForPlayer
*/
function SelectGroupAddForForce takes group whichGroup, force whichForce returns nothing
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		// Use only local code (no net traffic) within this block to avoid desyncs.
		call SelectGroupAdd(whichGroup)
	endif
endfunction

/**
* \sa SelectGroupAddForForce, SelectGroupAddForPlayer, SelectGroupRemoveForPlayer
*/
function SelectGroupAddForForce takes group whichGroup, force whichForce returns nothing
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		// Use only local code (no net traffic) within this block to avoid desyncs.
		call SelectGroupRemove(whichGroup)
	endif
endfunction


/**
* \copybrief SelectUnitTypeForPlayer
* \sa HighlightSelectedUnitForForce, SelectUnitTypeForPlayer, SelectUnitTypeForForce, GetSelectedUnitTypeOfPlayer
*/
function HighlightSelectedUnitForPlayer takes unit whichUnit, player whichPlayer returns nothing
	if (IsUnitSelected(whichUnit, whichPlayer)) then
		call SelectUnitAddForPlayer(whichUnit, whichPlayer)
	endif
endfunction

/**
* \copybrief SelectUnitTypeForPlayer
* \sa HighlightSelectedUnitForPlayer, SelectUnitTypeForPlayer, SelectUnitTypeForForce, GetSelectedUnitTypeOfPlayer
*/
function HighlightSelectedUnitForForce takes unit whichUnit, force whichForce returns nothing
	if (IsUnitSelectedByForce(whichUnit, whichForce)) then
		call SelectUnitAddForForce(whichUnit, whichForce)
	endif
endfunction

/**
* \brief If groups are selected in game there is always a highlighted unit type. This unit type depends on the currently first selected unit of the group. For instance, when you cast some ability of the first selected all highlighted units of the group (all units with the same unit type) will also cast that ability if they have skilled it/ it is available for them.
* \sa SelectUnitTypeForForce, HighlightSelectedUnitForPlayer, HighlightSelectedUnitForForce, GetSelectedUnitTypeOfPlayer
*/
function SelectUnitTypeForPlayer takes integer unitTypeId, player whichPlayer returns nothing
	local AGroup whichGroup = AGroup.unitsSelected(whichPlayer, null)
	local AGroupIterator iterator = whichGroup.begin()
	local unit whichUnit = null
	loop
		exitwhen (not iterator.isValid())
		if (GetUnitTypeId(iterator.data()) == unitTypeId) then
			set whichUnit = iterator.data()
			exitwhen (true)
		endif
		call iterator.next()
	endloop
	if (whichUnit != null) then
		call SelectUnitAddForPlayer(whichUnit, whichPlayer)
	endif
	call iterator.destroy()
	call whichGroup.destroy()
endfunction

/**
* \copybrief SelectUnitTypeForPlayer
* \sa SelectUnitTypeForPlayer, HighlightSelectedUnitForPlayer, HighlightSelectedUnitForForce, GetSelectedUnitTypeOfPlayer
*/
function SelectUnitTypeForForce takes integer unitTypeId, force whichForce returns nothing
	local integer i = 0
	loop
		if (IsPlayerInForce(Player(i), whichForce)) then
			call SelectUnitTypeForPlayer(unitTypeId, Player(i))
		endif
		set i = i + 1
		exitwhen (i == bj_MAX_PLAYER_SLOTS)
	endloop
endfunction

/**
* \copybrief SelectUnitTypeForPlayer
* \return Returns unit type id of highlighted unit type of player's \p whichPlayer selection.
* \sa SelectUnitTypeForPlayer, SelectUnitTypeForForce, HighlightSelectedUnitForPlayer, HighlightSelectedUnitForForce
*/
function GetSelectedUnitTypeOfPlayer takes player whichPlayer returns integer
	/// \todo How should we solve this since the highlighted unit isn't necessarily the first of the selection group.
endfunction