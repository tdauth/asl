/**
* TODO: Blizzard.j file contains much more GetUnits... functions (add more constructors and add methods).
* General changes:
* - Moved to core module "Unit".
* - Extends AUnitSet now.
* - Iterator type AGroupIterator is an alias for AUnitSetIterator.
* - addGroup has no parameters anymore (we added addGroupClear and addGroupDestroy).
* - Due to "addToGroup" and "removeFromGroup", "fillGroup" changes its behaviour and clears its target before now!
* - isInGroup, isDead and isAlive considers now if group is empty
* - isEqualToGroup returns true if both groups are empty
* - constructor createWithGroup uses only one parameter now (due to new constructors createWithGroupClear and createWithGroupDestroy).
*/

/**
* NEW AGROUP METHODS:
*/

public method addOther takes thistype other returns nothing
public method removeOther takes thistype other returns nothing
public method addUnit takes unit whichUnit returns nothing
public method removeUnit takes unit whichUnit returns nothing
public method addToGroup takes group whichGroup returns nothing
public method removeFromGroup takes group whichGroup returns nothing
public method addGroup takes group whichGroup returns nothing
public method addGroupClear takes group whichGroup returns nothing
public method addGroupDestroy takes group whichGroup returns nothing
public method removeGroup takes group whichGroup returns nothing
public method removeGroupClear takes group whichGroup returns nothing
public method removeGroupDestroy takes group whichGroup returns nothing
public method isInOther takes thistype other returns boolean
public method isEqualToGroup takes group whichGroup returns boolean
public method isAlive takes nothing returns boolean
public method hasUnitsOfForce takes force whichForce returns boolean
public method removeUnitsOfForce takes force whichForce returns nothing
public method hasAlliesOfForce takes force whichForce returns boolean
public method removeAlliesOfForce takes force whichForce returns boolean
public method hasEnemiesOfForce takes force whichForce returns boolean
public method removeEnemiesOfForce takes force whichForce returns boolean
/// Since it extends AUnitList now this is unnecessary.
public method clear takes nothing returns nothing
/// Selection stuff has already been added in to ASL 1.X!
public method select takes nothing returns nothing
public method deselect takes nothing returns nothing
public method selectOnly takes nothing returns nothing
public method selectForPlayer takes player whichPlayer returns nothing
public method deselectForPlayer takes player whichPlayer returns nothing
public method selectOnlyForPlayer takes player whichPlayer returns nothing
/// Force-based hasn't already been added.
public method selectForForce takes force whichForce returns nothing
public method deselectForForce takes force whichForce returns nothing
public method selectOnlyForForce takes force whichForce returns nothing
/**
* \sa AContainerInterface#empty
*/
public method isEmpty takes nothing returns boolean
public method isInRect takes rect whichRect returns boolean
public method isInRegion takes region whichRegion returns boolean
/**
* \sa AContainerInterface#random, GroupPickRandomUnit
*/
public method pickRandomUnit takes nothing returns unit

/**
* New constructors.
*/
public static method createWithGroupClear takes group whichGroup returns thistype
public static method createWithGroupDestroy takes group whichGroup returns thistype
public static method unitsOfType takes string unitTypeName, boolexpr filter returns thistype
public static method unitsOfPlayer takes player whichPlayer, boolexpr filter returns thistype
public static method unitsOfTypeCounted takes string unitTypeName, boolexpr filter, integer countLimit returns thistype
public static method unitsInRect takes rect whichRect, boolexpr filter returns thistype
public static method unitsInRectCounted takes rect whichRect, boolexpr filter, integer countLimit returns thistype
public static method unitsInRange takes real x, real y, real radius, boolexpr filter returns thistype
public static method unitsInRangeOfLocation takes location whichLocation, real radius, boolexpr filter returns thistype
public static method unitsInRangeCounted takes real x, real y, real radius, boolexpr filter, integer countLimit returns thistype
public static method unitsInRangeOfLocationCounted takes location whichLocation, real radius, boolexpr filter, integer countLimit returns thistype
public static method unitsSelected takes player whichPlayer, boolexpr filter returns thistype