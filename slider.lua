-- This file is part of QUI, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')
local core = require(BASE .. 'core')

return function(info, ...)
	local opt, x,y,w,h = core.getOptionsAndSize(...)

	opt.id = opt.id or info

	info.min = info.min or math.min(info.value, 0)
	info.max = info.max or math.max(info.value, 1)
	info.step = info.step or (info.max - info.min) / 10
	local fraction = (info.value - info.min) / (info.max - info.min)
	local value_changed = false

	core.registerHitbox(opt.id, x,y,w,h)

	if core.isActive(opt.id) then
		-- mouse update
		local mx,my = core.getMousePosition()
		if opt.vertical then
			fraction = math.min(1, math.max(0, (y+h - my) / h))
		else
			fraction = math.min(1, math.max(0, (mx - x) / w))
		end
		local v = fraction * (info.max - info.min) + info.min
		if v ~= info.value then
			info.value = v
			value_changed = true
		end

		-- keyboard update
		local key_up = opt.vertical and 'up' or 'right'
		local key_down = opt.vertical and 'down' or 'left'
		if core.getPressedKey() == key_up then
			info.value = math.min(info.max, info.value + info.step)
			value_changed = true
		elseif core.getPressedKey() == key_down then
			info.value = math.max(info.min, info.value - info.step)
			value_changed = true
		end
	end

	core.registerDraw(core.theme.Slider, fraction, opt, x,y,w,h)

	return {
		id = opt.id,
		hit = core.mouseReleasedOn(opt.id),
		changed = value_changed,
		hovered = core.isHot(opt.id),
		entered = core.isHot(opt.id) and not core.wasHot(opt.id),
		left = not core.isHot(opt.id) and core.wasHot(opt.id)
	}
end
