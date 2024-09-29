-- config.lua

Config = {}

--[[ 
    Pet Configuration
    Add as many pets as you like by following the structure below.
    Each pet should have a unique name.
]]
Config.Pets = {
    Cat = {
        Name = "Cat",
        ModelHash = 0xD3C8B7BA, -- Replace with actual cat model hash
        Animation = {
            Dict = "creatures@cat@amb@world_cat_sleeping_pet@base",
            Name = "base"
        },
        ControlAction = 0xE3BF959B, -- Default: E key
        StressReduction = 10,
        InteractionDistance = 2.0,
        PromptText = "Pet the Cat",
        HoldTime = 1000, -- in milliseconds
        Cooldown = 50, -- in ticks (each tick is 100ms)
        Notification = {
            Success = "You pet the cat. You feel more relaxed.",
            Failure = "You can't pet right now."
        }
    },
  --[[ Dog Model
    Dog = {
        Name = "Dog",
        ModelHash = 0x12345678, -- Replace with actual dog model hash
        Animation = {
            Dict = "creatures@dog@amb@world_dog_pet@base",
            Name = "base"
        },
        ControlAction = 0xE3BF959B, -- Default: E key
        StressReduction = 15,
        InteractionDistance = 2.5,
        PromptText = "Pet the Dog",
        HoldTime = 1000, -- in milliseconds
        Cooldown = 60, -- in ticks (each tick is 100ms)
        Notification = {
            Success = "You pet the dog. You feel more relaxed.",
            Failure = "You can't pet right now."
        }
    },
  ]]--
    -- Add more pets here following the same structure
}

--[[ 
    Global Configuration Options 
    These settings apply to all pets unless overridden in individual pet configurations.
]]
Config.Global = {
    DefaultControlAction = 0xE3BF959B, -- Default: E key
    DefaultHoldTime = 1000, -- in milliseconds
    DefaultCooldown = 50, -- in ticks (each tick is 100ms)
    DefaultInteractionDistance = 2.0,
    DefaultPromptText = "Interact",
    DefaultNotification = {
        Success = "Interaction successful.",
        Failure = "You can't interact right now."
    }
}

--[[ 
    Additional Settings 
    Configure as needed for further customization.
]]
Config.Settings = {
    -- Animation Settings
    EnableAnimation = true,
    
    -- Debugging
    EnableDebug = false,
}
