-- client/client.lua

local PedPrompt = {}
local cooldowns = {}

-- Ensure RSG-Core is available
local RSGCore = exports['rsg-core']:GetCoreObject()

-- Function to create the interaction prompt for a specific pet
local function CreatePrompt(petName, group)
    if PedPrompt[petName] then
        return
    end

    local pet = Config.Pets[petName]
    if not pet then return end

    local prompt = PromptRegisterBegin()
    PromptSetControlAction(prompt, pet.ControlAction)
    PromptSetText(prompt, CreateVarString(10, "LITERAL_STRING", pet.PromptText))
    PromptSetEnabled(prompt, true)
    PromptSetVisible(prompt, true)
    PromptSetHoldMode(prompt, pet.HoldTime)
    PromptSetGroup(prompt, group)
    PromptRegisterEnd(prompt)

    PedPrompt[petName] = prompt
end

-- Function to delete the interaction prompt for a specific pet
local function DeletePrompt(petName)
    if PedPrompt[petName] then
        PromptDelete(PedPrompt[petName])
        PedPrompt[petName] = nil
    end
end

-- Function to play interaction animation
local function PlayAnimation(pet)
    if not Config.Settings.EnableAnimation then return end

    local playerPed = PlayerPedId()
    local animDict = pet.Animation.Dict
    local animName = pet.Animation.Name

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(100)
    end

    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, 1500, 0, 0, false, false, false)
end

-- Function to handle interaction
local function HandleInteraction(petName, entity)
    local pet = Config.Pets[petName]
    if not pet then return end

    local playerPed = PlayerPedId()

    -- Make the player approach the entity
    TaskGoToEntity(playerPed, entity, -1, 1.25, 0.5, 0, 0)

    -- Play interaction animation
    PlayAnimation(pet)

    -- Trigger server event to reduce stress
    TriggerServerEvent('petting_interaction:petPet', petName)

    -- Notify the player
    RSGCore:Notify(pet.Notification.Success, "success")
end

CreateThread(function()
    while true do
        Wait(100)

        local playerPed = PlayerPedId()
        local pid = PlayerId()
        local retval, entity = GetPlayerTargetEntity(pid)

        -- If no entity is targeted, delete all prompts and reset cooldowns
        if not entity or not DoesEntityExist(entity) then
            for petName, _ in pairs(PedPrompt) do
                DeletePrompt(petName)
            end
            cooldowns = {}
            goto continue
        end

        local entityCoords = GetEntityCoords(entity)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - entityCoords)

        -- Iterate through all configured pets
        for petName, pet in pairs(Config.Pets) do
            if distance < (pet.InteractionDistance or Config.Global.DefaultInteractionDistance) then
                local model_hash = GetEntityModel(entity)
                if model_hash == pet.ModelHash then
                    local promptGroup = PromptGetGroupIdForTargetEntity(entity)
                    local promptName = pet.PromptText or Config.Global.DefaultPromptText

                    if not PedPrompt[petName] then
                        CreatePrompt(petName, promptGroup)
                    end

                    if PedPrompt[petName] and PromptHasHoldModeCompleted(PedPrompt[petName]) then
                        if not cooldowns[petName] or cooldowns[petName] == 0 then
                            HandleInteraction(petName, entity)
                            cooldowns[petName] = Config.Pets[petName].Cooldown or Config.Global.DefaultCooldown
                        end
                    end
                else
                    -- Delete prompt if the targeted entity is not a pet
                    DeletePrompt(petName)
                end
            else
                -- Delete prompt if out of interaction distance
                DeletePrompt(petName)
            end
        end

        -- Handle cooldowns
        for petName, cooldown in pairs(cooldowns) do
            if cooldown > 0 then
                cooldowns[petName] = cooldown - 1
            else
                cooldowns[petName] = 0
            end
        end

        ::continue::
    end
end)

--[[

if (coffeee > 0) { code(); } else { sleep(); } 

]]--
