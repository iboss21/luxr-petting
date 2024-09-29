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
    TriggerServerEvent
