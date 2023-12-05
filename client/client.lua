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
local player = PlayerPedId()
local id = PlayerId()
local name = GetPlayerName(id)

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
                    title = ('Missionen Absolviert!'),
                    description = ('Anzahl absolvierter Missionen!'),
                    icon = 'fas fa-info',
                    event = 'mms-shipmissions:client:missioncount',
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
    if Config.MissionLimit == true then
    if missionamount <= Config.Maxmission and shipmissionactive == 0 then
        shipmissionactive = math.random(1,10)
        RSGCore.Functions.Notify('Du Startest eine Mission!', 'success')
        StartMission()
    else
        RSGCore.Functions.Notify('Du hast bereits ' .. Config.Maxmission .. ' Missionen Abgeschlosse!', 'error')
    end
    elseif Config.MissionLimit == false then
    if shipmissionactive == 0 then
        shipmissionactive = math.random(1,10)
        RSGCore.Functions.Notify('Du Startest eine Mission!', 'success')
        StartMission()
    elseif shipmissionactive >=1 then
        RSGCore.Functions.Notify('Du hast bereits eine Mission Angenommen!', 'error')
    end
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
        lib.hideTextUI()
        missionamount = missionamount + 1
        UpdateDB()
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
        if shipmissionactive == 1 then ClearGpsMultiRoute(Config.Mission1Coords1) ClearGpsMultiRoute(Config.Mission1Coords2) ClearGpsMultiRoute(Config.Mission1Coords3)
        elseif shipmissionactive == 2 then ClearGpsMultiRoute(Config.Mission2Coords1) ClearGpsMultiRoute(Config.Mission2Coords2) ClearGpsMultiRoute(Config.Mission2Coords3)
        elseif shipmissionactive == 3 then ClearGpsMultiRoute(Config.Mission3Coords1) ClearGpsMultiRoute(Config.Mission3Coords2) ClearGpsMultiRoute(Config.Mission3Coords3)
        elseif shipmissionactive == 4 then ClearGpsMultiRoute(Config.Mission4Coords1) ClearGpsMultiRoute(Config.Mission4Coords2) ClearGpsMultiRoute(Config.Mission4Coords3)
        elseif shipmissionactive == 5 then ClearGpsMultiRoute(Config.Mission5Coords1) ClearGpsMultiRoute(Config.Mission5Coords2) ClearGpsMultiRoute(Config.Mission5Coords3)
        elseif shipmissionactive == 6 then ClearGpsMultiRoute(Config.Mission6Coords1) ClearGpsMultiRoute(Config.Mission6Coords2) ClearGpsMultiRoute(Config.Mission6Coords3)
        elseif shipmissionactive == 7 then ClearGpsMultiRoute(Config.Mission7Coords1) ClearGpsMultiRoute(Config.Mission7Coords2) ClearGpsMultiRoute(Config.Mission7Coords3)
        elseif shipmissionactive == 8 then ClearGpsMultiRoute(Config.Mission8Coords1) ClearGpsMultiRoute(Config.Mission8Coords2) ClearGpsMultiRoute(Config.Mission8Coords3)
        elseif shipmissionactive == 9 then ClearGpsMultiRoute(Config.Mission9Coords1) ClearGpsMultiRoute(Config.Mission9Coords2) ClearGpsMultiRoute(Config.Mission9Coords3)
        elseif shipmissionactive == 10 then ClearGpsMultiRoute(Config.Mission10Coords1) ClearGpsMultiRoute(Config.Mission10Coords2) ClearGpsMultiRoute(Config.Mission10Coords3)
        end
        shipmissionactive = 0
        aufgabe1 = 0
        aufgabe2 = 0
        aufgabe3 = 0
        DeleteVehicle(boat)
        lib.hideTextUI()
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
        Mission1Part1()
    elseif shipmissionactive == 2 then
        Mission2Part1()
    elseif shipmissionactive == 3 then
        Mission3Part1()
    elseif shipmissionactive == 4 then
        Mission4Part1()
    elseif shipmissionactive == 5 then
        Mission5Part1()
    elseif shipmissionactive == 6 then
        Mission6Part1()
    elseif shipmissionactive == 7 then
        Mission7Part1()
    elseif shipmissionactive == 8 then
        Mission8Part1()
    elseif shipmissionactive == 9 then
        Mission9Part1()
    elseif shipmissionactive == 10 then
        Mission10Part1()
    end
end


-- Mission 1
function Mission1Part1()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    SpawnBoat()
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission1Coords1)
        SetGpsMultiRouteRender(true)
        missionactive = true
        lib.showTextUI('Fahre auf See und Fange Fische')
        local showgps = true
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission1Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe1, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission1Coords1) < 9.5 then
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
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
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
                    if #(boatpos - Config.Mission1Coords2) < 9.5 then
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
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
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
                    if #(boatpos - Config.Mission1Coords3) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission1Coords3)
                        end
                        TriggerEvent('mms-shipmissions:client:aufgabe3')
                        missionactive = false
                        showgps = false
                    end
        end
end



