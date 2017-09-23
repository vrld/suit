Layout
======

.. note::
  Still under construction...

Immediate Mode Layouts
----------------------

.. function:: reset([x,y, [pad_x, [pad_y]]])

   :param numbers x,y: Origin of the layout (optional).
   :param pad_x,pad_y: Cell padding (optional).

Reset the layout, puts the origin at ``(x,y)`` and sets the cell padding to
``pad_x`` and ``pad_y``.

If ``x`` and ``y`` are omitted, they default to ``(0,0)``. If ``pad_x`` is
omitted, it defaults to 0. If ``pad_y`` is omitted, it defaults to ``pad_x``.

.. function:: padding([pad_x, [pad_y]])

   :param pad_x: Cell padding in x direction (optional).
   :param pad_y: Cell padding in y direction (optional, defaults to ``pad_x``).
   :returns: The current (or new) cell padding.

Get and set the current cell padding.

If given, sets the cell padding to ``pad_x`` and ``pad_y``.
If only ``pad_x`` is given, set both padding in ``x`` and ``y`` direction to ``pad_x``.

.. function:: size()

   :returns: ``width,height`` - The size of the last cell.

Get the size of the last cell.

.. function:: nextRow()

   :returns: ``x,y`` - Upper left corner of the next row cell.

Get the position of the upper left corner of the next cell in a row layout.
Use for mixing precomputed and immediate mode layouts.

.. function:: nextCol()

   :returns: ``x,y`` - Upper left corner of the next column cell.

Get the position of the upper left corner of the next cell in a column layout.
Use for mixing precomputed and immediate mode layouts.

.. function:: push([x,y])

   :param numbers x,y: Origin of the layout (optional).

Saves the layout state (position, padding, sizes, etc.) on a stack, resets the
layout with position ``(x,y)``.

If ``x`` and ``y`` are omitted, they default to ``(0,0)``.

Used for nested row/column layouts.

.. function:: pop()

Restores the layout parameters from the stack and advances the layout position
according to the size of the popped layout.

Used for nested row/column layouts.

.. _layout-row:

.. function:: row(w,h)

   :param mixed w,h: Cell width and height (optional).
   :returns: Position and size of the cell: ``x,y,w,h``.

Creates a new cell below the current cell with width ``w`` and height ``h``. If
either ``w`` or ``h`` is omitted, the value is set the last used value. Both
``w`` and ``h`` can be a string, which takes the following meaning:

``max``
   Maximum of all values since the last reset.

``min``
   Mimimum of all values since the last reset.

``median``
   Median of all values since the last reset.

Used to provide the last four arguments to a widget, e.g.::

    suit.Button("Start Game", suit.layout:row(100,30))
    suit.Button("Options", suit.layout:row())
    suit.Button("Quit", suit.layout:row(nil, "median"))

.. function:: down(w,h)

An alias for :ref:`layout:row() <layout-row>`.

.. _layout-col:

.. function:: col(w,h)

   :param mixed w,h: Cell width and height (optional).
   :returns: Position and size of the cell: ``x,y,w,h``.

Creates a new cell to the right of the current cell with width ``w`` and height
``h``.  If either ``w`` or ``h`` is omitted, the value is set the last used
value. Both ``w`` and ``h`` can be a string, which takes the following meaning:

``max``
   Maximum of all values since the last reset.

``min``
   Mimimum of all values since the last reset.

``median``
   Median of all values since the last reset.

Used to provide the last four arguments to a widget, e.g.::

    suit.Button("OK", suit.layout:col(100,30))
    suit.Button("Cancel", suit.layout:col("max"))

.. function:: right(w,h)

An alias for :ref:`layout:col() <layout-col>`.

.. function:: up(w,h)

   :param mixed w,h: Cell width and height (optional).
   :returns: Position and size of the cell: ``x,y,w,h``.

Creates a new cell above the current cell with width ``w`` and height ``h``. If
either ``w`` or ``h`` is omitted, the value is set the last used value. Both
``w`` and ``h`` can be a string, which takes the following meaning:

``max``
   Maximum of all values since the last reset.

``min``
   Mimimum of all values since the last reset.

``median``
   Median of all values since the last reset.

