local RSGCore = exports['rsg-core']:GetCoreObject()
local shipmissionactive = 0
local aufgabe1 = 0
local aufgabe2 = 0
local aufgabe3 = 0
local prompts = 0
local SpawnedBoat = nil
local boatSpawned = false
local missionamount = 1
----------------------------Hafen ----------------------

Citizen.CreateThread(function()
    for hafen,v in pairs(Config.hafen) do
        exports['rsg-core']:createPrompt(v.name, v.coords, RSGCore.Shared.Keybinds['J'],  (' ') .. v.lable, {
            type = 'client',
            event = 'mms-shipmissions:client:hafenmenu',
            args = {},
        })
        if v.showblip == true then
            local hafen = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(hafen, GetHashKey(v.blipSprite), true)
            SetBlipScale(hafen, v.blipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, hafen, v.blipName)
        end
    end
end)


RegisterNetEvent('mms-shipmissions:client:hafenmenu', function()
    lib.registerContext(
        {
            id = 'hafenmenu',
            title = ('Schiffmissionen'),
            position = 'top-right',
            options = {
                {
                    title = ('Starte Mission!'),
                    description = ('Starte eine Schiffsmission' ),
                    icon = 'fas fa-circle',
                    event = 'mms-shipmissions:client:getmission',
                },
                {
                    title = ('Beende Mission!'),
                    description = ('Beende die Schiffsmission' ),
                    icon = 'fas fa-circle',
                    event = 'mms-shipmissions:client:finishmission',
                },
                {
                    title = ('Mission Abbrechen!'),
                    description = ('Breche die Mission ab!' ),
                    icon = 'fas fa-x',
                    event = 'mms-shipmissions:client:abortmission',
                },
                
            }
        }
    )
    lib.showContext('hafenmenu')
end)



RegisterNetEvent('mms-shipmissions:client:getmission')
AddEventHandler('mms-shipmissions:client:getmission', function()
    if shipmissionactive == 0 then
        shipmissionactive = math.random(1,1)
        RSGCore.Functions.Notify('Du Startest eine Mission!', 'success')
        StartMission()
    elseif shipmissionactive >=1 then
        RSGCore.Functions.Notify('Du hast bereits eine Mission Angenommen!', 'error')
    end
    
end)

RegisterNetEvent('mms-shipmissions:client:finishmission')
AddEventHandler('mms-shipmissions:client:finishmission', function()
    if shipmissionactive == 0 then
        RSGCore.Functions.Notify('Du hast Aktuell keine Mission!', 'error')
    elseif shipmissionactive >= 1 and aufgabe1 == 1 and aufgabe2 == 1 and aufgabe3 == 1 then
        DeletePrompts()
        DeleteVehicle(boat)
        reward = shipmissionactive
        aufgabe1 = 0
        aufgabe2 = 0
        aufgabe3 = 0
        shipmissionactive = 0
        missionamount = missionamount + 1
        TriggerServerEvent('mms-shipmissions:server:rewards' , reward)
    elseif shipmissionactive >=1 and aufgabe1 == 0 then
        RSGCore.Functions.Notify('Du hast nicht alle Aufgaben erledigt!', 'error') 
    end
end)

RegisterNetEvent('mms-shipmissions:client:abortmission')
AddEventHandler('mms-shipmissions:client:abortmission', function()
    if shipmissionactive <=1 then
        if shipmissionactive == 0 then
            RSGCore.Functions.Notify('Du hast Aktuell keine Mission.', 'error')
        elseif shipmissionactive >= 1 then
        RSGCore.Functions.Notify('Du brichst deine Aktuelle Mission ab!', 'error')
        shipmissionactive = 0
        aufgabe1 = 0
        aufgabe2 = 0
        aufgabe3 = 0
        DeletePrompts()
        if DoesBlipExist(blipaufgabe1) then
            RemoveBlip(blipaufgabe1)
        end
        if DoesBlipExist(blipaufgabe2) then
            RemoveBlip(blipaufgabe2)
        end
        if DoesBlipExist(blipaufgabe3) then
            RemoveBlip(blipaufgabe3)
        end
        end
    else
        RSGCore.Functions.Notify('Du hast keine Mission!', 'error')
    end
    
end)


