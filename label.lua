-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')
local core = require(BASE .. 'core')

return function(text, ...)
	local opt, x,y,w,h = core.getOptionsAndSize(...)
	opt.id = opt.id or text
	opt.font = opt.font or love.graphics.getFont()

	w = w or opt.font:getWidth(text) + 4
	h = h or opt.font:getHeight() + 4

	core.registerHitbox(opt.id, x,y,w,h)
	core.registerDraw(core.theme.Label, text, opt, x,y,w,h)

	return {
		id = opt.id,
		hit = core.mouseReleasedOn(opt.id),
		hovered = core.isHot(opt.id),
		entered = core.isHot(opt.id) and not core.wasHot(opt.id),
		left = not core.isHot(opt.id) and core.wasHot(opt.id)
	}
end
