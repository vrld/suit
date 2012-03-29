# QUICKIE

Quickie is an [immediate mode gui][IMGUI] library for [L&Ouml;VE][LOVE]. Initial inspiration came from the article [Sol on Immediate Mode GUIs (IMGUI)][Sol]. You should check it out to understand how Quickie works.


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

	function love.load()
		-- disable tabbing through the widgets
		gui.core.disableKeyFocus()
	end

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
		-- forward keyboard events to the gui. If you don't want keyboard support
		-- skip this line
		gui.core.keyboard.pressed(key, code)
	end

## Documentation

### Modules

`gui = require 'quickie'`

* Main module. Includes all other modules.

`gui.core = require 'quickie.core'`

* Core functionality: Input, display, widget internals, ...

`gui.style = require 'quickie.style-default'`

* Default widget style. May be replaced by custom style.

`gui.Button = require 'quickie.button'`

* Button widget.

`gui.Slider = require 'quickie.slider'`

* Slider widget.

`gui.Slider2D = require 'quickie.slider2d'`

* 2D slider widget.

`gui.Label = require 'quickie.label'`

* Label widget.

`gui.Input = require 'quickie.input'`

* Input box widget.

`gui.Checkbox = require 'quickie.checkbox'`

* Check box widget.

### Widgets

* Widgets are functions; they should return `true` if the state has changed.
* Widgets don't manage state. That's your job.
* Calling a widget function creates the widget for the current frame only.
* Widgets will be shown using `gui.core.draw()`. See the example above.

#### Button

```lua
function gui.Button(label, x,y,w,h, widgetHit, draw)
```

**Parameters:**

* *string* `label`: Button label.
* *numbers* `x,y,w,h`: Hit box.
* *function* `widgetHit`: Custom mouse hit function *(optional)*.
* *function* `draw`:  Custom widget style *(optional)*.

**Returns:**

* `true` if button was activated.

**Hit test function prototype:**

```lua
function widgetHit(mouse_x, mouse_y, x,y,w,h)
```

**Style function prototype:**

```lua
function draw(state, title, x,y,w,h)
```

#### Slider

```lua
function gui.Slider(info, x,y,w,h, widgetHit, draw)
```

**Parameters:**

* *table* `info`: Widget info table. Fields:
 * *number* `info.value`: The slider value *(required)*.
 * *number* `info.min`: Minimum value *(optional, default = 0)*.
 * *number* `info.max`: Maximum value *(optional, default = max(value, 1))*.
 * *number* `info.step`: Step for keyboard input *(optional, default = (max-min)/50)*.
 * *boolean* `info.vertical`: Flags slider as vertical *(optional, default = false)*.
* *numbers* `x,y,w,h`: Hit box.
* *function* `widgetHit`: Custom mouse hit function *(optional)*.
* *function* `draw`:  Custom widget style *(optional)*.

**Returns:**

* `true` if slider value changed.

**Hit test function prototype:**

```lua
function widgetHit(mouse_x, mouse_y, x,y,w,h)
```

**Style function prototype:**

```lua
function draw(state, fraction, x,y,w,h, vertical)
```

#### Slider2D

TODO

#### Label

TODO

#### Input

TODO

#### Checkbox

TODO

### Core functions

TODO


## License

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


[LOVE]: http://love2d.org
[IMGUI]: http://www.mollyrocket.com/forums/viewforum.php?f=10
[Sol]: http://sol.gfxile.net/imgui/
