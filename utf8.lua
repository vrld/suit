local function iter(s, i)
	if i >= #s then return end
	local b, nbytes = s:byte(i+1,i+1), 1

	-- determine width of the codepoint by counting the number of set bits in the first byte
	-- warning: there is no validation of the following bytes!
	if     b >= 0xc0 and b <= 0xdf then nbytes = 2 -- 1100 0000 to 1101 1111
	elseif b >= 0xe0 and b <= 0xef then nbytes = 3 -- 1110 0000 to 1110 1111
	elseif b >= 0xf0 and b <= 0xf7 then nbytes = 4 -- 1111 0000 to 1111 0111
	elseif b >= 0xf8 and b <= 0xfb then nbytes = 5 -- 1111 1000 to 1111 1011
	elseif b >= 0xfc and b <= 0xfd then nbytes = 6 -- 1111 1100 to 1111 1101
	elseif b <  0x00 or  b >  0x7f then error(("Invalid codepoint: 0x%02x"):format(b))
	end
	return i+nbytes, s:sub(i+1,i+nbytes), nbytes
end

local function chars(s)
	return iter, s, 0
end

local function len(s)
	-- assumes sane utf8 string: count the number of bytes that is *not* 10xxxxxx
	local _, c = s:gsub('[^\128-\191]', '')
	return c
end

local function sub(s, i, j)
	local l = len(s)
	j = j or l
	if i < 0 then i = l + i + 1 end
	if j < 0 then j = l + j + 1 end
	if j < i then return '' end

	local k, t = 1, {}
	for _, c in chars(s) do
		if k >= i then t[#t+1] = c end
		if k >= j then break end
		k = k + 1
	end
	return table.concat(t)
end

local function split(s, i)
	local l = len(s)
	if i < 0 then i = l + i + 1 end

	local k, pos = 1, 0
	for byte in chars(s) do
		if k > i then break end
		pos, k = byte, k + 1
	end
	return s:sub(1, pos), s:sub(pos+1, -1)
end

local function reverse(s)
	local t = {}
	for _, c in chars(s) do
		table.insert(t, 1, c)
	end
	return table.concat(t)
end

return {
	iter    = iter,
	chars   = chars,
	len     = len,
	sub     = sub,
	split   = split,
	reverse = reverse,
}
