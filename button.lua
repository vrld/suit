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

