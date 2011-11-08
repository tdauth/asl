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

 * \section wrappers Wrappers
 * There are various wrapper structures which provide nearly the same functionality of a default native JASS type but some extras, as well.
 * \ref AForce can be used to get the same functions as there are for native type \ref force but you get random access to force members, too.
 * \ref AGroup does the same for native type \ref group.
 * Finally, \ref AHashTable provides access to one single \ref hashtable but in a way like for \ref gamecache (which had been used before), too.

 * \section containers Containers
 * ASL provides some different container types based on <a href="http://www.cplusplus.com/reference/stl">C++ STL</a> and provided through vJass's text macro feature.
 * For simple containers which do usually only grow at their end you can use \ref A_VECTOR.
 * There is a more specialized version for numeric operations, as well called \ref A_NUMERIC_VECTOR.
 * If you need a more flexible container without random access functionality which can grow easily by pushing elements to its front or inserting elements somewhere you should use \ref A_LIST which provides you a double-linked list container.
 * For faster search results and associative containers you should use \ref A_MAP which generates a container type which stores elements ordered by their corresponding unique key.
 * For simple pushing and popping you can use \ref A_STACK.
 * The last structure isn't any real custom container macro but can be used to store elements, too.
 * It's simply a wrapper for JASS data type \ref hashtable called \ref AHashTable.
 * Therefore it doesn't need any text macro call to be generated.
 *
 * All container text macros do provide some default structures mostly for default types in JASS:
 * <ul>
 * <li>AIntegerVector</li>
 * <li>AStringVector</li>
 * <li>ABooleanVector</li>
 * <li>ARealVector</li>
 * <li>AHandleVector</li>
 * <li>AEffectVector</li>
 * <li>AUnitVector</li>
 * <li>AItemVector</li>
 * <li>ADestructableVector</li>
 * <li>ARectVector</li>
 * <li>AWeatherEffectVector</li>
 * <li>APlayerVector</li>
 * <li>AIntegerNumericVector</li>
 * <li>ARealNumericVector</li>
 * <li>AIntegerList</li>
 * <li>AStringList</li>
 * <li>ABooleanList</li>
 * <li>ARealList</li>
 * <li>AHandleList</li>
 * <li>APlayerList</li>
 * <li>ARegionList</li>
 * <li>AIntegerMap - in debug mode only</li>
 * <li>AUnitMap - in debug mode only</li>
 * <li>AIntegerStack</li>
 * <li>AStringStack</li>
 * <li>ABooleanStack</li>
 * <li>ARealStack</li>
 * <li>AHandleStack</li>
 * </ul>
 * \note If you're going to use any container structure for storing pointers you should rather use an existing integer based container than creating a new text macro instance which generates a lot of code although it could be more type safe (actually type safety isn't implemented in vJass that strong at all).
 * \note As you can see there are many default containers for native handle-based types. Unfortunately, we cannot do downcasts anymore (since return bug has been fixed) so we need to generate a container structure for each type seperately instead of using the handle-based container for all derived types.
 */
library ACoreGeneral requires AInterfaceCoreGeneralContainer, AStructCoreGeneralAsl, AStructCoreGeneralForce, AStructCoreGeneralGroup, AStructCoreGeneralHashTable, AStructCoreGeneralList, AStructCoreGeneralMap, AStructCoreGeneralNumericVector, AStructCoreGeneralSignal, AStructCoreGeneralSlkTableEntry, AStructCoreGeneralStack, AStructCoreGeneralVector, ALibraryCoreGeneralConversion, ALibraryCoreGeneralGame, ALibraryCoreGeneralItem, ALibraryCoreGeneralPlayer, ALibraryCoreGeneralTimer, ALibraryCoreGeneralUnit, AModuleCoreGeneralSystemStruct
endlibrary