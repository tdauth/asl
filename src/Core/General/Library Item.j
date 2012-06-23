library ALibraryCoreGeneralItem

	/**
	 * Data which cannot be copied by this function:
	 * <ul>
	 * <li>if item is dropped on death - \ref SetItemDropOnDeath()</li>
	 * <li>if item is droppable - \ref SetItemDroppable()</li>
	 * <li>item drop id - \ref SetItemDropID()</li>
	 * </ul>
	 * \author Tamino Dauth
	 * \sa CopyItem()
	 * \sa CopyUnit()
	 */
	function CopyItemToItem takes item whichItem, item result returns nothing
		local player owner
		call SetItemCharges(result, GetItemCharges(whichItem))
		call SetItemInvulnerable(result, IsItemInvulnerable(whichItem))
		call SetWidgetLife(result, GetWidgetLife(whichItem))
		call SetItemPawnable(result, IsItemPawnable(whichItem))
		if (IsItemOwned(whichItem)) then
			set owner = GetItemPlayer(whichItem)
			call SetItemPlayer(result, owner, true)
			set owner = null
		endif
		call SetItemVisible(result, IsItemVisible(whichItem))
		call SetItemUserData(result, GetItemUserData(whichItem))
	endfunction

	/**
	 * Creates a copy of item \p whichItem at position with coordinates \p x and \p y.
	 * \author Tamino Dauth
	 * \sa CopyItemToItem()
	 */
	function CopyItem takes item whichItem, real x, real y returns item
		local item result = CreateItem(GetItemTypeId(whichItem), x, y)
		call CopyItemToItem(whichItem, result)
		return result
	endfunction

	/**
	* \return Returns name of item type \p itemTypeId.
	* \author Tamino Dauth
	*/
	function GetItemTypeIdName takes integer itemTypeId returns string
		local item whichItem = CreateItem(itemTypeId, 0.0, 0.0)
		local string result = GetItemName(whichItem)
		call RemoveItem(whichItem)
		set whichItem = null
		return result
	endfunction

endlibrary