Add serializable interface:
interface ASerializable
	public method store takes gamecache whichGameCache returns string /// @return Returns mission key
	public method restore takes gamecache whichGameCache, string missionKey returns boolean
	public method save takes hashtable whichHashTable returns integer /// @return Returns parent key
	public method load takes hashtable whichHashTable, integer parentKey returns boolean
endinterface
- add store functionality to AInventory etc.