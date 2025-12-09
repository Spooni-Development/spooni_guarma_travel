function createBlip(blipConfig, coords, name)
    if not blipConfig or not blipConfig.enabled then return nil end
    local blip = BlipAddForCoords(1664425300, coords.x, coords.y, coords.z)
    SetBlipSprite(blip, blipConfig.sprite, true)
    SetBlipScale(blip, blipConfig.scale)
    SetBlipName(blip, name)
    return blip
end

function manageBlips()
    if not blips then blips = {} end
    for i, tele in pairs(Config.Teleports) do
        if tele.blip and tele.blip.enabled then
            if not blips[i] then
                blips[i] = createBlip(tele.blip, tele.coords, tele.name)
            end
        elseif blips[i] then
            RemoveBlip(blips[i])
            blips[i] = nil
        end
    end
end

function cleanupBlips()
    blips = blips or {}
    for i, b in pairs(blips) do
        if DoesBlipExist(b) then RemoveBlip(b) end
        blips[i] = nil
    end
end