# SUIT

Simple User Interface Toolkit for LÖVE.

## Immediate mode GUI

SUIT is an immediate mode GUI library.

With classical (retained) mode libraries you typically have a stage where you
create the whole UI when the program initializes. After that point, the GUI
does not change much.

With immediate mode libraries, on the other hand, the GUI is created every
frame from scratch. There are no widget objects, only functions that draw the
widget and update internal GUI state. This allows to put the widgets in their
immediate conceptual context (instead of a construction stage). It also makes
the UI very flexible: Don't want to draw a widget? Simply remove the call.
Handling the mutable data (e.g., text of an input box) of each widget is your
responsibility. This separation of behaviour and data 

## What SUIT is

SUIT is simple: It provides only the most important widgets for games:

- Buttons (including Image Buttons)
- Checkboxes
- Text Input
- Value Sliders

SUIT is comfortable: It features a simple, yet effective row/column-based
layouting engine.

SUIT is adaptable: You can easily alter the color scheme, change how widgets
are drawn or swap the whole theme.

SUIT is hackable: The core library can be used to construct new widgets with
relative ease.

**SUIT is good at games**

## What SUIT is not

SUIT is not a complete GUI library: It does not provide dropdowns, subwindows,
radio buttons, menu bars, ribbons, etc.

SUIT is not a complete GUI library: SUIT spits MVC and other good OO practices
in the face.

SUIT is not a complete GUI library: There is no markup language to generate or
style the GUI.

**SUIT is not good at "serious" applications**

## Example code

## Documentation

To be done.

## Example code


```lua
suit = require 'suit'

function love.load()
	-- generate some assets
	snd = generateClickySound()
	normal, hot = generateImageButton()
	smallerFont = love.graphics.newFont(10)
end

-- mutable widget data
local slider= {value = .5, max = 2}
local input = {text = "Hello"}
local chk = {text = "Check me out"}

function love.update(dt)
	-- new layout at 100,100 with a padding of 20x20 px
	suit.layout.reset(100,100, 20,20)

	-- Button
	state = suit.Button("Hover me!", suit.layout.row(200,30))
	if state.entered then
		love.audio.play(snd)
	end
	if state.hit then
		print("Ouch!")
	end

	-- Input box
	if suit.Input(input, suit.layout.row()).submitted then
		print(input.text)
	end

	-- dynamically add widgets
	if suit.Button("test2", suit.layout.row(nil,40)).hovered then
		-- drawing options can be provided for each widget ... optionally
		suit.Button("You can see", {align='left', valign='top'}, suit.layout.row(nil,30))
		suit.Button("...but you can't touch!", {align='right', valign='bottom'}, suit.layout.row(nil,30))
	end

	-- Checkbox
	suit.Checkbox(chk, {align='right'}, suit.layout.row())

	-- nested layouts
	suit.layout.push(suit.layout.row())
		suit.Slider(slider, suit.layout.col(160, 20))
		suit.Label(("%.02f"):format(slider.value), suit.layout.col(40))
	suit.layout.pop()

	-- image buttons
	suit.ImageButton({normal, hot = hot}, suit.layout.row(200,100))

	if chk.checked then
		-- precomputed layout can fill up available space
		suit.layout.reset()
		rows = suit.layout.rows{pos = {400,100},
			min_height = 300,
			{200, 30},
			{30, 'fill'},
			{200, 30},
		}
		suit.Label("You uncovered the secret!", {align="left", font = smallerFont}, rows.item(1))
		suit.Label(slider.value, {align='left'}, rows.item(3))

		-- give different id to slider on same object so they don't grab
		-- each others user interaction
		suit.Slider(slider, {id = 'vs', vertical=true}, rows.item(2))
		print(rows.item(3))
	end
end

function love.draw()
	-- draw the gui
	suit.core.draw()
end

-- forward keyboard events
function love.textinput(t)
	suit.core.textinput(t)
end

function love.keypressed(key)
	suit.core.keypressed(key)
end

-- generate assets (see love.load)
function generateClickySound()
	local snd = love.sound.newSoundData(512, 44100, 16, 1)
	for i = 0,snd:getSampleCount()-1 do
		local t = i / 44100
		local s = i / snd:getSampleCount()
		snd:setSample(i, (.7*(2*love.math.random()-1) + .3*math.sin(t*9000*math.pi)) * (1-s)^1.2 * .3)
	end
	return love.audio.newSource(snd)
end

function generateImageButton()
	local normal, hot = love.image.newImageData(200,100), love.image.newImageData(200,100)
	normal:mapPixel(function(x,y)
		local d = (x/200-.5)^2 + (y/100-.5)^2
		if d < .12 then
			return 200,160,20,255
		end
		return 0,0,0,0
	end)
	hot:mapPixel(function(x,y)
		local d = (x/200-.5)^2 + (y/100-.5)^2
		if d < .13 then
			return 255,255,255,255
		end
		return 0,0,0,0
	end)
	return love.graphics.newImage(normal), love.graphics.newImage(hot)
end
```
