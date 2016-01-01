SUIT
====

Simple User Interface Toolkit for `LÖVE <http://love2d.org>`_.

SUIT up
-------

You can download SUIT and view the code on github: `vrld/SUIT
<http://github.com/vrld/SUIT>`_.
You may also download the sourcecode as a `zip
<http://github.com/vrld/SUIT/zipball/master>`_ or `tar
<http://github.com/vrld/SUIT/tarball/master>`_ file.

Using `Git <http://git-scm.com>`_, you can clone the project by running::

    git clone git://github.com/vrld/SUIT

Once done, tou can check for updates by running::

    git pull


Read on
-------

.. toctree::
   :maxdepth: 2

   Getting Started <gettingstarted>
   Widgets <widgets>
   Layout <layout>
   Core Functions <core>
   Themeing <themes>
   License <license>


Example code
------------
::

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
            suit.Label("You uncovered the secret!", {align="left", font = smallerFont}, rows.cell(1))
            suit.Label(slider.value, {align='left'}, rows.cell(3))

            -- give different id to slider on same object so they don't grab
            -- each others user interaction
            suit.Slider(slider, {id = 'vs', vertical=true}, rows.cell(2))
            print(rows.cell(3))
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

Indices and tables
------------------

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
