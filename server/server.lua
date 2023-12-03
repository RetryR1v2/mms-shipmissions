local RSGCore = exports['rsg-core']:GetCoreObject()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-shipmissions/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
        print(vorname)
        print(nachname)
        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

-----------------------------------------------------------------------
-- reward system
-----------------------------------------------------------------------

RegisterNetEvent('mms-shipmissions:server:rewards', function(reward)
    if reward >= 1 then
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
        if Config.Dynamicrewards == true then
            local Money = math.random(Config.Moneymin,Config.Moneymax)
            Player.Functions.AddMoney('cash',Money)
            TriggerClientEvent('ox_lib:notify', src, {title = 'Mission Erfolgreich Abgeschlossen!', description =  'Erfolg', type = 'success' , duration = 5000})
            TriggerClientEvent('ox_lib:notify', src, {title = 'Du erhältst ' .. Money .. ' $ Glückwunsch!!!', description =  'Erfolg', type = 'success' , duration = 5000})
        elseif Config.Dynamicrewards == false then
            Player.Functions.AddMoney('cash',Config.Money)
            TriggerClientEvent('ox_lib:notify', src, {title = 'Mission Erfolgreich Abgeschlossen!', description =  'Erfolg', type = 'success' , duration = 5000})
            TriggerClientEvent('ox_lib:notify', src, {title = 'Du erhältst ' .. Config.Money .. ' $. Glückwunsch!!!', description =  'Erfolg', type = 'success' , duration = 5000})
        end
    
    end
    end)



--------------Mission Count
RegisterNetEvent('mms-shipmissions:server:updatedb', function(username,count)
    local result = MySQL.prepare.await("SELECT COUNT(*) as count FROM counter WHERE username = ?", { username })
        if result == 0 then
            MySQL.insert('INSERT INTO counter(username, count) VALUES(@username, @count)', {
            ['@username'] = username,
            ['@count'] = count,
        })
    elseif result == 1 then
        local getcount = MySQL.prepare.await("SELECT COUNT(*) as count FROM counter WHERE count = ?", { count })
        if getcount >= 1 then
            local addcount = getcount + 1
            MySQL.update('UPDATE counter SET count = ? WHERE username = ? ',{addcount, username})
        end
    end
end)

--MySQL.update('UPDATE saloontender_stock SET stock = ? WHERE saloontender = ? AND item = ?',{stockadd, job, receive})
--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()











