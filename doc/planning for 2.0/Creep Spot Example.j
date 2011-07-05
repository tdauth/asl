struct CreepSpotCreep extends AUnitSpawn
	private static AIdTable itemTable = AIdTable.create()
	private static AIdSet itemSet1 = AIdSet.create()
	private static AIdSet itemSet2 = AIdSet.create()
	// second parameter is chance
	private static AItemTypeIdItem itemItem1 = AItemTypeIdItem.create('rde3', 10)
	private static AItemTypeIdItem itemItem2 = AItemTypeIdItem.create('rde2', 20)
	private static AItemTypeIdItem itemItem3 = AItemTypeIdItem.create('rde1', 30)
	private static AItemTypeIdItem itemItem4 = AItemTypeIdItem.createRandom(2, 50)
	private static AItemTypeIdItem itemItem5 = AItemTypeIdItem.createRandom(8, 100)

	public stub method onSpawn takes nothing returns nothing
		local AIntegerSetIterator iterator
		call super.onSpawn()
		// destroy manually added set items
		set iterator = this.getSet().begin()
		loop
			exitwhen (not iterator.isValid())
			call ACreepIdItem(iterator.data()).destroy()
			call iterator.next()
		endloop
		call this.getSet().destroy() // destroy manually added set
		call this.destroy()
	endmethod

	public stub method onSpawnUnit takes unit whichUnit returns nothing
		local AItemDrop itemDrop = AItemDrop.create(whichUnit) // is destroyed automatically when items are created
		call itemDrop.setTable(thistype.itemTable)
	endmethod

	private static method onInit takes nothing returns nothing
		// initialization of default item tables
		call thistype.itemSet1.addItem(thistype.itemItem1)
		call thistype.itemSet1.addItem(thistype.itemItem2)
		call thistype.itemSet1.addItem(thistype.itemItem3)
		call thistype.itemSet1.addItem(thistype.itemItem4)
		call thistype.itemSet2.addItem(thistype.itemItem5)
		call thistype.itemTable.addSet(thistype.itemSet1)
		call thistype.itemTable.addSet(thistype.itemSet2)
	endmethod
endstruct

function CreateMyCreepSpotCreep takes location where, real face returns nothing
	local CreepSpotCreep creep1 = CreepSpotCreep.create() // use custom structure with item drop creation
	local AIdSet creepSet1 = AIdSet.create()
	// second parameter is chance
	local ACreepIdItem creepIdItem1 = ACreepIdItem.create('nwnr', 30)
	local ACreepIdItem creepIdItem2 = ACreepIdItem.create('nhdc', 20)
	local ACreepIdItem creepIdItem3 = ACreepIdItem.createRandom(9, 50) // random creep level 9
	// add items to set
	call creepSet1.addItem(creepIdItem1)
	call creepSet1.addItem(creepIdItem2)
	call creepSet1.addItem(creepIdItem3)
	// assign set to unit spawn and setup parameters
	call creep1.setSet(creepSet1)
	call creep1.setIsInCamp(true) // if unit is in camp its acquire range will be set to 100
	call creep1.setLocation(where)
	call creep1.setFace(face)
	call creep1.setLifePercentage((GetGameDifficulty() + 1) * 25.0) // start hit points depend on game difficulty
	debug call creep1.show() // shows it in debug mode like in World Editor
endfunction