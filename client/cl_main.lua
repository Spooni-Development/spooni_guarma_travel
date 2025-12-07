-- Constants

local state = {
    isGuarmaMode = false,
    promptGroupMainland = GetRandomIntInRange(0, 0xffffff),
    promptGroupGuarma = GetRandomIntInRange(0, 0xffffff),
    guarmaPrompt = nil,
    mainlandPrompt = nil,
    blips = {},
}

-- Utility Functions

local function Debug(message)
    if Config.DevMode then print(message) end
end

local function getPlayerPed()
    return PlayerPedId()
end

local function getPlayerCoords()
    return GetEntityCoords(getPlayerPed())
end

local function getDistance(from, to)
    return #(from - to)
end

local function formatPrice(price)
    if price == 0 then
        return Translation[Config.Locale]['prompt_group_free_ride'] .. ' '
    end
    return price .. '$'
end

-- Player State Management

local function applyTeleportProtection()
    local ped = getPlayerPed()
    FreezeEntityPosition(ped, true)
    SetPlayerInvincible(ped, true)
    SetEntityCanBeDamaged(ped, false)
    Debug('Teleport protection enabled')
end

local function removeTeleportProtection()
    local ped = getPlayerPed()
    SetPlayerInvincible(ped, false)
    FreezeEntityPosition(ped, false)
    SetEntityCanBeDamaged(ped, true)
    Debug('Teleport protection disabled')
end

local function setHudVisibility(enabled)
    if not Config.Transitions.enabled then return end
    if enabled then
        ExecuteCommand('hud')
        ExecuteCommand('toggleHud')
    else
        ExecuteCommand('toggleHud')
        ExecuteCommand('hud')
    end
end

-- World State Management

local function activateGuarmaWorld()
    if state.isGuarmaMode then return end
    
    SetGuarmaWorldhorizonActive(true)
    SetWorldWaterType(1)
    SetMinimapZone("guarma")
    SetOceanGuarmaWaterQuadrant(
        Config.Water.waves.height,
        50.04,
        Config.Water.waves.direction,
        1.15,
        Config.Water.waves.amount,
        -1082130432,
        Config.Water.waves.speed,
        Config.Water.waves.strength,
        1
    )
    
    state.isGuarmaMode = true
    Debug('Guarma world activated')
end

local function activateMainlandWorld()
    if not state.isGuarmaMode then return end
    
    SetGuarmaWorldhorizonActive(false)
    SetWorldWaterType(0)
    SetMinimapZone("world")
    ResetGuarmaWaterState()
    
    state.isGuarmaMode = false
    Debug('Mainland world activated')
end

-- Teleportation

local function executeTeleportation(destination, isGuarmaDest)
    applyTeleportProtection()
    setHudVisibility(false)
    
    if Config.Transitions.enabled then
        DoScreenFadeOut(Config.Transitions.duration.fadeOut)
        Wait(Config.Transitions.duration.fadeOut)
    end
    
    SetEntityCoords(getPlayerPed(), destination.destination.x, destination.destination.y, destination.destination.z, false, false, false, false)
    
    if Config.Transitions.enabled then
        DoScreenFadeIn(Config.Transitions.duration.fadeIn)
        
        local titleKey = isGuarmaDest and 'transition_guarma_title' or 'transition_mainland_title'
        local subtitleKey = isGuarmaDest and 'transition_guarma_subtitle' or 'transition_mainland_subtitle'
        local messageKey = isGuarmaDest and 'transition_guarma_message' or 'transition_mainland_message'
        
        DisplayLoadingScreens(0, 0, 0,
            Translation[Config.Locale][titleKey],
            Translation[Config.Locale][subtitleKey],
            Translation[Config.Locale][messageKey]
        )
        
        Wait(Config.Transitions.duration.normal)
        DoScreenFadeOut(Config.Transitions.duration.fadeOut)
        Wait(Config.Transitions.duration.fadeOut)
        ShutdownLoadingScreen()
        DoScreenFadeIn(Config.Transitions.duration.fadeIn)
    end
    
    setHudVisibility(true)
    removeTeleportProtection()
