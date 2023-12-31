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
RegisterNetEvent('mms-shipmissions:server:updatedb', function(vorname, nachname, citizenid,count)
    local result = MySQL.prepare.await("SELECT COUNT(*) as count FROM mms_shipmissions WHERE citizenid = ?", { citizenid })
    if result == 0 then
            MySQL.insert('INSERT INTO mms_shipmissions(vorname, nachname, citizenid, count) VALUES(@vorname, @nachname, @citizenid, @count)', {
                ['@vorname'] = vorname,
                ['@nachname'] = nachname,
                ['@citizenid'] = citizenid,
                ['@count'] = count,
        })
    else
        MySQL.query('SELECT * FROM mms_shipmissions WHERE citizenid = ? ',{citizenid} , function(result2)
            --print(result2[1].count)
            if result2[1].count >=0 then
                local newcount = result2[1].count + 1
                MySQL.update('UPDATE mms_shipmissions SET count = ? WHERE citizenid = ?',{newcount, citizenid})
            end
        end)
    end
end)

RegisterNetEvent('mms-shipmissions:server:missioncount', function(vorname, nachname, citizenid,count)
    local src = source
    local result = MySQL.prepare.await("SELECT COUNT(*) as count FROM mms_shipmissions WHERE citizenid = ?", { citizenid })
        if result == 0 then
            MySQL.insert('INSERT INTO mms_shipmissions(vorname, nachname, citizenid, count) VALUES(@vorname, @nachname, @citizenid, @count)', {
                ['@vorname'] = vorname,
                ['@nachname'] = nachname,
                ['@citizenid'] = citizenid,
                ['@count'] = 0,
            })
            local missioncount = 0
            TriggerClientEvent('mms-shipmissions:client:ReturnCount', src, missioncount)
        else
            MySQL.query('SELECT * FROM mms_shipmissions WHERE citizenid = ? ',{citizenid} , function(result2)
                if result2[1].count >=0 then
                local missioncount = result2[1].count
                TriggerClientEvent('mms-shipmissions:client:ReturnCount', src, missioncount)
                end
        end)
end
end)


--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()











