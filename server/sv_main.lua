local Core = exports.vorp_core:GetCore()

-- Utility Functions

local function Debug(message, ...)
    if Config.DevMode then
        print(message, ...)
    end
end

local function isValid(value)
    return value ~= nil and value ~= false and value ~= 0
end

local function getCharacter(src)
    if not isValid(src) then return nil end
    
    local user = Core.getUser(src)
    if not user then return nil end
    
    local character = user.getUsedCharacter
    if not character then return nil end
    
    return character
end

-- Events

RegisterServerEvent('spooni_guarma_travel:server:buyTicket')
AddEventHandler('spooni_guarma_travel:server:buyTicket', function(destination)
    local src = source
    
    if not isValid(src) or type(destination) ~= 'string' then
        Debug('Invalid parameters from source ' .. tostring(src))
        return
    end
    
    local character = getCharacter(src)
    if not character then
        Debug('Failed to get character for source ' .. src)
        return
    end
    
    local isMainland = destination == 'mainland'
    local isGuarma = destination == 'guarma'
    
    if not isMainland and not isGuarma then
        Debug('Invalid destination: ' .. destination .. ' from source ' .. src)
        return
    end
    
    local price = isMainland and Config.Main.price or Config.Guarma.price
    local notificationKey = isMainland and 'notify_ticket_mainland' or 'notify_ticket_guarma'
    
    character.removeCurrency(0, price)
    Core.NotifyAvanced(src, Translation[Config.Locale][notificationKey], 'inventory_items', 'money_moneystack', 'COLOR_PURE_WHITE', 5000)
    -- jo.notif.right(src, Translation[Config.Locale][notificationKey], 'inventory_items', 'money_moneystack', 'COLOR_PURE_WHITE', 5000)
    Debug(destination .. ' ticket purchased by source ' .. src .. ' (Price: $' .. price)
end)