# SUIT

Simple User Interface Toolkit for LÖVE.

SUIT is an immediate mode GUI library.

## Documentation?

Over at [readthedocs](http://suit.readthedocs.org/en/latest/)

## Hello, World!

```lua
suit = require 'suit'

local input = {text = ""}

function love.update(dt)
	suit.layout.reset(100,100)

	suit.Input(input, suit.layout.row(200,30))
	suit.Label("Hello, "..input.text, {align = "left"}, suit.layout.row())

	suit.layout.row() -- padding of one cell
	if suit.Button("Close", suit.layout.row()).hit then
		love.event.quit()
	end
end

function love.draw()
	suit.core.draw()
end

function love.textinput(t)
	suit.core.textinput(t)
end

function love.keypressed(key)
	suit.core.keypressed(key)
end
```
