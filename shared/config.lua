Config = {}

Config.DevMode = true
Config.Locale = 'en'
Config.Key = 0x760A9C6F

Config.Transitions = {
    enabled = true,
    duration = {
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

Config.Main = {
    name = 'Travel to Guarma',
    id = 'mainland',
    price = 0,
    coords = vector3(2671.13, -1552.96, 46.47),
    radius = 2.0,
    blip = true,
    sprite = -1018164873,
    scale = 0.7,
}

Config.Guarma = {
    name = 'Travel to Mainland',
    id = 'guarma',
    price = 0,
    coords = vector3(1265.8421, -6852.1635, 43.4185),
    radius = 2.0,
    blip = true,
    sprite = -1018164873,
    scale = 0.7,
}