-- Mission 2
function Mission2Part1()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    SpawnBoat()
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission2Coords1)
        SetGpsMultiRouteRender(true)
        missionactive = true
        lib.showTextUI('Fahre auf See und Fange Fische')
        local showgps = true
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission2Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe1, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission2Coords1) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission2Coords1)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe1')
                    end
        end
end

function Mission2Part2()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission2Coords2)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission2Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe2, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission2Coords2) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission2Coords2)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe2')
                    end
        end
end

function Mission2Part3()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission2Coords3)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission2Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe3, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission2Coords3) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission2Coords3)
                        end
                        TriggerEvent('mms-shipmissions:client:aufgabe3')
                        missionactive = false
                        showgps = false
                    end
        end
end


-- Mission 3
function Mission3Part1()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    SpawnBoat()
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission3Coords1)
        SetGpsMultiRouteRender(true)
        missionactive = true
        lib.showTextUI('Fahre auf See und Fange Fische')
        local showgps = true
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission3Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe1, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission3Coords1) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission3Coords1)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe1')
                    end
        end
end

function Mission3Part2()
    Citizen.Wait(500)
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission3Coords2)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission3Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe2, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission3Coords2) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission3Coords2)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe2')
                    end
        end
end

function Mission3Part3()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission3Coords3)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission3Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe3, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission3Coords3) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission3Coords3)
                        end
                        TriggerEvent('mms-shipmissions:client:aufgabe3')
                        missionactive = false
                        showgps = false
                    end
        end
end


-- Mission 4
function Mission4Part1()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    SpawnBoat()
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission4Coords1)
        SetGpsMultiRouteRender(true)
        missionactive = true
        lib.showTextUI('Fahre auf See und Fange Fische')
        local showgps = true
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission4Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe1, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission4Coords1) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission4Coords1)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe1')
                    end

        end
end

function Mission4Part2()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission4Coords2)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission4Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe2, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission4Coords2) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission4Coords2)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe2')
                    end
        end
end

function Mission4Part3()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission4Coords3)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission4Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe3, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission4Coords3) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission4Coords3)
                        end
                        TriggerEvent('mms-shipmissions:client:aufgabe3')
                        missionactive = false
                        showgps = false
                    end
        end
end


-- Mission 5
function Mission5Part1()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    SpawnBoat()
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission5Coords1)
        SetGpsMultiRouteRender(true)
        missionactive = true
        lib.showTextUI('Fahre auf See und Fange Fische')
        local showgps = true
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission5Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe1, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission5Coords1) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission5Coords1)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe1')
                    end
        end
end

function Mission5Part2()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission5Coords2)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission5Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe2, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission5Coords2) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission5Coords2)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe2')
                    end
                
        end
end

function Mission5Part3()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission5Coords3)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission5Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe3, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission5Coords3) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission5Coords3)
                        end
                        TriggerEvent('mms-shipmissions:client:aufgabe3')
                        missionactive = false
                        showgps = false
                    end
        end
end


-- Mission 6
function Mission6Part1()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    SpawnBoat()
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission6Coords1)
        SetGpsMultiRouteRender(true)
        missionactive = true
        lib.showTextUI('Fahre auf See und Fange Fische')
        local showgps = true
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission6Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe1, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission6Coords1) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission6Coords1)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe1')
                    end
        end
end

function Mission6Part2()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission6Coords2)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission6Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe2, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission6Coords2) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission6Coords2)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe2')
                    end
            
        end
end

function Mission6Part3()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission6Coords3)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission6Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe3, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission6Coords3) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission6Coords3)
                        end
                        TriggerEvent('mms-shipmissions:client:aufgabe3')
                        missionactive = false
                        showgps = false
                    end
                
        end
end


-- Mission 7
function Mission7Part1()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    SpawnBoat()
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission7Coords1)
        SetGpsMultiRouteRender(true)
        missionactive = true
        lib.showTextUI('Fahre auf See und Fange Fische')
        local showgps = true
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission7Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe1, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission7Coords1) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission7Coords1)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe1')
                    end
        end
end

function Mission7Part2()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission7Coords2)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission7Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe2, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission7Coords2) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission7Coords2)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe2')
                    end
                
        end
end

function Mission7Part3()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission7Coords3)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission7Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe3, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission7Coords3) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission7Coords3)
                        end
                        TriggerEvent('mms-shipmissions:client:aufgabe3')
                        missionactive = false
                        showgps = false
                    end
                
        end
end


-- Mission 8
function Mission8Part1()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    SpawnBoat()
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission8Coords1)
        SetGpsMultiRouteRender(true)
        missionactive = true
        lib.showTextUI('Fahre auf See und Fange Fische')
        local showgps = true
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission8Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe1, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission8Coords1) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission8Coords1)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe1')
                    end
                
        end
end

function Mission8Part2()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission8Coords2)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission8Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe2, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission8Coords2) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission8Coords2)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe2')
                    
                end
        end
end

function Mission8Part3()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission8Coords3)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission8Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe3, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission8Coords3) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission8Coords3)
                        end
                        TriggerEvent('mms-shipmissions:client:aufgabe3')
                        missionactive = false
                        showgps = false
                    end
               
        end
