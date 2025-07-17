local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    for _, npc in pairs(Config.NPCs) do
        RequestModel(npc.model)
        while not HasModelLoaded(npc.model) do Wait(0) end

        local ped = CreatePed(0, npc.model, npc.coords.x, npc.coords.y, npc.coords.z - 1, npc.coords.w, false, false)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        
        if npc.animation then
            if npc.animation.scenario then
                TaskStartScenarioInPlace(ped, npc.animation.scenario, 0, true)
            elseif npc.animation.dict and npc.animation.clip then
                RequestAnimDict(npc.animation.dict)
                while not HasAnimDictLoaded(npc.animation.dict) do Wait(0) end
                TaskPlayAnim(ped, npc.animation.dict, npc.animation.clip, 8.0, -8.0, -1, 1, 0, false, false, false)
            end
        end

        exports.ox_target:addLocalEntity(ped, {
            {
                label = 'Sell Items to ' .. npc.label,
                icon = 'fa-solid fa-hand-holding-dollar',
                onSelect = function()
                    openSellMenu(npc)
                end
            }
        })
    end
end)

function openSellMenu(npc)
    local options = {}

    for _, v in pairs(npc.items) do

        local hasItem = false
        QBCore.Functions.TriggerCallback('npc-sell:playerHasItem', function(result)
            hasItem = result
        end, v.item)

        
        local timeout = 1000
        local tick = 0
        while tick < timeout and hasItem == false do
            Wait(10)
            tick = tick + 10
        end

        if hasItem then
            table.insert(options, {
                title = v.label,
                description = "Sell for $" .. v.price .. " each",
                icon = v.image or "fa-solid fa-dollar-sign",
                onSelect = function()
                    local input = lib.inputDialog('Quantity to Sell', {
                        { type = 'number', label = 'Amount', description = 'Enter how many to sell', min = 1, default = 1 }
                    })

                    if input and input[1] then
                        startSellingAnimation(v.item, v.price, input[1], npc.label)
                    end
                end
            })
        else
            table.insert(options, {
                title = v.label .. " (No items)",
                description = "You do not have this item",
                icon = "fa-solid fa-ban",
                onSelect = function()
                    lib.notify({
                        title = 'Sell Items',
                        description = 'You don\'t have any ' .. v.label,
                        type = 'error'
                    })
                end,
                disabled = true
            })
        end
    end

    lib.registerContext({
        id = 'sell_menu',
        title = 'Sell Items to ' .. npc.label,
        options = options
    })

    lib.showContext('sell_menu')
end

function startSellingAnimation(item, price, amount, npcLabel)
    local ped = PlayerPedId()

    RequestAnimDict(Config.SellAnimation.dict)
    while not HasAnimDictLoaded(Config.SellAnimation.dict) do Wait(0) end

    TaskPlayAnim(ped, Config.SellAnimation.dict, Config.SellAnimation.clip, 8.0, -8.0, -1, 49, 0, false, false, false)

    lib.progressBar({
        duration = Config.SellAnimation.duration,
        label = Config.SellAnimation.label,
        useWhileDead = false,
        canCancel = false,
        disable = { car = true, move = true, combat = true },
        anim = { dict = Config.SellAnimation.dict, clip = Config.SellAnimation.clip },
    })

    ClearPedTasks(ped)

    TriggerServerEvent('npc-sell:sellItem', item, price, amount, npcLabel)
end
