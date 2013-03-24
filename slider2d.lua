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

-- {info = {value = {x,y}, min = {0,0}, max = {1,1}, step = (max-min)/20}, pos = {x, y}, size={w, h}, widgetHit=widgetHit, draw=draw}
return function(w)
	assert(type(w) == 'table' and type(w.info) == "table" and w.info.value, "Invalid argument.")
	w.info.min = {
		w.info.min and w.info.min[1] or 0,
		w.info.min and w.info.min[2] or 0,
	}
	w.info.max = {
		w.info.max and w.info.max[1] or math.max(1, w.info.value[1]),
		w.info.max and w.info.max[2] or math.max(1, w.info.value[2]),
	}
	w.info.step = {
		w.info.step and w.info.step[1] or (w.info.max[1] - w.info.min[1]) / 20,
		w.info.step and w.info.step[2] or (w.info.max[2] - w.info.min[2]) / 20,
	}

	local fraction = {
		(w.info.value[1] - w.info.min[1]) / (w.info.max[1] - w.info.min[1]),
		(w.info.value[2] - w.info.min[2]) / (w.info.max[2] - w.info.min[2]),
	}

	local id = w.id or core.generateID()
	local pos, size = group.getRect(w.pos, w.size)

	mouse.updateWidget(id, pos, size, w.widgetHit)
	keyboard.makeCyclable(id)

	-- update value
	local changed = false
	if mouse.isActive(id) then
		keyboard.setFocus(id)
		fraction = {
			math.min(1, math.max(0, (mouse.x - pos[1]) / size[1])),
			math.min(1, math.max(0, (mouse.y - pos[2]) / size[2])),
		}
		local v = {
			fraction[1] * (w.info.max[1] - w.info.min[1]) + w.info.min[1],
			fraction[2] * (w.info.max[2] - w.info.min[2]) + w.info.min[2],
		}
		if v[1] ~= w.info.value[1] or v[2] ~= w.info.value[2] then
			w.info.value = v
			changed = true
		end
	end

	if keyboard.hasFocus(id) then
		if keyboard.key == 'down' then
			w.info.value[2] = math.min(w.info.max[2], w.info.value[2] + w.info.step[2])
			changed = true
		elseif keyboard.key == 'up' then
			w.info.value[2] = math.max(w.info.min[2], w.info.value[2] - w.info.step[2])
			changed = true
		end
		if keyboard.key == 'right' then
			w.info.value[1] = math.min(w.info.max[1], w.info.value[1] + w.info.step[1])
			changed = true
		elseif keyboard.key == 'left' then
			w.info.value[1] = math.max(w.info.min[1], w.info.value[1] - w.info.step[1])
			changed = true
		end
	end

	core.registerDraw(id, w.draw or core.style.Slider2D,
		fraction, pos[1],pos[2], size[1],size[2])

	return changed
end
