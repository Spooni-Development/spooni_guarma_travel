-- State globals
isGuarmaMode = false
promptGroupMainland = GetRandomIntInRange(0, 0xffffff)
promptGroupGuarma = GetRandomIntInRange(0, 0xffffff)
guarmaPrompt = nil
mainlandPrompt = nil
blips = {}

-- Threads
Citizen.CreateThread(function()
    if not Config.Water.enabled then return end
    Debug('World state monitor started')
    while true do
        Wait(Config.Transitions.duration.screenWait)
        local playerCoords = getPlayerCoords()
        local distanceToGuarma = getDistance(playerCoords, Config.Water.baseCoords)
        if distanceToGuarma <= Config.Water.radius then
            if not isGuarmaMode then
                activateGuarmaWorld()
            end
        else
            if isGuarmaMode then
                activateMainlandWorld()
            end
        end
    end
end)

Citizen.CreateThread(function()
    Debug('Teleport threads started')
    initializeGuarmaPrompt()
    initializeMainlandPrompt()
    while true do
        Wait(0)
        local playerCoords = getPlayerCoords()
        for i, teleporter in ipairs(Config.Teleports) do
            local distance = getDistance(playerCoords, teleporter.coords)
            if distance <= teleporter.radius then
                local destinationId = teleporter.id
                local isGuarmaDest = destinationId == 'guarma'
                showTeleportPrompt(teleporter, destinationId)
                local promptToCheck = isGuarmaDest and guarmaPrompt or mainlandPrompt
                if UiPromptHasStandardModeCompleted(promptToCheck) then
                    TriggerServerEvent('spooni_guarma_travel:server:buyTicket', teleporter)
                    executeTeleportation(teleporter, isGuarmaDest)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        manageNpcs()
    end
end)

-- Events
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    manageBlips()
    manageNpcs()
    Debug('Resource started')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    cleanupBlips()
    cleanupNpcs()
    Debug('Resource stopped')
end)

-- Debug Commands
if Config.DevMode then
    RegisterCommand('guarmaDebug', function()
        Debug('Position: ' .. tostring(getPlayerCoords()))
        Debug('Guarma mode: ' .. tostring(isGuarmaMode))
    end, false)

    RegisterCommand('onGuarma', function()
        activateGuarmaWorld()
    end, false)

    RegisterCommand('onMainland', function()
        activateMainlandWorld()
    end, false)
end