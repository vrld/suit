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
local core     = require(BASE .. 'core')
local group    = require(BASE .. 'group')
local mouse    = require(BASE .. 'mouse')
local keyboard = require(BASE .. 'keyboard')

-- the widget
-- {text = text, pos = {x, y}, size={w, h}, widgetHit=widgetHit, draw=draw}
return function(w)
	assert(type(w) == "table" and w.text, "Invalid argument")

	-- if tight fit requested, compute the size according to text size
	-- have a 2px margin around the text
	local tight = w.size and (w.size[1] == 'tight' or w.size[2] == 'tight')
	if tight then
		local f = assert(love.graphics.getFont())
		if w.size[1] == 'tight' then
			w.size[1] = f:getWidth(w.text) + 4
		end
		if w.size[2] == 'tight' then
			w.size[2] = f:getHeight(w.text) + 4
		end
	end

	-- Generate unique identifier for gui state update and querying.
	local id = core.generateID()

	-- group.getRect determines the position and size of the widget according
	-- to the currently active group. Both arguments may be omitted.
	local pos, size = group.getRect(w.pos, w.size)

	-- mouse.updateWidget(id, {x,y}, {w,h}, widgetHit) updates the state for this widget.
	-- widgetHit may be nil, in which case mouse.widgetHit will be used.
	-- The widget mouse-state can be:
	--   hot (mouse over widget),
	--   active (mouse pressed on widget) or
	--   normal (mouse not on widget and not pressed on widget).
	mouse.updateWidget(id, pos, size, w.widgetHit)

	-- keyboard.makeCyclable makes the item focus on tab or whatever binding is
	-- in place (see core.keyboard.cycle). Cycle order is determied by the
	-- order you call the widget functions.
	keyboard.makeCyclable(id)

	-- core.registerDraw(id, drawfunction, drawfunction-arguments...)
	-- shows widget when core.draw() is called.
	core.registerDraw(id, w.draw or core.style.Button,
		w.text, pos[1],pos[2], size[1],size[2])

	return mouse.releasedOn(id) or (keyboard.key == 'return' and keyboard.hasFocus(id))
end

