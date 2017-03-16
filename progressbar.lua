-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')
local min, max = math.min, math.max;

return function(core, info, ...)
	local opt, x,y,w,h = core.getOptionsAndSize(...)

	opt.id = opt.id or info

	info.min = info.min or min(info.value, 0)
	info.max = info.max or max(info.value, 1)
	info.step = info.step or (info.max - info.min) / 10
	local fraction = (info.value - info.min) / (info.max - info.min)

	opt.state = core:registerHitbox(opt.id, x,y,w,h)

	core:registerDraw(opt.draw or core.theme.ProgressBar, fraction, opt, x,y,w,h)

	return {
		id = opt.id,
		hovered = core:isHovered(opt.id),
		entered = core:isHovered(opt.id) and not core:wasHovered(opt.id),
		left = not core:isHovered(opt.id) and core:wasHovered(opt.id)
	}
end
