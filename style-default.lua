--[[
Copyright (c) 2012 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local BASE = (...):match("(.-)[^%.]+$")
local utf8 = require(BASE .. 'utf8')

-- default style
local color = {
	normal = {bg = {78,78,78}, fg = {200,200,200}, border={20,20,20}},
	hot    = {bg = {98,98,98}, fg = {69,201,84},   border={30,30,30}},
	active = {bg = {88,88,88}, fg = {49,181,64},   border={10,10,10}}
}

-- box drawing
local gradient = {}
function gradient:set(from, to)
	local id = love.image.newImageData(1,2)
	id:setPixel(0,0, to,to,to,255)
	id:setPixel(0,1, from,from,from,255)
	gradient.img = love.graphics.newImage(id)
	gradient.img:setFilter('linear', 'linear')
end
gradient:set(200,255)

local function box(x,y,w,h, bg, border, flip)
	love.graphics.setLineWidth(1)
	love.graphics.setLineStyle('rough')

	love.graphics.setColor(bg)
	local sy = flip and -h/2 or h/2
	love.graphics.draw(gradient.img, x,y+h/2, 0,w,sy, 0,1)
	love.graphics.setColor(border)
	love.graphics.rectangle('line', x,y,w,h)
end

-- load default font
if not love.graphics.getFont() then
	love.graphics.setFont(love.graphics.newFont(12))
end

local function Button(state, title, x,y,w,h)
	local c = color[state]
	box(x,y,w,h, c.bg, c.border, state == 'active')
	local f = assert(love.graphics.getFont())
	x,y = x + (w-f:getWidth(title))/2, y + (h-f:getHeight(title))/2
	love.graphics.setColor(c.fg)
	love.graphics.print(title, x,y)
end

local function Label(state, text, align, x,y,w,h)
	local c = color[state]
	love.graphics.setColor(c.fg)
	local f = assert(love.graphics.getFont())
	y = y + (h - f:getHeight(text))/2
	if align == 'center' then
		x = x + (w - f:getWidth(text))/2
	elseif align == 'right' then
		x = x + w - f:getWidth(text)
	end
	love.graphics.print(text, x,y)
end

local function Slider(state, fraction, vertical, x,y,w,h)
	local c = color[state]
	
	love.graphics.setLineWidth(1)
	love.graphics.setLineStyle('rough')
	love.graphics.setColor(c.bg)
	if vertical then
		love.graphics.rectangle('fill', x+w/2-2,y,4,h)
		love.graphics.setColor(c.border)
		love.graphics.rectangle('line', x+w/2-2,y,4,h)
		y = math.floor(y + h - h * fraction - 5)
		h = 10
	else
		love.graphics.rectangle('fill', x,y+h/2-2,w,4)
		love.graphics.setColor(c.border)
		love.graphics.rectangle('line', x,y+h/2-2,w,4)
		x = math.floor(x + w * fraction - 5)
		w = 10
	end
	box(x,y,w,h, c.bg,c.border)
end

local function Slider2D(state, fraction, x,y,w,h)
	local c = color[state]
	box(x,y,w,h, c.bg, c.border)

	-- draw quadrants
	love.graphics.setLineWidth(1)
	love.graphics.setLineStyle('rough')
	love.graphics.setColor(c.fg[1], c.fg[2], c.fg[3], math.min(127,c.fg[4] or 255))
	love.graphics.line(x+w/2,y, x+w/2,y+h)
	love.graphics.line(x,y+h/2, x+w,y+h/2)

	-- draw cursor
	local xx = math.ceil(x + fraction[1] * w)
	local yy = math.ceil(y + fraction[2] * h)
	love.graphics.setColor(c.fg)
	love.graphics.line(xx-3,yy,xx+2.5,yy)
	love.graphics.line(xx,yy-2.5,xx,yy+2.5)
end

local function Input(state, text, cursor, x,y,w,h)
	local c = color[state]
	box(x,y,w,h, c.bg, c.border, state ~= 'active')

	local f = love.graphics.getFont()
	local th = f:getHeight(text)
	local cursorPos = x + 2 + f:getWidth(utf8.sub(text, 1,cursor))
	local offset = 2 - math.floor((cursorPos-x) / (w-4)) * (w-4)

	local tsx,tsy,tsw,tsh = x+1, y, w-2, h
	local sx,sy,sw,sh = love.graphics.getScissor()
	if sx then -- intersect current scissors with our's
		local l,r = math.max(sx, tsx), math.min(sx+sw, tsx+tsw)
		local t,b = math.max(sy, tsy), math.min(sy+sh, tsy+tsh)
		if l > r or t > b then -- there is no intersection
			return
		end
		tsx, tsy, tsw, tsh = l, t, r-l, b-t
	end

	love.graphics.setScissor(tsx, tsy, tsw, tsh)
	love.graphics.setLineWidth(1)
	love.graphics.setLineStyle('rough')
	love.graphics.setColor(color.normal.fg)
	love.graphics.print(text, x+offset,y+(h-th)/2)
	if state ~= 'normal' then
		love.graphics.setColor(color.active.fg)
		love.graphics.line(cursorPos+offset, y+4, cursorPos+offset, y+h-4)
	end
	if sx then
		love.graphics.setScissor(sx,sy,sw,sh)
	else
		love.graphics.setScissor()
	end
end

local function Checkbox(state, checked, label, align, x,y,w,h)
	local c = color[state]
	local bw, bx, by  = math.min(w,h)*.7, x, y
	by = y + (h-bw)/2

	local f = assert(love.graphics.getFont())
	local tw,th = f:getWidth(label), f:getHeight(label)
	local tx, ty = x, y + (h-th)/2
	if align == 'left' then
		-- [ ] LABEL
		bx, tx = x, x+bw+4
	else
		-- LABEL [ ]
		tx, bx = x, x+4+tw
	end

	box(bx,by,bw,bw, c.bg, c.border)

	if checked then
		bx,by = bx+bw*.25, by+bw*.25
		bw = bw * .5
		love.graphics.setColor(color.active.fg)
		box(bx,by,bw,bw, color.hot.fg, {0,0,0,0}, true)
	end

	love.graphics.setColor(c.fg)
	love.graphics.print(label, tx, ty)
end


-- the style
return {
	color    = color,
	gradient = gradient,

	Button   = Button,
	Label    = Label,
	Slider   = Slider,
	Slider2D = Slider2D,
	Input    = Input,
	Checkbox = Checkbox,
}
