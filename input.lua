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
local core     = require(BASE .. 'core')
local group    = require(BASE .. 'group')
local mouse    = require(BASE .. 'mouse')
local keyboard = require(BASE .. 'keyboard')

-- {info = {text = "", cursor = text:len()}, pos = {x, y}, size={w, h}, widgetHit=widgetHit, draw=draw}
return function(w)
	assert(type(w) == "table" and type(w.info) == "table", "Invalid argument")
	w.info.text = w.info.text or ""
	w.info.cursor = math.min(w.info.cursor or w.info.text:len(), w.info.text:len())

	local id = core.generateID()
	local pos, size = group.getRect(w.pos, w.size)
	mouse.updateWidget(id, pos, size, w.widgetHit)
	keyboard.makeCyclable(id)
	if mouse.isActive(id) then keyboard.setFocus(id) end

	local changed = false
	if not keyboard.hasFocus(id) then
		--[[nothing]]
	-- editing
	elseif keyboard.key == 'backspace' then
		w.info.text = w.info.text:sub(1,w.info.cursor-1) .. w.info.text:sub(w.info.cursor+1)
		w.info.cursor = math.max(0, w.info.cursor-1)
		changed = true
	elseif keyboard.key == 'delete' then
		w.info.text = w.info.text:sub(1,w.info.cursor) .. w.info.text:sub(w.info.cursor+2)
		w.info.cursor = math.min(w.info.text:len(), w.info.cursor)
		changed = true
	-- movement
	elseif keyboard.key == 'left' then
		w.info.cursor = math.max(0, w.info.cursor-1)
	elseif keyboard.key == 'right' then
		w.info.cursor = math.min(w.info.text:len(), w.info.cursor+1)
	elseif keyboard.key == 'home' then
		w.info.cursor = 0
	elseif keyboard.key == 'end' then
		w.info.cursor = w.info.text:len()
	-- info
	elseif keyboard.code >= 32 and keyboard.code < 127 then
		local left = w.info.text:sub(1,w.info.cursor)
		local right =  w.info.text:sub(w.info.cursor+1)
		w.info.text = table.concat{left, string.char(keyboard.code), right}
		w.info.cursor = w.info.cursor + 1
		changed = true
	end

	core.registerDraw(id, w.draw or core.style.Input,
		w.info.text, w.info.cursor, pos[1],pos[2], size[1],size[2])

	return changed
end
