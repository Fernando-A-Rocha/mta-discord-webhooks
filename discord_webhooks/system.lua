--[[
	Author: Fernando

	Discord Webhooks MTA Resource (System)

	/!\ Unless you know what you are doing, do not edit this file /!\
]]

-- Custom Events:
addEvent("discord_webhooks:send", false) -- source must always be root (Event cannot be triggered by remote clients)
addEvent("discord_webhooks:sendToURL", false) -- source must always be root (Event cannot be triggered by remote clients)

-- https://discord.com/developers/docs/resources/webhook#execute-webhook-jsonform-params
local function internalValidateMessage(message)
	local newMessage
	if type(message) == "string" then
		newMessage = {
			["content"] = message
		}
	elseif type(message) == "table" then
		if type(message.embeds) ~= "table" then
			-- Doesn't have embeds key
			if message[1] == nil then
				-- Is not an ordered table, assume it's a single embed table
				message.embeds = {message}
			else
				-- Is an ordered table, assume it's a list of embed tables
				message.embeds = message
			end
		else
			-- Has embeds key
			if message.embeds[1] == nil then
				return false, "Invalid embeds: Expected table with at least one element OR one element directly, got empty table"
			end
			-- Check for additional message attributes
			if message.content ~= nil then
				if type(message.content) ~= "string" then
					return false, "Invalid content: Expected string, got "..type(message.content)
				end
			end
			if message.username ~= nil then
				if type(message.username) ~= "string" then
					return false, "Invalid username: Expected string, got "..type(message.username)
				end
			end
			if message.avatar_url ~= nil then
				if type(message.avatar_url) ~= "string" then
					return false, "Invalid avatar_url: Expected string, got "..type(message.avatar_url)
				end
			end
			if message.tts ~= nil then
				if type(message.tts) ~= "boolean" then
					return false, "Invalid tts: Expected boolean, got "..type(message.tts)
				end
			end
			-- TODO:
			-- 		allowed_mentions
			-- 		flags
			-- 		thread_name
			-- 		components (require an application-owned webhook)
			
			-- File attachments (files[n], payload_json, attachments) will probably not be supported here
		end
		for i=1, #message.embeds do
			local embed = message.embeds[i]
			if embed then
				local valid, additional = validateEmbed(embed)
				if not valid then
					return false, "Invalid embed: "..tostring(additional).." (embeds["..tostring(i).."])"
				end
				message.embeds[i] = additional
			end
		end
		newMessage = {
			["content"] = message.content,
			["embeds"] = message.embeds
		}
	end
	return newMessage
end

