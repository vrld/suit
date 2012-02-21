-- default style
local color = {
	normal = {bg = {128,128,128,200}, fg = {59,59,59,200}},
	hot    = {bg = {145,153,153,200}, fg = {60,61,54,200}},
	active = {bg = {145,153,153,255}, fg = {60,61,54,255}}
}

-- load default font
if not love.graphics.getFont() then
	love.graphics.setFont(love.graphics.newFont(12))
end

local function Button(state, title, x,y,w,h)
	local c = color[state]
	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', x,y,w,h)
	love.graphics.setColor(c.fg)
	local f = love.graphics.getFont()
	love.graphics.print(title, x + (w-f:getWidth(title))/2, y + (h-f:getHeight(title))/2)
end

local function Label(state, text, x,y,w,h,align)
	local c = color[state]
	love.graphics.setColor(c.fg)
	local f = assert(love.graphics.getFont())
	if align == 'center' then
		x = x + (w - f:getWidth(text))/2
		y = y + (h - f:getHeight(text))/2
	elseif align == 'right' then
		x = x + w - f:getWidth(text)
		y = y + h - f:getHeight(text)
	end
	love.graphics.print(text, x,y)
end

local function Slider(state, fraction, x,y,w,h, vertical)
	local c = color[state]
	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', x,y,w,h)

	love.graphics.setColor(c.fg)
	local hw,hh = w,h
	if vertical then
		hh = h * fraction
		y = y + (h - hh)
	else
		hw = w * fraction
	end
	love.graphics.rectangle('fill', x,y,hw,hh)
end

local function Slider2D(state, fraction, x,y,w,h, vertical)
	local c = color[state]
	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', x,y,w,h)

	-- draw quadrants
	local lw = love.graphics.getLineWidth()
	love.graphics.setLineWidth(1)
	love.graphics.setColor(c.fg[1], c.fg[2], c.fg[3], math.min(c.fg[4], 127))
	love.graphics.line(x+w/2,y, x+w/2,y+h)
	love.graphics.line(x,y+h/2, x+w,y+h/2)
	love.graphics.setLineWidth(lw)

	-- draw cursor
	local xx = x + fraction.x * w
	local yy = y + fraction.y * h
	love.graphics.setColor(c.fg)
	love.graphics.circle('fill', xx,yy,4,4)
end

local function Input(state, text, cursor, x,y,w,h)
	local c = color[state]
	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', x,y,w,h)
	love.graphics.setColor(c.fg)

	local lw = love.graphics.getLineWidth()
	love.graphics.setLineWidth(1)
	love.graphics.rectangle('line', x,y,w,h)

	local f = love.graphics.getFont()
	local th = f:getHeight(text)
	local cursorPos = x + 2 + f:getWidth(text:sub(1,cursor))

	love.graphics.print(text, x+2,y+(h-th)/2)
	love.graphics.line(cursorPos, y+4, cursorPos, y+h-4)

	love.graphics.setLineWidth(lw)
end

local function Checkbox(state, checked, x,y,w,h)
	local c = color[state]
	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', x,y,w,h)
	love.graphics.setColor(c.fg)
	love.graphics.rectangle('line', x,y,w,h)
	if checked then
		local r = math.max(math.min(w/7,h/7), 2)
		love.graphics.rectangle('fill', x+r,y+r, w-2*r,h-2*r)
	end
end


-- the style
return {
	color    = color,
	Button   = Button,
	Label    = Label,
	Slider   = Slider,
	Slider2D = Slider2D,
	Input    = Input,
	Checkbox = Checkbox,
}
