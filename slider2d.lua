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
	assert(type(info) == 'table' and type(info.value) == "table", "Incomplete slider value info")
	info.min = info.min or {x = 0, y = 0}
	info.max = info.max or {x = math.max(info.value.x or 0, 1), y = math.max(info.value.y or 0, 1)}
	info.step = info.step or {x = (info.max.x - info.min.x)/50, y = (info.max.y - info.min.y)/50}
	local fraction = {
		x = (info.value.x - info.min.x) / (info.max.x - info.min.x),
		y = (info.value.y - info.min.y) / (info.max.y - info.min.y),
	}

	local id = core.generateID()
	core.mouse.updateState(id, widgetHit or core.style.widgetHit, x,y,w,h)
	core.makeCyclable(id)
	core.registerDraw(id,draw or core.style.Slider2D, fraction, x,y,w,h)

	-- update value
	if core.isActive(id) then
		core.setKeyFocus(id)
		fraction = {
			x = (core.mouse.x - x) / w,
			y = (core.mouse.y - y) / h,
		}
		fraction.x = math.min(1, math.max(0, fraction.x))
		fraction.y = math.min(1, math.max(0, fraction.y))
		local v = {
			x = fraction.x * (info.max.x - info.min.x) + info.min.x,
			y = fraction.y * (info.max.y - info.min.y) + info.min.y,
		}
		if v.x ~= info.value.x or v.y ~= info.value.y then
			info.value = v
			return true
		end
	end

	local changed = false
	if core.hasKeyFocus(id) then
		if core.keyboard.key == 'down' then
			info.value.y = math.min(info.max.y, info.value.y + info.step.y)
			changed = true
		elseif core.keyboard.key == 'up' then
			info.value.y = math.max(info.min.y, info.value.y - info.step.y)
			changed = true
		end
		if core.keyboard.key == 'right' then
			info.value.x = math.min(info.max.x, info.value.x + info.step.x)
			changed = true
		elseif core.keyboard.key == 'left' then
			info.value.x = math.max(info.min.x, info.value.x - info.step.x)
			changed = true
		end
	end
	return changed
end
