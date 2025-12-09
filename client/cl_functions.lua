-- Utilities
function Debug(message)
    if Config.DevMode then print(message) end
end

function getPlayerPed()
    return PlayerPedId()
end

function getPlayerCoords()
    return GetEntityCoords(getPlayerPed())
end

function toVec3(coord)
    if coord and coord.x then
        return vector3(coord.x, coord.y, coord.z)
    end
    return coord
end

function getDistance(from, to)
    return #(from - toVec3(to))
end

function formatPrice(price)
    if price == 0 then
        return Translation[Config.Locale]['prompt_group_free_ride'] .. ' '
    end
    return price .. '$'
end

function setHudVisibility(enabled)
    if not Config.Transitions.enabled then return end
    if enabled then
        ExecuteCommand('hud')
        ExecuteCommand('toggleHud')
    else
        ExecuteCommand('toggleHud')
        ExecuteCommand('hud')
    end
end

function applyTeleportProtection()
    local ped = getPlayerPed()
    FreezeEntityPosition(ped, true)
    SetPlayerInvincible(ped, true)
    SetEntityCanBeDamaged(ped, false)
    Debug('Teleport protection enabled')
end

function removeTeleportProtection()
    local ped = getPlayerPed()
    SetPlayerInvincible(ped, false)
    FreezeEntityPosition(ped, false)
    SetEntityCanBeDamaged(ped, true)
    Debug('Teleport protection disabled')
end

-- World State
function activateGuarmaWorld()
    if isGuarmaMode then return end
    SetGuarmaWorldhorizonActive(true)
    SetWorldWaterType(1)
    SetMinimapZone("guarma")
    SetOceanGuarmaWaterQuadrant(Config.Water.waves.height, 50.04, Config.Water.waves.direction, 1.15, Config.Water.waves.amount, -1082130432, Config.Water.waves.speed, Config.Water.waves.strength, 1)
    isGuarmaMode = true
    Debug('Guarma world activated')
end

function activateMainlandWorld()
    if not isGuarmaMode then return end
    SetGuarmaWorldhorizonActive(false)
    SetWorldWaterType(0)
    SetMinimapZone("world")
    ResetGuarmaWaterState()
    isGuarmaMode = false
    Debug('Mainland world activated')
end

-- Teleportation
function executeTeleportation(destination, isGuarmaDest)
    applyTeleportProtection()
    setHudVisibility(false)
    if Config.Transitions.enabled then
        DoScreenFadeOut(Config.Transitions.duration.fadeOut)
        Wait(Config.Transitions.duration.fadeOut)
    end
    SetEntityCoords(getPlayerPed(), destination.destination.x, destination.destination.y, destination.destination.z, false, false, false, false)
    if Config.Transitions.enabled then
        DoScreenFadeIn(Config.Transitions.duration.fadeIn)
        if isGuarmaDest then
            DisplayLoadingScreens(0, 0, 0, Translation[Config.Locale]['transition_mainland_title'], Translation[Config.Locale]['transition_mainland_subtitle'], Translation[Config.Locale]['transition_mainland_message'])
        else
            DisplayLoadingScreens(0, 0, 0, Translation[Config.Locale]['transition_guarma_title'], Translation[Config.Locale]['transition_guarma_subtitle'], Translation[Config.Locale]['transition_guarma_message'])
        end
        Wait(Config.Transitions.duration.normal)
        DoScreenFadeOut(Config.Transitions.duration.fadeOut)
        Wait(Config.Transitions.duration.fadeOut)
        ShutdownLoadingScreen()
        DoScreenFadeIn(Config.Transitions.duration.fadeIn)
    end
    setHudVisibility(true)
    removeTeleportProtection()
end