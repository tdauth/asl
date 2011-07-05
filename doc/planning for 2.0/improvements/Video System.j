/*
* Make AVideo force-based!

Global things which has to be stored by the video system:
* time of day

-- player-related things --
* camera bounds
* camera setup (current)
* volumes
* selection

-- actor-related things --
* vulnerbility
* pause state (PauseUnitsAll)
* everything which is changed automatically by video
* multiple actors has to be saved in an unsorted map with their corresponding units as keys

Add abstract structure or interface AActor.
Derived structures are AUnitActor (-> ACharacterActor), AItemActor and ADestructableActor.
*/

interface AActor
	public method store takes nothing returns nothing
	public method restore takes nothing returns nothing
endinterface

struct AWidgetActor extends AActor
endstruct

struct AUnitActor extends AWidgetActor
endstruct

struct AItemActor extends AWidgetActor
endstruct

struct ADestructableActor extends AWidgetActor
endstruct