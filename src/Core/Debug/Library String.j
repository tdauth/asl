/// Test of all core string functions.
library ALibraryCoreDebugString requires AStructCoreDebugUnitTest, ALibraryCoreDebugMisc, ACoreString

	//! runtextmacro A_UNIT_TEST("AStringTest")
		private string a
		private string b
		private integer i

		//! runtextmacro A_TEST_CASE_INIT()
			set this.a = ""
			set this.b = ""
			set this.i = 0
		//! runtextmacro A_TEST_CASE_INIT_END()

		//! runtextmacro A_TEST_CASE_CLEAN()
			set this.a = ""
			set this.b = ""
			set this.i = 0
		//! runtextmacro A_TEST_CASE_CLEAN_END()

		//! runtextmacro A_TEST()
			//! runtextmacro A_TEST_CASE("Conversion")

				set this.i = 48
				loop
					exitwhen (this.i == 58)
					//! runtextmacro A_CHECK("AsciiToChar(this.i) == I2S(this.i - 48)")
					set this.i = this.i + 1
				//! runtextmacro A_TEST_CASE_END_LOOP()

				//! runtextmacro A_CHECK_2("StringToPlayerColor(\"ff0000\") == PLAYER_COLOR_RED", "Error in StringToPlayerColor().")
				//! runtextmacro A_CHECK_2("PlayerColorToString(PLAYER_COLOR_BLUE) == \"0000ff\"", "Error in PlayerColorToString().")
				//! runtextmacro A_CHECK_2("HighlightShortcut(\"Oh Lord forgive me!\", 'O', null) == \"|cffffcc00O|rh Lord forgive me!\"", "Error in HighlightShortcut().")
				//! runtextmacro A_CHECK_2("InsertLineBreaks(\"Hey there out in the jungle!\", 4) == \"Hey \nther\ne ou\nt in\n the\njung\nle!\"", "Error in InsertLineBreaks().")
				//! runtextmacro A_CHECK_2("GetTimeString(120) == \"02:00\"", "Error in GetTimeString().")
				//! runtextmacro A_CHECK_2("StringArg(StringArg(IntegerArg(\"You're %i years old and you're called %s. Besides you're %s.\", 0), \"Peter\"), \"nice\") == \"You're 0 years old and you're called Peter. Besides you're nice.\"", "Error in StringArg().")

			//! runtextmacro A_TEST_CASE_END()

			//! runtextmacro A_TEST_CASE("Pool")
				//! runtextmacro A_CHECK_2("IsStringFromCharacterPool(GetRandomCharacter(\"abc\"), \"abc\")", "Error in IsStringFromCharacterPool().")
				//! runtextmacro A_CHECK_2("IsStringAlphabetical(GetRandomAlphabeticalCharacter())", "Error in IsStringAlphabetical().")
				//! runtextmacro A_CHECK_2("IsStringNumeral(GetRandomNumeralCharacter())", "Error in IsStringNumeral().")
				//! runtextmacro A_CHECK_2("IsStringSpecial(GetRandomSpecialCharacter())", "Error in IsStringSpecial().")
				//! runtextmacro A_CHECK_2("IsStringWhiteSpace(GetRandomWhiteSpaceCharacter())", "Error in IsStringWhiteSpace().")
				//! runtextmacro A_CHECK_2("IsStringSign(GetRandomSignCharacter())", "Error in IsStringSign().")
				//! runtextmacro A_CHECK_2("IsStringInteger(\"-23\") and IsStringInteger(\"+23\") and IsStringInteger(\"12\") and (not IsStringInteger(\"34,3\"))", "Error in IsStringInteger().")
				//! runtextmacro A_CHECK_2("IsStringBinary(\"+101\") and IsStringBinary(\"101\") and IsStringBinary(\"-0\") and (not IsStringBinary(\"1201\")) and (not IsStringBinary(\"010\"))", "Error in IsStringBinary().")
				//! runtextmacro A_CHECK_2("IsStringOctal(\"00023\") and IsStringOctal(\"-123\") and IsStringOctal(\"+077\") and (not IsStringOctal(\"2148\"))", "Error in IsStringOctal().")
				//! runtextmacro A_CHECK_2("IsStringHexadecimal(\"+AF23\") and IsStringHexadecimal(\"-acf1034a\") and IsStringHexadecimal(\"-0x1439\") and IsStringHexadecimal(\"0x1AF9\") and (not IsStringHexadecimal(\"0AF21\"))", "Error in IsStringHexadecimal().")
				//! runtextmacro A_CHECK_2("(not IsStringInteger(\"\")) and (not IsStringBinary(\"\")) and (not IsStringOctal(\"\")) and (not IsStringHexadecimal(\"\"))", "Error in empty string string pool test.")

				//! runtextmacro A_CHECK_2("StringTrimLeft(\"  Peter lief heim!  \") == \"Peter lief heim!  \"", "Error in StringTrimLeft().")
				//! runtextmacro A_CHECK_2("StringTrimRight(\"  Peter lief heim!  \") == \"  Peter lief heim!\"", "Error in StringTrimRight().")
				//! runtextmacro A_CHECK_2("StringTrim(\"  Peter lief heim!  \") == \"Peter lief heim!\"", "Error in StringTrim().")

			//! runtextmacro A_TEST_CASE_END()

			//! runtextmacro A_TEST_CASE("Misc")
			/*
				//! runtextmacro A_CHECK("FindString(\"Peter went home!\", \"went\") == 6")
				//! runtextmacro A_CHECK("FindString(\"Peter went home!\", \"leaves\") == -1")

				//! runtextmacro A_CHECK("ReplaceSubString(\"Peter went home!\", 6, \"is at\") == \"Peter is athome!\"") // normal replacement with overriding chars
				//! runtextmacro A_CHECK("ReplaceSubString(\"Peter went home!\", -10, \"Hansi\") == \"Hansi went home!\"") // negative values, replacement should start at 0
				//! runtextmacro A_CHECK("ReplaceSubString(\"Peter went home!\", 2341, \" Besides he lost his keys!\") == \"Peter went home! Besides he lost his keys!\"") // big values, replacement means appending string

				//! runtextmacro A_CHECK("ReplaceString(\"Peter went home!\", \"back\", \"to his mother\") == \"Peter went home!\"") // no changes
				//! runtextmacro A_CHECK("ReplaceString(\"Peter went home!\", \"home\", \"to his mother\") == \"Peter went to his mother!\"") // no override, usual replacement


				//! runtextmacro A_CHECK("RemoveSubString(\"Peter went home!\", 0, 6) == \"went home!\"")
				//! runtextmacro A_CHECK("RemoveSubString(\"Peter went home!\", 0, StringLength(\"Peter went home!\")) == \"\"")
				//! runtextmacro A_CHECK("RemoveSubString(\"Peter went home!\", StringLength(\"Peter went home!\") - 6, 6) == \"Peter went\"")

				//! runtextmacro A_CHECK("RemoveSubString(\"Peter went home!\", -2332, 6) == \"went home!\"")
				//! runtextmacro A_CHECK("RemoveSubString(\"Peter went home!\", -2332, 343435) == \"\"")
				//! runtextmacro A_CHECK("RemoveSubString(\"Peter went home!\", 434, 343435) == \"Peter went home!\"")

				//! runtextmacro A_CHECK("RemoveString(\"Peter went home!\", \"Peter \") == \"went home!\"")
				//! runtextmacro A_CHECK("RemoveString(\"Peter went home!\", \"back\") == \"Peter went home!\"")


				//! runtextmacro A_CHECK("InsertString(\"Peter went home!\", 0, \"Our wonderful \") == \"Our wonderful Peter went home!\"")
				//! runtextmacro A_CHECK("InsertString(\"Peter went home!\", -2323, \"Our wonderful \") == \"Our wonderful Peter went home!\"")
				//! runtextmacro A_CHECK("InsertString(\"Peter went home!\", StringLength(\"Peter went home!\"), \" And this is the end!\") == \"Peter went home! And this is the end!\"")
				//! runtextmacro A_CHECK("InsertString(\"Peter went home!\", 0, \"\") == \"Peter went home!\"")


				// TODO fix/improve/revise and add tests
				//function MoveSubString takes string whichString, integer position, integer length, integer newPosition returns string
				//function MoveString takes string whichString, string movedString, integer newPosition returns string



				//! runtextmacro A_CHECK("ReverseString(\"Peter went home!\") == \"!emoh tnew reteP\"")
				//! runtextmacro A_CHECK("ReverseString(\"\") == \"\"")


				//! runtextmacro A_CHECK("StringMatch(\"Peter went home!\", \"peter went home!\", false)")
				//! runtextmacro A_CHECK("StringMatch(\"Peter went home!\", \"WENT\", false)")
				//! runtextmacro A_CHECK("StringMatch(\"Peter went home!\", \"*WENT*\", false)")
				//! runtextmacro A_CHECK("StringMatch(\"Peter went home!\", \"[P]\", true)")
				//! runtextmacro A_CHECK("not StringMatch(\"Peter went home!\", \"[p]\", true)")
				//! runtextmacro A_CHECK("StringMatch(\"*?[\", \"\\*\\?\\[\", true)")

				//! runtextmacro A_CHECK("StringLeft(\"Peter went home!\", 5) == \"Peter\"")
				//! runtextmacro A_CHECK("StringLeft(\"Peter went home!\", 534) == \"Peter went home!\"")

				//! runtextmacro A_CHECK("StringRight(\"Peter went home!\", 5) == \"home!\"")
				//! runtextmacro A_CHECK("StringRight(\"Peter went home!\", 534) == \"Peter went home!\"")

				//! runtextmacro A_CHECK("StringAppend(\"Peter went home!\", \"\") == \"Peter went home!\"")
				//! runtextmacro A_CHECK("StringAppend(\"Peter went home!\", \"!!\") == \"Peter went home!!!\"")

				//! runtextmacro A_CHECK("StringPrepend(\"Peter went home!\", \"\") == \"Peter went home!\"")
				//! runtextmacro A_CHECK("StringPrepend(\"Peter went home!\", \"Our wonderful \") == \"Our wonderful Peter went home!\"")

				//! runtextmacro A_CHECK("StringRepeated(\"Peter went home!\", 0) == \"\"")
				//! runtextmacro A_CHECK("StringRepeated(\"Peter went home!\", -2334) == \"\"")
				//! runtextmacro A_CHECK("StringRepeated(\"Peter went home!\", 1) == \"Peter went home!\"")

				//! runtextmacro A_CHECK("StringResize(\"Peter went home!\", 5) == \"Peter\"")
				//! runtextmacro A_CHECK("StringResize(\"Peter went home!\", StringLength(\"Peter went home!\") + 4) == \"Peter went home!    \"")
				//! runtextmacro A_CHECK("StringResize(\"Peter went home!\", 0) == \"\"")
				//! runtextmacro A_CHECK("StringResize(\"Peter went home!\", -123) == \"\"")

				//! runtextmacro A_CHECK("StringTruncate(\"Peter went home!\", 0) == \"\"")
				//! runtextmacro A_CHECK("StringTruncate(\"Peter went home!\", -332) == \"\"")
				//! runtextmacro A_CHECK("StringTruncate(\"Peter went home!\", 6) == \"went home!\"")
				//! runtextmacro A_CHECK("StringTruncate(\"Peter went home!\", 2342) == \"\"")
				*/
			//! runtextmacro A_TEST_CASE_END()

			//! runtextmacro A_TEST_CASE("Format")
				//! runtextmacro A_CHECK("Format(\"Hallo %1%, wie heißt du? Du bist %2%!!!!\").s(\"Peter\").s(\"nett\").result() == \"Hallo Peter, wie heißt du? Du bist nett!!!!\"")
			//! runtextmacro A_TEST_CASE_END()

		//! runtextmacro A_TEST_END()

	//! runtextmacro A_UNIT_TEST_END()

	function AStringDebug takes nothing returns nothing
		//! runtextmacro A_TEST_RUN("AStringTest")
		//! runtextmacro A_TEST_PRINT("AStringTest")
	endfunction

endlibrary