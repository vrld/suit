Getting Started
===============

Before actually getting started, it is important to understand the motivation
and mechanics behind SUIT:

- **SUIT is an immediate mode GUI library**
- **Less is more**
- **Layouting must be easy**

Immediate mode?
---------------

With classical (retained) mode libraries you typically have a stage where you
create the whole UI when the program initializes. After that point, the GUI
is expected to not change very much.

With immediate mode libraries, on the other hand, the GUI is created every
frame from scratch. There are no widget objects, only functions that draw the
widget and update some internal GUI state. This allows to put the widgets in
their immediate conceptual context (instead of a construction stage). It also
makes the UI very flexible: Don't want to draw a widget? Simply remove the
call. Handling the mutable data (e.g., text of an input box) of each widget is
your responsibility. This separation of data and behaviour gives you greater
control of what is happening when an where, but can take a bit of time getting
used to - especially if you have used retained mode libraries before.

What SUIT is
^^^^^^^^^^^^

SUIT is simple: It provides only the most important widgets for games:

- :func:`Buttons <Button>` (including :func:`Image Buttons <ImageButton>`)
- :func:`Text Labels <Label>`
- :func:`Checkboxes <Checkbox>`
- :func:`Text Input <Input>`
- :func:`Value Sliders <Slider>`

SUIT is comfortable: It features a simple, yet effective row/column-based
layouting engine.

SUIT is adaptable: You can easily alter the color scheme, change how widgets
are drawn or swap the whole theme.

SUIT is hackable: The core library can be used to construct new widgets with
relative ease.

**SUIT is good at games!**


What SUIT is not
^^^^^^^^^^^^^^^^

SUIT is not a complete GUI library: It does not provide dropdowns, sub-windows,
radio buttons, menu bars, ribbons, etc.

SUIT is not a complete GUI library: SUIT spits separation of concerns, MVC and
other good OO practices in the face.

SUIT is not a complete GUI library: There is no markup language to generate or
style the GUI.

**SUIT is not good at "serious" applications!**


Hello, World
------------

SUIT is simple: Load the library, define your GUI in ``love.update()``, and
draw it in ``love.draw()``::

    suit = require 'suit'

    local show_message = false
    function love.update(dt)
        -- Put a button on the screen. If hit, show a message.
        if suit.Button("Hello, World!", 100,100, 300,30).hit then
            show_message = true
        end

        if show_message then
            suit.Label("How are you today?", 100,150, 300,30)
        end
    end

    function love.draw()
        suit.core.draw()
    end

As you can see, each widget is created by a function call (:func:`suit.Button
<Button>` and :func:`suit.Label <Label>`). The first argument is always the
"payload" of the widget, and the last four arguments define the position and
dimension of the widget. The widget returns a table indicating their updated
GUI state. The most important is ``hit``, which signals that the mouse was
clicked and released on the widget. See :doc:`Widgets <widgets>` for more info.

Mutable state
-------------

Widgets that mutate some state - input boxes and sliders - receive a table
argument as payload, e.g.::

    local slider = {value = 1, max = 2}
    function love.update(dt)
        suit.Slider(slider, 100,100, 200,30)
        suit.Label(tostring(slider.value), 300,100, 100,30)
    end

Options
-------

You can define optional, well, options after the payload. These options usually
affect how the widget is drawn. For example, to align the label text to the
left in the above example, you would write::

    local slider = {value = 1, max = 2}
    function love.update(dt)
        suit.Slider(slider, 100,100, 200,30)
        suit.Label(tostring(slider.value), {align = "left"}, 300,100, 100,30)
    end

Which options are available and what they are doing depends on the widget and
the theme.

Keyboard input
--------------

The input widget requires that you forward ``keypressed`` and ``textinput``
events to SUIT::

    local input = {text = ""}
    function love.update(dt)
        suit.Input(input, 100,100,200,30)
        suit.Label("Hello, "..input.text, {align="left"}, 100,150,200,30)
    end

    -- forward keyboard events
    function love.textinput(t)
        suit.core.textinput(t)
    end

    function love.keypressed(key)
        suit.core.keypressed(key)
    end

Layout
------

It is tedious to write down the position and size of each widget. It is also
not very easy to figure out what those numbers mean when you look at your code
after not touching it for some time. SUIT offers a simple, yet effective
layouting engine to put widgets in rows or columns. If you have ever dabbled
with `Qt's <http://qt.io>`_ ``QBoxLayout``, you already know 78.42% [1]_
of what you need to know.

The first example can be written as follows::

    suit = require 'suit'

    local show_message = false
    function love.update(dt)
        suit.layout.reset(100,100) -- reset layout origin to x=100, y=100
        suit.layout.padding(10,10) -- padding of 10x10 pixels

        -- add a new row with width=300 and height=30 and put a button in it
        if suit.Button("Hello, World!", suit.layout.row(300,30)).hit then
            show_message = true
        end

        -- add another row of the same size below the first row
        if show_message then
            suit.Label("How are you today?", suit.layout.row())
        end
    end

    function love.draw()
        suit.core.draw()
    end

At the beginning of each frame, the layout has to be reset. You can provide an
optional starting position and padding as arguments. Rows and columns are added
using ``layout.row(w,h)`` and ``layout.col(w,h)``. If omitted, the width and
height of the cell are copied from the previous cell. There are also special
identifiers that calculate the size from all cells since the last ``reset()``:
``max``, ``min`` and ``median``. They do what you expect them to do.

It is also possible to nest rows and columns and to let cells dynamically fill
available space. Refer to the :doc:`Layout <layout>` documentation for more
information.


Themeing
--------

SUIT allows to customize the appearance of any widget (except
:func:`ImageButton`). Each widget is drawn by a function of the same name in
the ``theme``-table of the core module. So, a button is drawn by the function
``suit.core.theme.Button``. You can overwrite these functions or swap the whole
table to achieve a different look.

However, most of the time, especially when prototyping, you probably don't want
to do this. For this reason, the default theme can be customized by modifying a
color scheme, contained in the table ``suit.core.theme.color``::

    theme.color = {
        normal = {bg = {78,78,78}, fg = {200,200,200}, border={20,20,20}},
        hot    = {bg = {98,98,98}, fg = {69,201,84},   border={30,30,30}},
        active = {bg = {88,88,88}, fg = {49,181,64},   border={10,10,10}}
    }

The keys ``normal``, ``hot`` and ``active`` correspond to different widget states:
When the mouse is above a widget, it is ``hot``, if the mouse is pressed (but
not released) on a widget, it is ``active``, and otherwise it is in the
``normal`` state.
Each state defines a background (``bg``), foreground (``fg``) and border color.

You can change the colors directly by overwriting the values::

    function love.load()
        suit.core.theme.color.normal.fg = {255,255,255}
        suit.core.theme.color.hot = {bg = {200,230,255}, {fg = {0,0,0}, border = {120,140,180}}}
    end

.. [1] Determined by rigorous scientific experiments [2]_.
.. [2] Significance level p = 0.5 [1]_.
