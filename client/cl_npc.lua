local spawnedNpcs = {}

function spawnNpc(npcConfig, coords)
    if not npcConfig or not npcConfig.enabled then return nil end
    local heading = npcConfig.heading or 0.0
    local model = GetHashKey(npcConfig.model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end
    local ped = CreatePed(model, coords.x, coords.y, coords.z - 1.0, heading, false, true, true, true)
    if npcConfig.outfit and type(npcConfig.outfit) == 'number' then
        SetPedOutfitPreset(ped, npcConfig.outfit, 1)
    else
        SetRandomOutfitVariation(ped, true)
    end
    if npcConfig.scenario and npcConfig.scenario ~= false then
        TaskStartScenarioInPlace(ped, npcConfig.scenario, -1, true, false, false, false)
    end
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    return ped
end

function despawnNpc(ped)
    if ped and DoesEntityExist(ped) then
        DeletePed(ped)
    end
end

function manageNpcs()
    for i, tele in pairs(Config.Teleports) do
        if tele.npc and tele.npc.enabled then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local npcCoords = tele.coords
            local npcVec3 = vector3(npcCoords.x, npcCoords.y, npcCoords.z)
            local dist = #(playerCoords - npcVec3)
            if dist < 100.0 then
                if not spawnedNpcs[i] or not DoesEntityExist(spawnedNpcs[i]) then
                    spawnedNpcs[i] = spawnNpc(tele.npc, npcCoords)
                end
            else
                if spawnedNpcs[i] and DoesEntityExist(spawnedNpcs[i]) then
                    despawnNpc(spawnedNpcs[i])
                    spawnedNpcs[i] = nil
                end
            end
        end
    end
end

function cleanupNpcs()
    for i, ped in pairs(spawnedNpcs) do
        if ped and DoesEntityExist(ped) then
            DeletePed(ped)
        end
        spawnedNpcs[i] = nil
    end
end