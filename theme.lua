-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')

local theme = {}
theme.cornerRadius = 4

theme.color = {
	normal  = {bg = { 66, 66, 66}, fg = {188,188,188}},
	hovered = {bg = { 50,153,187}, fg = {255,255,255}},
	active  = {bg = {255,153,  0}, fg = {225,225,225}}
}


-- HELPER
function theme.getStateName(id)
	if theme.core.isActive(id) then
		return 'active'
	end
	if theme.core.isHot(id) then
		return 'hovered'
	end
	return 'normal'
end

function theme.getColorForState(opt)
	local s = theme.getStateName(opt.id)
	return (opt.color and opt.color[s]) or theme.color[s]
end

function theme.drawBox(x,y,w,h, colors)
	love.graphics.setColor(colors.bg)
	love.graphics.rectangle('fill', x,y, w,h, theme.cornerRadius)
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

	theme.drawBox(x+h/10,y+h/10,h*.8,h*.8, c)
	love.graphics.setColor(c.fg)
	if chk.checked then
		love.graphics.setLineWidth(5)
		love.graphics.setLineJoin("bevel")
		love.graphics.line(x+h*.2,y+h*.55, x+h*.45,y+h*.75, x+h*.8,y+h*.2)
	end

	if chk.text then
		love.graphics.setFont(opt.font)
		y = y + theme.getVerticalOffsetForAlign(opt.valign, opt.font, h)
		love.graphics.printf(chk.text, x + th+2, y, w - th+2, opt.align or "left")
	end
end

function theme.Slider(fraction, opt, x,y,w,h)
	local xb, yb, wb, hb -- size of the progress bar
	local r =  math.min(w,h) / 2.1
	if opt.vertical then
		x, w = x + w*.25, w*.5
		xb, yb, wb, hb = x, y+h*(1-fraction), w, h*fraction
	else
		y, h = y + h*.25, h*.5
		xb, yb, wb, hb = x,y, w*fraction, h
	end

	local c = theme.getColorForState(opt)
	theme.drawBox(x,y,w,h, c)
	love.graphics.setColor(c.fg)
	love.graphics.rectangle('fill', x,yb,wb,hb, theme.cornerRadius)

	if theme.getStateName(opt.id) ~= "normal" then
		love.graphics.setColor((opt.color and opt.color.active or {}).fg or theme.color.active.fg)
		if opt.vertical then
			love.graphics.circle('fill', x+wb/2, yb, r)
		else
			love.graphics.circle('fill', x+wb, yb+hb/2, r)
		end
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
		local s = input.text:sub(0, utf8.offset(input.text, input.cursor)-1)
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
	if opt.hasKeyboardFocus and (love.timer.getTime() % 1) > .5 then
		love.graphics.line(x + cursor_pos, y + (h-th)/2,
		                   x + cursor_pos, y + (h+th)/2)
	end

	-- reset scissor
	love.graphics.setScissor(sx,sy,sw,sh)
end

return theme
