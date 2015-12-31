-- This file is part of QUI, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')
local core = require(BASE .. 'core')

return function(...)
	local opt, x,y,w,h = core.getOptionsAndSize(...)
	opt.normal = opt.normal or opt[1]
	opt.hot = opt.hot or opt[2] or opt.normal
	opt.active = opt.active or opt[3] or opt.hot
	assert(opt.normal, "Need at least `normal' state image")
	opt.id = opt.id or opt.normal

	core.registerMouseHit(opt.id, x,y, function(u,v)
		local id = opt.normal:getData()
		assert(id:typeOf("ImageData"), "Can only use uncompressed images")
		u, v = math.floor(u+.5), math.floor(v+.5)
		if u < 0 or u >= opt.normal:getWidth() or v < 0 or v >= opt.normal:getHeight() then
			return false
		end
		local _,_,_,a = id:getPixel(u,v)
		return a > 0
	end)

	local img = opt.normal
	if core.isHot(opt.id) then
		img = opt.hot
	elseif core.isActive(opt.id) then
		img = opt.active
	end

	core.registerDraw(love.graphics.setColor, 255,255,255)
	core.registerDraw(love.graphics.draw, img, x,y)

	return {
		id = opt.id,
		hit = core.mouseReleasedOn(opt.id),
		hovered = core.isHot(opt.id),
		entered = core.isHot(opt.id) and not core.wasHot(opt.id),
		left = not core.isHot(opt.id) and core.wasHot(opt.id)
	}
end
