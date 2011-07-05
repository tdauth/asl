private constant    integer                 MAX_IMAGES                      = 8190
// Doesnt get rendered
// using this type in CreateImage returns an invalid image (id of -1)
constant    integer                 IMAGE_TYPE_SHADOW               = 0
// Gets drawn above fog of war
constant    integer                 IMAGE_TYPE_SELECTION            = 1
// Gets drawn above fog of war
constant    integer                 IMAGE_TYPE_INDICATOR            = 2
// Gets drawn above fog of war
constant    integer                 IMAGE_TYPE_OCCLUSION_MASK       = 3
// Gets tinted based on time of day ingame.
// Gets drawn below fog of war
constant    integer                 IMAGE_TYPE_UBERSPLAT            = 4
// Doesnt get rendered
constant    integer                 IMAGE_TYPE_TOPMOST              = 5
constant integer MAX_IMAGE_TYPES = 6

/*
 CreateImage                  takes string file, real sizeX, real sizeY, real sizeZ, real posX, real posY, real posZ, real originX, real originY, real originZ, integer imageType returns image
native DestroyImage                 takes image whichImage returns nothing
native ShowImage                    takes image whichImage, boolean flag returns nothing
native SetImageConstantHeight       takes image whichImage, boolean flag, real height returns nothing
native SetImagePosition             takes image whichImage, real x, real y, real z returns nothing
native SetImageColor                takes image whichImage, integer red, integer green, integer blue, integer alpha returns nothing
native SetImageRender               takes image whichImage, boolean flag returns nothing
native SetImageRenderAlways         takes image whichImage, boolean flag returns nothing
native SetImageAboveWater           takes image whichImage, boolean flag, boolean useWaterAlpha returns nothing
native SetImageType                 takes image whichImage, integer imageType returns nothing
*/

private function SetImageRenderWarning takes image whichImage, boolean flag returns nothing
	debug call PrintFunctionError("SetImageRender", "Deprecated.")
endfunction

hook SetImageRender SetImageRenderWarning

/**
 * As data type \ref image does not allow access to many of its initial properties AImage has been introduced as wrapper structure.
 * This structure considers some engine limits (e. g. maximum number of possible image instances) as well.
 */
struct AImage[MAX_IMAGES]
	private image m_image
	private string m_file
	private AVector3 m_size
	private ALocation3 m_position
	private ALocation3 m_origin
	private AColor m_color
	private boolean m_show
	private boolean m_wrap
	private integer m_type
	private boolean m_aboveWater
	private boolean m_useWaterAlpha
	private boolean m_valid

	public static method create takes string file, AVector3 size, ALocation3 position, ALocation3 origin, AColor color, integer imageType returns thistype
		local thistype this
		local image whichImage = CreateImage(path, sizeX, sizeY, sizeZ, posX, posY, posZ, originX, originY, originZ, imageType)
		local integer id = GetHandleId(whichImage)
		if (id < 0) then
			debug call thistype.printStaticMethodError("create", "Invalid file!")
			return 0
		endif
		set this = thistype.allocate()
		set this.m_image = whichImage
		set this.m_file = file
		set this.m_size = size
		set this.m_position = position
		set this.m_origin = origin
		set this.m_color = color
		set this.m_show = false
		set this.m_wrap = false
		set this.m_imageType = imageType
		set this.m_aboveWater = false
		set this.m_useWaterAlpha = false
		set this.m_valid = id >= MAX_IMAGES

		if (not this.m_valid) then
			debug call thistype.printStaticMethodError("create", "Exceeded maximum images!")
		endif

		call this.recolor()

		return this
	endmethod

	// Get Methods

	public method isValid takes nothing returns boolean
		return m_valid
	endmethod

	// Private Proxies

	private method updatePosition takes nothing returns nothing
		call SetImagePosition(this.m_image, this.m_position.x(), this.m_position.y(), 0)
	endmethod

	private method updatePositionZ takes nothing returns nothing
		call SetImageConstantHeight(this.m_image, this.m_wrap, this.m_position.z())
	endmethod

	private method recolor takes nothing returns nothing
		call SetImageColor(this.m_image, this.color().red(), this.color().green(), this.color().blue(), this.color().alpha())
	endmethod

	private method reshow takes nothing returns nothing
		call SetImageRenderAlways(this.m_image, this.isShown())
	endmethod

	private method rewater takes nothing returns nothing
		call SetImageAboveWater(this.m_image, this.m_aboveWater, this.m_useWaterAlpha)
	endmethod

	private method recreate takes nothing returns nothing
		call DestroyImage(this.m_image)
		set this.m_image = CreateImage(this.path(), this.size().x(), this.size().y(), this.size().z(), this.position().x(), this.position().y(), this.position().z(), this.origin().x(), this.origin().y(), this.origin().z(), this.type())
		call this.updatePositionZ()
		call this.recolor()
		call this.reshow()
		call this.rewater()
	endmethod

	// Set Methods

	public method setFile takes string file returns nothing
		set this.m_file = file
		call this.recreate()
	endmethod

	public method setSize takes AVector3 size returns nothing
		set this.m_size = size
		call this.recreate()
	endmethod

	/**
	 * Sets the X/Y/Z position of the provided image. This is the bottom left corner of the image, unless you used values form originX/Y/Z in the constructor or in \ref thistype#setOrigin other than 0, in which case the bottom left corner is moved further into negative X/Y/Z direction.
	 */
	public method setPosition takes ALocation3 position returns nothing
		set this.m_position = position
		call this.updatePosition()
		call this.updatePositionZ()
	endmethod

	public method setOrigin takes ALocation3 origin returns nothing
		set this.m_origin = origin
		call this.recreate()
	endmethod

	public method setColor takes AColor color returns nothing
		set this.m_color = color
		call this.recolor()
	endmethod

	public method show takes boolean show returns nothing
		set this.m_show = show
		call this.reshow()
	endmethod

	public method wrap takes boolean wrap returns nothing
		set this.m_wrap = wrap
		call this.updatePositionZ()
	endmethod

	public method setType takes integer imageType returns nothing
		set this.m_type = imageType
		call SetImageType(this.m_image, imageType)
	endmethod

	/**
	 * Draws the specified image above the water if \p aboveWater is true.
	 * Every image type other than \ref IMAGE_TYPE_SELECTION doesnt seem to appear above water.
	 */
	public method setAboveWater takes boolean aboveWater returns nothing
		set this.m_aboveWater = aboveWater
		call this.rewater()
	endmethod

	/**
	 * Doesn't seem to do much.
	 * \todo Test every possible combination of this flag and image type.
	 */
	public method setUseWaterAlpha takes boolean useWaterAlpha returns nothing
		set this.m_useWaterAlpha = useWaterAlpha
		call this.rewater()
	endmethod

	public method onDestroy takes nothing returns nothing
		call DestroyImage(this.m_image)
		set this.m_image = null
	endmethod
endstruct

