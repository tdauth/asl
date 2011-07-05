library AStructCoreTimeFrequency requires AStructCoreTimeDuration

	struct AFrequencyMember
		private AFrequency m_frequency
		private ADelay m_timeOfDay /// if < 0 it is run immediatly after delay
		private ADelay m_delay
		private integer m_repeats /// -1 for infinite repeats
		private ADuration m_duration
		
		
	endstruct

	struct AFrequency
		private AIntegerList m_members
		
		public stub method onRun takes nothing returns nothing
		endmethod
		
		public method run takes nothing returns nothing
			call run.execute()
		endmethod
	endstruct

endlibrary