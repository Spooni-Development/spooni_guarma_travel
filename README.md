# 🏝️ Guarma Travel
Documentation relating to the spooni_guarma_travel.

## 1. Installation
spooni_guarma_travel works only with VORP. 

To install spooni_guarma_travel:
- Download the resource
  - On [Github](https://github.com/Spooni-Development/spooni_guarma_travel)
- Drag and drop the resource into your resources folder
  - `spooni_guarma_travel`
- Add this ensure in your server.cfg
  ```
    ensure spooni_guarma_travel
  ```
- Now you can configure and translate the script as you like
  - `config.lua`
- At the end, restart the server

If you have any problems, you can always open a ticket in the [Spooni Discord](https://discord.gg/spooni).

## 2. Usage
Allows players to travel between Mainland and Guarma. Simply interact with the travel points at the designated locations to initiate a smooth transition with fade effects and water animations. The travel system includes customizable pricing, convenient map blips, and configurable transition durations.

## 3. For developers
```lua
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
```

## 4. Credits

Big thanks go to [NeoGaming22](https://github.com/NeoGaming22) the creator of the main script and [Hailey-Ross](https://github.com/Hailey-Ross), since the script is already 5 years old (As of: 2025) we wanted to give it a little overhaul.

Click here for the [original script](https://github.com/NeoGaming22/wcrp_guarma)
Click here for the [edit script](https://github.com/Hailey-Ross/hails_guarma)
