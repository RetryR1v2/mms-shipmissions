local RSGCore = exports['rsg-core']:GetCoreObject()
local shipmissionactive = 0
local aufgabe1 = 0
local aufgabe2 = 0
local aufgabe3 = 0
local prompts = 0
local SpawnedBoat = nil
local boatSpawned = false
local missionamount = 1
local radius = 5.0
local missionactive = false
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
                    icon = 'fas fa-check',
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
        DeleteVehicle(boat)
        SpawnedBoat = nil
        boatSpawned = false
        reward = shipmissionactive
        aufgabe1 = 0
        aufgabe2 = 0
        aufgabe3 = 0
        shipmissionactive = 0
        missionactive = false
        showgps = false
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
        DeleteVehicle(boat)
        SpawnedBoat = nil
        boatSpawned = false
        missionactive = false
        showgps = false
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
        Mission1Part1()
    elseif shipmissionactive == 2 then
        --Mission2Part1()
    elseif shipmissionactive == 3 then
        --Mission3Part1()
    elseif shipmissionactive == 4 then
        --Mission4Part1()
    elseif shipmissionactive == 5 then
        --Mission5Part1()
    elseif shipmissionactive == 6 then
        --Mission6Part1()
    elseif shipmissionactive == 7 then
        --Mission7Part1()
    elseif shipmissionactive == 8 then
        --Mission8Part1()
    elseif shipmissionactive == 9 then
        --Mission9Part1()
    elseif shipmissionactive == 10 then
        --Mission10Part1()
    end
end

-- Mission 1
function Mission1Part1()
    SpawnBoat()
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission1Coords1)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission1Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe1, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission1Coords1) < 5.0 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission1Coords1)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe1')
                    end
        end
end

function Mission1Part2()
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission1Coords2)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission1Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe2, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission1Coords2) < 5.0 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission1Coords2)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe2')
                    end
        end
end

function Mission1Part3()

    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission1Coords3)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission1Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe3, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission1Coords3) < 5.0 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission1Coords3)
                        end
                        TriggerEvent('mms-shipmissions:client:aufgabe3')
                        missionactive = false
                        showgps = false
                    end
        end
end











RegisterNetEvent('mms-shipmissions:client:aufgabe1')
AddEventHandler('mms-shipmissions:client:aufgabe1', function()
    if aufgabe1 == 0 then
        FreezeEntityPosition(boat,true)
        RSGCore.Functions.Progressbar('Netze Auswerfen','Du Wirfst das Netz aus!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Progressbar('Netze Einholen','Du holst das Netz ein!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Progressbar('Netze Leermachen','Du machst das Netz leer!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        FreezeEntityPosition(boat,false)
        RSGCore.Functions.Notify('Du hast diesen Teil der Mission erfolgreich abgeschlossen!.', 'success')
        if DoesBlipExist(blipaufgabe1) then
            RemoveBlip(blipaufgabe1)
        end
        aufgabe1 = 1
        if aufgabe1 == 1 and aufgabe2 == 1 and aufgabe3 == 1 then
            RSGCore.Functions.Notify('Du hast alle Aufgaben Abgeschlossen! Hole deine Belohnung!.', 'success')
        end
        Mission1Part2()
    end
end)

---- Aufgabe 2

RegisterNetEvent('mms-shipmissions:client:aufgabe2')
AddEventHandler('mms-shipmissions:client:aufgabe2', function()
    if aufgabe2 == 0 then
        FreezeEntityPosition(boat,true)
        RSGCore.Functions.Progressbar('Netze Auswerfen','Du Wirfst das Netz aus!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Progressbar('Netze Einholen','Du holst das Netz ein!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Progressbar('Netze Leermachen','Du machst das Netz leer!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        FreezeEntityPosition(boat,false)
        RSGCore.Functions.Notify('Du hast diesen Teil der Mission erfolgreich abgeschlossen!.', 'success')
        if DoesBlipExist(blipaufgabe2) then
            RemoveBlip(blipaufgabe2)
        end
        aufgabe2 = 1
        if aufgabe1 == 1 and aufgabe2 == 1 and aufgabe3 == 1 then
            RSGCore.Functions.Notify('Du hast alle Aufgaben Abgeschlossen! Hole deine Belohnung!.', 'success')
        end
    Mission1Part3()
    end
end)

---- Aufgabe 3

RegisterNetEvent('mms-shipmissions:client:aufgabe3')
AddEventHandler('mms-shipmissions:client:aufgabe3', function()
    if aufgabe3 == 0 then
        FreezeEntityPosition(boat,true)
        RSGCore.Functions.Progressbar('Netze Auswerfen','Du Wirfst das Netz aus!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Progressbar('Netze Einholen','Du holst das Netz ein!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        RSGCore.Functions.Progressbar('Netze Leermachen','Du machst das Netz leer!',Config.Missiontime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        FreezeEntityPosition(boat,false)
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