local function internalSendRequest(name, url, message, callBackEvent)
	local newMessage, failReason = internalValidateMessage(message)
	if not newMessage then
		return false, "internalSendRequest ERROR: "..tostring(failReason)
	end
	newMessage = toJSON(newMessage, true)
	-- make it only JSON object and not [JSON object] (it's inside an array for no reason)
	if string.sub(newMessage, 1, 1) == "[" then
		newMessage = string.sub(newMessage, 2, -2)
	end
	if (LOG_INFO_DEBUG) then
		outputDebugString("Sending to URL '"..url.."' with data:", 3)
		outputDebugString(newMessage, 3)
	end
	local function callBackFunction(responseData, responseInfo)
		triggerEvent(callBackEvent.name, callBackEvent.source, {
			name = name, -- false if sendToURL is used
			url = url,
			message = newMessage,
			responseData = responseData,
			responseInfo = responseInfo
		}, unpack(callBackEvent.args or {}))
	end
	if callBackEvent == nil then
		callBackFunction = function() end
	end
	local request = fetchRemote(url, {
		queueName = md5(url),
		connectionAttempts = 3,
		connectTimeout = 5000,
		method = "POST",
		postIsBinary = false,
		headers = {
			["Content-Type"] = "application/json"
		},
		postData = newMessage,
	}, callBackFunction)
	if not request then
		return false, "internalSendRequest ERROR: fetchRemote failed"
	end
	return request
end

local function internalSend(name, message, callBackEvent)
	if type(name) ~= "string" then
		return false, "Bad argument @ 'send' [Expected string at argument 1, got "..type(name).."]"
	end
	local url = WEB_HOOKS[name]
	if type(url) ~= "string" then
		return false, "Bad argument @ 'send' [Webhook name '"..name.."' (argument 1) does not have a valid URL]"
	end
	if not (type(message)=="string" or (type(message)=="table")) then
		return false, "Bad argument @ 'send' [Expected string or table at argument 2, got "..type(message).."]"
	end
	if callBackEvent ~= nil then
		if (type(callBackEvent) ~= "table") then
			return false, "Bad argument @ 'send' [Expected table at argument 3, got "..type(callBackEvent).."]"
		end
		if (type(callBackEvent.name) ~= "string") then
			return false, "Bad argument @ 'send' [Expected string at argument 3.name, got "..type(callBackEvent.name).."]"
		end
		if (not isElement(callBackEvent.source) and callBackEvent.source ~= root) then
			return false, "Bad argument @ 'send' [Expected element at argument 3.source, got "..type(callBackEvent.source).."]"
		end
		if (callBackEvent.args ~= nil) and (type(callBackEvent.args) ~= "table") then
			return false, "Bad argument @ 'send' [Expected table at argument 3.args, got "..type(callBackEvent.args).."]"
		end
	end
	return internalSendRequest(name, url, message, callBackEvent)
end

-- Exported function
function send(...)
	local result, reason = internalSend(...)
	if (not result) and (LOG_ERRORS_DEBUG == true) then
		outputDebugString(tostring(reason), 1)
	end
	return result, reason
end
addEventHandler("discord_webhooks:send", root, send, false)

local function isValidURL(url)
	return url:match("[a-z]+://[^ >,;]+")
end

local function internalSendToURL(url, message, callBackEvent)
	if type(url) ~= "string" then
		return false, "Bad argument @ 'sendToURL' [Expected string at argument 1, got "..type(url).."]"
	end
	if not isValidURL(url) then
		outputDebugString("sendToURL: URL may not be valid: "..url, 2)
	end
	if type(message) ~= "string" and type (message) ~= "table" then
		return false, "Bad argument @ 'sendToURL' [Expected string or table at argument 2, got "..type(message).."]"
	end
	if callBackEvent ~= nil then
		if type(callBackEvent) ~= "table" then
			return false, "Bad argument @ 'sendToURL' [Expected table at argument 3, got "..type(callBackEvent).."]"
		end
		if type(callBackEvent.name) ~= "string" then
			return false, "Bad argument @ 'sendToURL' [Expected string at argument 3.name, got "..type(callBackEvent.name).."]"
		end
		if not (isElement(callBackEvent.source) or callBackEvent.source == root) then
			return false, "Bad argument @ 'sendToURL' [Expected element at argument 3.source, got "..type(callBackEvent.source).."]"
		end
		if callBackEvent.args ~= nil and type(callBackEvent.args) ~= "table" then
			return false, "Bad argument @ 'send' [Expected table at argument 3.args, got "..type(callBackEvent.args).."]"
		end
	end
	local foundName = false
	for name, webhookURL in pairs(WEB_HOOKS) do
		if webhookURL == url then
			foundName = name
			break
		end
	end
	return internalSendRequest(foundName, url, message, callBackEvent)
end

-- Exported function
function sendToURL(...)
	local result, reason = internalSendToURL(...)
	if (not result) and (LOG_ERRORS_DEBUG == true) then
		outputDebugString(tostring(reason), 1)
	end
	return result, reason
end
addEventHandler("discord_webhooks:sendToURL", root, sendToURL, false)

-- Exported function
function validateMessage(message)
	local newMessage, failReason = internalValidateMessage(message)
	if not newMessage then
		return false, failReason
	end
	return newMessage
end
	
addEventHandler("onResourceStart", resourceRoot, function()
	if type(WEB_HOOKS) ~= "table" then
		outputServerLog("WEB_HOOKS is not a table. Please check your config.lua file.")
		return cancelEvent()
	end
	for name, url in pairs(WEB_HOOKS) do
		if type(name) ~= "string" then
			outputServerLog("WEB_HOOKS contains a non-string key. Please check your config.lua file.")
			return cancelEvent()
		end
		if type(url) ~= "string" then
			outputServerLog("WEB_HOOKS contains a non-string value. Please check your config.lua file.")
			return cancelEvent()
		end
	end
	-- No critical errors, continue
	if type(SETTING_DISABLE) == "string"  then
		local settingValue = tostring(get(SETTING_DISABLE))
		if (settingValue == "true" or settingValue == "1") then
			if (LOG_INFO_DEBUG) then
				outputDebugString("Webhooks are disabled by the server's settings registry.", 3)
			end
			send = function() return true end
			sendToURL = function() return true end
			return
		end
	end
	if (LOG_INFO_DEBUG) then
		outputDebugString("Initialization complete ("..#WEB_HOOKS.." webhooks declared).", 3)
	end
end, false)
