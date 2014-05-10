--[[
Copyright (c) 2012 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local _M -- holds the module. needed to make widgetHit overridable

local x,y = 0,0
local down, downLast = false, false
local hot, active = nil, nil
local NO_WIDGET = {}
local function _NOP_() end

local function widgetHit(mouse, pos, size)
	return mouse[1] >= pos[1] and mouse[1] <= pos[1] + size[1] and
	       mouse[2] >= pos[2] and mouse[2] <= pos[2] + size[2]
end

local function setHot(id)    hot = id end
local function setActive(id) active = id end
local function isHot(id)     return id == hot end
local function isActive(id)  return id == active end
local function getHot()      return hot end

local function updateWidget(id, pos, size, hit)
	hit = hit or _M.widgetHit

	if hit({x,y}, pos, size) then
		setHot(id)
		if not active and down then
			setActive(id)
		end
	end
end

local function releasedOn(id)
	return not down and isHot(id) and isActive(id) and downLast
end

local function beginFrame()
	hot = nil
	x,y = _M.getMousePosition()
	downLast = down
	down = false
	for _,btn in ipairs{'l', 'm', 'r'} do
		down = down or (love.mouse.isDown(btn) and btn)
	end
end

local function endFrame()
	if not down then -- released
		setActive(nil)
	elseif not active then -- clicked outside
		setActive(NO_WIDGET)
	end
end

local function disable()
	_M.beginFrame   = _NOP_
	_M.endFrame     = _NOP_
	_M.updateWidget = _NOP_
end

local function enable()
	_M.beginFrame   = beginFrame
	_M.endFrame     = endFrame
	_M.updateWidget = updateWidget
end

_M = {
	widgetHit    = widgetHit,
	setHot       = setHot,
	getHot       = getHot,
	setActive    = setActive,
	isHot        = isHot,
	isActive     = isActive,
	updateWidget = updateWidget,
	releasedOn   = releasedOn,

	beginFrame   = beginFrame,
	endFrame     = endFrame,

	disable      = disable,
	enable       = enable,
        getMousePosition = love.mouse.getPosition
}

-- metatable provides getters to x, y and down
return setmetatable(_M, {__index = function(_,k) return ({x = x, y = y, down = down})[k] end})
