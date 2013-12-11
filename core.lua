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

local BASE = (...):match("(.-)[^%.]+$")
local group    = require(BASE .. 'group')
local mouse    = require(BASE .. 'mouse')
local keyboard = require(BASE .. 'keyboard')

--
-- Helper functions
--

-- evaluates all arguments
local function strictAnd(...)
	local n = select("#", ...)
	local ret = true
	for i = 1,n do ret = select(i, ...) and ret end
	return ret
end

local function strictOr(...)
	local n = select("#", ...)
	local ret = false
	for i = 1,n do ret = select(i, ...) or ret end
	return ret
end

--
-- Widget ID
--
local maxid, uids = 0, {}
setmetatable(uids, {__index = function(t, i)
	t[i] = {}
	return t[i]
end})

local function generateID()
	maxid = maxid + 1
	return uids[maxid]
end

--
-- Drawing / Frame update
--
local draw_items = {n = 0}
local function registerDraw(id, f, ...)
	assert(type(f) == 'function' or (getmetatable(f) or {}).__call,
	       'Drawing function is not a callable type!')

	local font = love.graphics.getFont()

	local state = 'normal'
	if mouse.isHot(id) or keyboard.hasFocus(id) then
		state = mouse.isActive(id) and 'active' or 'hot'
	end
	local rest = {n = select('#', ...), ...}
	draw_items.n = draw_items.n + 1
	draw_items[draw_items.n] = function()
		if font then love.graphics.setFont(font) end
		f(state, unpack(rest, 1, rest.n))
	end
end

-- actually update-and-draw
local function draw()
	keyboard.endFrame()
	mouse.endFrame()
	group.endFrame()

	-- save graphics state
	local c = {love.graphics.getColor()}
	local f = love.graphics.getFont()
	local lw = love.graphics.getLineWidth()
	local ls = love.graphics.getLineStyle()

	for i = 1,draw_items.n do draw_items[i]() end

	-- restore graphics state
	love.graphics.setLineWidth(lw)
	love.graphics.setLineStyle(ls)
	if f then love.graphics.setFont(f) end
	love.graphics.setColor(c)

	draw_items.n = 0
	maxid = 0

	group.beginFrame()
	mouse.beginFrame()
	keyboard.beginFrame()
end

--
-- The Module
--
return {
	generateID   = generateID,

	style        = require((...):match("(.-)[^%.]+$") .. 'style-default'),
	registerDraw = registerDraw,
	draw         = draw,

	strictAnd    = strictAnd,
	strictOr     = strictOr,
}
