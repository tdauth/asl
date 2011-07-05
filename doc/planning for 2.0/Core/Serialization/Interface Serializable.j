library AInterfaceSerializationSerializable

	/**
	 * Generic interface for serialization of structures.
	 * Serialization can be used for storing data on the hard disk to load it in another mission (campaigns) or simply to store and attach it on objects.
	 */
	interface ASerializable
		public method store takes gamecache cache, string missionKey, string labelPrefix returns nothing
		public method restore takes gamecache cache, string missionKey, string labelPrefix returns nothing
		public method save takes hashtable whichHashtable, integer parentKey, string labelPrefix returns nothing
		public method load takes hashtable whichHashtable, integer parentKey, string labelPrefix returns nothing

		public static method createRestored takes gamecache cache, string missionKey, string labelPrefix returns thistype
		public static method createLoaded takes hashtable whichHashtable, integer parentKey, string labelPrefix returns thistype
	endinterface

endlibrary