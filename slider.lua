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
	assert(type(info) == 'table' and info.value, "Incomplete slider value info")
	info.min = info.min or 0
	info.max = info.max or math.max(info.value, 1)
	info.step = info.step or (info.max - info.min) / 50
	local fraction = (info.value - info.min) / (info.max - info.min)

	local id = core.generateID()
	core.mouse.updateState(id, widgetHit or core.style.widgetHit, x,y,w,h)
	core.makeCyclable(id)
	core.registerDraw(id,draw or core.style.Slider, fraction, x,y,w,h, info.vertical)

	-- mouse update
	if core.isActive(id) then
		core.setKeyFocus(id)
		if info.vertical then
			fraction = math.min(1, math.max(0, (y - core.mouse.y + h) / h))
		else
			fraction = math.min(1, math.max(0, (core.mouse.x - x) / w))
		end
		local v = fraction * (info.max - info.min) + info.min
		if v ~= info.value then
			info.value = v
			return true
		end
	end

	-- keyboard update
	local changed = false
	if core.hasKeyFocus(id) then
		local keys = info.vertical and {'up', 'down'} or {'right', 'left'}
		if core.keyboard.key == keys[1] then
			info.value = math.min(info.max, info.value + info.step)
			changed = true
		elseif core.keyboard.key == keys[2] then
			info.value = math.max(info.min, info.value - info.step)
			changed = true
		end
	end

	return changed
end
