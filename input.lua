-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')
local utf8 = require 'utf8'

local function split(str, pos)
	local offset = utf8.offset(str, pos) or 0
	return str:sub(1, offset-1), str:sub(offset)
end

return function(core, input, ...)
	local font = love.graphics.getFont()
	local opt, x,y,w,h = core.getOptionsAndSize(...)
	opt.id = opt.id or input
	opt.font = opt.font or love.graphics.getFont()

	local text_width = opt.font:getWidth(input.text)
	w = w or text_width + 4
	h = h or opt.font:getHeight() + 4

	input.text = input.text or ""
	input.cursor = math.max(1, math.min(utf8.len(input.text)+1, input.cursor or utf8.len(input.text)+1))
	-- cursor is position *before* the character (including EOS) i.e. in "hello":
	--   position 1: |hello
	--   position 2: h|ello
	--   ...
	--   position 6: hello|

	opt.state = core:registerHitbox(opt.id, x,y,w,h)
	opt.hasKeyboardFocus = core:grabKeyboardFocus(opt.id)

	if opt.hasKeyboardFocus then
		local keycode,char = core:getPressedKey()
		-- text input
		if char ~= "" then
			local a,b = split(input.text, input.cursor)
			input.text = table.concat{a, char, b}
			input.cursor = input.cursor + 1
		end

		-- text editing
		if keycode == 'backspace' then
			local a,b = split(input.text, input.cursor)
			input.text = table.concat{split(a,utf8.len(a)), b}
			input.cursor = math.max(1, input.cursor-1)
		elseif keycode == 'delete' then
			local a,b = split(input.text, input.cursor)
			local _,b = split(b, 2)
			input.text = table.concat{a, b}
		end

		-- cursor movement
		if keycode =='left' then
			input.cursor = math.max(0, input.cursor-1)
		elseif keycode =='right' then -- cursor movement
			input.cursor = math.min(utf8.len(input.text)+1, input.cursor+1)
		elseif keycode =='home' then -- cursor movement
			input.cursor = 1
		elseif keycode =='end' then -- cursor movement
			input.cursor = utf8.len(input.text)+1
		end

		-- mouse cursor position
		-- TODO
	end

	-- get size of text and cursor position
	opt.cursor_pos = 0
	if input.cursor > 1 then
		local s = input.text:sub(0, utf8.offset(input.text, input.cursor)-1)
		opt.cursor_pos = opt.font:getWidth(s)
	end

	-- compute drawing offset
	input.drawoffset = input.drawoffset or 0
	if opt.cursor_pos - input.drawoffset < 0 then
		-- cursor left of input box
		input.drawoffset = opt.cursor_pos
	end
	if opt.cursor_pos - input.drawoffset > w then
		-- cursor right of input box
		input.drawoffset = opt.cursor_pos - w
	end
	if text_width - input.drawoffset < w and text_width > w then
		-- text bigger than input box, but does not fill it
		input.drawoffset = text_width - w
	end

	core:registerDraw(core.theme.Input, input, opt, x,y,w,h)

	return {
		id = opt.id,
		hit = core:mouseReleasedOn(opt.id),
		submitted = core:keyPressedOn(opt.id, "return"),
		hovered = core:isHovered(opt.id),
		entered = core:isHovered(opt.id) and not core:wasHovered(opt.id),
		left = not core:isHovered(opt.id) and core:wasHovered(opt.id)
	}
end
