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

-- {info = {value = v, min = 0, max = 1, step = (max-min)/20}, vertical = boolean, pos = {x, y}, size={w, h}, widgetHit=widgetHit, draw=draw}
return function(w)
	assert(type(w) == 'table' and type(w.info) == "table" and w.info.value, "Invalid argument.")
	w.info.min = w.info.min or 0
	w.info.max = w.info.max or math.max(w.info.value, 1)
	w.info.step = w.info.step or (w.info.max - w.info.min) / 20
	local fraction = (w.info.value - w.info.min) / (w.info.max - w.info.min)

	local id = core.generateID()
	local pos, size = group.getRect(w.pos, w.info.size)

	mouse.updateWidget(id, pos, size, w.widgetHit)
	keyboard.makeCyclable(id)

	-- mouse update
	local changed = false
	if mouse.isActive(id) then
		keyboard.setFocus(id)
		if w.vertical then
			fraction = math.min(1, math.max(0, (pos[2] - mouse.y + size[2]) / size[2]))
		else
			fraction = math.min(1, math.max(0, (mouse.x - pos[1]) / size[1]))
		end
		local v = fraction * (w.info.max - w.info.min) + w.info.min
		if v ~= w.info.value then
			w.info.value = v
			changed = true
		end
	end

	-- keyboard update
	if keyboard.hasFocus(id) then
		local keys = w.vertical and {'up', 'down'} or {'right', 'left'}
		if keyboard.key == keys[1] then
			w.info.value = math.min(w.info.max, w.info.value + w.info.step)
			changed = true
		elseif keyboard.key == keys[2] then
			w.info.value = math.max(w.info.min, w.info.value - w.info.step)
			changed = true
		end
	end

	core.registerDraw(id, w.draw or core.style.Slider,
		fraction, w.vertical, pos[1],pos[2], size[1],size[2])

	return changed
end
