--[[
    Author: Fernando

    Example script that uses Discord Webhook
]]


function makeVehicleCmd(thePlayer, commandName, ...)

    if not (...) then
        return outputChatBox("SYNTAX: /"..commandName.." [MTA Vehicle ID/Name]", thePlayer, 255,194,14)
    end
    local text = table.concat({...}, " ")
    
    local modelID, name
    if tonumber(text) then
        modelID = tonumber(text)
        name = getVehicleNameFromModel(modelID)
    else
        modelID = getVehicleModelFromName(text)
        name = text
    end
    if not name or not modelID then
        outputChatBox("Invalid vehicle ID/Name: "..text, thePlayer, 255,25,25)
        return
    end

    local x,y,z = getElementPosition(thePlayer)
    local rx,ry,rz = getElementRotation(thePlayer)
    local veh = createVehicle(modelID, x,y,z, rx,ry,rz)
    if veh then
        
        setElementInterior(veh, getElementInterior(thePlayer))
        setElementDimension(veh, getElementDimension(thePlayer))

        setVehicleOverrideLights(veh, 1)
        setVehicleFuelTankExplodable(veh, false)
        setVehicleEngineState(veh, true)

        outputChatBox("Created vehicle: "..name.." (#"..modelID..").", thePlayer, 14,255,14)

        if not getPedOccupiedVehicle(thePlayer) then
            warpPedIntoVehicle(thePlayer, veh, 0)
        end

        local logMsg = "**"..getPlayerName(thePlayer).."** has created a `"..name.." (#"..modelID..")` at "..getElementZoneName(thePlayer).."."
        
        exports.discord:msg("admin-logs", logMsg) -- Send the log message to #admin-logs in our Discord server
	end
end
addCommandHandler("spawnveh", makeVehicleCmd, false, false)
