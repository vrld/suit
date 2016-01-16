-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')

return function(core, normal, ...)
	local opt, x,y = core.getOptionsAndSize(...)
	opt.normal = normal or opt.normal or opt[1]
	opt.hovered = opt.hovered or opt[2] or opt.normal
	opt.active = opt.active or opt[3] or opt.hovered
	assert(opt.normal, "Need at least `normal' state image")
	opt.id = opt.id or opt.normal

	opt.state = core:registerMouseHit(opt.id, x,y, function(u,v)
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
	if core:isActive(opt.id) then
		img = opt.active
	elseif core:isHovered(opt.id) then
		img = opt.hovered
	end

	core:registerDraw(opt.draw or function(img,x,y, r,g,b,a)
		love.graphics.setColor(r,g,b,a)
		love.graphics.draw(img,x,y)
	end, img, x,y, love.graphics.getColor())

	return {
		id = opt.id,
		hit = core:mouseReleasedOn(opt.id),
		hovered = core:isHovered(opt.id),
		entered = core:isHovered(opt.id) and not core:wasHovered(opt.id),
		left = not core:isHovered(opt.id) and core:wasHovered(opt.id)
	}
end
