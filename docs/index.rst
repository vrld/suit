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

    local suit = require 'suit'

    -- generate some assets (below)
    function love.load()
        snd = generateClickySound()
        normal, hot = generateImageButton()
        smallerFont = love.graphics.newFont(10)
    end

    -- data for a slider, an input box and a checkbox
    local slider= {value = 0.5, min = -2, max = 2}
    local input = {text = "Hello"}
    local chk = {text = "Check?"}

    -- all the UI is defined in love.update or functions that are called from here
    function love.update(dt)
        -- put the layout origin at position (100,100)
        -- cells will grown down and to the right from this point
        -- also set cell padding to 20 pixels to the right and to the bottom
        suit.layout.reset(100,100, 20,20)

        -- put a button at the layout origin
        -- the cell of the button has a size of 200 by 30 pixels
        state = suit.Button("Click?", suit.layout.row(200,30))

        -- if the button was entered, play a sound
        if state.entered then love.audio.play(snd) end

        -- if the button was pressed, take damage
        if state.hit then print("Ouch!") end

        -- put an input box below the button
        -- the cell of the input box has the same size as the cell above
        -- if the input cell is submitted, print the text
        if suit.Input(input, suit.layout.row()).submitted then
            print(input.text)
        end

        -- put a button below the input box
        -- the width of the cell will be the same as above, the height will be 40 px
        if suit.Button("Hover?", suit.layout.row(nil,40)).hovered then
            -- if the button is hovered, show two other buttons
            -- this will shift all other ui elements down

            -- put a button below the previous button
            -- the cell height will be 30 px
            -- the label of the button will be aligned top left
            suit.Button("You can see", {align='left', valign='top'}, suit.layout.row(nil,30))

            -- put a button below the previous button
            -- the cell size will be the same as the one above
            -- the label will be aligned bottom right
            suit.Button("...but you can't touch!", {align='right', valign='bottom'},
                                                   suit.layout.row())
        end

        -- put a checkbox below the button
        -- the size will be the same as above
        -- (NOTE: height depends on whether "Hover?" is hovered)
        -- the label "Check?" will be aligned right
        suit.Checkbox(chk, {align='right'}, suit.layout.row())

        -- put a nested layout
        -- the size of the cell will be as big as the cell above or as big as the
        -- nested content, whichever is bigger
        suit.layout.push(suit.layout.row())

            -- put a slider in the cell
            -- the inner cell will be 160 px wide and 20 px high
            suit.Slider(slider, suit.layout.col(160, 20))

            -- put a label that shows the slider value to the right of the slider
            -- the width of the label will be 40 px
            suit.Label(("%.02f"):format(slider.value), suit.layout.col(40))

        -- close the nested layout
        suit.layout.pop()

        -- put an image button below the nested cell
        -- the size of the cell will be 200 by 100 px,
        --      but the image may be bigger or smaller
        -- the button shows the image `normal' when the mouse is outside the image
        --      or above a transparent pixel
        -- the button shows the image `hot` if the mouse is above an opaque pixel
        --      of the image `normal'
        suit.ImageButton({normal, hot = hot}, suit.layout.row(200,100))

        -- if the checkbox is checked, display a precomputed layout
        if chk.checked then
            -- the precomputed layout will be 3 rows below each other
            -- the origin of the layout will be at (400,100)
            -- the minimal height of the layout will be 300 px
            rows = suit.layout.rows{pos = {400,100}, min_height = 300,
                {200, 30},    -- the first cell will measure 200 by 30 px
                {30, 'fill'}, -- the second cell will be 30 px wide and fill the
                              -- remaining vertical space between the other cells
                {200, 30},    -- the third cell will be 200 by 30 px
            }

            -- the first cell will contain a witty label
            -- the label will be aligned left
            -- the font of the label will be smaller than the usual font
            suit.Label("You uncovered the secret!", {align="left", font = smallerFont},
                                                    rows.cell(1))

            -- the third cell will contain a label that shows the value of the slider
            suit.Label(slider.value, {align='left'}, rows.cell(3))

            -- the second cell will show a slider
            -- the slider will operate on the same data as the first slider
            -- the slider will be vertical instead of horizontal
            -- the id of the slider will be 'slider two'. this is necessary, because
            --     the two sliders should not both react to UI events
            suit.Slider(slider, {vertical = true, id = 'slider two'}, rows.cell(2))
        end
    end

    function love.draw()
        -- draw the gui
        suit.core.draw()
    end

    function love.textinput(t)
        -- forward text input to SUIT
        suit.core.textinput(t)
    end

    function love.keypressed(key)
        -- forward keypressed to SUIT
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
