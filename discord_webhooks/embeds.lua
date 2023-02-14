--[[
	Author: Fernando

	Discord Webhooks MTA Resource (Embeds)

	/!\ Unless you know what you are doing, do not edit this file /!\
]]

-- https://discord.com/developers/docs/resources/channel#embed-object
local EMBED_STRUCTURE = {
    -- must be "rich" for webhooks
	type = {type="string", required=false},

	title = {type="string", required=false},
	description = {type="string", required=false},
	url = {type="string", required=false},
	timestamp = {types={"number", "string"}, required=false},
	color = {type="number", required=false},

	thumbnail = {type={
		url = {type="string", required=true},
		proxy_url = {type="string", required=false},
		height = {type="number", required=false},
		width = {type="number", required=false}
	}, required=false},
	image = {type={
		url = {type="string", required=true},
		proxy_url = {type="string", required=false},
		height = {type="number", required=false},
		width = {type="number", required=false}
	}, required=false},
	author = {type={
		name = {type="string", required=true},
		url = {type="string", required=false},
		icon_url = {type="string", required=false},
		proxy_icon_url = {type="string", required=false}
	}, required=false},
	footer = {type={
		text = {type="string", required=true},
		icon_url = {type="string", required=false},
		proxy_icon_url = {type="string", required=false}
	}, required=false},
	fields = {type="array", array_types={
		name = {type="string", required=true},
		value = {type="string", required=true},
		inline = {type="boolean", required=false}
	}, required=false},

    -- useless?
	video = {type={
		url = {type="string", required=true},
		height = {type="number", required=false},
		width = {type="number", required=false}
	}, required=false},
	provider = {type={
		name = {type="string", required=true},
		url = {type="string", required=false}
	}, required=false},
}

local function validateOneType(fieldName, value, theType, required)
	if value == nil then
		if required == true then
			return false, "Missing required field '"..fieldName.."'"
		end
	else
		if type(theType) == "table" then
			local valid = false
			for i=1, #theType do
				if type(value) == theType[i] then
					valid = true
					break
				end
			end
			if valid == false then
				return false, "Invalid type for field '"..fieldName.."'. Expected '"..table.concat(theType, "' or '").."', got '"..type(value).."'"
			end
		elseif type(value) ~= theType then
			return false, "Invalid type for field '"..fieldName.."'. Expected '"..theType.."', got '"..type(value).."'"
		end
		if type(value) == "table" then
			for k2, v2 in pairs(value) do
				if type(v2) == "table" then
					return false, "Invalid type for field '"..fieldName.."'. Expected '"..theType.."', got '"..type(value).."'"
				end
			end
		end
	end
	return true
end

local function validateEmbedFields(embed)
	local fields = {}
	for fieldName, info in pairs(EMBED_STRUCTURE) do
		local theType = info.type
		local theTypes = info.types
		local required = info.required

		local value = embed[fieldName]
		if value == nil then
			if required == true then
				return false, "Missing required field '"..fieldName.."'"
			end
		else
			if theType == "array" then
				if value[1] == nil then
					return false, "Field '"..fieldName.."' is an array, but it is empty"
				end
				local array_types = info.array_types
				fields[fieldName] = {}
				for i=1, #value do
					local v = value[i]
					if v then
						for k, t in pairs(array_types) do
							local theType2 = t.type
							local required2 = t.required
							local value2 = v[k]
							local valid, err = validateOneType(fieldName.."["..i.."]."..k, value2, theType2, required2)
							if valid == false then
								return false, err
							end
							fields[fieldName][i] = fields[fieldName][i] or {}
							fields[fieldName][i][k] = value2
						end
					end
				end
			elseif type(theType) == "table" then
				if not fields[fieldName] then
					fields[fieldName] = {}
				end
				for k, t in pairs(theType) do
					local theType2 = t.type
					local required2 = t.required
					local value2 = value[k]
					local valid, err = validateOneType(fieldName.."."..k, value2, theType2, required2)
					if valid == false then
						return false, err
					end
					fields[fieldName][k] = value2
				end
			elseif type(theTypes) == "table" then
				local valid = false
				for i=1, #theTypes do
					if type(value) == theTypes[i] then
						valid = true
						break
					end
				end
				if valid == false then
					return false, "Invalid type for field '"..fieldName.."'. Expected '"..table.concat(theTypes, "' or '").."', got '"..type(value).."'"
				end
				fields[fieldName] = value
			else
				if type(value) ~= theType then
					return false, "Invalid type for field '"..fieldName.."'. Expected '"..theType.."', got '"..type(value).."'"
				end
				fields[fieldName] = value
			end
		end
	end
	return true, fields
end

-- Returns a ISO 8061 formatted timestamp in UTC (Z)
-- e.g. 2021-09-21T15:20:44.323Z
local function iso_8061_timestamp(now)
    local ms = math.floor((now % 1) * 1000) -- never happens because getRealTime returns integer seconds
    local epochSeconds = math.floor(now)
    return os.date("!%Y-%m-%dT%T", epochSeconds) .. "." .. ms .. "Z"
end

-- Inverse of tocolor
local function fromColor(color)
	local blue = bitExtract(color, 0, 8)
	local green = bitExtract(color, 8, 8)
	local red = bitExtract(color, 16, 8)
	-- local alpha = bitExtract(color, 24, 8) -- unsupported by Discord
	return { red, green, blue }
end

local function rgbToHex(rgb)
	local hexadecimal = '0x'
	for key, value in pairs(rgb) do
		local hex = ''
		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end
		if(string.len(hex) == 0)then
			hex = '00'
		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end
		hexadecimal = hexadecimal .. hex
	end
	return tonumber(hexadecimal)
end

-- Used in system.lua
function validateEmbed(embed)
	local valid, additional = validateEmbedFields(embed)
	if valid == false then
		return false, additional
	end
	-- Validate and adapt some special fields
	if (additional.type ~= nil) then
		if (additional.type ~= "rich") then
			return false, "Disallowed type. Expected 'rich', got '"..additional.type.."'"
		end
	else
		additional.type = "rich"
	end
	if (additional.timestamp ~= nil) then
		if type(additional.timestamp) == "number" then
			additional.timestamp = iso_8061_timestamp(additional.timestamp)
		else
			if (additional.timestamp == "now") then
				local now = getRealTime().timestamp
				additional.timestamp = iso_8061_timestamp(now)
			else
				return false, "Invalid timestamp. Expected 'now' or a number, got '"..additional.timestamp.."'"
			end
		end
	end
	if (additional.color ~= nil) then
		-- check if in range of tocolor()
		if (additional.color >= 0) and (additional.color <= 0xFFFFFFFF) then
			additional.color = rgbToHex(fromColor(additional.color))
		else
			return false, "Invalid color. Expected a number between 0 and 0xFFFFFFFF, got '"..additional.color.."' - use tocolor(R,G,B) or 0xRRGGBB"
		end
	end
	return true, additional
end
