library AStructCoreTimeDuration requires AStructCoreTimeDelay

	struct ADuration
		private boolean m_infinite
		private ADelay m_delay
		private conditionfunc m_untilCondition
		
		public method infinite takes nothing returns boolean
			return m_infinite
		endmethod
		
		public method waitForCondition takes nothing returns boolean
			return m_untilCondition != null
		endmethod
		
		public method delayed takes nothing returns boolean
			return not this.infinite() and not this.waitForCondition()
		endmethod
		
	endstruct
	
endlibrary