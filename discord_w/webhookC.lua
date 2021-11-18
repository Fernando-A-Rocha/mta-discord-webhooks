--[[
	Author: Fernando

	Client event to trigger the serverside function for using a webhook
]]

function whMessage(name, message)
	triggerServerEvent("discord:sendWebHookMsg", getRootElement(), name, message)
end
addEvent("discord:sendWebHookMsg", true)
addEventHandler("discord:sendWebHookMsg", root, whMessage)