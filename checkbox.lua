-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')

return function(core, checkbox, ...)
	local opt, x,y,w,h = core.getOptionsAndSize(...)
	opt.id = opt.id or checkbox
	opt.font = opt.font or love.graphics.getFont()

	w = w or (opt.font:getWidth(checkbox.text) + opt.font:getHeight() + 4)
	h = h or opt.font:getHeight() + 4

	opt.state = core:registerHitbox(opt.id, x,y,w,h)
	local hit = core:mouseReleasedOn(opt.id)
	if hit then
		checkbox.checked = not checkbox.checked
	end
	core:registerDraw(opt.draw or core.theme.Checkbox, checkbox, opt, x,y,w,h)

	return {
		id = opt.id,
		hit = hit,
		hovered = core:isHovered(opt.id),
		entered = core:isHovered(opt.id) and not core:wasHovered(opt.id),
		left = not core:isHovered(opt.id) and core:wasHovered(opt.id)
	}
end
