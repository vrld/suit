-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')

return function(core, info, ...)
	local opt, x,y,w,h = core.getOptionsAndSize(...)

	opt.id = opt.id or info

	info.min = info.min or math.min(info.value, 0)
	info.max = info.max or math.max(info.value, 1)
	info.step = info.step or (info.max - info.min) / 10
	local fraction = (info.value - info.min) / (info.max - info.min)
	local value_changed = false

	opt.state = core:registerHitbox(opt.id, x,y,w,h)

	if core:isActive(opt.id) then
		-- mouse update
		local mx,my = core:getMousePosition()
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
		if core:getPressedKey() == key_up then
			info.value = math.min(info.max, info.value + info.step)
			value_changed = true
		elseif core:getPressedKey() == key_down then
			info.value = math.max(info.min, info.value - info.step)
			value_changed = true
		end
	end

	core:registerDraw(opt.draw or core.theme.Slider, fraction, opt, x,y,w,h)

	return {
		id = opt.id,
		hit = core:mouseReleasedOn(opt.id),
		changed = value_changed,
		hovered = core:isHovered(opt.id),
		entered = core:isHovered(opt.id) and not core:wasHovered(opt.id),
		left = not core:isHovered(opt.id) and core:wasHovered(opt.id)
	}
end
