-- server/server.lua

-- Ensure RSG-Core is available
local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterNetEvent('petting_interaction:petPet')
AddEventHandler('petting_interaction:petPet', function(petName)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    if not Player then
        -- Player not found, notify failure
        TriggerClientEvent('rsgcore:Notify', src, "Unable to pet the pet at this time.", "error")
        return
    end

    local petConfig = Config.Pets[petName]
    if not petConfig then
        -- Invalid pet name, notify failure
        TriggerClientEvent('rsgcore:Notify', src, "Invalid pet interaction.", "error")
        return
    end

    -- Check if the player has a stress attribute
    if Player.PlayerData.stress then
        -- Reduce player's stress
        local currentStress = Player.PlayerData.stress
        local newStress = math.max(currentStress - (petConfig.StressReduction or Config.Global.StressReduction or 5), 0)
        Player.Functions.SetStress(newStress)

        -- Optionally, log the action
        print(string.format("Player %s (ID: %d) petted a %s. Stress reduced by %d.", Player.PlayerData.name, src, petName, petConfig.StressReduction or Config.Global.StressReduction or 5))
    else
        -- If the player does not have a stress attribute, notify failure
        TriggerClientEvent('rsgcore:Notify', src, "Stress system not found.", "error")
    end
end)
