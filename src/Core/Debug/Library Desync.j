library ALibraryCoreDebugDesync requires ALibraryCoreDebugMisc, ALibraryCoreInterfaceCamera, ALibraryCoreEnvironmentTerrainFog

	function ADesyncDebug takes nothing returns nothing
		local player whichPlayer = Player(0)
		local location whichLocation = Location(0.0, 0.0)
		call ResetTerrainFogForPlayer(whichPlayer)
		call PanCameraToWithZForPlayer(whichPlayer, 0.0, 0.0, 2.0)
		call PanCameraToTimedWithZForPlayer(whichPlayer, 0.0, 0.0, 2.0, 4.0)
		call SmartCameraPanForPlayer(whichPlayer, 0.0, 0.0, 4.0)
		call SmartCameraPanWithZForPlayer(whichPlayer, 0.0, 0.0, 2.0, 4.0)
		call RotateCameraAroundForPlayer(whichPlayer, 0.0, 0.0, 30.0, 4.0)
		call SetCameraPositionLocationForPlayer(whichPlayer, whichLocation)
		call SetCameraQuickPositionLocationForPlayer(whichPlayer, whichLocation)
		call PanCameraToLocationForPlayer(whichPlayer, whichLocation)
		call PanCameraToLocationWithZForPlayer(whichPlayer, whichLocation, 2.0)
		call PanCameraToTimedLocationForPlayer(whichPlayer, whichLocation, 4.0)
		call PanCameraToTimedLocationWithZForPlayer(whichPlayer, whichLocation, 1.0, 4.0)
		call RotateCameraAroundLocationForPlayer(whichPlayer, whichLocation, 30.0, 3.0)
		call SetCameraBoundsToPointForPlayer(whichPlayer, 0.0, 0.0)
		call ResetCameraBoundsToMapRectForPlayer(whichPlayer)

		call ResetToGameCameraForPlayer(whichPlayer, 0.0)

		// TODO ShowUnitForPlayer()

		set whichPlayer = null
		call RemoveLocation(whichLocation)
		set whichLocation = null
	endfunction

endlibrary