end

-- UI Prompts

local function initializeGuarmaPrompt()
    local str = Translation[Config.Locale]['prompt_guarma']
    state.guarmaPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(state.guarmaPrompt, Config.Key)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    UiPromptSetText(state.guarmaPrompt, str)
    UiPromptSetEnabled(state.guarmaPrompt, 1)
    UiPromptSetVisible(state.guarmaPrompt, 1)
    UiPromptSetStandardMode(state.guarmaPrompt, 1)
    UiPromptSetGroup(state.guarmaPrompt, state.promptGroupGuarma)
    UiPromptSetUrgentPulsingEnabled(state.guarmaPrompt, true)
    UiPromptRegisterEnd(state.guarmaPrompt)
    Debug('Guarma prompt initialized')
end

local function initializeMainlandPrompt()
    local str = Translation[Config.Locale]['prompt_mainland']
    state.mainlandPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(state.mainlandPrompt, Config.Key)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    UiPromptSetText(state.mainlandPrompt, str)
    UiPromptSetEnabled(state.mainlandPrompt, 1)
    UiPromptSetVisible(state.mainlandPrompt, 1)
    UiPromptSetStandardMode(state.mainlandPrompt, 1)
    UiPromptSetGroup(state.mainlandPrompt, state.promptGroupMainland)
    UiPromptSetUrgentPulsingEnabled(state.mainlandPrompt, true)
    UiPromptRegisterEnd(state.mainlandPrompt)
    Debug('Mainland prompt initialized')
end

local function showTeleportPrompt(teleporter, destinationId)
    local priceDisplay = formatPrice(teleporter.price)
    local label = CreateVarString(10, 'LITERAL_STRING', teleporter.name .. ' - ' .. priceDisplay)
    UiPromptSetActiveGroupThisFrame(destinationId == 'guarma' and state.promptGroupGuarma or state.promptGroupMainland, label)
end

-- Blips

local function createBlips()
    for i, teleporter in ipairs(Config.Teleports) do
        if teleporter.blip then
            local blip = BlipAddForCoords(1664425300, teleporter.coords.x, teleporter.coords.y, teleporter.coords.z)
            SetBlipSprite(blip, teleporter.sprite, true)
            SetBlipScale(blip, teleporter.scale)
            SetBlipName(blip, teleporter.name)
            
            state.blips[i] = blip
            Debug('Blip created for: ' .. teleporter.name)
        end
    end
end

local function destroyBlips()
    for location, blip in pairs(state.blips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
            Debug('Blip removed for ' .. location)
        end
    end
    state.blips = {}
end

-- Threads

Citizen.CreateThread(function()
    Debug('World state monitor started')
    
    while true do
        Wait(Config.Transitions.duration.screenWait)
        
        local playerCoords = getPlayerCoords()
        local distanceToGuarma = getDistance(playerCoords, Config.Water.baseCoords)
        
        if distanceToGuarma <= Config.Water.radius then
            if not state.isGuarmaMode then
                activateGuarmaWorld()
            end
        else
            if state.isGuarmaMode then
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
                
                local promptToCheck = isGuarmaDest and state.guarmaPrompt or state.mainlandPrompt
                if UiPromptHasStandardModeCompleted(promptToCheck) then
                    TriggerServerEvent('spooni_guarma_travel:server:buyTicket', teleporter)
                    executeTeleportation(teleporter, isGuarmaDest)
                end
            end
        end
    end
end)

-- Events

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    createBlips()
    Debug('Resource started')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    destroyBlips()
    Debug('Resource stopped')
end)

-- Debug Commands

if Config.DevMode then
    RegisterCommand('guarmaDebug', function()
        Debug('Position: ' .. tostring(getPlayerCoords()))
        Debug('Guarma mode: ' .. tostring(state.isGuarmaMode))
    end, false)
    
    RegisterCommand('onGuarma', function()
        activateGuarmaWorld()
    end, false)
    
    RegisterCommand('onMainland', function()
        activateMainlandWorld()
    end, false)
end
