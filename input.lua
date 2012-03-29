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

local core = require((...):match("(.-)[^%.]+$") .. 'core')

return function(info, x,y,w,h, widgetHit, draw)
	info.text = info.text or ""
	info.cursor = math.min(info.cursor or info.text:len(), info.text:len())

	local id = core.generateID()
	core.mouse.updateState(id, widgetHit or core.style.widgetHit, x,y,w,h)
	core.makeCyclable(id)
	if core.isActive(id) then core.setKeyFocus(id) end

	core.registerDraw(id, draw or core.style.Input, info.text, info.cursor, x,y,w,h)
	if not core.hasKeyFocus(id) then return false end

	local changed = false
	-- editing
	if core.keyboard.key == 'backspace' then
		info.text = info.text:sub(1,info.cursor-1) .. info.text:sub(info.cursor+1)
		info.cursor = math.max(0, info.cursor-1)
		changed = true
	elseif core.keyboard.key == 'delete' then
		info.text = info.text:sub(1,info.cursor) .. info.text:sub(info.cursor+2)
		info.cursor = math.min(info.text:len(), info.cursor)
		changed = true
	-- movement
	elseif core.keyboard.key == 'left' then
		info.cursor = math.max(0, info.cursor-1)
	elseif core.keyboard.key == 'right' then
		info.cursor = math.min(info.text:len(), info.cursor+1)
	elseif core.keyboard.key == 'home' then
		info.cursor = 0
	elseif core.keyboard.key == 'end' then
		info.cursor = info.text:len()
	-- input
	elseif core.keyboard.code >= 32 and core.keyboard.code < 127 then
		local left = info.text:sub(1,info.cursor)
		local right =  info.text:sub(info.cursor+1)
		info.text = table.concat{left, string.char(core.keyboard.code), right}
		info.cursor = info.cursor + 1
		changed = true
	end

	return changed
end
