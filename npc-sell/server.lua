local QBCore = exports['qb-core']:GetCoreObject()

local CurrentVersion = "1.0.0" -- Current version of your resource
local UpdateCheckURL = "https://raw.githubusercontent.com/Wolfiye/wolfiye-npc-sell/main/version.txt" -- URL to check latest version

CreateThread(function()
    print(("^3[npc-sell]^0 Version %s Loaded"):format(CurrentVersion))

    
    PerformHttpRequest(UpdateCheckURL, function(err, text, headers)
        if err == 200 and text then
            local latestVersion = text:match("(%d+%.%d+%.%d+)")
            if latestVersion then
                if latestVersion ~= CurrentVersion then
                    print(("^1[npc-sell]^0 Update available! Current: %s, Latest: %s"):format(CurrentVersion, latestVersion))
                    print("^1Please update your resource to the latest version.^0")
                else
                    print("^2[npc-sell]^0 You are running the latest version.")
                end
            else
                print("^3[npc-sell]^0 Failed to parse latest version from update URL.")
            end
        else
            print(("^3[npc-sell]^0 Failed to check for updates. HTTP error code: %s"):format(err))
        end
    end)
end)


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
