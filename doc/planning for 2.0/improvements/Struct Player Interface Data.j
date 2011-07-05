library A

Illidans Fight mrf file?!
Environment\BlightDoodad\BlightDoodad.mdl
Wenn SetCinematicCamera mit einer Modelldateiaufgerufen wird, wird dann die Kamera der Modelldatei übernommen?

function DefaultCameraSetup takes nothing returns camerasetup
AOA=304,311,318,325,332,339
FOV=70,70,70,70,70,70
Rotation=90,90,90,90,90,90,20,20,20,20,20,20,160,160,160,160,160,160
Distance=1650,1600,1500,1400,1275,1100
FarZ=5000,5000,5000,5000,5000,5000
NearZ=100,100,100,100,100,100,60
Height=0,0,0,0,0,0,0
// Camera smoothing.
Smoothing=0.00
SmoothMaxDist=1000
SmoothScale=0.80
SmoothBias=0.15
SmoothMinFPS=10
SmoothBeta=1.5
endfunction

[CameraRates]
// game camera change rates
AOA=20
FOV=20
Rotation=30
Distance=1200
Forward=3000
Strafe=3000
endfunction

ATalk:
Improve importance check.
showRange and showUntil should collect important infos and show first important info first!

No more static init methods!
Increase dynamic.

Add core functions:
- Cinematic Filter functions
- Text tag functions
- Lightning functions
- Utility functions should affect on all selected units

Add the following struct to store player's UI data:
struct APlayerUIData
	private leaderboard m_leaderboard
	private multiboard m_multiboard
	private ATimerDialogVector m_timerDialogs
	private ADialogVector m_dialogs
	private rect m_cameraBounds
	private APlayerSelection m_selection
	private camerasetup m_cameraSetup
endstruct

Add environment structs:
- AActor
- AVideo - force based
- AWidget/AMainWindow - force based
- ADialog - force based
- AUnitStats

Add interface structs:
- AImageBar
- ATextBar
- AHealthBar
- ATransportBar
- AConstructionBar

Add container stuff:
- ATokenizer backwards ability, extends AContainerInterface
- Add backwards iterators (rBegin and rEnd).
- Add A_PAIR and ARange which holds a range between two iterators (see Boost).
- Add A_SORTED_CONTAINER to create containers which do sort newly inserted elements automatically