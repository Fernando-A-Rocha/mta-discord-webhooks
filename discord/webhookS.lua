--[[
	Author: Fernando

	Serverside script for using Discord Webhooks in your MTA server
]]

--[[ -- Optional: have a setting in settings.xml inside 'deathmatch' folder for enabling webhook calls:

local setting = get("discord_webhooks")
if setting and setting == "enabled" then
	webhooksEnabled = true
	outputDebugString("Discord Logs via Webhooks: ENABLED", 3)
else
	webhooksEnabled = false
	outputDebugString("Discord Logs via Webhooks: DISABLED", 3)
end
--]]

-- Exported
function msg(name, message)
	-- if not webhooksEnabled then return end -- Optional setting

	if not (type(name)=="string") then return end

	local url = webhook_list[name]
	if url then

		sendOptions = {
			queueName = "dwebhook",
			connectionAttempts = 3,
			connectTimeout = 5000,
			formFields = {
				content = message
			},
		}
		
		fetchRemote ( url, sendOptions, function() end )
	
	else
		outputDebugString("Unknown webhook named '"..t.."'")
	end
end
addEvent("discord:sendWebHookMsg", true)
addEventHandler("discord:sendWebHookMsg", root, msg)