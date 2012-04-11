# QUICKIE

Quickie is an [immediate mode gui][IMGUI] library for [L&Ouml;VE][LOVE]. Initial inspiration came from the article [Sol on Immediate Mode GUIs (IMGUI)][Sol]. You should check it out to understand how Quickie works.


# Example

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

# Modules

<dl>
<dt><code>gui = require 'quickie'</code></dt>
<dd>Main module. <em>Includes all other modules.</em></dd>

<dt><code>gui.core = require 'quickie.core'</code></dt>
<dd>Core functionality: Input, display, widget internals, ...</dd>

<dt><code>gui.style = require 'quickie.style-default'</code></dt>
<dd>Default widget style. May be replaced by custom style.</dd>

<dt><code>gui.Button = require 'quickie.button'</code></dt>
<dd>Button widget.</dd>

<dt><code>gui.Slider = require 'quickie.slider'</code></dt>
<dd>Slider widget.</dd>

<dt><code>gui.Slider2D = require 'quickie.slider2d'</code></dt>
<dd>2D slider widget.</dd>

<dt><code>gui.Label = require 'quickie.label'</code></dt>
<dd>Label widget.</dd>

<dt><code>gui.Input = require 'quickie.input'</code></dt>
<dd>Input box widget.</dd>

<dt><code>gui.Checkbox = require 'quickie.checkbox'</code></dt>
<dd>Check box widget.</dd>
</dl>

# Widgets

* Widgets are functions; they should return `true` if the state has changed.
* Widgets don't manage state. That's your job.
* Calling a widget function creates the widget for the current frame only.
* Widgets will be shown using `gui.core.draw()`. See the example above.

## Button

```lua
function gui.Button(label, x,y,w,h, widgetHit, draw)
```

#### Parameters:

* *string* `label`: Button label.
* *numbers* `x,y,w,h`: Hit box.
* *function* `widgetHit`: Custom mouse hit function *(optional)*.
* *function* `draw`:  Custom widget style *(optional)*.

#### Returns:

* `true` if button was activated.

#### Hit test function signature:

```lua
function widgetHit(mouse_x, mouse_y, x,y,w,h)
```

#### Style function signature:

```lua
function draw(state, title, x,y,w,h)
```

## Slider

```lua
function gui.Slider(info, x,y,w,h, widgetHit, draw)
```

#### Parameters:

* *table* `info`: Widget info table. Fields:
 * *number* `info.value`: The slider value *(required)*.
 * *number* `info.min`: Minimum value *(optional, default = 0)*.
 * *number* `info.max`: Maximum value *(optional, default = max(value, 1))*.
 * *number* `info.step`: Step for keyboard input *(optional, default = (max-min)/50)*.
 * *boolean* `info.vertical`: Flags slider as vertical *(optional, default = false)*.
* *numbers* `x,y,w,h`: Hit box.
* *function* `widgetHit`: Custom mouse hit function *(optional)*.
* *function* `draw`:  Custom widget style *(optional)*.

#### Returns:

* `true` if slider value changed.

#### Hit test function signature:

```lua
function widgetHit(mouse_x, mouse_y, x,y,w,h)
```

#### Style function signature:

```lua
function draw(state, fraction, x,y,w,h, vertical)
```

## Slider2D

```lua
function gui.Slider2D(info, x,y,w,h, widgetHit, draw)
```

#### Parameters:

* *table* `info`: Widget info table. Fields:
 * *table* `info.value = {x = x, y = y}`: The slider value *(required)*.
 * *table* `info.min = {x = x, y = y}`: Minimum value *(optional, `default = {x = 0, y = 0}`)*.
 * *table* `info.max = {x = x, y = y}`: Maximum value *(optional, `default = {x = max(value.x, 1), y = max(value.y, 1)}`)*.
 * *table* `info.step = {x = x, y = y}`: Step for keyboard input *(optional)*.
* *numbers* `x,y,w,h`: Hit box.
* *function* `widgetHit`: Custom mouse hit function *(optional)*.
* *function* `draw`:  Custom widget style *(optional)*.

#### Returns:

* `true` if slider value changed.

#### Hit test function signature:

```lua
function widgetHit(mouse_x, mouse_y, x,y,w,h)
```

#### Style function signature:

```lua
function draw(state, fraction, x,y,w,h)
```

**Note:** `fraction = {x = [0..1], y = [0..1]}` is a table argument

## Label

```lua
function gui.Label(text, x,y,w,h, align, draw)
```

#### Parameters:

* *string* `text`: Label text.
* *numbers* `x,y`: Upper left corner of the label's bounding box.
* *numbers* `w,h`: Width and height of the bounding box *(optional, `default = 0,0`)*.
* *string* `align`: Text alignment. One of `left`, `center`, `right`. *(optional, `default = 'left'`)*
* *function* `draw`:  Custom widget style *(optional)*.

#### Returns:

* `false`.

#### Style function signature:

```lua
function draw(state, text, x,y,w,h, align)
```

## Input

```lua
function gui.Input(info, x,y,w,h, widgetHit, draw)
```

#### Parameters:

* *table* `info`: Widget info table. Fields:
 * *string* `info.text`: Entered text *(optional `default = ""`)*.
 * *number* `info.cursor`: Cursor position *(optional `default = info.text:len()`).
* *numbers* `x,y,w,h`: Hit box.
* *function* `widgetHit`: Custom mouse hit function *(optional)*.
* *function* `draw`:  Custom widget style *(optional)*.

#### Returns:

* `true` if textbox value was changed.

#### Hit test function signature:

```lua
function widgetHit(mouse_x, mouse_y, x,y,w,h)
```

#### Style function signature:

```lua
function draw(state, text, cursor, x,y,w,h)
```

## Checkbox

```lua
function gui.Checkbox(info, x,y,w,h, widgetHit, draw)
```

#### Parameters:

* *string* `info`: Widget info table. Fields:
 * *boolean* `checked`: Whether the box is checked.
* *numbers* `x,y,w,h`: Hit box.
* *function* `widgetHit`: Custom mouse hit function *(optional)*.
* *function* `draw`:  Custom widget style *(optional)*.

#### Returns:

* `true` if box was checked/unchecked.

#### Hit test function signature:

```lua
function widgetHit(mouse_x, mouse_y, x,y,w,h)
```

#### Style function signature:

```lua
function draw(state, checked, x,y,w,h)
```


# Core functions

TODO


# License

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
