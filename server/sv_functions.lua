Core = exports.vorp_core:GetCore()

function Debug(message, ...)
    if Config.DevMode then
        print(message, ...)
    end
end

function isValid(value)
    return value ~= nil and value ~= false and value ~= 0
end

function getCharacter(src)
    if not isValid(src) then return nil end
    local user = Core.getUser(src)
    if not user then return nil end
    local character = user.getUsedCharacter
    if not character then return nil end
    return character
end