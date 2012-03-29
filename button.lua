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
local core = require((...):match("(.-)[^%.]+$") .. 'core')

-- the widget
return function(title, x,y, w,h, widgetHit, draw)
	-- Generate unique identifier for gui state update and querying.
	local id = core.generateID()

	-- The widget mouse-state can be:
	--   hot (mouse over widget),
	--   active (mouse pressed on widget) or
	--   normal (mouse not on widget and not pressed on widget).
	--
	-- core.mouse.updateState(id, widgetHit, x,y,w,h) updates the state for this widget.
	core.mouse.updateState(id, widgetHit or core.style.widgetHit, x,y,w,h)

	-- core.makeCyclable makes the item focus on tab or whatever binding is
	-- in place (see core.keyboard.cycle). Cycle order is determied by the
	-- order you call the widget functions.
	core.makeCyclable(id)

	-- core.registerDraw(id, drawfunction, drawfunction-arguments...)
	-- shows widget when core.draw() is called.
	core.registerDraw(id, draw or core.style.Button, title,x,y,w,h)

	return core.mouse.releasedOn(id) or
	       (core.keyboard.key == 'return' and core.hasKeyFocus(id))
end

