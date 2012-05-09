--[[
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
]]--

local stack = {n = 0}
local default = {
	pos = {0,0},
	grow = {0,0},
	spacing = 2,
	size = {100, 30},
	upper_left  = {0,0},
	lower_right = {0,0},
}
local current = default

local Grow = {
	none  = { 0,  0},
	up    = { 0, -1},
	down  = { 0,  1},
	left  = {-1,  0},
	right = { 1,  0}
}

-- {grow = grow, spacing = spacing, size = size, pos = pos}
local function push(info)
	local grow    = info.grow    or "none"
	local spacing = info.spacing or default.spacing

	local size = {
		info.size and info.size[1] or current.size[1],
		info.size and info.size[2] or current.size[2]
	}

	local pos = {current.pos[1], current.pos[2]}
	if info.pos then
		pos[1] = pos[1] + (info.pos[1] or 0)
		pos[2] = pos[2] + (info.pos[2] or 0)
	end

	assert(size, "Size neither specified nor derivable from parent group.")
	assert(pos, "Position neither specified nor derivable from parent group.")
	grow = assert(Grow[grow], "Invalid grow: " .. tostring(grow))

	current = {
		pos         = pos,
		grow        = grow,
		size        = size,
		spacing     = spacing,
		upper_left  = { math.huge,  math.huge},
		lower_right = {-math.huge, -math.huge},
	}
	stack.n = stack.n + 1
	stack[stack.n] = current
end

local function advance(pos, size)
	current.upper_left[1]  = math.min(current.upper_left[1], pos[1])
	current.upper_left[2]  = math.min(current.upper_left[2], pos[2])
	current.lower_right[1] = math.max(current.lower_right[1], pos[1] + size[1])
	current.lower_right[2] = math.max(current.lower_right[2], pos[2] + size[2])

	if current.grow[1] ~= 0 then
		current.pos[1] = pos[1] + current.grow[1] * (size[1] + current.spacing)
	end
	if current.grow[2] ~= 0 then
		current.pos[2] = pos[2] + current.grow[2] * (size[2] + current.spacing)
	end
	return pos, size
end

local function getRect(pos, size)
	pos  = {pos  and pos[1]  or 0,               pos  and pos[2]  or 0}
	size = {size and size[1] or current.size[1], size and size[2] or current.size[2]}

	-- growing left/up: update current position to account for differnt size
	if current.grow[1] < 0 and current.size[1] ~= size[1] then
		current.pos[1] = current.pos[1] + (current.size[1] - size[1])
	end
	if current.grow[2] < 0 and current.size[2] ~= size[2] then
		current.pos[2] = current.pos[2] - (current.size[2] - size[2])
	end

	pos[1] = pos[1] + current.pos[1]
	pos[2] = pos[2] + current.pos[2]

	return advance(pos, size)
end

local function pop()
	assert(stack.n > 0, "Group stack is empty.")
	stack.n = stack.n - 1
	local child = current
	current = stack[stack.n] or default

	local size = {
		child.lower_right[1] - math.max(child.upper_left[1], current.pos[1]),
		child.lower_right[2] - math.max(child.upper_left[2], current.pos[2])
	}
	advance(current.pos, size)
end

local function beginFrame()
	current = default
	stack.n = 0
end

local function endFrame()
	-- future use?
end

return setmetatable({
	push       = push,
	pop        = pop,
	getRect    = getRect,
	advance    = advance,
	beginFrame = beginFrame,
	endFrame   = endFrame,
	default    = default,
}, {__index = function(_,k) 
	return ({size = current.size, pos = current.pos})[k]
end})
