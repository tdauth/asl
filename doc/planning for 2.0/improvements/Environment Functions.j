function EnableWorldFogBoundaryBJ takes boolean enable, force f returns nothing
    if (IsPlayerInForce(GetLocalPlayer(), f)) then
        // Use only local code (no net traffic) within this block to avoid desyncs.
        call EnableWorldFogBoundary(enable)
    endif
endfunction

//===========================================================================
function EnableOcclusionBJ takes boolean enable, force f returns nothing
    if (IsPlayerInForce(GetLocalPlayer(), f)) then
        // Use only local code (no net traffic) within this block to avoid desyncs.
        call EnableOcclusion(enable)
    endif
endfunction


function EnableWorldFogBoundaryForPlayer takes boolean enable, player whichPlayer returns nothing
	if (GetLocalPlayer() == whichPlayer) then
		// Use only local code (no net traffic) within this block to avoid desyncs.
		call EnableWorldFogBoundary(enable)
	endif
endfunction

function EnableOcclusionForPlayer takes boolean enable, player whichPlayer returns nothing
	if (GetLocalPlayer() == whichPlayer) then
		// Use only local code (no net traffic) within this block to avoid desyncs.
		call EnableOcclusion(enable)
	endif
endfunction
