local core = require((...):match("^(.+)%.[^%.]+") .. '.core')

return function(info, x,y, w,h, draw)
	local id = core.generateID()

	core.mouse.updateState(id, x,y,w,h)
	core.makeTabable(id)
	core.registerDraw(id, draw or core.style.Checkbox, info.checked,x,y,w,h)

	local checked = info.checked
	local key = core.keyboard.key
	if core.mouse.releasedOn(id) or
		(core.hasKeyFocus(id) and key == 'return' or key == ' ') then
		info.checked = not info.checked
	end

	return info.checked ~= checked
end

