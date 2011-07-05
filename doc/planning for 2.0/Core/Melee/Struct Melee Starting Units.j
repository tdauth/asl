library AStructCoreMeleeStartingUnits

	struct AMeleeWorkerType
		private integer m_unitTypeId
		private boolean m_nearTownHall // otherwise near gold mine
	endstruct

	struct AMeleePeonType extends AMeleeWorkerType
	endstruct

	struct AMeleeRace
	endstruct


	/**
	* Allows you to customly place starting units for players (including custom races).
	* \todo Get data from AMeleeRace instance.
	* \sa AMeleeWorkerType, AMeleeRace
	*/
	struct AMeleeStartingUnits
		private integer m_townHallUnitTypeId
		private ASimpleIntegerList m_workerTypes
		private string m_preloader
		private boolean m_blightedGoldMine
		private integer array m_heroTypeId[4]

		public method place takes player whichPlayer, location startLocation, boolean doHeroes, boolean doCamera, boolean doPreload returns nothing
			local boolean useRandomHero = IsMapFlagSet(MAP_RANDOM_HERO)
			local real unitSpacing = 64.00
			local unit nearestMine = MeleeFindNearestMine(startLocation, bj_MELEE_MINE_SEARCH_RADIUS)
			local location workerLocation
			local ASimpleIntegerListIterator iterator
			local integer i
			local location heroLocation


			if (doPreload and this.preloader() != null) then
				call Preloader(this.preloader())
			endif

			// Spawn town hall at the start location.
			call CreateUnitAtLoc(whichPlayer, this.townHallUnitTypeId(), startLocation, bj_UNIT_FACING)

			// Replace the nearest gold mine with a blighted version.
			if (nearestMine != null and this.blightedGoldMine()) then
				set nearestMine = BlightGoldMineForPlayerBJ(nearestMine, whichPlayer)
			endif

			set iterator = this.workerTypes().begin()
			set i = 0
			loop
				exitwhen (not iterator.isValid())
				/// \todo Get the correct delta values using \ref i
				if (nearestMine != null) then
					if (AMeleeWorkerType(iterator.data()).nearTownHall()) then
						set workerLocation = MeleeGetProjectedLoc(startLocation, GetUnitLoc(nearestMine), 288, 0)
					else
						set workerLocation = MeleeGetProjectedLoc(GetUnitLoc(nearestMine), startLocation, 320, 0)
					endif
				// Spawn workers directly south of the town hall.
				else
					set workerLocation = Location(GetLocationX(startLocation), GetLocationY(startLoc) - 224.00)

					/*
					call CreateUnit(whichPlayer, 'uaco', peonX - 1.50 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
					call CreateUnit(whichPlayer, 'uaco', peonX - 0.50 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
					call CreateUnit(whichPlayer, 'uaco', peonX + 0.50 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
					call CreateUnit(whichPlayer, 'ugho', peonX + 1.50 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
					*/
				endif

				call CreateUnit(whichPlayer, AMeleeWorkerType(iterator.data()).unitTypeId(), GetLocationX(workerLocation) + xValue, GetLocationY(workerLocation) + yValue, bj_UNIT_FACING)
				call RemoveLocation(workerLocation)
				set workerLocation = null
				call iterator.next()
				set i = i + 1
			endloop
			call iterator.destroy()

			if (this.blightedGoldMine()) then
				if (nearsetMine != null) then
					set workerLocation = MeleeGetProjectedLoc(GetUnitLoc(nearestMine), startLocation, 320, 0)
				// Create a patch of blight around the start location.
				else
					set workerLocation = startLocation
				endif
				// Create a patch of blight around the gold mine.
				call SetBlightLoc(whichPlayer, nearMineLocation, 768, true)
				if (nearsetMine != null) then
					call RemoveLocation(workerLocation)
					set workerLocation = null
				endif
			endif

			if (doHeroes) then
				// If the "Random Hero" option is set, start the player with a random hero.
				// Otherwise, give them a "free hero" token.
				if (useRandomHero) then
					if (nearestMine != null) then
						// Set random hero spawn point to be off to the side of the start location.
						set workerLocation = MeleeGetProjectedLoc(GetUnitLoc(nearestMine), startLocation, 384, 45)
					else
						// Set random hero spawn point to be just south of the start location.
						set workerLocation = Location(GetLocationX(startLocation),  GetLocationY(startLoc) - 226.00 * unitSpacing)
					endif
					call MeleeRandomHeroLoc(whichPlayer, this.heroTypeId(0), this.heroTypeId(1), this.heroTypeId(2), this.heroTypeId(3), workerLocation)
					call RemoveLocation(workerLocation)
					set workerLocation = null
				else
					call SetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_HERO_TOKENS, bj_MELEE_STARTING_HERO_TOKENS)
				endif
			endif

			if (doCamera) then
				if (nearestMine != null) then
					set workerLocation = MeleeGetProjectedLoc(GetUnitLoc(nearestMine), startLocation, 320, 0)
				else
					set workerLocation = Location(GetLocationX(startLocation), GetLocationY(startLoc) - 224.00)
				endif
				// Center the camera on the initial Acolytes.
				call SetCameraPositionForPlayer(whichPlayer, GetLocationX(workerLocation), GetLocationY(workerLocation))
				call SetCameraQuickPositionForPlayer(whichPlayer, GetLocationX(workerLocation), GetLocationY(workerLocation))
				call RemoveLocation(workerLocation)
				set workerLocation = null
			endif
		endmethod

		public static method placeRaceForPlayer

		public static method placeForPlayer takes player whichPlayer, location startLocation, boolean doHeroes, boolean doCamera, boolean doPreload returns nothing
			local AMeleeRace meleeRace = AMeleeRace.playerRace(whichPlayer)
			if (meleeRace != 0) then
				call this.placeRaceForPlayer(whichPlayer, meleeRace, startLocation, doHeroes, doCamera, doPreload)
			else
				if (GetPlayerRace(whichPlayer) == RACE_HUMAN) then
					call this.placeHumanForPlayer(whichPlayer, startLocation, doHeroes, doCamera, doPreload)
				elseif (GetPlayerRace(whichPlayer) == RACE_ORC) then
					call this.placeOrcForPlayer(whichPlayer, startLocation, doHeroes, doCamera, doPreload)
				elseif (GetPlayerRace(whichPlayer) == RACE_UNDEAD) then
					call this.placeUndeadForPlayer(whichPlayer, startLocation, doHeroes, doCamera, doPreload)
				elseif (GetPlayerRace(whichPlayer) == RACE_NIGHTELF) then
					call this.placeNightElfForPlayer(whichPlayer, startLocation, doHeroes, doCamera, doPreload)
				endif
			endif
		endmethod

		/**
		* \sa MeleeStartingUnits
		*/
		public static method placeForAllPlayers takes nothing returns nothing
			local integer index
			local player indexPlayer
			local location indexStartLoc


			call Preloader("scripts\\SharedMelee.pld")

			set index = 0
			loop
				set indexPlayer = Player(index)
				if (GetPlayerSlotState(indexPlayer) == PLAYER_SLOT_STATE_PLAYING) then
					set indexStartLoc = GetStartLocationLoc(GetPlayerStartLocation(indexPlayer))
					call thistype.placeForPlayer(indexPlayer, indexStartLoc, true, true, true)
					call RemoveLocation(indexStartLoc)
					set indexStartLoc = null
				endif
				set indexPlayer = null
				set index = index + 1
				exitwhen index == bj_MAX_PLAYERS
			endloop
		endmethod

	endstruct

endlibrary