local BASE = (...) .. '.'

return {
	core     = require(BASE .. 'core'),
	Button   = require(BASE .. 'button'),
	Slider   = require(BASE .. 'slider'),
	Slider2D = require(BASE .. 'slider2d'),
	Label    = require(BASE .. 'label'),
	Input    = require(BASE .. 'input'),
	Checkbox = require(BASE .. 'checkbox')
}
