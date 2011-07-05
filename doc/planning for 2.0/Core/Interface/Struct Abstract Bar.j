library AStructCoreInterfaceAbstractBar

	//! textmacro A_ABSTRACT_BAR takes IDENTIFIER, COORDINATESTYPE, VALUETYPE
		struct $IDENTIIER$
			private $COORDINATESTYPE$ m_x
			private $COORDINATESTYPE$ m_y
			private $COORDINATESTYPE$ m_itemSize

			private $VALUETYPE$ m_value
			private $VALUETYPE$ m_maxValue
			private integer m_length
			private boolean m_horizontal

			public method setX takes $COORDINATESTYPE$ x returns nothing
				if (this.m_x == x) then
					return
				endif
				set this.m_x = x
				call this.refresh()
			endmethod

			public method x takes nothing returns $COORDINATESTYPE$
				return this.m_x
			endmethod

			public method setY takes $COORDINATESTYPE$ y returns nothing
				if (this.m_y == y) then
					return
				endif
				set this.m_y = y
				call this.refresh()
			endmethod

			public method y takes nothing returns $COORDINATESTYPE$
				return this.m_y
			endmethod

			public method setItemSize takes $COORDINATESTYPE$ itemSize returns nothing
				if (this.m_itemSize == itemSize) then
					return
				endif
				set this.m_itemSize = itemSize
				call this.refresh()
			endmethod

			public method itemSize takes nothing returns $COORDINATESTYPE$
				return this.m_itemSize
			endmethod


			public method setValue takes $VALUETYPE$ value returns nothing
				if (this.m_value == value) then
					return
				endif
				set this.m_value = value
				call this.refresh()
			endmethod

			public method value takes nothing returns $VALUETYPE$
				return this.m_value
			endmethod

			public method setMaxValue takes $VALUETYPE$ maxValue returns nothing
				if (this.m_maxValue == maxValue) then
					return
				endif
				set this.m_maxValue = maxValue
				call this.refresh()
			endmethod

			public method maxValue takes nothing returns $VALUETYPE$
				return this.m_maxValue
			endmethod

			public method setLength takes integer length returns nothing
				local integer i
				local $VALUETYPE$ percentage
				if (length < this.m_length) then
					set i = this.m_length - 1
					loop
						exitwhen (i < length)
						call this.remove(i)
						set i = i - 1
					endloop
				elseif (length > this.m_length) then
					set i = this.m_length
					set percentage = this.percentage()
					loop
						exitwhen (i == length)
						call this.update(i, this.itemX(i), this.itemY(i), i <= percentage)
						set i = i + 1
					endloop
				endif
				set this.m_length = length
			endmethod

			public method length takes nothing returns $VALUETYPE$
				return this.m_length
			endmethod

			public method setHorizontal takes boolean horizontal returns nothing
				if (this.m_horizontal == horizontal) then
					return
				endif
				set this.m_horizontal = horizontal
				call this.refresh()
			endmethod

			public method horizontal takes nothing returns boolean
				return this.m_horizontal
			endmethod

			public method percentage takes nothing returns $VALUETYPE$
				return this.value() * 100 / this.maxValue()
			endmethod

			public method itemX takes integer length returns $COORDINATESTYPE$
				set length = Max(this.length() - 1, length)
				if (this.horizontal()) then
					return this.x() + ((length + 1) * this.itemSize())
				else
					return this.x()
				endif
			endmethod

			public method itemY takes integer length returns $COORDINATESTYPE$
				set length = Max(this.length() - 1, length)
				if (not this.horizontal()) then
					return this.y() + ((length + 1) * this.itemSize())
				else
					return this.y()
				endif
			endmethod

			public method itemLocation takes integer length returns location
				return Location(this.itemX(length), this.itemY(length))
			endmethod

			public stub method update takes integer length, $COORDINATESTYPE$ x, $COORDINATESTYPE$ y, boolean colored returns nothing
			endmethod

			public stub method remove takes integer length returns nothing
			endmethod

			private method refresh takes nothing returns nothing
				local integer i = 0
				local $VALUETYPE$ percentage = this.percentage()
				loop
					exitwhen (i == this.length())
					call this.update(i, this.itemX(i), this.itemY(i), i <= percentage)
					set i = i + 1
				endloop
			endmethod
		endstruct
	//! endtextmacro

endlibrary