function StartMission()
    if shipmissionactive == 1 then
        prompts = 1
        Mission1()
    elseif shipmissionactive == 2 then
        --Mission2()
    elseif shipmissionactive == 3 then
        --Mission3()
    elseif shipmissionactive == 4 then
        --Mission4()
    elseif shipmissionactive == 5 then
        --Mission5()
    elseif shipmissionactive == 6 then
        --Mission6()
    elseif shipmissionactive == 7 then
        --Mission7()
    elseif shipmissionactive == 8 then
        --Mission8()
    elseif shipmissionactive == 9 then
        --Mission9()
    elseif shipmissionactive == 10 then
        --Mission10()
    end
end

-- Mission 1
function Mission1()
    SpawnBoat()
    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission1Aufgabe1, Config.Mission1Coords1, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission1Aufgabe1desc, {
        type = 'client',
        event = 'mms-shipmissions:client:aufgabe1',
        args = {},
    })
    
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission1Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe1, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.BlipNameMissions)
        SetBlipFlashes(blipaufgabe1, true)
        AllowSonarBlips(blipaufgabe1,true)


    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission1Aufgabe2, Config.Mission1Coords2, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission1Aufgabe2desc, {
        type = 'client',
        event = 'mms-shipmissions:client:aufgabe2',
        args = {},
    })
        
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission1Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe2, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.BlipNameMissions)
        SetBlipFlashes(blipaufgabe2, true)
        AllowSonarBlips(blipaufgabe2,true)



    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission1Aufgabe3, Config.Mission1Coords3, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission1Aufgabe3desc, {
        type = 'client',
        event = 'mms-shipmissions:client:aufgabe3',
        args = {},
    })
            
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission1Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe3, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.BlipNameMissions)
        SetBlipFlashes(blipaufgabe3, true)
        AllowSonarBlips(blipaufgabe3,true)
end

-- Mission 2
function Mission2()

    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission2Aufgabe1, Config.Mission2Coords1, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission2Aufgabe1desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe1',
        args = {},
    })
    
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission2Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe1, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.Blipname1)
        SetBlipFlashes(blipaufgabe1, true)
        AllowSonarBlips(blipaufgabe1,true)


    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission2Aufgabe2, Config.Mission2Coords2, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission2Aufgabe2desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe2',
        args = {},
    })
        
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission2Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe2, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.Blipname2)
        SetBlipFlashes(blipaufgabe2, true)
        AllowSonarBlips(blipaufgabe2,true)



    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission2Aufgabe3, Config.Mission2Coords3, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission2Aufgabe3desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe3',
        args = {},
    })
            
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission2Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe3, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.Blipname3)
        SetBlipFlashes(blipaufgabe3, true)
        AllowSonarBlips(blipaufgabe3,true)

end

-- Mission 3
function Mission3()

    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission3Aufgabe1, Config.Mission3Coords1, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission3Aufgabe1desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe1',
        args = {},
    })
    
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission3Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe1, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.Blipname1)
        SetBlipFlashes(blipaufgabe1, true)
        AllowSonarBlips(blipaufgabe1,true)


    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission3Aufgabe2, Config.Mission3Coords2, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission3Aufgabe2desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe2',
        args = {},
    })
        
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission3Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe2, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.Blipname2)
        SetBlipFlashes(blipaufgabe2, true)
        AllowSonarBlips(blipaufgabe2,true)



    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission3Aufgabe3, Config.Mission3Coords3, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission3Aufgabe3desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe3',
        args = {},
    })
            
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission3Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe3, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.Blipname3)
        SetBlipFlashes(blipaufgabe3, true)
        AllowSonarBlips(blipaufgabe3,true)

end

-- Mission 4
function Mission4()

    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission4Aufgabe1, Config.Mission4Coords1, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission4Aufgabe1desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe1',
        args = {},
    })
    
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission4Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe1, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.Blipname1)
        SetBlipFlashes(blipaufgabe1, true)
        AllowSonarBlips(blipaufgabe1,true)


    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission4Aufgabe2, Config.Mission4Coords2, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission4Aufgabe2desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe2',
        args = {},
    })
        
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission4Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe2, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.Blipname2)
        SetBlipFlashes(blipaufgabe2, true)
        AllowSonarBlips(blipaufgabe2,true)



    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission4Aufgabe3, Config.Mission4Coords3, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission4Aufgabe3desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe3',
        args = {},
    })
            
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission4Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe3, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.Blipname3)
        SetBlipFlashes(blipaufgabe3, true)
        AllowSonarBlips(blipaufgabe3,true)

