function AddSpecialEffectForForce takes force whichForce, string modelPath, real x, real y returns effect
	local string localPath = ""
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		set localPath = modelPath 
	endif
	return AddSpecialEffect(localPath, x, y)
endfunction

/**
 * Old version \ref CreateSpecialEffectForPlayer.
 */
function AddSpecialEffectForPlayer takes player whichPlayer, string modelPath, real x, real y returns effect
	local string localPath = ""
	if (GetLocalPlayer() == whichPlayer) then
		set localPath = modelPath
	endif
	return AddSpecialEffect(localPath, x, y)
endfunction

function AddSpecialEffectLocForForce takes force whichForce, string modelPath, location where returns effect
	local string localPath = ""
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		set localPath = modelPath 
	endif
	return AddSpecialEffectLoc(localPath, where)
endfunction

function AddSpecialEffectLocForPlayer takes player whichPlayer, string modelPath, location where returns effect
	local string localPath = ""
	if (GetLocalPlayer() == whichPlayer) then
		set localPath = modelPath 
	endif
	return AddSpecialEffectLoc(localPath, where)
endfunction

function AddSpecialEffectTargetForForce takes force whichForce, string modelPath, widget targetWidget, string attachPointName returns effect
	local string localPath = ""
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		set localPath = modelPath 
	endif
	return AddSpecialEffectTarget(localPath, targetWidget, attachPointName)
endfunction

/**
 * Old version \ref CreateSpecialEffectOnTargetForPlayer.
 */
function AddSpecialEffectTargetForPlayer takes player whichPlayer, string modelPath, widget targetWidget, string attachPointName returns effect
	local string localPath = ""
	if (GetLocalPlayer() == whichPlayer) then
		set localPath = modelPath 
	endif
	return AddSpecialEffectTarget(localPath, targetWidget, attachPointName)
endfunction

function AddSpellEffectForForce takes force whichForce, string abilityString, effecttype t, real x, real y returns effect
	local string localAbilityString = ""
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		set localAbilityString = abilityString
	endif
	return AddSpellEffect(localAbilityString, t, x, y)
endfunction

function AddSpellEffectForPlayer takes player whichPlayer, string abilityString, effecttype t, real x, real y returns effect
	local string localAbilityString = ""
	if (GetLocalPlayer() == whichPlayer) then
		set localAbilityString = abilityString
	endif
	return AddSpellEffect(localAbilityString, t, x, y)
endfunction

function AddSpellEffectLocForForce takes force whichForce, string abilityString, effecttype t, location where returns effect
	local string localAbilityString = ""
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		set localAbilityString = abilityString
	endif
	return AddSpellEffectLoc(localAbilityString, t, where)
endfunction

function AddSpellEffectLocForPlayer takes player whichPlayer, string abilityString, effecttype t, location where returns effect
	local string localAbilityString = ""
	if (GetLocalPlayer() == whichPlayer) then
		set localAbilityString = abilityString
	endif
	return AddSpellEffectLoc(localAbilityString, t, where)
endfunction

function AddSpellEffectByIdForForce takes force whichForce, integer abilityId, effecttype t, real x, real y returns effect
	local integer localAbilityId = 0
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		set localAbilityId = abilityId
	endif
	return AddSpellEffectById(localAbilityId, t, x, y)
endfunction

function AddSpellEffectByIdForPlayer takes player whichPlayer, integer abilityId, effecttype t, real x, real y returns effect
	local integer localAbilityId = 0
	if (GetLocalPlayer() == whichPlayer) then
		set localAbilityId = abilityId
	endif
	return AddSpellEffectById(localAbilityId, t, x, y)
endfunction

function AddSpellEffectByIdLocForForce takes force whichForce, integer abilityId, effecttype t, location where returns effect
	local integer localAbilityId = 0
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		set localAbilityId = abilityId
	endif
	return AddSpellEffectByIdLoc(localAbilityId, t, where)
endfunction

function AddSpellEffectByIdLocForPlayer takes player whichPlayer, integer abilityId, effecttype t, location where returns effect
	local integer localAbilityId = 0
	if (GetLocalPlayer() == whichPlayer) then
		set localAbilityId = abilityId
	endif
	return AddSpellEffectByIdLoc(localAbilityId, t, where)
endfunction

function AddSpellEffectTargetForForce takes force whichForce, string modelName, effecttype t, widget targetWidget, string attachPoint returns effect
	local string localModelName = ""
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		set localModelName = modelName
	endif
	return AddSpellEffectTarget(localModelName, t, targetWidget, attachPoint)
endfunction

function AddSpellEffectTargetForPlayer takes player whichPlayer, string modelName, effecttype t, widget targetWidget, string attachPoint returns effect
	local string localModelName = ""
	if (GetLocalPlayer() == whichPlayer) then
		set localModelName = modelName
	endif
	return AddSpellEffectTarget(localModelName, t, targetWidget, attachPoint)
endfunction

function AddSpellEffectTargetByIdForForce takes force whichForce, integer abilityId, effecttype t, widget targetWidget, string attachPoint returns effect
	local integer localAbilityId = 0
	if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
		set localAbilityId = abilityId
	endif
	return AddSpellEffectTargetById(localAbilityId, t, targetWidget, attachPoint)
endfunction

function AddSpellEffectTargetByIdForPlayer takes player whichPlayer, integer abilityId, effecttype t, widget targetWidget, string attachPoint returns effect
	local integer localAbilityId = 0
	if (GetLocalPlayer() == whichPlayer) then
		set localAbilityId = abilityId
	endif
	return AddSpellEffectTargetById(localAbilityId, t, targetWidget, attachPoint)
endfunction