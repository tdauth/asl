library AStructCoreGeneralMap requires AInterfaceCoreGeneralContainer, optional ALibraryCoreDebugMisc

	/**
	 * \author Tamino Dauth
	 * Got some inspiration from <a href="https://en.wikipedia.org/wiki/Standard_Template_Library">C++ STL</a> and <a href="https://en.wikipedia.org/wiki/Std::map">C++ STL class map</a>.
	 * Maps are ordered containers which contain pairs of values and their corresponding keys.
	 * Elements are ordered ascending to their corresponding keys which means that elements with smaller keys will be at the beginning of the map whereas larger keys will be at the end of the map.
	 * Here's a small example how a single map's elements should be ordered after inserting them:
	 * \code
	 * map[2] = 0
	 * map[3] = 1
	 * map[1] = 2
	 * map[4] = 3
	 * \endcode
	 * When iterating the map and printing all elements the order would be:
	 * 2, 0, 1, 3
	 * because of their ascending key order
	 * 1, 2, 3, 4
	 *
	 * When creating a new instance of \ref A_MAP user can define element and key type.
	 * For instance, you can create your custom unit map with string keys for accessing units by name:
	 * \code
	 * library MyLibrary initializer init
	 * //! runtextmacro A_MAP("private", "MyUnitMap", "unit", "string", "null", "null", "AStringComparator", "8192", "20000", "8192")
	 * globals
	 * MyUnitMap units = MyUnitMap.create()
	 * endglobals
	 *
	 * function init takes nothing returns nothing
	 * call MyUnit["Peter"] = gg_unit_n0001
	 * call MyUnit["Heinz"] = gg_unit_n0001
	 * call MyUnit["Franz"] = gg_unit_n0001
	 * endfunction
	 * \endcode
	 * By using methods \ref $STRUCTNAME$.findKey and \ref $STRUCTNAME$.findValue user can get iterator
	 * which can be used to iterate all contained map elements.
	 * Using methods \ref thistype.find you can search for elements by a single key which uses binary search since maps are ordered containers which can be much faster than linear search (e. g. unordered lists).
	 * \param COMPARATOR Less than comparator for keys to order the map.
	 * \sa containers
	 */
	//! textmacro A_MAP takes STRUCTPREFIX, NAME, ELEMENTTYPE, KEYTYPE, NULLVALUE, KEYNULLVALUE, COMPARATOR, STRUCTSPACE, NODESPACE, ITERATORSPACE

		/// @todo Should be a part of \ref $NAME$, vJass bug.
		$STRUCTPREFIX$ function interface $NAME$UnaryPredicate takes $ELEMENTTYPE$ value, $KEYTYPE$ key returns boolean

		/// @todo Should be a part of \ref $NAME$, vJass bug.
		$STRUCTPREFIX$ function interface $NAME$BinaryPredicate takes $ELEMENTTYPE$ value0, $KEYTYPE$ key0, $ELEMENTTYPE$ value1, $KEYTYPE$ key1 returns boolean

		/// @todo Should be a part of \ref $NAME$, vJass bug.
		$STRUCTPREFIX$ function interface $NAME$UnaryFunction takes $ELEMENTTYPE$ value, $KEYTYPE$ key returns nothing

		/// Generator.
		/// Allows filling some elements with the return value.
		/// @todo Should be a part of \ref $NAME$, vJass bug.
		$STRUCTPREFIX$ function interface $NAME$Generator takes nothing returns $ELEMENTTYPE$

		/// @todo Should be a part of \ref $NAME$, vJass bug.
		$STRUCTPREFIX$ function interface $NAME$BinaryOperation  takes $ELEMENTTYPE$ value0, $KEYTYPE$ key0, $ELEMENTTYPE$ value1, $KEYTYPE$ key1 returns $ELEMENTTYPE$

		private struct $NAME$Node[$NODESPACE$]
			private thistype m_next
			private thistype m_previous
			private $KEYTYPE$ m_key
			private $ELEMENTTYPE$ m_data

			public method setNext takes thistype next returns nothing
				set this.m_next = next
			endmethod

			public method next takes nothing returns thistype
				return this.m_next
			endmethod

			public method setPrevious takes thistype previous returns nothing
				set this.m_previous = previous
			endmethod

			public method previous takes nothing returns thistype
				return this.m_previous
			endmethod

			public method setKey takes $KEYTYPE$ key returns nothing
				set this.m_key = key
			endmethod

			public method key takes nothing returns $KEYTYPE$
				return this.m_key
			endmethod

			public method setData takes $ELEMENTTYPE$ data returns nothing
				set this.m_data = data
			endmethod

			public method data takes nothing returns $ELEMENTTYPE$
				return this.m_data
			endmethod

			public method hasNext takes nothing returns boolean
				return this.m_next != 0
			endmethod

			public method hasPrevious takes nothing returns boolean
				return this.m_previous != 0
			endmethod

			public static method create takes nothing returns thistype
				local thistype this = thistype.allocate()
				set this.m_next = 0
				set this.m_previous = 0
				set this.m_key = $KEYNULLVALUE$
				set this.m_data = $NULLVALUE$

				return this
			endmethod

			public static method createWith takes $KEYTYPE$ key, $ELEMENTTYPE$ data returns thistype
				local thistype this = thistype.allocate()
				set this.m_next = 0
				set this.m_previous = 0
				set this.m_key = key
				set this.m_data = data

				return this
			endmethod

			public method onDestroy takes nothing returns nothing
				set this.m_key = $KEYNULLVALUE$
				set this.m_data = $NULLVALUE$
			endmethod
		endstruct

		$STRUCTPREFIX$ struct $NAME$Iterator[$ITERATORSPACE$]
			private $NAME$Node m_node

			/// Required by list struct.
			public method setNode takes $NAME$Node node returns nothing
				set this.m_node = node
			endmethod

			/// Required by list struct.
			public method node takes nothing returns $NAME$Node
				return this.m_node
			endmethod

			public method isValid takes nothing returns boolean
				return not (this.m_node == 0)
			endmethod

			public method hasNext takes nothing returns boolean
				return this.m_node != 0 and this.m_node.next() != 0
			endmethod

			public method hasPrevious takes nothing returns boolean
				return this.m_node != 0 and this.m_node.previous() != 0
			endmethod

			/// Similar to C++'s ++ iterators operator.
			public method next takes nothing returns nothing
				if (this.m_node == 0) then
					return
				endif

				set this.m_node = this.m_node.next()
			endmethod

			/// Similar to C++'s -- iterators operator.
			public method previous takes nothing returns nothing
				if (this.m_node == 0) then
					return
				endif

				set this.m_node = this.m_node.next()
			endmethod

			public method setKey takes $KEYTYPE$ key returns nothing
				if (this.m_node == 0) then
					return
				endif
				call this.m_node.setKey(key)
			endmethod

			public method key takes nothing returns $KEYTYPE$
				if (this.m_node == 0) then
					return $KEYNULLVALUE$
				endif
				return this.m_node.key()
			endmethod

			public method setData takes $ELEMENTTYPE$ data returns nothing
				if (this.m_node == 0) then
					return
				endif
				call this.m_node.setData(data)
			endmethod

			public method data takes nothing returns $ELEMENTTYPE$
				if (this.m_node == 0) then
					return $NULLVALUE$
				endif
				return this.m_node.data()
			endmethod

			/**
			* @todo If you want to implement toBack and toFront (like Qt does) you'll have to save parent struct instance ...
			*/

			public static method create takes nothing returns thistype
				local thistype this = thistype.allocate()
				set this.m_node = 0

				return this
			endmethod

			public static method createWith takes $NAME$Node node returns thistype
				local thistype this = thistype.allocate()
				set this.m_node = node

				return this
			endmethod

			public method operator== takes thistype iterator returns boolean
				return this.m_node == iterator.m_node
			endmethod
		endstruct

		$STRUCTPREFIX$ struct $NAME$[$STRUCTSPACE$]
			public static constant string structPrefix = "$STRUCTPREFIX$"
			public static constant string name = "$NAME$"
			public static constant $ELEMENTTYPE$ nullValue = $NULLVALUE$
			public static constant integer structSpace = $STRUCTSPACE$
			public static constant integer nodeSpace = $NODESPACE$
			public static constant integer iteratorSpace = $ITERATORSPACE$
			// members
			private $NAME$Node m_front
			private $NAME$Node m_back
			private integer m_size

			public method begin takes nothing returns $NAME$Iterator
				local $NAME$Iterator begin = $NAME$Iterator.create()
				call begin.setNode(this.m_front)

				return begin
			endmethod

			/// Does not reference the past-end element rather than the last one.
			public method end takes nothing returns $NAME$Iterator
				local $NAME$Iterator end = $NAME$Iterator.create()
				call end.setNode(this.m_back)

				return end
			endmethod

			public method size takes nothing returns integer
				return this.m_size
			endmethod

			public method frontKey takes nothing returns $KEYTYPE$
				if (this.m_front == 0) then
					return $KEYNULLVALUE$
				endif

				return this.m_front.key()
			endmethod

			/**
			 * \return Returns the first element value of list.
			 */
			public method front takes nothing returns $ELEMENTTYPE$
				if (this.m_front == 0) then
					return $NULLVALUE$
				endif

				return this.m_front.data()
			endmethod

			public method backKey takes nothing returns $KEYTYPE$
				if (this.m_back == 0) then
					return $KEYNULLVALUE$
				endif

				return this.m_back.key()
			endmethod

			/**
			 * \return Returns the last element value of list.
			 */
			public method back takes nothing returns $ELEMENTTYPE$
				if (this.m_back == 0) then
					return $NULLVALUE$
				endif

				return this.m_back.data()
			endmethod

			public method empty takes nothing returns boolean
				return this.m_size == 0
			endmethod

			/**
			 * Uses binary search.
			 */
			private method findKeyNodeInRange takes $NAME$Node front, $NAME$Node back, $KEYTYPE$ key returns $NAME$Node
				local $NAME$Node lower = front
				local $NAME$Node upper = back
				local $NAME$Node middle
				local integer range
				local integer i

				loop
					// get range size
					set middle = lower
					set range = 0
					loop
						set range = range + 1
						exitwhen (middle == upper)
						set middle = middle.next()
					endloop
					// get index of middle
					set range = (range + 1) / 2
					// get middle node
					set middle = lower
					set i = 0
					loop
						exitwhen (i == range)
						set middle = middle.next()
						set i = i + 1
					endloop

					// got result
					if (middle.key() == key) then
						return middle
					// no result and we're at the end
					elseif (middle == front or middle == back) then
						return 0
					// less than, changes to new bounds
					elseif ($COMPARATOR$(key, middle.key())) then
						set lower = front
						set upper = middle.previous()
					// greater than, changes to new bounds
					else
						set lower = middle.next()
						set upper = back
					endif
				endloop

				return 0
			endmethod

			public method findInRange takes $NAME$Iterator first, $NAME$Iterator last, $KEYTYPE$ key returns $ELEMENTTYPE$
				local $NAME$Node result = this.findKeyNodeInRange(first.node(), last.node(), key)
				if (result == 0) then
					return $NULLVALUE$
				endif
				return result.data()
			endmethod

			public method find takes $KEYTYPE$ key returns $ELEMENTTYPE$
				local $NAME$Node result = this.findKeyNodeInRange(this.m_front, this.m_back, key)
				if (result == 0) then
					return $NULLVALUE$
				endif
				return result.data()
			endmethod

			/**
			 * Searches the container for key \p key and returns an iterator to it if
			 * found, otherwise it returns 0.
			 * \note As container is ordered this uses binary search and is much faster than \ref $STRUCTNAME$.findValue.
			 * \note Take care of the resulting iterator's destruction if it's not 0!
			 */
			public method findKeyInRange takes $NAME$Iterator first, $NAME$Iterator last, $KEYTYPE$ key returns $NAME$Iterator
				local $NAME$Node result = this.findKeyNodeInRange(first.node(), last.node(), key)
				if (result == 0) then
					return 0
				endif
				return $NAME$Iterator.createWith(result)
			endmethod

			/**
			 * Searches the container for key \p key and returns an iterator to it if
			 * found, otherwise it returns 0.
			 * \note As container is ordered this uses binary search and is much faster than \ref $STRUCTNAME$.findValue.
			 * \note Take care of the resulting iterator's destruction if it's not 0!
			 */
			public method findKey takes $KEYTYPE$ key returns $NAME$Iterator
				local $NAME$Node result = this.findKeyNodeInRange(this.m_front, this.m_back, key)
				if (result == 0) then
					return 0
				endif
				return $NAME$Iterator.createWith(result)
			endmethod

			/**
			 * Slow linear search for value since values are not ordered.
			 */
			public method findValue takes $ELEMENTTYPE$ value returns $NAME$Iterator
				local $NAME$Node node = this.m_front
				local $NAME$Iterator result = 0
				loop
					exitwhen (node == 0)
					if (node.data() == value) then
						set result = $NAME$Iterator.create()
						call result.setNode(node)
						exitwhen (true)
					endif
					set node = node.next()
				endloop
				return result
			endmethod

			public method containsInRange takes $NAME$Iterator first, $NAME$Iterator last, $KEYTYPE$ key returns boolean
				local $NAME$Node result = this.findKeyNodeInRange(first.node(), last.node(), key)
				return not (result == 0)
			endmethod

			public method contains takes $KEYTYPE$ key returns boolean
				local $NAME$Node result = this.findKeyNodeInRange(this.m_front, this.m_back, key)
				return not (result == 0)
			endmethod

			public method countValues takes $ELEMENTTYPE$ value returns integer
				local $NAME$Node node = this.m_front
				local integer result = 0
				loop
					exitwhen (node == 0)
					if (node.data() == value) then
						set result = result + 1
					endif
					set node = node.next()
				endloop
				return result
			endmethod

			public method containsValue takes $ELEMENTTYPE$ value returns boolean
				local $NAME$Node node = this.m_front
				loop
					exitwhen (node == 0)
					if (node.data() == value) then
						return true
					endif
					set node = node.next()
				endloop
				return false
			endmethod

			/**
			 * \note Iterator must point to an element which indeed belongs to the container (not only the same key).
			 */
			public method containsIteratorInRange takes $NAME$Iterator first, $NAME$Iterator last, $NAME$Iterator iterator returns boolean
				local $NAME$Node result = this.findKeyNodeInRange(this.m_front, this.m_back, iterator.key())
				return iterator.node() == result
			endmethod

			/**
			 * \note Iterator must point to an element which indeed belongs to the container (not only the same key).
			 */
			public method containsIterator takes $NAME$Iterator iterator returns boolean
				local $NAME$Node result = this.findKeyNodeInRange(this.m_front, this.m_back, iterator.key())
				return iterator.node() == result
			endmethod

			/**
			 * The map is extended by inserting a new element with value \p value and key \p key.
			 * This effectively increases the container size by 1.
			 * The element can't be inserted if key \p key is already used by another one.
			 * The element's position depends on its key value since it is ordered automatically using \ref $COMPARATOR$ function.
			 * \note This method should use the equal algorithmic functionality as \ref thistype#findNode() which is based on the binary search which has complexity of O(log n).
			 */
			private method insertNode takes $KEYTYPE$ key, $ELEMENTTYPE$ value returns $NAME$Node
				local $NAME$Node node = $NAME$Node.createWith(key, value)
				local $NAME$Node lower = this.m_front
				local $NAME$Node upper = this.m_back
				local $NAME$Node middle
				local integer range
				local integer i

				loop
					// get range size
					set middle = lower
					set range = 0
					loop
						set range = range + 1
						exitwhen (middle == upper)
						set middle = middle.next()
					endloop
					// get index of middle
					set range = (range + 1) / 2
					// get middle node
					set middle = lower
					set i = 0
					loop
						exitwhen (i == range)
						set middle = middle.next()
						set i = i + 1
					endloop

					// same key, do not insert!!!
					if (middle.key() == key) then
						call node.destroy()
						return 0
					// less than, changes to new bounds
					elseif ($COMPARATOR$(key, middle.key())) then
						// insert before front node
						if (middle == this.m_front) then
							call this.m_front.setPrevious(node)
							call node.setNext(this.m_front)
							set this.m_size = this.m_size + 1
							return node
						endif
						set lower = this.m_front
						set upper = middle.previous()
					// greater than, changes to new bounds
					else
						// insert after back node
						if (middle == this.m_back) then
							call this.m_back.setNext(node)
							call node.setPrevious(this.m_back)
							set this.m_size = this.m_size + 1
							return node
						endif

						set lower = middle.next()
						set upper = this.m_back
					endif
				endloop

				call node.destroy()

				return 0
			endmethod

			/**
			 * \copydoc thistype#insertNode
			 * \return Returns true if element has been inserted.
			 */
			public method insert takes $KEYTYPE$ key, $ELEMENTTYPE$ value returns boolean
				return this.insertNode(key, value) != 0
			endmethod

			/**
			 * \copydoc thistype#insertNode
			 * \return Returns iterator to created pair which can point to an invalid pair (0) as well.
			 */
			public method insertIterator takes $KEYTYPE$ key, $ELEMENTTYPE$ value returns $NAME$Iterator
				return $NAME$Iterator.createWith(this.insertNode(key, value))
			endmethod

			private method eraseNumberNode takes $NAME$Node first, $NAME$Node last returns nothing
				local $NAME$Node tmpNode
				loop
					exitwhen (first == 0)
					// check both since it can be front and back at the same time!
					if (first == this.m_front) then
						set this.m_front = first.next()
					endif
					if (first == this.m_back) then
						set this.m_back = first.previous()
					endif
					if (first.next() != 0) then
						call first.next().setPrevious(first.previous())
					endif
					if (first.previous() != 0) then
						call first.previous().setNext(first.next())
					endif
					if (first == last) then
						call first.destroy()
						set first = 0
					else
						set tmpNode = first
						set first = first.next()
						call tmpNode.destroy()
					endif
					set this.m_size = this.m_size -1
				endloop
			endmethod

			/// No reverse erasing.
			public method eraseNumber takes $NAME$Iterator first, $NAME$Iterator last returns nothing
				call this.eraseNumberNode(first.node(), last.node())
			endmethod

			public method erase takes $NAME$Iterator position returns nothing
				call this.eraseNumber(position, position)
			endmethod

			/// All the elements in the map container are dropped: they are removed from the map container, leaving it with a size of 0.
			public method clear takes nothing returns nothing
				call this.eraseNumberNode(this.m_front, this.m_back)
			endmethod

			public method randomValue takes nothing returns $ELEMENTTYPE$
				local integer index
				local integer i
				local $NAME$Iterator iterator
				local $ELEMENTTYPE$ result
				if (this.empty()) then
					return $NULLVALUE$
				endif
				set index = GetRandomInt(0, this.m_size - 1)
				set iterator = this.begin()
				set i = 0
				loop
					exitwhen (i == index)
					call iterator.next()
					set i = i + 1
				endloop
				set result = iterator.data()
				call iterator.destroy()
				return result
			endmethod

			public method randomKey takes nothing returns $KEYTYPE$
				local integer index
				local integer i
				local $NAME$Iterator iterator
				local $KEYTYPE$ result
				if (this.empty()) then
					return $NULLVALUE$
				endif
				set index = GetRandomInt(0, this.m_size - 1)
				set iterator = this.begin()
				set i = 0
				loop
					exitwhen (i == index)
					call iterator.next()
					set i = i + 1
				endloop
				set result = iterator.key()
				call iterator.destroy()
				return result
			endmethod

			public method randomIterator takes nothing returns $NAME$Iterator
				local integer index
				local integer i
				local $NAME$Iterator iterator
				if (this.empty()) then
					return 0
				endif
				set index = GetRandomInt(0, this.m_size - 1)
				set iterator = this.begin()
				set i = 0
				loop
					exitwhen (i == index)
					call iterator.next()
					set i = i + 1
				endloop
				return iterator
			endmethod

			public static method create takes nothing returns thistype
				local thistype this = thistype.allocate()
				set this.m_front = 0
				set this.m_back = 0
				set this.m_size = 0

				return this
			endmethod

			/// Map will be cleared before destruction.
			public method onDestroy takes nothing returns nothing
				call this.clear()
			endmethod

			/**
			 * Similar to \ref thistype.insert().
			 */
			public method operator[]= takes $KEYTYPE$ key, $ELEMENTTYPE$ value returns nothing
				call this.insert(key, value)
			endmethod

			/**
			 * Similar to \ref thistype.find().
			 */
			public method operator[] takes $KEYTYPE$ key returns $ELEMENTTYPE$
				return this.find(key)
			endmethod

			/**
			 * \return Returns true if the map's size is less than \p other's size. Otherwise it returns false.
			 */
			public method operator< takes thistype other returns boolean
				debug if (this == other) then
					debug call Print("Same map.")
				debug endif
				return this.m_size < other.m_size
			endmethod

			public static constant method maxInstances takes nothing returns integer
				return $STRUCTSPACE$
			endmethod
		endstruct

	//! endtextmacro

	function AIntegerComparator takes integer a, integer b returns boolean
		return a < b
	endfunction

	function AHandleComparator takes handle a, handle b returns boolean
		return GetHandleId(a) < GetHandleId(b)
	endfunction

	function AStringComparator takes string a, string b returns boolean
		return StringHash(a) < StringHash(b)
	endfunction

	/**
	 * Default maps with JASS data types.
	 * max instances = required struct space / biggest array member size
	 * 150000 is struct space maximum
	 * max instances = 150000 / 1 = 150000 since there is no array member
	 */
	//! runtextmacro A_MAP("", "AIntegerMap", "integer", "integer", "0", "0", "AIntegerComparator", "150000", "150000", "8192")
static if (DEBUG_MODE) then
	//! runtextmacro A_MAP("", "AUnitMap", "unit", "string", "null", "null", "AStringComparator", "150000", "150000", "8192")
endif

endlibrary