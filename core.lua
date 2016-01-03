-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')
local theme = require(BASE..'theme')

-- helper
local function getOptionsAndSize(opt, ...)
	if type(opt) == "table" then
		return opt, ...
	end
	return {}, opt, ...
end

-- gui state
local hot, hot_last, active
local NONE = {}

local function anyHot()
	return hot ~= nil
end

local function isHot(id)
	return id == hot
end

local function wasHot(id)
	return id == hot_last
end

local function isActive(id)
	return id == active
end

-- mouse handling
local mouse_x, mouse_y, mouse_button_down = 0,0, false
local function mouseInRect(x,y,w,h)
	return not (mouse_x < x or mouse_y < y or mouse_x > x+w or mouse_y > y+h)
end

local function registerMouseHit(id, ul_x, ul_y, hit)
	if hit(mouse_x - ul_x, mouse_y - ul_y) then
		hot = id
		if active == nil and mouse_button_down then
			active = id
		end
	end
end

local function registerHitbox(id, x,y,w,h)
	return registerMouseHit(id, x,y, function(x,y)
		return x >= 0 and x <= w and y >= 0 and y <= h
	end)
end

local function mouseReleasedOn(id)
	return not mouse_button_down and isActive(id) and isHot(id)
end

local function updateMouse(x, y, button_down)
	mouse_x, mouse_y, mouse_button_down = x,y, button_down
end

local function getMousePosition()
	return mouse_x, mouse_y
end

-- keyboard handling
local key_down, textchar, keyboardFocus
local function getPressedKey()
	return key_down, textchar
end

local function keypressed(key)
	key_down = key
end

local function textinput(char)
	textchar = char
end

local function grabKeyboardFocus(id)
	if isActive(id) then
		keyboardFocus = id
		if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
			if id == NONE then
				love.keyboard.setTextInput( false )
			else
				love.keyboard.setTextInput( true )
			end
		end
	end
end

local function hasKeyboardFocus(id)
	return keyboardFocus == id
end

local function keyPressedOn(id, key)
	return hasKeyboardFocus(id) and key_down == key
end

-- state update
local function enterFrame()
	hot_last, hot = hot, nil
	updateMouse(love.mouse.getX(), love.mouse.getY(), love.mouse.isDown(1))
	key_down, textchar = nil, ""
	grabKeyboardFocus(NONE)
end

local function exitFrame()
	if not mouse_button_down then
		active = nil
	elseif active == nil then
		active = NONE
	end
end

-- draw
local draw_queue = {n = 0}

local function registerDraw(f, ...)
	local args = {...}
	local nargs = select('#', ...)
	draw_queue.n = draw_queue.n + 1
	draw_queue[draw_queue.n] = function()
		f(unpack(args, 1, nargs))
	end
end

local function draw()
	exitFrame()
	for i = 1,draw_queue.n do
		draw_queue[i]()
	end
	draw_queue.n = 0
	enterFrame()
end

local module = {
	getOptionsAndSize = getOptionsAndSize,

	anyHot = anyHot,
	isHot = isHot,
	wasHot = wasHot,
	isActive = isActive,

	mouseInRect = mouseInRect,
	registerHitbox = registerHitbox,
	registerMouseHit = registerMouseHit,
	mouseReleasedOn = mouseReleasedOn,
	updateMouse = updateMouse,
	getMousePosition = getMousePosition,

	getPressedKey = getPressedKey,
	keypressed = keypressed,
	textinput = textinput,
	grabKeyboardFocus = grabKeyboardFocus,
	hasKeyboardFocus = hasKeyboardFocus,
	keyPressedOn = keyPressedOn,

	enterFrame = enterFrame,
	exitFrame = exitFrame,
	registerDraw = registerDraw,
	theme = theme,
	draw = draw,
}
theme.core = module
return module
