local core = require((...):match("^(.+)%.[^%.]+") .. '.core')

return function(info, x,y,w,h, draw)
	info.text = info.text or ""
	info.cursor = math.min(info.cursor or info.text:len(), info.text:len())

	local id = core.generateID()
	core.mouse.updateState(id, x,y,w,h)
	core.makeTabable(id)
	if core.isActive(id) then core.setKeyFocus(id) end

	core.registerDraw(id, draw or core.style.Input, info.text, info.cursor, x,y,w,h)

	local changed = false
	-- editing
	if core.keyboard.key == 'backspace' then
		info.text = info.text:sub(1,info.cursor-1) .. info.text:sub(info.cursor+1)
		info.cursor = math.max(0, info.cursor-1)
		changed = true
	elseif core.keyboard.key == 'delete' then
		info.text = info.text:sub(1,info.cursor) .. info.text:sub(info.cursor+2)
		info.cursor = math.min(info.text:len(), info.cursor)
		changed = true
	-- movement
	elseif core.keyboard.key == 'left' then
		info.cursor = math.max(0, info.cursor-1)
	elseif core.keyboard.key == 'right' then
		info.cursor = math.min(info.text:len(), info.cursor+1)
	elseif core.keyboard.key == 'home' then
		info.cursor = 0
	elseif core.keyboard.key == 'end' then
		info.cursor = info.text:len()
	-- input
	elseif core.keyboard.code >= 32 and core.keyboard.code < 127 then
		local left = info.text:sub(1,info.cursor)
		local right =  info.text:sub(info.cursor+1)
		info.text = table.concat{left, string.char(core.keyboard.code), right}
		info.cursor = info.cursor + 1
		changed = true
	end

	return changed
end
