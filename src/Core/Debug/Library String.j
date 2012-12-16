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
					debug call Print("I2S: " + I2S(this.i))
					debug call Print("AsciiToChar: " + AsciiToChar(this.i))
					set this.i = this.i + 1
				//! runtextmacro A_TEST_CASE_END_LOOP()

				//! runtextmacro A_CHECK("StringToPlayerColor(\"ff0000\") == PLAYER_COLOR_RED")
				//! runtextmacro A_CHECK("PlayerColorToString(PLAYER_COLOR_BLUE) == \"0000ff\"")
				//! runtextmacro A_CHECK("HighlightShortcut(\"Oh Lord forgive me!\", 'O', null) == \"|cffffcc00O|rh Lord forgive me!\"")
				//! runtextmacro A_CHECK("InsertLineBreaks(\"Hey there out in the jungle!\", 4) == \"Hey \nther\ne ou\nt in\n the\njung\nle!\"")
				//! runtextmacro A_CHECK("GetTimeString(120) == \"02:00\"")
				//! runtextmacro A_CHECK("StringArg(StringArg(IntegerArg(\"You're %i years old and you're called %s. Besides you're %s.\", 0), \"Peter\"), \"nice\") == \"You're 0 years old and you're called Peter. Besides you're nice.\"")

			//! runtextmacro A_TEST_CASE_END()

			//! runtextmacro A_TEST_CASE("Pool")
				//! runtextmacro A_CHECK("IsStringFromCharacterPool(GetRandomCharacter(\"abc\"), \"abc\")")
				//! runtextmacro A_CHECK("IsStringAlphabetical(GetRandomAlphabeticalCharacter())")
				//! runtextmacro A_CHECK("IsStringNumeral(GetRandomNumeralCharacter())")
				//! runtextmacro A_CHECK("IsStringSpecial(GetRandomSpecialCharacter())")
				//! runtextmacro A_CHECK("IsStringWhiteSpace(GetRandomWhiteSpaceCharacter())")
				//! runtextmacro A_CHECK("IsStringSign(GetRandomSignCharacter())")
				//! runtextmacro A_CHECK("IsStringInteger(\"-23\") and IsStringInteger(\"+23\") and IsStringInteger(\"12\") and (not IsStringInteger(\"34,3\")) and (not IsStringInteger(\"034\"))")
				//! runtextmacro A_CHECK("IsStringBinary(\"+101\") and IsStringBinary(\"101\") and IsStringBinary(\"-0\") and (not IsStringBinary(\"1201\")) and (not IsStringBinary(\"010\"))")
				//! runtextmacro A_CHECK("IsStringOctal(\"00023\") and IsStringOctal(\"-123\") and IsStringOctal(\"+077\") and (not IsStringOctal(\"2148\"))")
				//! runtextmacro A_CHECK("IsStringHexadecimal(\"+AF23\") and IsStringHexadecimal(\"-acf1034a\") and IsStringHexadecimal(\"-0x1439\") and IsStringHexadecimal(\"0x1AF9\") and (not IsStringHexadecimal(\"0AF21\"))")
				//! runtextmacro A_CHECK("(not IsStringInteger(\"\")) and (not IsStringBinary(\"\")) and (not IsStringOctal(\"\")) and (not IsStringHexadecimal(\"\"))")

				//! runtextmacro A_CHECK("StringTrimLeft(\"  Peter lief heim!  \") == \"Peter lief heim!  \"")
				//! runtextmacro A_CHECK("StringTrimRight(\"  Peter lief heim!  \") == \"  Peter lief heim!\"")
				//! runtextmacro A_CHECK("StringTrim(\"  Peter lief heim!  \") == \"Peter lief heim!\"")

			//! runtextmacro A_TEST_CASE_END()

			//! runtextmacro A_TEST_CASE("Misc")
				/*
				if (FindString(testString, testParameter0) != -1) then
					debug call Print("FindString - Found it.")
				else
					debug call Print("FindString - Did not find it.")
				endif
				debug call Print("ReplaceSubString - Result is \"" + ReplaceSubString(testString, 0, testParameter0) + "\"")
				debug call Print("ReplaceString - Result is \"" + ReplaceString(testString, testParameter0, testParameter1) + "\"")
				debug call Print("RemoveSubString - Result is \"" + RemoveSubString(testString, 0, StringLength(testParameter0)) + "\"")
				debug call Print("RemoveString - Result is \"" + RemoveString(testString, testParameter0) + "\"")
				debug call Print("InsertString - Result is \"" + InsertString(testString, 0, testParameter0) + "\"")
				debug call Print("MoveSubString - Result is \"" + MoveSubString(testString, 0, StringLength(testParameter0), 0) + "\"") /// \todo Move to old position to prevent crashes
				debug call Print("MoveString - Result is \"" + MoveString(testString, testParameter0, 0) + "\"") /// \todo Move to old position to prevent crashes
				debug call Print("ReverseString - Result is \"" + ReverseString(testString) + "\"")
				debug if (StringMatch(testString, testParameter0, true)) then
					debug call Print("StringMatch - Result is true.")
				debug else
					debug call Print("StringMatch - Result is false.")
				debug endif
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