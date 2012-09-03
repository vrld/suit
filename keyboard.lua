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

local key,code = nil, -1
local focus, lastwidget
local NO_WIDGET = {}

local cycle = {
	-- binding = {key = key, modifier1, modifier2, ...} XXX: modifiers are OR-ed!
	prev = {key = 'tab', 'lshift', 'rshift'},
	next = {key = 'tab'},
}

local function pressed(...)   key, code = ... end
local function setFocus(id)   focus = id end
local function disableFocus() focus = NO_WIDGET end
local function clearFocus()   focus = nil end
local function hasFocus(id)   return id == focus end

local function tryGrab(id)
	if not focus then
		setFocus(id)
	end
end

local function isBindingDown(bind)
	local modifiersDown = #bind == 0 or love.keyboard.isDown(unpack(bind))
	return key == bind.key and modifiersDown
end

local function makeCyclable(id)
	tryGrab(id)
	if hasFocus(id) then
		if isBindingDown(cycle.prev) then
			setFocus(lastwidget)
			key = nil
		elseif isBindingDown(cycle.next) then
			setFocus(nil)
			key = nil
		end
	end
	lastwidget = id
end

local function beginFrame()
	-- for future use?
end

local function endFrame()
	key, code = nil, -1
end

return setmetatable({
	cycle         = cycle,
	pressed       = pressed,
	tryGrab       = tryGrab,
	isBindingDown = isBindingDown,
	setFocus      = setFocus,
	disableFocus  = disableFocus,
	enableFocus   = clearFocus,
	clearFocus    = clearFocus,
	hasFocus      = hasFocus,
	makeCyclable  = makeCyclable,

	beginFrame   = beginFrame,
	endFrame     = endFrame,
}, {__index = function(_,k) return ({key = key, code = code})[k] end})
