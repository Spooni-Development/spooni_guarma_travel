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

Config.Water = { -- guarma ocean waves
    enabled = true, -- true or false
    baseCoords = vector3(1315.291, -6884.81, 62.252),
    radius = 1000.0,
    waves = { height = 4.0, direction = 0, amount = 1.25, speed = 1.5, strength = 8.0 },
}

Config.Teleports = {
    [1] = { -- St. Denis Harbor
        name = 'Travel to Guarma',
        id = 'mainland', -- guarma or mainland
        radius = 2.0, -- prompt
        price = 5,
        coords = vector3(2671.13, -1552.96, 46.47), -- prompt and npc
        destination = vector3(1268.2664, -6853.1997, 43.3181), -- where the player spawns after teleport
        npc = {
            enabled = true, -- true or false
            model = 'a_m_m_asbboatcrew_01',
            outfit = false, -- number or false
            scenario = 'WORLD_HUMAN_GUARD', -- scenario or flase
            heading = 0.0,
        },
        blip = {
            enabled = true, -- true or false
            sprite = -1018164873,
            scale = 0.7,
        }
    },
    [2] = {
        name = 'Travel to St. Denis Harbor',
        id = 'guarma', -- guarma or mainland
        radius = 2.0, -- prompt
        price = 2.5,
        coords = vector3(1265.8421, -6852.1635, 43.4185),  -- prompt and npc
        destination = vector3(2670.7642, -1550.0131, 45.9683), -- where the player spawns after teleport
        npc = {
            enabled = true, -- true or false
            model = 'u_m_m_nbxriverboattarget_01',
            outfit = false, -- number or false
            scenario = 'WORLD_HUMAN_GUARD', -- scenario or flase
            heading = 250.0,
        },
        blip = {
            enabled = true, -- true or false
            sprite = -1018164873,
            scale = 0.7,
        }
    },
}