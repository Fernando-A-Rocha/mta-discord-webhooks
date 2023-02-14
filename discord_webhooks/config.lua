--[[
	Author: https://github.com/Fernando-A-Rocha

	Discord Webhooks MTA Resource (Config)
]]
RES_NAME = getResourceName(resource)

--[[
	List of defined webhooks
	Format: name => URL

		name: can be any string of your choice,
			it is what you will use to trigger it
		URL: webhook URL must be the one you copied
			from channel settings -> Integrations -> Webhooks -> Your webhook -> Copy URL
]]
WEB_HOOKS = {
	-- Example:
	["my_webhook"] = "https://discord.com/api/webhooks/123456/abcdefgh",
}

DEBUG_ON = false -- Set to true to enable debug messages

-- Custom Events for Developers:
addEvent(RES_NAME..":send", true) -- source: must always be root
addEvent(RES_NAME..":sendToURL", true) -- source: must always be root

-- (OPTIONAL) You may want to add a setting to your server's Settings Registry to disable Webhooks
-- 		e.g. You are running a Development server which mirrors your Production server's resources
-- 		and you want to prevent Webhooks from being triggered on the Development server
-- By default this is "@discord_webhooks.disabled"
-- Set it to "1" or "true" to disable webhooks from being triggered
SETTING_DISABLE = "@"..RES_NAME..".disabled"