end

-- Mission 5
function Mission5()

    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission5Aufgabe1, Config.Mission5Coords1, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission5Aufgabe1desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe1',
        args = {},
    })
    
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission5Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe1, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.Blipname1)
        SetBlipFlashes(blipaufgabe1, true)
        AllowSonarBlips(blipaufgabe1,true)


    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission5Aufgabe2, Config.Mission5Coords2, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission5Aufgabe2desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe2',
        args = {},
    })
        
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission5Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe2, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.Blipname2)
        SetBlipFlashes(blipaufgabe2, true)
        AllowSonarBlips(blipaufgabe2,true)



    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission5Aufgabe3, Config.Mission5Coords3, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission5Aufgabe3desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe3',
        args = {},
    })
            
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission5Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe3, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.Blipname3)
        SetBlipFlashes(blipaufgabe3, true)
        AllowSonarBlips(blipaufgabe3,true)

end

-- Mission 6
function Mission6()

    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission6Aufgabe1, Config.Mission6Coords1, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission6Aufgabe1desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe1',
        args = {},
    })
    
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission6Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe1, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.Blipname1)
        SetBlipFlashes(blipaufgabe1, true)
        AllowSonarBlips(blipaufgabe1,true)


    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission6Aufgabe2, Config.Mission6Coords2, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission6Aufgabe2desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe2',
        args = {},
    })
        
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission6Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe2, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.Blipname2)
        SetBlipFlashes(blipaufgabe2, true)
        AllowSonarBlips(blipaufgabe2,true)



    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission6Aufgabe3, Config.Mission6Coords3, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission6Aufgabe3desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe3',
        args = {},
    })
            
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission6Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe3, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.Blipname3)
        SetBlipFlashes(blipaufgabe3, true)
        AllowSonarBlips(blipaufgabe3,true)

end

-- Mission 7
function Mission7()

    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission7Aufgabe1, Config.Mission7Coords1, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission7Aufgabe1desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe1',
        args = {},
    })
    
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission7Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe1, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.Blipname1)
        SetBlipFlashes(blipaufgabe1, true)
        AllowSonarBlips(blipaufgabe1,true)


    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission7Aufgabe2, Config.Mission7Coords2, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission7Aufgabe2desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe2',
        args = {},
    })
        
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission7Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe2, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.Blipname2)
        SetBlipFlashes(blipaufgabe2, true)
        AllowSonarBlips(blipaufgabe2,true)



    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission7Aufgabe3, Config.Mission7Coords3, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission7Aufgabe3desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe3',
        args = {},
    })
            
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission7Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe3, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.Blipname3)
        SetBlipFlashes(blipaufgabe3, true)
        AllowSonarBlips(blipaufgabe3,true)

end

-- Mission 8
function Mission8()

    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission8Aufgabe1, Config.Mission8Coords1, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission8Aufgabe1desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe1',
        args = {},
    })
    
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission8Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe1, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.Blipname1)
        SetBlipFlashes(blipaufgabe1, true)
        AllowSonarBlips(blipaufgabe1,true)


    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission8Aufgabe2, Config.Mission8Coords2, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission8Aufgabe2desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe2',
        args = {},
    })
        
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission8Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe2, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.Blipname2)
        SetBlipFlashes(blipaufgabe2, true)
        AllowSonarBlips(blipaufgabe2,true)



    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission8Aufgabe3, Config.Mission8Coords3, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission8Aufgabe3desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe3',
        args = {},
    })
            
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission8Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe3, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.Blipname3)
        SetBlipFlashes(blipaufgabe3, true)
        AllowSonarBlips(blipaufgabe3,true)

end

