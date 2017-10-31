-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...) .. "."
local suit = require(BASE .. "core")

local instance = suit.new()
return setmetatable({
	_instance = instance,

	new = suit.new,
	getOptionsAndSize = suit.getOptionsAndSize,

	-- core functions
	setHovered = function(...) return instance:setHovered(...) end,
	anyHovered = function(...) return instance:anyHovered(...) end,
	isHovered = function(...) return instance:isHovered(...) end,
	wasHovered = function(...) return instance:wasHovered(...) end,
	anyActive = function(...) return instance:anyActive(...) end,
	setActive = function(...) return instance:setActive(...) end,
	isActive = function(...) return instance:isActive(...) end,
	setHit = function(...) return instance:setHit(...) end,
	anyHit = function(...) return instance:anyHit(...) end,
	isHit = function(...) return instance:isHit(...) end,

	mouseInRect = function(...) return instance:mouseInRect(...) end,
	registerHitbox = function(...) return instance:registerHitbox(...) end,
	registerMouseHit = function(...) return instance:registerMouseHit(...) end,
	mouseReleasedOn = function(...) return instance:mouseReleasedOn(...) end,
	updateMouse = function(...) return instance:updateMouse(...) end,
	getMousePosition = function(...) return instance:getMousePosition(...) end,

	getPressedKey = function(...) return instance:getPressedKey(...) end,
	keypressed = function(...) return instance:keypressed(...) end,
	textinput = function(...) return instance:textinput(...) end,
	textedited = function(...) return instance:textedited(...) end,
	grabKeyboardFocus = function(...) return instance:grabKeyboardFocus(...) end,
	hasKeyboardFocus = function(...) return instance:hasKeyboardFocus(...) end,
	keyPressedOn = function(...) return instance:keyPressedOn(...) end,

	enterFrame = function(...) return instance:enterFrame(...) end,
	exitFrame = function(...) return instance:exitFrame(...) end,
	registerDraw = function(...) return instance:registerDraw(...) end,
	draw = function(...) return instance:draw(...) end,

	-- widgets
	Button = function(...) return instance:Button(...) end,
	ImageButton = function(...) return instance:ImageButton(...) end,
	Label = function(...) return instance:Label(...) end,
	Checkbox = function(...) return instance:Checkbox(...) end,
	Input = function(...) return instance:Input(...) end,
	Slider = function(...) return instance:Slider(...) end,

	-- layout
	layout = instance.layout
}, {
	-- theme
	__newindex = function(t, k, v)
		if k == "theme" then
			instance.theme = v
		else
			rawset(instance, k, v)
		end
	end,
	__index = function(t, k)
		return k == "theme" and instance.theme or rawget(t, k)
	end,
})
