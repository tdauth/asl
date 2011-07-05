/**
* Changes:
*/

struct AWidget
	// dynamic members
	private AStyle m_style
	private region m_region
	// members
	private ATrackableList m_trackables // several trackables for filling the region
	private trigger m_trackTrigger
	private trigger m_hitTrigger

	public method setStyle takes AStyle style returns nothing
		call this.onChangeStyle.evaluate(style)
		set this.m_style = style
	endmethod

	public method style takes nothing returns AStyle
		return this.m_style
	endmethod

	/**
	* This event method can be used to refresh the widget's properties, fitting in the newly assigned style.
	*/
	public stub method onChangeStyle takes AStyle style returns nothing
	endmethod

	public stub method onShow takes nothing returns nothing
	endmethod

	public stub method onHide takes nothing returns nothing
	endmethod

	public stub method onEnable takes nothing returns nothing
	endmethod

	public stub method onDisable takes nothing returns nothing
	endmethod

	public method enable takes nothing returns nothing
		call EnableTrigger(this.m_trackTrigger)
		call EnableTrigger(this.m_hitTrigger)
		call this.onEnable.evaluate()
	endmethod

	public method disable takes nothing returns nothing
		call this.onDisable.evaluate()
		call DisableTrigger(this.m_trackTrigger)
		call DisableTrigger(this.m_hitTrigger)
	endmethod
endstruct

/**
* Newly introduced structures:
*/

struct ATooltipProperty extends AWidget
	// members
	private AText m_amount
	private AImage m_icon

	public method setAmount takes integer amount returns nothing
		call this.m_amount.setText(I2S(amount))
	endmethod

	public method amount takes nothing returns integer
		return S2I(this.m_amount.text())
	endmethod

	public method setIcon takes string filePath returns nothing
		call this.m_icon.setFilePath(filePath)
	endmethod

	public method icon takes nothing returns string
		return this.m_icon.filePath()
	endmethod
endstruct

struct ATooltipPropertyGold extends ATooltipProperty
endstruct

struct ATooltipPropertyLumber extends ATooltipProperty
endstruct

struct ATooltipPropertyMana extends ATooltipProperty
endstruct

struct ATooltipPropertyStones extends ATooltipProperty
endstruct

/**
* Emulates a tooltip in the corresponding style.
* Since Warcraft 3 has the same tooltip styles for all races, they will all appear equal as long as you're using no customized style.
*/
struct ATooltip extends AFrame
	// static constant members
	public static constant integer propertyGold = 0
	public static constant integer propertyLumber = 1
	public static constant integer propertyMana = 2
	public static constant integer propertyStones = 3
	public static constant integer propertyFood = 4
	public static constant integer maxProperties = 5
	// dynamic members
	private AIntegerList m_properties
	// members
	private AText m_name
	private AText m_tooltip

	public method setName takes string name returns nothing
		call this.m_name.setText(name)
	endmethod

	public method name takes nothing returns string
		return this.m_name.text()
	endmethod

	public method setTooltip takes string tooltip returns nothing
		call this.m_tooltip.setText(tooltip)
	endmethod

	public method tooltip takes nothing returns string
		return this.m_tooltip.text()
	endmethod

	/**
	* \param property Can be \ref thistype#propertyGold, \ref thistype#propertyLumber etc.
	*/
	public method setPropertyAmount takes integer property, integer amount returns nothing
		if (property == thistype.propertyGold) then
			/// \todo Find gold property or add newly created to list.
		elseif (property == thistype.propertyLumber) then
		endif
	endmethod
endstruct

struct AGuiInventorySlot extends AImage
	private AInventoryItemData m_itemData // taken from intentory system
endstruct

struct AGuiInventory extends AFrame
	private AGuiInventorySlot array m_slots[bj_MAX_INVENTORY]
	private ALayout m_layout
endstruct