end


-- Mission 9
function Mission9Part1()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    SpawnBoat()
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission9Coords1)
        SetGpsMultiRouteRender(true)
        missionactive = true
        lib.showTextUI('Fahre auf See und Fange Fische')
        local showgps = true
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission9Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe1, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                    if #(boatpos - Config.Mission9Coords1) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission9Coords1)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe1')
                    end
                
        end
end

function Mission9Part2()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission9Coords2)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission9Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe2, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
               
                    if #(boatpos - Config.Mission9Coords2) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission9Coords2)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe2')
                    end
                
        end
end

function Mission9Part3()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission9Coords3)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission9Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe3, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                
                    if #(boatpos - Config.Mission9Coords3) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission9Coords3)
                        end
                        TriggerEvent('mms-shipmissions:client:aufgabe3')
                        missionactive = false
                        showgps = false
                    end
               

        end
end


-- Mission 10
function Mission10Part1()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    SpawnBoat()
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission10Coords1)
        SetGpsMultiRouteRender(true)
        missionactive = true
        lib.showTextUI('Fahre auf See und Fange Fische')
        local showgps = true
        blipaufgabe1 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission10Coords1)
        SetBlipSprite(blipaufgabe1, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe1, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe1, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                
                    if #(boatpos - Config.Mission10Coords1) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission10Coords1)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe1')
                    end
                
        end
end

function Mission10Part2()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission10Coords2)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe2 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission10Coords2)
        SetBlipSprite(blipaufgabe2, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe2, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe2, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
                
                    if #(boatpos - Config.Mission10Coords2) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission10Coords2)
                        end
                        missionactive = false
                        showgps = false
                        TriggerEvent('mms-shipmissions:client:aufgabe2')
                    end
                
        end
end

function Mission10Part3()
    RSGCore.Functions.Notify('Fahre raus auf See und Fange Fische!', 'info')
    Citizen.Wait(500)
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(Config.Mission10Coords3)
        SetGpsMultiRouteRender(true)
        missionactive = true
        local showgps = true
        blipaufgabe3 = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.Mission10Coords3)
        SetBlipSprite(blipaufgabe3, GetHashKey(Config.BlipSpriteMissions), true)
        SetBlipScale(blipaufgabe3, Config.BlipScaleMissions)
        Citizen.InvokeNative(0x9CB1A1623062F402, blipaufgabe3, Config.BlipNameMissions)
        while missionactive == true do
            Citizen.Wait(1000)
                local boatpos = GetEntityCoords(boat, true)
            
                    if #(boatpos - Config.Mission10Coords3) < 9.5 then
                        if showgps == true then
                            ClearGpsMultiRoute(Config.Mission10Coords3)
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
        if shipmissionactive == 1 then Mission1Part2() elseif shipmissionactive == 2 then Mission2Part2() elseif shipmissionactive == 3 then Mission3Part2()
        elseif shipmissionactive == 4 then Mission4Part2() elseif shipmissionactive == 5 then Mission5Part2() elseif shipmissionactive == 6 then Mission6Part2()
        elseif shipmissionactive == 7 then Mission7Part2() elseif shipmissionactive == 8 then Mission8Part2() elseif shipmissionactive == 9 then Mission9Part2()
        elseif shipmissionactive == 10 then Mission10Part2()
        end
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
        if shipmissionactive == 1 then Mission1Part3() elseif shipmissionactive == 2 then Mission2Part3() elseif shipmissionactive == 3 then Mission3Part3()
        elseif shipmissionactive == 4 then Mission4Part3() elseif shipmissionactive == 5 then Mission5Part3() elseif shipmissionactive == 6 then Mission6Part3()
        elseif shipmissionactive == 7 then Mission7Part3() elseif shipmissionactive == 8 then Mission8Part3() elseif shipmissionactive == 9 then Mission9Part3()
        elseif shipmissionactive == 10 then Mission10Part3()
        end
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
            lib.hideTextUI()
            lib.showTextUI('Fahre zurück zum Hafen!')
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


function UpdateDB()
    local vorname = RSGCore.Functions.GetPlayerData().charinfo.firstname
    local nachname = RSGCore.Functions.GetPlayerData().charinfo.lastname
    local citizenid = RSGCore.Functions.GetPlayerData().citizenid
    local count = 1
    TriggerServerEvent('mms-shipmissions:server:updatedb',vorname, nachname, citizenid,count)
end

RegisterNetEvent('mms-shipmissions:client:missioncount')
AddEventHandler('mms-shipmissions:client:missioncount', function()
    local vorname = RSGCore.Functions.GetPlayerData().charinfo.firstname
    local nachname = RSGCore.Functions.GetPlayerData().charinfo.lastname
    local citizenid = RSGCore.Functions.GetPlayerData().citizenid
    TriggerServerEvent('mms-shipmissions:server:missioncount',vorname, nachname, citizenid)
end)

RegisterNetEvent('mms-shipmissions:client:ReturnCount', function(missioncount)
    RSGCore.Functions.Notify('Du hast bereits ' .. missioncount .. ' Missionen Abgeschlosse!', 'info')
end)
