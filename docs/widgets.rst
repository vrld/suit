Widgets
=======

.. note::
  Still under construction...

Immutable Widgets
-----------------

.. function:: Button(text, [options], x,y,w,h)

   :param string text: Button label.
   :param table options: Optional settings (see below).
   :param numbers x,y: Upper left corner of the widget.
   :param numbers w,h: Width and height of the widget.o
   :returns: Return state (see below).

Creates a button widget at position ``(x,y)`` with width ``w`` and height
``h``.

.. function:: Label(text, [options], x,y,w,h)

   :param string text: Label text.
   :param table options: Optional settings (see below).
   :param numbers x,y: Upper left corner of the widget.
   :param numbers w,h: Width and height of the widget.o
   :returns: Return state (see below).

Creates a label at position ``(x,y)`` with width ``w`` and height ``h``.

.. function:: ImageButton(normal, options, x,y)

   :param mixed normal: Image of the button in normal state.
   :param table options: Widget options.
   :param numbers x,y: Upper left corner of the widget.
   :returns: Return state (see below).

Creates an image button widget at position ``(x,y)``.
Unlike all other widgets, an ``ImageButton`` is not affected by the current
theme.
The argument ``normal`` defines the image of the normal state as well as the
area of the widget.
The button activates when the mouse enters the area occupied by the widget.
If the option ``mask`` defined, the button activates only if the mouse is over
a pixel with non-zero alpha.
You can provide additional ``hovered`` and ``active`` images, but the widget area
is always computed from the ``normal`` image.
You can provide additional ``hovered`` and ``active`` images, but the widget area
is always computed from the ``normal`` image.

**Additional Options:**

``mask``
   Alpha-mask of the button, i.e. an ``ImageData`` of the same size as the
   ``normal`` image that has non-zero alpha where the button should activate.

``normal``
   Image for the normal state of the widget. Defaults to widget payload.

``hovered``
   Image for the hovered state of the widget. Defaults to ``normal`` if omitted.

``active``
   Image for the active state of the widget. Defaults to ``hovered`` if omitted.

.. note::

  ``ImageButton`` does not recieve width and height parameters.  As such, it
  does not necessarily honor the cell size of a :doc:`layout`.

.. note::

  Unlike other widgets, ``ImageButton`` is tinted by the currently active
  color.  If you want the button to appear untinted, make sure the active color
  is set to white before adding the button, e.g.::

    love.graphics.setColor(255,255,255)
    suit.ImageButton(push_me, {hovered=and_then_just, active=touch_me},
                     suit.layout:row())

Mutable Widgets
---------------

.. function:: Checkbox(checkbox, [options], x,y,w,h)

   :param table checkbox: Checkbox state.
   :param table options: Optional settings (see below).
   :param numbers x,y: Upper left corner of the widget.
   :param numbers w,h: Width and height of the widget.o
   :returns: Return state (see below).

Creates a checkbox at position ``(x,y)`` with width ``w`` and height ``h``.

**State:**

``checkbox`` is a table with the following components:

``checked``
   ``true`` if the checkbox is checked, ``false`` otherwise.

``text``
   Optional label to show besides the checkbox.

.. function:: Slider(slider, [options], x,y,w,h)

   :param table slider: Slider state.
   :param table options: Optional settings (see below).
   :param numbers x,y: Upper left corner of the widget.
   :param numbers w,h: Width and height of the widget.o
   :returns: Return state (see below).

Creates a slider at position ``(x,y)`` with width ``w`` and height ``h``.
Sliders can be horizontal (default) or vertical.

**State:**

``value``
   Current value of the slider. Mandatory argument.

``min``
   Minimum value of the slider. Defaults to ``min(value, 0)`` if omitted.

``max``
   Maximum value of the slider. Defaults to ``min(value, 1)`` if omitted.

``step``
   Value stepping for keyboard input. Defaults to ``(max - min)/10`` if omitted.

**Additional Options:**

``vertical``
   Whether the slider is vertical or horizontal.

**Additional Return State:**

``changed``
   ``true`` when the slider value was changed, ``false`` otherwise.


.. function:: Input(input, [options], x,y,w,h)

   :param table input: Checkbox state
   :param table options: Optional settings (see below).
   :param numbers x,y: Upper left corner of the widget.
   :param numbers w,h: Width and height of the widget.o
   :returns: Return state (see below).

Creates an input box at position ``(x,y)`` with width ``w`` and height ``h``.
Implements typical movement (arrow keys, home and end key) and editing
(deletion with backspace and delete) facilities.

**State:**

``text``
   Current text inside the input box. Defaults to the empty string if omitted.

``cursor``
   Cursor position. Defined as the position before the character (including
   EOS), so ``1`` is the position before the first character, etc. Defaults to
   the end of ``text`` if omitted.

**Additional Return State:**

``submitted``
   ``true`` when enter was pressed while the widget has keyboard focus.


Common Options
--------------

``id``
   Identifier of the widget regarding user interaction. Defaults to the first
   argument (e.g., ``text`` for buttons) if omitted.

``font``
   Font of the label. Defaults to the current font (``love.graphics.getFont()``).

``align``
   Horizontal alignment of the label. One of ``"left"``, ``"center"``, or
   ``"right"``. Defaults to ``"center"``.

``valign``
   Vertical alignment of the label. On of ``"top"``, ``"middle"``, or
   ``"bottom"``. Defaults to ``"middle"``.

``color``
   A table to overwrite the color. Undefined colors default to the theme colors.

``cornerRadius``
  The corner radius for boxes. Overwrites the theme corner radius.

``draw``
   A function to replace the drawing function. Refer to :doc:`themes` for more information about the function signatures.


Common Return States
--------------------

``id``
   Identifier of the widget.

``hit``
   ``true`` if the mouse was pressed and released on the button, ``false``
   otherwise.

``hovered``
   ``true`` if the mouse is above the widget, ``false`` otherwise.

``entered``
   ``true`` if the mouse entered the widget area, ``false`` otherwise.

``left``
   ``true`` if the mouse left the widget area, ``false`` otherwise.