Be careful when mixing ``up()`` and :ref:`layout:row() <layout-row>`, as suit
does no checking to make sure cells don't overlap. e.g.::

    suit.Button("A", suit.layout:row(100,30))
    suit.Button("B", suit.layout:row())
    suit.Button("Also A", suit.layout:up())

.. function:: left(w,h)

   :param mixed w,h: Cell width and height (optional).
   :returns: Position and size of the cell: ``x,y,w,h``.

Creates a new cell to the left of the current cell with width ``w`` and height
``h``. If either ``w`` or ``h`` is omitted, the value is set the last used
value. Both ``w`` and ``h`` can be a string, which takes the following meaning:

``max``
   Maximum of all values since the last reset.

``min``
   Mimimum of all values since the last reset.

``median``
   Median of all values since the last reset.

Be careful when mixing ``left()`` and :ref:`layout:col() <layout-col>`, as suit
does no checking to make sure cells don't overlap. e.g.::

    suit.Button("A", suit.layout:col(100,30))
    suit.Button("B", suit.layout:col())
    suit.Button("Also A", suit.layout:left())

Precomputed Layouts
-------------------

Apart from immediate mode layouts, you can specify layouts in advance.
The specification is a table of tables, where each inner table follows the
convention of :func:`row` and :func:`col`.
The result is a layout definition object that can be used to access the cells.

There are almost only two reasons to do so: (1) You know the area of your
layout in advance (say, the screen size), and want certain cells to dynamically
fill the available space; (2) You want to animate the cells.

.. note::
    Unlike immediate mode layouts, precomputed layouts **can not be nested**.
    You can mix immediate mode and precomputed layouts to achieve nested
    layouts with precomputed cells, however.

Layout Specifications
^^^^^^^^^^^^^^^^^^^^^

Layout specifications are tables of tables, where the each inner table
corresponds to a cell. The inner tables define the width and height of the cell
according to the rules of :func:`row` and :func:`col`, with one additonal
keyword:

``fill``
   Fills the available space, determined by ``min_height`` or ``min_width`` and
   the number of cells with property ``fill``.

For example, this row specification makes the height of the second cell to
``(300 - 50 - 50) / 1 = 200``::

    {min_height = 300,
        {100, 50},
        {nil, 'fill'},
        {nil, 50},
    }

This column specification divides the space evenly among two cells::

    {min_width = 300,
        {'fill', 100}
        {'fill'}
    }

Apart from ``min_height`` and ``min_width``, layout specifications can also
define the position (upper left corner) of the layout using the ``pos`` keyword::

    {min_width = 300, pos = {100,100},
        {'fill', 100}
        {'fill'}
    }

You can also define a padding::

    {min_width = 300, pos = {100,100}, padding = {5,5},
        {'fill', 100}
        {'fill'}
    }

Layout Definition Objects
^^^^^^^^^^^^^^^^^^^^^^^^^

Once constructed, the cells can be accessed in two ways:

- Using iterators::

    for i, x,y,w,h in definition() do
        suit.Button("Button "..i, x,y,w,h)
    end

- Using the ``cell(i)`` accessor::

    suit.Button("Button 1", definition.cell(1))
    suit.Button("Button 3", definition.cell(3))
    suit.Button("Button 2", definition.cell(2))

There is actually a third way: Because layout definitions are just tables, you
can access the cells directly::

    local cell = definition[1]
    suit.Button("Button 1", cell[1], cell[2], cell[3], cell[4])
    -- or suit.Button("Button 1", unpack(cell))

This is especially useful if you want to animate the cells, for example with a
`tween <http://hump.readthedocs.org/en/latest/timer.html#Timer.tween>`_::

    for i,cell in ipairs(definition)
        local destination = {[2] = cell[2]} -- save cell y position
        cell[2] = -cell[4] -- move cell just outside of the screen

        -- let the cells fall into the screen one after another
        timer.after(i / 10, function()
            timer.tween(0.7, cell, destination, 'bounce')
        end)
    end


Constructors
^^^^^^^^^^^^

.. function:: rows(spec)

   :param table spec: Layout specification.
   :returns: Layout definition object.

Defines a row layout.

.. function:: cols(spec)

   :param table spec: Layout specification.
   :returns: Layout definition object.

Defines a column layout.
