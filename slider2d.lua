local core = require((...):match("^(.+)%.[^%.]+") .. '.core')

return function(info, x,y,w,h, draw)
	assert(type(info) == 'table' and type(info.value) == "table", "Incomplete slider value info")
	info.min = info.min or {x = 0, y = 0}
	info.max = info.max or {x = math.max(info.value.x or 0, 1), y = math.max(info.value.y or 0, 1)}
	info.step = info.step or {x = (info.max.x - info.min.x)/50, y = (info.max.y - info.min.y)/50}
	local fraction = {
		x = (info.value.x - info.min.x) / (info.max.x - info.min.x),
		y = (info.value.y - info.min.y) / (info.max.y - info.min.y),
	}

	local id = core.generateID()
	core.mouse.updateState(id, x,y,w,h)
	core.makeTabable(id)
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
