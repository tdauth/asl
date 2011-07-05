//! import "Core/String/Struct Format.j"
//! import "Core/String/Struct Tokenizer.j"
//! import "Core/String/Library Conversion.j"
//! import "Core/String/Library Pool.j"
//! import "Core/String/Library Misc.j"


/**
TODO add docs below!
native S2I  takes string s returns integer
native S2R  takes string s returns real
native GetHandleId takes handle h returns integer
native SubString takes string source, integer start, integer end returns string
native StringLength takes string s returns integer
native StringCase takes string source, boolean upper returns string
native StringHash takes string s returns integer

native GetLocalizedString takes string source returns string
native GetLocalizedHotkey takes string source returns integer
*/


/**
 * \fn I2S
 * Converts integer value \p i into string value.
 * \param r Integer value which is converted into string value.
 * \return Returns resulting string value.
 * 
 * \fn R2S
 * Converts real value \p r into string value.
 * \param r Real value which is converted into string value.
 * \return Returns resulting string value.
 *
 * \fn R2SW
 * Converts real value \p r into string value using maximum value width \p width and precision \p precision.
 * \param r Real value which is converted into string value.
 * \param width Exact width of the resulting string. If the real number is not that long there will be inserted white-spaces at the beginning of the string value.
 * \param precision Exact precision. If it's higher than actual numbers after the dot there will be inserted 0 values at the end of the string value.
 * \return Returns resulting string value.
 * Examples:  R2SW(1.234, 7, 2) = "   1.23".  R2SW(1.234, 2, 5) = "1.23400".
 *
 * \fn SubString
 * \param start start char position, starts with 0: 0 = first char, \ref StringLength - 1 = last char
 * \param end last char position, starts with 1: 1 = first char, \ref StringLength = last char
 * \sa StringLength
 */
library ACoreString requires AStructCoreStringFormat, AStructCoreStringTokenizer, ALibraryCoreStringConversion, ALibraryCoreStringPool, ALibraryCoreStringMisc
endlibrary