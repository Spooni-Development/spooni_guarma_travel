-- Events
RegisterServerEvent('spooni_guarma_travel:server:buyTicket')
AddEventHandler('spooni_guarma_travel:server:buyTicket', function(teleporter)
    local src = source
    if not isValid(src) or type(teleporter) ~= 'table' then
        Debug('Invalid parameters from source ' .. tostring(src))
        return
    end
    local character = getCharacter(src)
    if not character then
        Debug('Failed to get character for source ' .. src)
        return
    end
    if not isValid(teleporter.price) or not isValid(teleporter.name) or not isValid(teleporter.id) then
        Debug('Invalid teleporter data from source ' .. src)
        return
    end
    character.removeCurrency(0, teleporter.price)
    if teleporter.id == 'guarma' then
        Core.NotifyAvanced(src, Translation[Config.Locale]['notify_ticket_guarma'], 'inventory_items', 'money_moneystack', 'COLOR_PURE_WHITE', 5000)
    elseif teleporter.id == 'mainland' then
        Core.NotifyAvanced(src, Translation[Config.Locale]['notify_ticket_mainland'], 'inventory_items', 'money_moneystack', 'COLOR_PURE_WHITE', 5000)
    else
        Debug('No valid id found! Check your config.lua')
        return
    end
    Debug(teleporter.name .. ' ticket purchased by source ' .. src .. ' (Price: $' .. teleporter.price .. ')')
end)