/// A_LIST and A_MAP do not use any size member anymore
/// Current implementations are already in code files!
/// .count counts elements .size is an array/vector only implementation?

/**
* A_CONTAINER
*/

/**
* \return Returns true if all elements of the container are the same as \p other's ones or if both containers are empty.
*/
public method isEqualToOther takes thistype other returns boolean
public method isEqual takes $ITERATORTYPE$ position, ARange range returns boolean

/**
* Erases element at position \p position and increases iterator.
* \note Note that the iterator can become invalid by this operation.
*/
public method eraseIncrease takes $ITERATORTYPE$ position returns nothing
/**
* Erases element at position \p position and decreases iterator.
* \note Note that the iterator can become invalid by this operation.
*/
public method eraseDecrease takes $ITERATORTYPE$ position returns nothing

/**
* Inserts all elements from range before position "position".
*/
public method splice takes $ITERATORTYPE$ position, ARange range returns nothing
public method spliceOther takes $ITERATORTYPE$ position, thistype other returns nothing
/**
* Splices all elements from range "range" before first element of container.
*/
public method spliceFront takes ARange range returns nothing
/**
* Splices all elements from container "other" before first element of container.
*/
public method spliceOtherFront takes thistype other returns nothing
/**
* Splices all elements from range "range" after last element of container.
*/
public method spliceBack takes ARange range returns nothing
/**
* Splices all elements from container "other" after last element of container.
*/
public method spliceOtherBack takes thistype other returns nothing
/**
* Returns a newly created range instance which covers the whole range of the container.
* You will have to clear the begin and end iterators yourself!
* \sa ARange#destroyAll
*/
public method range takes nothing returns ARange
/**
* Swaps the containers' contents.
*/
public method swap takes thistype other returns nothing

/**
* Removes all elements contained by other container "other".
*/
public method removeOther takes thistype other returns nothing
/**
* Removes all elements contained by range "range".
*/
public method removeRange takes ARange range returns nothing

/**
* A standard container giving FILO behavior.
*/
//! textmacro A_STACK

/**
* New container structures:
*/

/**
* Extension has to be defined in all container text macros.
* Allows you to be used instead of passing two iterators.
*/
struct ARange
	public method begin takes nothing returns AIteratorInterface
	public method end takes nothing returns AIteratorInterface
	/**
	* Destroys iterators, too!
	*/
	public method destroyAll takes nothing returns nothing
endstruct

public method pushFront takes $VALUETYPE$ value returns nothing
				local $IDENTIFIER$Node node = $IDENTIFIER$Node.create()
				call node.setNext(this.m_front)
				call node.setValue(value)
				set this.m_front = node
			endmethod

			public method popFront takes nothing returns nothing
				local $IDENTIFIER$Node node = this.m_front
				set this.m_front = node.next()
				call node.destroy()
			endmethod

			public method resizeWith takes integer size, $VALUETYPE$ value returns nothing
			endmethod

			public method resize takes integer size returns nothing
				call this.resizeValue($NULLVALUE$)
			endmethod

			public method reverse takes nothing returns nothing
			endmethod

			public method removeIf takes $FUNCTIONINTERFACESPREFIX$UnaryPredicate predicate returns nothing
			endmethod

			public method remove takes $VALUETYPE$ value returns nothing
			endmethod

			public method sort takes $FUNCTIONINTERFACESPREFIX$BinaryPredicate comparator returns nothing
			endmethod

			/**
			* \p range First element after beginning of range until the end of range is removed (end of range is also removed).
			*/
			public method eraseRange takes ASimpleRange range returns nothing
				local $IDENTIFIER$Node node
				local $IDENTIFIER$Node nextNode
				local boolean extCondition
				if (not range.isValid()) then
					return
				endif
				set node = range.begin.node()
				set nextNode = node.next()
				loop
					exitwhen (nextNode == 0)
					// reached back
					if (nextNode == this.m_back) then
						set this.m_back = node
						call nextNode.destroy()
						exitwhen (true)
					endif
					call node.setNext(nextNode.next())
					set exitCondition = nextNode == range.end.node()
					call nextNode.destroy()
					exitwhen (exitCondition)
					set nextNode = node.next()
				endloop
			endmethod

			public method erase takes $IDENTIIER$Iterator position returns nothing
				local $IDENTIFIER$Iterator end = this.end()
				local ASimpleRange range = ASimpleRange.create(position, end)
				call this.eraseRange(range)
				call range.destroy()
				call end.destroy()
			endmethod

			/**
			* Remove consecutive duplicate elements.
			* For each consecutive set of elements with the same value, remove all but the first one. Remaining elements stay in list order. Note that this function only erases the elements, and that if the elements themselves are pointers, the pointed-to memory is not touched in any way. Managing the pointer is the user's responsibility.
			*/
			public method unique takes nothing returns nothing

			endmethod


/**
* New container text macros:
*/
//! textmacro A_ARRAY takes STRUCTPREFIX, NAME, ELEMENTTYPE, NULLVALUE, STRUCTSPACE, NODESPACE, ITERATORSPACE
//! textmacro A_BITSET takes STRUCTPREFIX, NAME, ELEMENTTYPE, NULLVALUE, STRUCTSPACE, NODESPACE, ITERATORSPACE
/**
* A standard container giving FIFO behavior.
*/
//! textmacro A_QUEUE takes STRUCTPREFIX, NAME, ELEMENTTYPE, NULLVALUE, STRUCTSPACE, NODESPACE, ITERATORSPACE
/**
* A standard container made up of unique keys
*/
//! textmacro A_SET takes STRUCTPREFIX, NAME, ELEMENTTYPE, NULLVALUE, STRUCTSPACE, NODESPACE, ITERATORSPACE
//! textmacro A_PAIR
//! textmacro A_TUPLE takes STRUCTPREFIX, NAME, ELEMENTTYPE, NULLVALUE, STRUCTSPACE, NODESPACE, ITERATORSPACE

/**
* Those containers create derived structures which extend the base structure by some new methods or conditions.
*/
//! textmacro A_SORTED takes STRUCTPREFIX, NAME, BASENAME, ELEMENTTYPE, NULLVALUE, CONDITION
//! textmacro A_NUMERIC takes STRUCTPREFIX, NAME, BASENAME, ELEMENTTYPE, NULLVALUE

/**
 * Bidrectional maps contain ordered values ordered by both element types.
 * Therefore it provides methods such as "findLeft" and "findRight" but "find" (which uses left/first element type as key by default) as well.
 */
//! textmacro A_BIMAP takes STRUCTPREFIX, NAME, BASENAME, ELEMENTTYPE1, NULLVALUE1, LESSTHAN1, ELEMENTTYPE2, NULLVALUE2, LESSTHAN2