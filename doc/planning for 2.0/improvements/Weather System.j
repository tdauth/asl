* Add method enableTimer (enables change timer).
* Add method disableTimer (disables change timer).
* Add struct AWeatherType which contains weather effect path and sky model.
* Move method "setChangesSky" to AWeatherType.
* AWeatherType gets new thunderstorm members:
	* boolean m_thunderstorm
	* AFrequency m_thunderstormFrequency
	* sound m_thunderstormSound
	* stub method onDisplayThunderstormCineFilter takes nothing returns nothing
* AWeatherType should allow change of sun model (at specific times), map fog, map soundset and morning and evening soundsets.
* Add method onChange takes AWeather weather to AWeatherType.
* Add static method createDefaultWeatherTypes which creates the default weather types and returns them in a container.
* Add stub onChange method to AWeather.
* If weather effects and sky models can be changed for players only make AWeather force-based!
* Use AFrequency for frequency and duration (requires AStructCoreTimeFrequency).


/**
 * Gewitter können mit einer bestimmten Häufigkeit auftreten. Dabei kann der Blitzeffekt über einen cinematic filter und einen Sound-Effekt erzeugt werden.
 * Sie sind ebenfalls force-basiert.
 */
struct AThunderstorm
	private force m_force
	private sound m_sound
	
	public stub method onDisplayCineFilter takes nothing
	endmethod
endstruct