-- Mission 9
function Mission9()

    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission9Aufgabe1, Config.Mission9Coords1, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission9Aufgabe1desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe1',
        args = {},
    })
    
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission9Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe1, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.Blipname1)
        SetBlipFlashes(blipaufgabe1, true)
        AllowSonarBlips(blipaufgabe1,true)


    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission9Aufgabe2, Config.Mission9Coords2, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission9Aufgabe2desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe2',
        args = {},
    })
        
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission9Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe2, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.Blipname2)
        SetBlipFlashes(blipaufgabe2, true)
        AllowSonarBlips(blipaufgabe2,true)



    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission9Aufgabe3, Config.Mission9Coords3, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission9Aufgabe3desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe3',
        args = {},
    })
            
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission9Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe3, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.Blipname3)
        SetBlipFlashes(blipaufgabe3, true)
        AllowSonarBlips(blipaufgabe3,true)

end

-- Mission 10
function Mission10()

    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission10Aufgabe1, Config.Mission10Coords1, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission10Aufgabe1desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe1',
        args = {},
    })
    
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission10Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe1, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.Blipname1)
        SetBlipFlashes(blipaufgabe1, true)
        AllowSonarBlips(blipaufgabe1,true)


    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission10Aufgabe2, Config.Mission10Coords2, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission10Aufgabe2desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe2',
        args = {},
    })
        
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission10Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe2, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.Blipname2)
        SetBlipFlashes(blipaufgabe2, true)
        AllowSonarBlips(blipaufgabe2,true)



    Citizen.Wait(500)
    exports['rsg-core']:createPrompt(Config.Mission10Aufgabe3, Config.Mission10Coords3, RSGCore.Shared.Keybinds['J'],  (' ') .. Config.Mission10Aufgabe3desc, {
        type = 'client',
        event = 'mms-questsystem:client:aufgabe3',
        args = {},
    })
            
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission10Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey('blip_code_waypoint'), true)
        SetBlipScale(blipaufgabe3, 5.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.Blipname3)
        SetBlipFlashes(blipaufgabe3, true)
        AllowSonarBlips(blipaufgabe3,true)

end









