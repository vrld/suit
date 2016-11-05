-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local BASE = (...):match('(.-)[^%.]+$')

local theme = {}
theme.cornerRadius = 4

theme.color = {
	normal   = {bg = { 66, 66, 66}, fg = {188,188,188}},
	hovered  = {bg = { 50,153,187}, fg = {255,255,255}},
	active   = {bg = {255,153,  0}, fg = {225,225,225}}
}


-- HELPER
function theme.getColorForState(opt)
	local s = opt.state or "normal"
	return (opt.color and opt.color[opt.state]) or theme.color[s]
end

function theme.drawBox(x,y,w,h, colors, cornerRadius)
	colors = colors or theme.getColorForState(opt)
	cornerRadius = cornerRadius or theme.cornerRadius
	w = math.max(cornerRadius/2, w)
	if h < cornerRadius/2 then
		y,h = y - (cornerRadius - h), cornerRadius/2
	end

	love.graphics.setColor(colors.bg)
	love.graphics.rectangle('fill', x,y, w,h, cornerRadius)
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

	theme.drawBox(x,y,w,h, c, opt.cornerRadius)
	love.graphics.setColor(c.fg)
	love.graphics.setFont(opt.font)

	y = y + theme.getVerticalOffsetForAlign(opt.valign, opt.font, h)
	love.graphics.printf(text, x+2, y, w-4, opt.align or "center")
end

function theme.Checkbox(chk, opt, x,y,w,h)
	local c = theme.getColorForState(opt)
	local th = opt.font:getHeight()

	theme.drawBox(x+h/10,y+h/10,h*.8,h*.8, c, opt.cornerRadius)
	love.graphics.setColor(c.fg)
	if chk.checked then
		love.graphics.setLineStyle('smooth')
		love.graphics.setLineWidth(5)
		love.graphics.setLineJoin("bevel")
		love.graphics.line(x+h*.2,y+h*.55, x+h*.45,y+h*.75, x+h*.8,y+h*.2)
	end

	if chk.text then
		love.graphics.setFont(opt.font)
		y = y + theme.getVerticalOffsetForAlign(opt.valign, opt.font, h)
		love.graphics.printf(chk.text, x + h, y, w - h, opt.align or "left")
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
	theme.drawBox(x,y,w,h, c, opt.cornerRadius)
	theme.drawBox(xb,yb,wb,hb, {bg=c.fg}, opt.cornerRadius)

	if opt.state ~= nil and opt.state ~= "normal" then
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
	theme.drawBox(x,y,w,h, (opt.color and opt.color.normal) or theme.color.normal, opt.cornerRadius)
	x = x + 3
	w = w - 6

	local th = opt.font:getHeight()

	-- set scissors
	local sx, sy, sw, sh = love.graphics.getScissor()
	love.graphics.setScissor(x-1,y,w+2,h)
	x = x - input.text_draw_offset

	-- text
	love.graphics.setColor((opt.color and opt.color.normal and opt.color.normal.fg) or theme.color.normal.fg)
	love.graphics.setFont(opt.font)
	love.graphics.print(input.text, x, y+(h-th)/2)

	-- cursor
	if opt.hasKeyboardFocus and (love.timer.getTime() % 1) > .5 then
		love.graphics.setLineWidth(1)
		love.graphics.setLineStyle('rough')
		love.graphics.line(x + opt.cursor_pos, y + (h-th)/2,
		                   x + opt.cursor_pos, y + (h+th)/2)
	end

	-- reset scissor
	love.graphics.setScissor(sx,sy,sw,sh)
end

return theme
