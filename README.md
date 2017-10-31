# SUIT

Simple User Interface Toolkit for LÖVE.

SUIT is an immediate mode GUI library.

## Documentation?

Over at [readthedocs](http://suit.readthedocs.org/en/latest/).

## Looks?

Here is how SUIT looks like with the default theme:

![Demo of all widgets](docs/_static/demo.gif)

More info and code is over at [readthedocs](http://suit.readthedocs.org/en/latest/).

## Hello, World!

```lua
-- suit up
local suit = require 'suit'

-- storage for text input
local input = {text = ""}

-- make love use font which support CJK text
function love.load()
    local font = love.graphics.newFont("NotoSansHans-Regular.otf", 20)
    love.graphics.setFont(font)
end

-- all the UI is defined in love.update or functions that are called from here
function love.update(dt)
	-- put the layout origin at position (100,100)
	-- the layout will grow down and to the right from this point
	suit.layout:reset(100,100)

	-- put an input widget at the layout origin, with a cell size of 200 by 30 pixels
	suit.Input(input, suit.layout:row(200,30))

	-- put a label that displays the text below the first cell
	-- the cell size is the same as the last one (200x30 px)
	-- the label text will be aligned to the left
	suit.Label("Hello, "..input.text, {align = "left"}, suit.layout:row())

	-- put an empty cell that has the same size as the last cell (200x30 px)
	suit.layout:row()

	-- put a button of size 200x30 px in the cell below
	-- if the button is pressed, quit the game
	if suit.Button("Close", suit.layout:row()).hit then
		love.event.quit()
	end
end

function love.draw()
	-- draw the gui
	suit.draw()
end

function love.textedited(text, start, length)
    -- for IME input
    suit.textedited(text, start, length)
end

function love.textinput(t)
	-- forward text input to SUIT
	suit.textinput(t)
end

function love.keypressed(key)
	-- forward keypresses to SUIT
	suit.keypressed(key)
end
```
