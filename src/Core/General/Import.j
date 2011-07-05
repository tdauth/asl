//! import "Core/General/Interface Container.j"
//! import "Core/General/Struct Asl.j"
//! import "Core/General/Struct Force.j"
//! import "Core/General/Struct Group.j"
//! import "Core/General/Struct Hash Table.j"
//! import "Core/General/Struct List.j"
//! import "Core/General/Struct Map.j"
//! import "Core/General/Struct Numeric Vector.j"
//! import "Core/General/Struct Signal.j"
//! import "Core/General/Struct Slk Table Entry.j"
//! import "Core/General/Struct Stack.j"
//! import "Core/General/Struct Vector.j"
//! import "Core/General/Library Conversion.j"
//! import "Core/General/Library Game.j"
//! import "Core/General/Library Item.j"
//! import "Core/General/Library Player.j"
//! import "Core/General/Library Timer.j"
//! import "Core/General/Library Unit.j"
//! import "Core/General/Module System Struct.j"

/**
 * \fn StartStockUpdates
 * Perform the first update, and then arrange future updates.
 * \author Blizzard Entertainment
 *
 * \fn UnitDropItem
 * Makes the given unit drop the given item
 * Note: This could potentially cause problems if the unit is standing
 * right on the edge of an unpathable area and happens to drop the
 * item into the unpathable area where nobody can get it...
 * \author Blizzard Entertainment
 * \sa WidgetDropItem
 *
 * \fn WidgetDropItem
 * Makes widget \p inWidget dropping an item of type \p inItemID which does acutally mean that it's created at a random location within a maximum range of 32.
 * \return Returns dropped item handle.
 * \sa UnitDropItem
 */
library ACoreGeneral requires AInterfaceCoreGeneralContainer, AStructCoreGeneralAsl, AStructCoreGeneralForce, AStructCoreGeneralGroup, AStructCoreGeneralHashTable, AStructCoreGeneralList, AStructCoreGeneralMap, AStructCoreGeneralNumericVector, AStructCoreGeneralSignal, AStructCoreGeneralSlkTableEntry, AStructCoreGeneralStack, AStructCoreGeneralVector, ALibraryCoreGeneralConversion, ALibraryCoreGeneralGame, ALibraryCoreGeneralItem, ALibraryCoreGeneralPlayer, ALibraryCoreGeneralTimer, ALibraryCoreGeneralUnit, AModuleCoreGeneralSystemStruct
endlibrary