-- utf8.lua - Basic (and unsafe) utf8 string support in plain Lua - public domain
--
-- Written in 2013 by Matthias Richter (vrld@vrld.org)
--
-- This software is in the public domain. Where that dedication is not
-- recognized, you are granted a perpetual, irrevokable license to copy and
-- modify this file as you see fit. This software is distributed without any
-- warranty.

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALL FUNCTIONS ARE UNSAFE: THEY ASSUME VALID UTF8 INPUT
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- Generic for iterator.
--
-- Arguments:
--     s ... The utf8 string.
--     i ... Last byte of the previous codepoint.
--
-- Returns:
--     k ... Number of the *last* byte of the codepoint.
--     c ... The utf8 codepoint (character).
--     n ... Width/number of bytes of the codepoint.
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

-- Shortcut to the generic for iterator.
--
-- Usage:
--    for k, c, n in chars(s) do
--        ...
--    end
--
--    Meaning of k, c, and n is the same as in iter(s, i).
local function chars(s)
	return iter, s, 0
end

-- Get length in characters of an utf8 string.
--
-- Arguments:
--     s ... The utf8 string.
--
-- Returns:
--     n ... Number of utf8 characters in s.
local function len(s)
	-- assumes sane utf8 string: count the number of bytes that is *not* 10xxxxxx
	local _, c = s:gsub('[^\128-\191]', '')
	return c
end

-- Get substring, same semantics as string.sub(s,i,j).
--
-- Arguments:
--     s ... The utf8 string.
--     i ... Starting position, may be negative.
--     j ... (optional) Ending position, may be negative.
--
-- Returns:
--     t ... The substring.
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

-- Split utf8 string in two substrings
--
-- Arguments:
--     s ... The utf8 string.
--     i ... The position to split, may be negative.
--
-- Returns:
--     left  ... Substring before i.
--     right ... Substring after i.
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

-- Reverses order of characters in an utf8 string.
--
-- Arguments:
--     s ... The utf8 string.
--
-- Returns:
--     t ... The revered string.
local function reverse(s)
	local t = {}
	for _, c in chars(s) do
		table.insert(t, 1, c)
	end
	return table.concat(t)
end

-- Convert a Unicode code point to a UTF-8 byte sequence
-- Logic stolen from this page:
-- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
--
-- Arguments:
--     Number representing the Unicode code point (e.g. 0x265c).
--
-- Returns:
--     UTF-8 encoded string of the given character.
--     Numbers out of range produce a blank string.
local function encode(code)
	if code < 0 then
		error('Code point must not be negative.')
	elseif code <= 0x7f then
		return string.char(code)
	elseif code <= 0x7ff then
		local c1 = code / 64 + 192
		local c2 = code % 64 + 128
		return string.char(c1, c2)
	elseif code <= 0xffff then
		local c1 = code / 4096 + 224
		local c2 = code % 4096 / 64 + 128
		local c3 = code % 64 + 128
		return string.char(c1, c2, c3)
	elseif code <= 0x10ffff then
		local c1 = code / 262144 + 240
		local c2 = code % 262144 / 4096 + 128
		local c3 = code % 4096 / 64 + 128
		local c4 = code % 64 + 128
		return string.char(c1, c2, c3, c4)
	end
	return ''
end

return {
	iter    = iter,
	chars   = chars,
	len     = len,
	sub     = sub,
	split   = split,
	reverse = reverse,
	encode  = encode
}
