Core Functions
==============

The core functions can be divided into two parts: Functions of interest to the
user and functions of interest to the (widget) developer.

External Interface
------------------

Drawing
^^^^^^^

.. function:: draw()

Draw the GUI - call in ``love.draw``.

.. data:: theme

The current theme. See :doc:`themes`.


Mouse Input
^^^^^^^^^^^

.. function:: updateMouse(x,y, buttonDown)

   :param number x,y: Position of the mouse.
   :param boolean buttonDown: Whether the mouse button is down.

Update mouse position and button status. You do not need to call this function,
unless you use some screen transformation (e.g., scaling, camera systems, ...).

Keyboard Input
^^^^^^^^^^^^^^

.. function:: keypressed(key)

   :param KeyConstant key: The pressed key.

Forwards a ``love.keypressed(key)`` event to SUIT.

.. function:: textinput(char)

   :param string char: The pressed character

Forwards a ``love.textinput(key)`` event to SUIT.


GUI State
^^^^^^^^^

.. function:: anyHovered()

   :returns: ``true`` if any widget is hovered by the mouse.

Checks if any widget is hovered by the mouse.

.. function:: isHovered(id)

   :param mixed id: Identifier of the widget.
   :returns: ``true`` if the widget is hovered by the mouse.

Checks if the widget identified by ``id`` is hovered by the mouse.

.. function:: wasHovered(id)

   :param mixed id: Identifier of the widget.
   :returns: ``true`` if the widget was in the hovered by the mouse in the last frame.

Checks if the widget identified by ``id`` was hovered by the mouse in the last frame.

.. function:: anyActive()

   :returns: ``true`` if any widget is in the ``active`` state.

Checks whether the mouse button is pressed and held on any widget.

.. function:: isActive(id)

   :param mixed id: Identifier of the widget.
   :returns: ``true`` if the widget is in the ``active`` state.

Checks whether the mouse button is pressed and held on the widget identified by ``id``.

.. function:: anyHit()

   :returns: ``true`` if the mouse was pressed and released on any widget.

Check whether the mouse was pressed and released on any widget.

.. function:: isHit(id)

   :param mixed id: Identifier of the widget.
   :returns: ``true`` if the mouse was pressed and released on the widget.

Check whether the mouse was pressed and released on the widget identified by ``id``.


Internal Helpers
----------------

.. function:: getOptionsAndSize(...)

   :param mixed ...: Varargs.
   :returns: ``options, x,y,w,h``.

Converts varargs to option table and size definition. Used in the widget
functions.

.. function:: registerDraw(f, ...)

   :param function f: Function to call in ``draw()``.
   :param mixed ...: Arguments to f.

Registers a function to be executed during :func:`draw()`. Used by widgets to
make themselves visible.

.. function:: enterFrame()

Prepares GUI state when entering a frame.

.. function:: exitFrame()

Clears GUI state when exiting a frame.


Mouse Input
^^^^^^^^^^^

.. function:: mouseInRect(x,y,w,h)

   :param numbers x,y,w,h: Rectangle definition.
   :returns: ``true`` if the mouse cursor is in the rectangle.

Checks whether the mouse cursor is in the rectangle defined by ``x,y,w,h``.

.. function:: registerMouseHit(id, ul_x, ul_y, hit)

   :param mixed id: Identifier of the widget.
   :param numbers ul_x, ul_y: Upper left corner of the widget.
   :param function hit: Function to perform the hit test.

Registers a hit-test defined by the function ``hit`` for the widget identified
by ``id``. Sets the widget to ``hovered`` if th hit-test returns ``true``. Sets the
widget to ``active`` if the hit-test returns ``true`` and the mouse button is
pressed.

The hit test receives coordinates in the coordinate system of the widget, i.e.
``(0,0)`` is the upper left corner of the widget.

.. function:: registerHitbox(id, x,y,w,h)

   :param mixed id: Identifier of the widget.
   :param numbers x,y,w,h: Rectangle definition.

Registers a hitbox for the widget identified by ``id``. Literally this function::

    function registerHitbox(id, x,y,w,h)
        return registerMouseHit(id, x,y, function(u,v)
            return u >= 0 and u <= w and v >= 0 and v <= h
        end)
    end

.. function:: mouseReleasedOn(id)

   :param mixed id: Identifier of the widget.
   :returns: ``true`` if the mouse was released on the widget.

Checks whether the mouse button was released on the widget identified by ``id``.

.. function:: getMousePosition()

   :returns: Mouse positon ``mx, my``.

Get the mouse position.

Keyboard Input
^^^^^^^^^^^^^^

.. function:: getPressedKey()

   :returns: KeyConstant

Get the currently pressed key (if any).

.. function:: grabKeyboardFocus(id)

   :param mixed id: Identifier of the widget.

Try to grab keyboard focus. Successful only if the widget is in the ``active``
state.

.. function:: hasKeyboardFocus(id)

   :param mixed id: Identifier of the widget.
   :returns: ``true`` if the widget has keyboard focus.

Checks whether the widget identified by ``id`` currently has keyboard focus.

.. function:: keyPressedOn(id, key)

   :param mixed id: Identifier of the widget.
   :param KeyConstant key: Key to query.
   :returns: ``true`` if ``key`` was pressed on the widget.

Checks whether the key ``key`` was pressed while the widget identified by
``id`` has keyboard focus.


Instancing
----------

.. function:: new()

   :returns: Separate UI state.

Create a separate UI and layout state.  Everything that happens in the new
state will not affect any other state.  You can use the new state like the
"global" state ``suit``, but call functions with the colon syntax instead of
the dot syntax, e.g.::

    function love.load()
        dress = suit.new()
    end

    function love.update()
        dress.layout:reset()
        dress:Label("Hello, World!", dress.layout:row(200,30))
        dress:Input(input, dress.layout:row())
    end

    function love.draw()
        dress:draw()
    end

.. warning::

   Unlike UI and layout state, the theme might be shared with other states.
   Changes in a shared theme will be shared across all themes.
   See the :ref:`Instance Theme <instance-theme>` subsection in the
   :doc:`gettingstarted` guide.
