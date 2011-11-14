library AStructSystemsCharacterRevival requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, ALibraryCoreInterfaceMisc, AStructSystemsCharacterAbstractCharacterSystem

	struct ARevival extends AAbstractCharacterSystem
		// dynamic members
		private real m_time
		private real m_x
		private real m_y
		private real m_facing
		private boolean m_showEffect
		// members
		private trigger m_revivalTrigger
		private timer m_timer
		private timerdialog m_timerDialog
		private boolean m_runs

		//! runtextmacro optional A_STRUCT_DEBUG("\"ARevival\"")

		// dynamic members

		public method setTime takes real time returns nothing
			set this.m_time = time
		endmethod

		public method time takes nothing returns real
			return this.m_time
		endmethod

		public method setX takes real x returns nothing
			set this.m_x = x
		endmethod

		public method x takes nothing returns real
			return this.m_x
		endmethod

		public method setY takes real y returns nothing
			set this.m_y = y
		endmethod

		public method y takes nothing returns real
			return this.m_y
		endmethod

		public method setFacing takes real facing returns nothing
			set this.m_facing = facing
		endmethod

		public method facing takes nothing returns real
			return this.m_facing
		endmethod

		public method setShowEffect takes boolean showEffect returns nothing
			set this.m_showEffect = showEffect
		endmethod

		public method showEffect takes nothing returns boolean
			return this.m_showEffect
		endmethod

		public method setShowDialog takes boolean show returns nothing
			if (show == this.showDialog()) then
				return
			endif
			if (show) then
				set this.m_timerDialog = CreateTimerDialog(this.m_timer)
				call TimerDialogSetTitle(this.m_timerDialog, GetModifiedPlayerName(this.character().player()))
			else
				call DestroyTimerDialog(this.m_timerDialog)
				set this.m_timerDialog = null
			endif
		endmethod

		public method showDialog takes nothing returns boolean
			return this.m_timerDialog != null
		endmethod

		// methods

		public stub method enable takes nothing returns nothing
			call super.enable()
			call EnableTrigger(this.m_revivalTrigger)
			if (this.m_runs) then
				call PauseTimerBJ(false, this.m_timer)
				if (this.showDialog()) then
					call TimerDialogDisplay(this.m_timerDialog, true)
				endif
			endif
		endmethod

		public stub method disable takes nothing returns nothing
			call super.disable()
			call DisableTrigger(this.m_revivalTrigger)
			if (this.m_runs) then
				call PauseTimerBJ(true, this.m_timer)
				if (this.showDialog()) then
					call TimerDialogDisplay(this.m_timerDialog, false)
				endif
			endif
		endmethod

		private method revive takes nothing returns nothing
			call ReviveHero(this.character().unit(), this.x(), this.y(), this.showEffect())
			call SetUnitFacing(this.character().unit(), this.facing())
		endmethod

		private static method timerFunctionRevival takes nothing returns nothing
			local timer expiredTimer = GetExpiredTimer()
			local thistype this = AHashTable.global().handleInteger(expiredTimer, "this")
			set this.m_runs = false
			call this.revive()
			call this.end.evaluate()
			set expiredTimer = null
		endmethod

		private method start takes nothing returns nothing
			call TimerStart(this.m_timer, this.m_time, false, function thistype.timerFunctionRevival)
			set this.m_runs = true
			if (this.showDialog()) then
				call TimerDialogDisplay(this.m_timerDialog, true)
			endif
		endmethod

		private method end takes nothing returns nothing
			call PauseTimer(this.m_timer) //Zur Sicherheit auch stoppen
			if (this.showDialog()) then
				call TimerDialogDisplay(this.m_timerDialog, false)
			endif
		endmethod

		private method createTimer takes nothing returns nothing
			set this.m_timer = CreateTimer()
			call AHashTable.global().setHandleInteger(this.m_timer, "this", this)
		endmethod

		private static method triggerActionRevival takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, "this")
			if (this.m_time > 0.0) then
				call this.start()
			else
				call this.revive()
			endif
			// set unmovable
			set triggeringTrigger = null
		endmethod

		private method createRevivalTrigger takes nothing returns nothing
			set this.m_revivalTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_revivalTrigger, this.character().unit(), EVENT_UNIT_DEATH)
			call TriggerAddAction(this.m_revivalTrigger, function thistype.triggerActionRevival)
			call AHashTable.global().setHandleInteger(this.m_revivalTrigger, "this", this)
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character)
			// dynamic members
			set this.m_time = 20.0
			set this.m_x = 0.0
			set this.m_y = 0.0
			set this.m_facing = 0.0
			set this.m_showEffect = true
			// members
			set this.m_runs = false

			call this.createTimer()
			call this.createRevivalTrigger()
			call this.setShowDialog(true) // default value
			return this
		endmethod

		private method destroyTimer takes nothing returns nothing
			call PauseTimer(this.m_timer)
			call AHashTable.global().destroyTimer(this.m_timer)
			set this.m_timer = null
		endmethod

		private method destroyRevivalTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_revivalTrigger)
			set this.m_revivalTrigger = null
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.setShowDialog(false) // destroys dialog if necessary
			call this.destroyTimer()
			call this.destroyRevivalTrigger()
		endmethod
	endstruct

endlibrary