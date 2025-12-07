Config = {}

Config.DevMode = true
Config.Locale = 'en'
Config.Key = 0x760A9C6F

Config.Transitions = {
    enabled = true, -- true or false
    duration = { -- in milliseconds
        normal = 10000,
        fadeIn = 2000,
        fadeOut=  2500,
        screenWait = 500,
    }
}

Config.Water = {
    baseCoords = vector3(1315.291, -6884.81, 62.252),
    radius = 1000.0,
    waves = { height = 4.0, direction = 0, amount = 1.25, speed = 1.5, strength = 8.0 },
}

Config.Teleports = {
    [1] = { -- St. Denis Harbor
        name = 'Travel to Guarma',
        id = 'mainland', -- guarma or mainland
        price = 5,
        coords = vector3(2671.13, -1552.96, 46.47),
        destination = vector3(1265.8421, -6852.1635, 43.4185), -- where the player spawns after teleport
        radius = 2.0,
        blip = true, -- true or false
        sprite = -1018164873,
        scale = 0.7,
    },
    [2] = {
        name = 'Travel to St. Denis Harbor',
        id = 'guarma', -- guarma or mainland
        price = 2.5,
        coords = vector3(1265.8421, -6852.1635, 43.4185),
        destination = vector3(2671.13, -1552.96, 46.47), -- where the player spawns after teleport
        radius = 2.0,
        blip = true, -- true or false
        sprite = -1018164873,
        scale = 0.7,
    },
}