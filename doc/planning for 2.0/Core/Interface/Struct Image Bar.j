library AStructCoreEnvironmentImageBar

	//! textmacro A_IMAGE_BAR takes BASE, COORDINATESTYPE
	struct AImageBar extends $BASE$

		public stub method update takes integer length, $COORDINATESTYPE$ x, $COORDINATESTYPE$ y, boolean colored returns nothing
		endmethod

		public stub method remove takes integer length returns nothing
		endmethod
	endstruct
	//! endtextmacro

endlibrary