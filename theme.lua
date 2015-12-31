-- This file is part of QUI, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')

local theme = {}

theme.color = {
	normal = {bg = {78,78,78}, fg = {200,200,200}, border={20,20,20}},
	hot    = {bg = {98,98,98}, fg = {69,201,84},   border={30,30,30}},
	active = {bg = {88,88,88}, fg = {49,181,64},   border={10,10,10}}
}


-- HELPER
function theme.getStateName(id)
	if theme.core.isHot(id) then
		return 'hot'
	end
	if theme.core.isActive(id) then
		return 'active'
	end
	return 'normal'
end

function theme.getColorForState(opt)
	local s = theme.getStateName(opt.id)
	return (opt.color and opt.color[s]) or theme.color[s]
end

function theme.drawBox(x,y,w,h, colors)
	love.graphics.setColor(colors.bg)
	love.graphics.rectangle('fill', x,y, w,h)

	love.graphics.setColor(colors.border)
	love.graphics.rectangle('line', x,y, w,h)
end

function theme.getVerticalOffsetForAlign(valign, font, h)
	if valign == "top" then
		return 0
	elseif valign == "bottom" then
		return h - font:getHeight()
	end
	-- else: "middle"
	return (h - font:getHeight()) / 2
end

-- WIDGET VIEWS
function theme.Label(text, opt, x,y,w,h)
	y = y + theme.getVerticalOffsetForAlign(opt.valign, opt.font, h)

	love.graphics.setColor((opt.color and opt.color.normal or {}).fg or theme.color.normal.fg)
	love.graphics.setFont(opt.font)
	love.graphics.printf(text, x+2, y, w-4, opt.align or "center")
end

function theme.Button(text, opt, x,y,w,h)
	local c = theme.getColorForState(opt)

	theme.drawBox(x,y,w,h, c)
	love.graphics.setColor(c.fg)
	love.graphics.setFont(opt.font)

	y = y + theme.getVerticalOffsetForAlign(opt.valign, opt.font, h)
	love.graphics.printf(text, x+2, y, w-4, opt.align or "center")
end

function theme.Checkbox(chk, opt, x,y,w,h)
	local c = theme.getColorForState(opt)
	local th = opt.font:getHeight()

	theme.drawBox(x,y+(h-th)/2,th,th, c)
	love.graphics.setColor(c.fg)
	if chk.checked then
		love.graphics.rectangle('fill', x+3,y+(h-th)/2+3,th-6,th-6)
	end

	if chk.text then
		love.graphics.setFont(opt.font)
		y = y + theme.getVerticalOffsetForAlign(opt.valign, opt.font, h)
		love.graphics.printf(chk.text, x + th+2, y, w - th+2, opt.align or "left")
	end
end

function theme.Slider(fraction, opt, x,y,w,h)
	local c = theme.getColorForState(opt)
	love.graphics.setColor(c.bg)

	if opt.vertical then
		love.graphics.rectangle('fill', x+w/2-2,y, 4,h)
		y = math.floor(y + h * (1 - fraction))
		theme.drawBox(x,y-2,w,4, c)
	else
		love.graphics.rectangle('fill', x,y+h/2-2, w,4)
		x = math.floor(x + w * fraction)
		theme.drawBox(x-2,y,4,h, c)
	end
end

function theme.Input(input, opt, x,y,w,h)
	local utf8 = require 'utf8'
	theme.drawBox(x,y,w,h, (opt.color and opt.color.normal) or theme.color.normal)
	x = x + 3
	w = w - 6

	-- get size of text and cursor position
	local th = opt.font:getHeight()
	local tw = opt.font:getWidth(input.text)
	local cursor_pos = 0
	if input.cursor > 1 then
		local s = input.text:sub(0, utf8.offset(input.text, input.cursor-1))
		cursor_pos = opt.font:getWidth(s)
	end

	-- compute drawing offset
	input.drawoffset = input.drawoffset or 0
	if cursor_pos - input.drawoffset < 0 then
		-- cursor left of input box
		input.drawoffset = cursor_pos
	end
	if cursor_pos - input.drawoffset > w then
		-- cursor right of input box
		input.drawoffset = cursor_pos - w
	end
	if tw - input.drawoffset < w and tw > w then
		-- text bigger than input box, but does not fill it
		input.drawoffset = tw - w
	end

	-- set scissors
	local sx, sy, sw, sh = love.graphics.getScissor()
	love.graphics.setScissor(x-1,y,w+2,h)
	x = x - input.drawoffset

	-- text
	love.graphics.setColor(opt.color and opt.color.normal or theme.color.normal.fg)
	love.graphics.setFont(opt.font)
	love.graphics.print(input.text, x, y+(h-th)/2)

	-- cursor
	if opt.hasFocus then
		love.graphics.line(x + cursor_pos, y + (h-th)/2,
		                   x + cursor_pos, y + (h+th)/2)
	end

	-- reset scissor
	love.graphics.setScissor(sx,sy,sw,sh)
end

return theme
