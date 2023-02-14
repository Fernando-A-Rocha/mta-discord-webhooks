--[[
	Author: Fernando

	Discord Webhooks MTA Resource (Examples)

    Command: /testwebhooks [test ID]
]]

-- For these examples to work, you need to change the TEST_WEBHOOK_URL variable to a valid webhook URL.
local TEST_WEBHOOK_URL = "https://discord.com/api/webhooks/1074743328454754376/Yr6IjUUou90uqy9SHv-vuGuoRjp9pIWEqPwpP4ezwdva8jtsurc0bVBGqBSU83BQDOVu"

-- Webhook names are assigned to URLs in the WEB_HOOKS table located in config.lua
-- This will assign one on runtime, so you don't need to edit the config.lua file
WEB_HOOKS["test_webhook"] = TEST_WEBHOOK_URL

addEvent("testWebHook", true)
addEventHandler("testWebHook", root, function(info, player)
    if isElement(player) then
        outputChatBox("Webhook call "..(info.responseInfo.success and "#00ff00succeeded" or "#ff0000failed").." #fffffffor:", thePlayer, 255, 255, 255, true)
        outputChatBox((info.name or info.url), thePlayer, 187, 187, 187, true)
        if not info.responseInfo.success then
            outputChatBox("Check debug console for more info.", thePlayer, 255, 255, 255, true)
            iprint(info.responseData)
            iprint(info.responseInfo)
        end
    else
        if info.responseInfo.success then
            print("testWebHook", (info.name or info.url), "SUCCESS")
        else
            print("testWebHook", (info.name or info.url), "FAIL")
            iprint(info.responseData)
            iprint(info.responseInfo)
        end
    end
end, false)

local EXAMPLES = {
    function(player, vehicleName, vehicleID)
        local request, failReason = exports.discord_webhooks:send(
            "test_webhook",
            "**"..getPlayerName(player).."** has created a `"..vehicleName.." (#"..vehicleID..")` at "..getElementZoneName(player)..".",
            {name="testWebHook", source=root, args={player}}
        )
        if not request then
            outputChatBox(tostring(failReason), player, 255, 0, 0)
        end
    end,
    function (player)
        local request, failReason = exports.discord_webhooks:sendToURL(
            TEST_WEBHOOK_URL,
            "HELLO",
            {name="testWebHook", source=root, args={player}}
        )
        if not request then
            outputChatBox(tostring(failReason), player, 255, 0, 0)
        end
    end,
    function (player)
        local request, failReason = exports.discord_webhooks:sendToURL(
            TEST_WEBHOOK_URL,
            "GOODBYE"
        )
        if request then
            -- According to the wiki, you may use abortRemoteRequest(request) to cancel the request
            outputChatBox("Request sent successfully. Check debug console.", player, 0, 255, 0)
            iprint(request, getRemoteRequestInfo(request))
        else
            outputChatBox(tostring(failReason), player, 255, 0, 0)
        end
    end,
    function (player)
        local randColor = tocolor(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        local request, failReason = exports.discord_webhooks:sendToURL(
            TEST_WEBHOOK_URL,
            {
                title = "Test",
                description = "This is a test",
                timestamp = "now",
                color = randColor,
                footer = {
                    text = "Footer text"
                },
                image = {
                    url = "https://i.imgur.com/bquJ4J9.png"
                },
                thumbnail = {
                    url = "https://i.imgur.com/v63JeLU.png"
                },
                video = {
                    url = "https://www.youtube.com/watch?v=CcCw1ggftuQ"
                },
                author = {
                    name = "Nando",
                    url = "https://github.com/Fernando-A-Rocha",
                    icon_url = "https://i.imgur.com/FA4tKt2.png"
                },
                url = "https://google.com",
                fields = {
                    {name="Field 1", value="Value 1"},
                    {name="Field 2", value="Value 2", inline=true},
                    {name="Field 3", value="Value 3", inline=true},
                }
            },
            {name="testWebHook", source=root, args={player}}
        )
        if not request then
            outputChatBox(tostring(failReason), player, 255, 0, 0)
        end
    end,
}

local function webHookExamples(thePlayer, cmd, id)
    local account = getPlayerAccount(thePlayer)
    if (isGuestAccount(account) or not isObjectInACLGroup("user."..getAccountName(account), aclGetGroup("Admin"))) then
        outputChatBox("You don't have permission to use this command.", thePlayer, 255, 0, 0)
        return
    end
    id = tonumber(id)
    if not id or not EXAMPLES[id] then
        outputChatBox("USAGE: /"..cmd.." [test ID]", thePlayer, 255, 255, 255)
        outputChatBox("   Test IDs: 1 to "..#EXAMPLES, thePlayer, 255, 255, 255)
        return
    end
    if id == 1 then
        EXAMPLES[id](thePlayer, "Landstalker", 400)
    else
        EXAMPLES[id](thePlayer)
    end
end
addCommandHandler("testwebhooks", webHookExamples, false, false)
