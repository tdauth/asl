static if (A_RTC) then
//! import "rtc.j"
endif
static if (A_JAPI) then
//! import "japi.j"
endif
//! import "Core/Import.j"
static if (A_SYSTEMS) then
//! import "Systems/Import.j"
endif
static if (DEBUG_MODE) then
//! import "Test/Import.j"
endif

/**
 * \mainpage Advanced Script Libray library
 * \author Tamino Dauth <tamino@cdauth.eu>
 * \library Asl
 * Request this library if you want to use any system of the ASL.
 * The ASL is separated into its core and additonal systems which are optional.
 * To use the systems you have to define \ref A_SYSTEMS as true.
 * Its core provides more abstract types and functions for general use in Warcraft III whereas the systems provide more specific usage, mainly RPG systems.
 * \note Since vJass has no real support for static ifs on import and require statements you cannot choose exactely which libraries you're going to use. Therefore your map script might become very big. We recommend to use <a href="http://www.wc3c.net/showthread.php?t=79326">Wc3mapoptimizer</a> to decrease the map's size and increase code performance.
 * \sa ACore
 * \if A_SYSTEMS
 * \sa ASystems
 * \endif

 * \defgroup japi jAPI
 * The <a href="http://www.wc3c.net/showthread.php?t=79652">jAPI</a> has been created to support various new JASS natives.
 * Unfortunately, jAPI doesn't seem to be maintained anymore and therefore only works with older versions of Warcraft III: The Frozen Throne up to 1.21b (just like <a href="http://www.wc3c.net/showthread.php?t=86652">war3err</a>.
 * Amongst some native container functions they provide stop watch natives which can be used for benchmarks, probably more exact than using \ref timer.
 * \ref japi.j contains all natives declarations. To enable ASL's jAPI support which means
 * that the ASL itself uses jAPI's natives in \ref ABenchmark, you have to define \ref A_JAPI as true.
 * \ref Asl.useJapi() returns the same result. \ref Asl.japiVersion() returns the supported jAPI version as string.
 * \note If you want to have support for the current version of Warcraft III: The Frozen Throne, please use \ref RtC.

 * \defgroup rtc RtC
 * <a href=http://www.wc3c.net/showthread.php?t=109255>Reinventing the Craft</a> (also refered as nAPI) provides some of the natives provided by \ref japi but in addition much more
 * like string, bit and mouse natives.
 * Checkout file \ref rtc.j to get a list of all natives and constants provided by RtC.
 * The following list shows which functions and structures use RtC natives if enabled:
 * <ul>
 * <li>\ref ABenchmark </li>
 * <li>\ref FindString() </li>
 * <li>\ref ReplaceString() </li>
 * <li>\ref AMovement -> only if \ref A_FPS_MOVEMENT is enabled as well</li>
 * </ul>
 * \note There had been another version of the project with its own <a href="http://www.hiveworkshop.com/forums/reinventing-craft-458/">board<a> which is obsolete now but contains some interesting FPS code examples.

 * \defgroup war3err war3err
 * If game is started with <a href="http://www.wc3c.net/showthread.php?t=86652">war3err</a> debugging support, you can use some more functions for better debugging.
 *
 * \defgroup nativedebug Native debugging
 * If global constant \ref A_DEBUG_NATIVES is set to true and script has been compiled in debug mode, some JASS natives will be debugged due to usual issues
 * of Warcraft III's interpreter.
 * Debugging is realized by using function hooks.
 * \note You can check out all known native bugs on <a href="http://www.wc3c.net/showthread.php?t=80693">Wc3C.net<a> or <a href="http://mappedia.de/Liste_bekannter_Fehler">Mappedia (German)</a>.
 */
library Asl requires ACore, optional ASystems, optional ATest
endlibrary