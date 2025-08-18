local QBCore = exports['qb-core']:GetCoreObject()

local function shouldCall911(npcLabel)
    for _, label in ipairs(Config.NPCsThatCall911) do
        if label == npcLabel then
            return true
        end
    end
    return false
end


local function getMoneyTypeForItem(itemName)
    for _, npc in pairs(Config.NPCs) do
        for _, v in pairs(npc.items) do
            if v.item == itemName then
                if v.dirtyMoney then
                    return Config.DirtyMoneyItem or 'blackmoney'
                else
                    return 'cash'
                end
            end
        end
    end
    return 'cash' 
end

RegisterNetEvent('npc-sell:sellItem', function(item, price, amount, npcLabel)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not amount or amount <= 0 then
        TriggerClientEvent('QBCore:Notify', src, 'Invalid amount.', 'error')
        return
    end

    local inventoryItem = Player.Functions.GetItemByName(item)

    if inventoryItem and inventoryItem.amount >= amount then
        Player.Functions.RemoveItem(item, amount)

        local moneyType = getMoneyTypeForItem(item)
        print(('Selling %s x %d, paying with money type: %s'):format(item, amount, moneyType))

        
        if moneyType == (Config.DirtyMoneyItem or 'blackmoney') then
            Player.Functions.AddItem(Config.DirtyMoneyItem, price * amount)
        else
            Player.Functions.AddMoney('cash', price * amount)
        end

        local notifyMsg = 'Sold '..amount..'x '..inventoryItem.label..' for $'..(price * amount)
        if moneyType == (Config.DirtyMoneyItem or 'blackmoney') then
            notifyMsg = notifyMsg .. ' (dirty money)'
        end
        TriggerClientEvent('QBCore:Notify', src, notifyMsg, 'success')

        
        if shouldCall911(npcLabel) then
            local chance = math.random(1, 100)
            if chance <= Config.PoliceCallChance then
                local ped = GetPlayerPed(src)
                local coords = GetEntityCoords(ped)



                -- This is specific to CD Dispatch; replace if you use another system
                TriggerClientEvent('cd_dispatch:AddNotification', -1, {
                    job_table = {'lspd', 'bcso', 'sasp'}, -- Police Jobs, adjust to your server
                    coords = coords,
                    title = 'Suspicious Sale',
                    message = 'Suspicious sale reported in the area.',
                    flash = 0,
                    unique_id = tostring(math.random(1000000,9999999)),
                    sound = 1,
                    blip = {
                        sprite = 431,
                        scale = 1.2,
                        colour = 3,
                        flashes = false,
                        text = '911 - Suspicious Sale',
                        time = 10,
                        radius = 150,
                    } 



                    --[[TriggerEvent('ps-dispatch:server:notify', {     -- This is for PS-Dispatch. If you don't use CD-Dispatch Just remove the snippet & uncomment this snippet
                    coords = coords,
                    title = 'Suspicious Activity',
                    message = 'A suspicious transaction was reported in the area.',
                    alert = {
                        sprite = 431,
                        colour = 3,
                        scale = 1.2,
                        flashes = false
                    },
                    jobs = { 'police' } --Add jobs here  ]]



                    -- QS Dispatch
                    --[[TriggerEvent('qs-dispatch:server:CreateDispatchCall', {
                    job = { 'police', 'sheriff', 'traffic', 'patrol' }, -- Add jobs here
                    callLocation = vector3(0, 0, 0), -- Coordinates of the call
                    callCode = { code = '10-10', snippet = 'Vehicle Pursuit' }, -- Call code and description
                    message = "A high-speed vehicle was spotted traveling at 120 km/h.", -- Dispatch call message
                    flashes = true, -- Should the blip on the map flash?
                    image = "URL", -- Optional: URL for an image attachment (use `getSSURL` if needed)
                    blip = { -- Blip details for the map
                         sprite = 488, -- Blip icon type
                         scale = 1.5, -- Blip size
                         colour = 1, -- Blip color
                        flashes = true, -- Blip flashes
                        text = 'High-Speed Pursuit', -- Blip label
                        time = (60 * 1000), -- Duration of the blip (milliseconds)
                        },
                  otherData = { -- Additional optional information
                 {
                   text = 'Suspect wearing red', -- Additional detail
                 icon = 'fas fa-user-secret' -- Font Awesome icon
                            }
                         }
                     }) ]]

                     --[[
                    local data = {
                    code = "alert code",
                     label = "Alert Label",
                     description = "alert description", -- Optional
                     coords = coords, -- (Optional) custom coords, will automaticly take the coords if this doesn't exists
                     blip = { -- Optional (and all the fields inside it are optional)
                        sprite = 280,
                        color = 4,
                        scale = 1.0,
                        name = "911 Call",
                         alpha = 255,
                         flash = true 
                         removeAfter = 5 -- seconds, will remove the blip after this (Optional)
                     },
                    customSound = "sound mp3 link", -- (Optional) will replace the default sound with a custom sound of your choosing
                    jobs = { "police" }, -- Can support multiple jobs, make sure its in a a table and this job exists in the config
                    }
                    exports["mr-dispatch"]:CreateAlert(data)                    
                     ]]
                })
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough '..(inventoryItem and inventoryItem.label or 'items')..'.', 'error')
    end
end)

QBCore.Functions.CreateCallback('npc-sell:playerHasItem', function(source, cb, itemName)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local item = Player.Functions.GetItemByName(itemName)
        cb(item and item.amount > 0 or false)
    else
        cb(false)
    end
end)