RegisterNetEvent('mms-shipmissions:client:aufgabe1')
AddEventHandler('mms-shipmissions:client:aufgabe1', function()
    if aufgabe1 == 0 then
        RSGCore.Functions.Progressbar('Netze Auswerfen','Du Wirfst die Netze aus!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Progressbar('Netze Einholen','Du holst die Netze ein!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Progressbar('Netze Leermachen','Du machst das Netzt leer!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Notify('Du hast diesen Teil der Mission erfolgreich abgeschlossen!.', 'success')
        if DoesBlipExist(blipaufgabe1) then
            RemoveBlip(blipaufgabe1)
        end
        aufgabe1 = 1
        if aufgabe1 == 1 and aufgabe2 == 1 and aufgabe3 == 1 then
            RSGCore.Functions.Notify('Du hast alle Aufgaben Abgeschlossen! Hole deine Belohnung!.', 'success')
        end
    elseif aufgabe1 == 1 then
        RSGCore.Functions.Notify('Diese aufgabe ist Bereits Erledigt.', 'info')
    end
end)

---- Aufgabe 2

RegisterNetEvent('mms-shipmissions:client:aufgabe2')
AddEventHandler('mms-shipmissions:client:aufgabe2', function()
    if aufgabe2 == 0 then
        RSGCore.Functions.Progressbar('Netze Auswerfen','Du Wirfst die Netze aus!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Progressbar('Netze Einholen','Du holst die Netze ein!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Progressbar('Netze Leermachen','Du machst das Netzt leer!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Notify('Du hast diesen Teil der Mission erfolgreich abgeschlossen!.', 'success')
        if DoesBlipExist(blipaufgabe2) then
            RemoveBlip(blipaufgabe2)
        end
        aufgabe2 = 1
        if aufgabe1 == 1 and aufgabe2 == 1 and aufgabe3 == 1 then
            RSGCore.Functions.Notify('Du hast alle Aufgaben Abgeschlossen! Hole deine Belohnung!.', 'success')
        end
    elseif aufgabe2 == 1 then
        RSGCore.Functions.Notify('Diese aufgabe ist Bereits Erledigt.', 'info')
    end
end)

---- Aufgabe 3

RegisterNetEvent('mms-shipmissions:client:aufgabe3')
AddEventHandler('mms-shipmissions:client:aufgabe3', function()
    if aufgabe3 == 0 then
        RSGCore.Functions.Progressbar('Netze Auswerfen','Du Wirfst die Netze aus!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Progressbar('Netze Einholen','Du holst die Netze ein!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Progressbar('Netze Leermachen','Du machst das Netzt leer!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Notify('Du hast diesen Teil der Mission erfolgreich abgeschlossen!.', 'success')
        if DoesBlipExist(blipaufgabe3) then
            RemoveBlip(blipaufgabe3)
        end
        aufgabe3 = 1
        if aufgabe1 == 1 and aufgabe2 == 1 and aufgabe3 == 1 then
            RSGCore.Functions.Notify('Du hast alle Aufgaben Abgeschlossen! Hole deine Belohnung!.', 'success')
        end
    elseif aufgabe3 == 1 then
        RSGCore.Functions.Notify('Diese aufgabe ist Bereits Erledigt.', 'info')
    end
end)



--------------------------------UTILS

function SpawnBoat()
    if boatSpawned == false then
        local ped = PlayerPedId()
        local boathash = 'boatsteam02x'
        local spawncoords = vector4(-684.55, -1256.70, 40.18, 254.70)
        RequestModel(boathash)
        while not HasModelLoaded(boathash) do
            Citizen.Wait(0)
        end
        boat = CreateVehicle(boathash, spawncoords, true, false)
        SetVehicleOnGroundProperly(boat)
        SetEntityAsMissionEntity(boat,true,true)
        SetVehicleCanBreak(boat,false)
        Wait(200)
        SetPedIntoVehicle(ped, boat, -1)
        SetModelAsNoLongerNeeded(boathash)
        SpawnedBoat = boat
        boatSpawned = true
    end
end

------ DElte Prompts

function DeletePrompts()
    if  prompts == 1 then
        if aufgabe1 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission1Aufgabe1)
        end
        if aufgabe2 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission1Aufgabe2)
        end
        if aufgabe3 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission1Aufgabe3)
        end

    elseif prompts == 2 then
        if aufgabe1 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission2Aufgabe1)
        end
        if aufgabe2 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission2Aufgabe2)
        end
        if aufgabe3 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission2Aufgabe3)
        end

    elseif prompts == 3 then
        if aufgabe1 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission3Aufgabe1)
        end
        if aufgabe2 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission3Aufgabe2)
        end
        if aufgabe3 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission3Aufgabe3)
        end
  
    elseif prompts == 4 then
        if aufgabe1 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission4Aufgabe1)
        end
        if aufgabe2 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission4Aufgabe2)
        end
        if aufgabe3 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission4Aufgabe3)
        end

    elseif prompts == 5 then
        if aufgabe1 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission5Aufgabe1)
        end
        if aufgabe2 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission5Aufgabe2)
        end
        if aufgabe3 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission5Aufgabe3)
        end

    elseif prompts == 6 then
        if aufgabe1 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission6Aufgabe1)
        end
        if aufgabe2 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission6Aufgabe2)
        end
        if aufgabe3 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission6Aufgabe3)
        end

    elseif prompts == 7 then
        if aufgabe1 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission7Aufgabe1)
        end
        if aufgabe2 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission7Aufgabe2)
        end
        if aufgabe3 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission7Aufgabe3)
        end

    elseif prompts == 8 then
        if aufgabe1 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission8Aufgabe1)
        end
        if aufgabe2 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission8Aufgabe2)
        end
        if aufgabe3 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission8Aufgabe3)
        end

    elseif prompts == 9 then
        if aufgabe1 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission9Aufgabe1)
        end
        if aufgabe2 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission9Aufgabe2)
        end
        if aufgabe3 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission9Aufgabe3)
        end

    elseif prompts == 10 then
        if aufgabe1 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission10Aufgabe1)
        end
        if aufgabe2 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission10Aufgabe2)
        end
        if aufgabe3 == 0 then
        exports['rsg-core']:deletePrompt(Config.Mission10Aufgabe3)
        end
    end
end