# QUICKIE

Quickie is an [immediate mode gui][IMGUI] library for [L&Ouml;VE][LOVE]

## Example

	local gui = require 'quickie'

	-- widgets are "created" by calling their corresponding functions in love.update.
	-- if you want to remove a widget, simply don't call the function (just like with
	-- any other love drawable). widgets dont hold their own state - this is your job:
	-- 
	-- sliders have a value and optional a minimum (default = 0) and maximum (default = 1)
	local slider = {value = 10, min = 0, max = 100}
	-- input boxes have a text and a cursor position (defaults to end of string)
	local input = {text = "Hello, World!", cursor = 0}
	-- checkboxes have only a `checked' status
	local checkbox = {checked = false}

	function love.update(dt)
		-- widgets are defined by simply calling them. usually a widget returns true if
		-- if its value changed or if it was activated (click on button, ...)
		if gui.Input(input, 10, 10, 300, 20) then
			print('Text changed:', input.text)
		end

		if gui.Button('Clear', 320,10,100,20) then
			input.text = ""
		end

		-- add more widgets here
	end

	function love.draw()
		-- draw the widgets which were "created" in love.update
		gui.core.draw()
	end

	function love.keypressed(key,code)
		-- forward keyboard events to the gui. If you don't want widget tabbing and
		-- input widgets, skip this line
		gui.core.keyboard.pressed(key, code)
	end

## Documentation

TODO


[LOVE]: http://love2d.org
[IMGUI]: http://www.mollyrocket.com/forums/viewforum.php?f=10
