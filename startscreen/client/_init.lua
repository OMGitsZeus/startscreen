Events = nil
loaded = false
local first = true
local waitingSpawn = true
PlayersCrew = {}
Crew = {}
KingDriftCrew = {
    name = "Nothing",
    elo = 5,
}
CrewRanking = {}

Citizen.CreateThread(function()
    TriggerServerEvent("driftV:InitPlayer")
    TriggerServerEvent("drift:GetRaceData")
    player:new()
    loaded = true

    startCinematic()

    SetPlayerInvincible(GetPlayerIndex(), true) 
    RequestIpl('shr_int')
end)

RegisterNetEvent("syncEvents")
AddEventHandler("syncEvents", function(ev)
    Events = ev
end)

RegisterNetEvent("driftV:RefreshData")
AddEventHandler("driftV:RefreshData", function(data)
    p:SetCars(data.cars)
    p:SetDriftPoint(data.driftPoint)
    p:SetMoney(data.money)
    p:InitSucces(data.succes)
    p:setExp(data.exp)
    p:setCrew(data.crew)
    p:setCrewOwner(data.crewOwner)
end)

RegisterNetEvent("driftV:RefreshOtherPlayerData")
AddEventHandler("driftV:RefreshOtherPlayerData", function(crew, pCrews, king)
    PlayersCrew = pCrews
    Crew = crew
    KingDriftCrew = king
end)

RegisterNetEvent("driftV:RefreshCrewRanking", function(ranking)
    CrewRanking = ranking
end)

local possibleCam = {

    {
        cam1 = vector3(-1820.38, 2970.94, 49.54),
        cam1fov = 40.0,
        cam1LookTo = vector3(-1820.38, 2970.94, 30.54),

        cam2 = vector3(-1859.32, 2993.87, 48.56),
        cam2fov = 15.0,
        cam2LookTo = vector3(-1859.32, 2993.87, 30.56),

        entity = {
            model = "cmC101",
            pos = vector4(-1841.24, 2982.66, 33.20, 61.67),
        },
    },

    {
        cam1 = vector3(-1230.06, -3302.62, 16.96),
        cam1fov = 60.0,
        cam1LookTo = vector3(-1258.05, -3350.87, 14.609693527222),

        cam2 = vector3(-1246.52, -3331.69, 15.38),
        cam2fov = 20.0,
        cam2LookTo = vector3(-1258.05, -3350.87, 15.609693527222),

        entity = {
            model = "akdemo1",
            pos = vector4(-1258.05, -3350.87, 12.109693527222, 270.19365722656),
        },
    },

    {
        cam1 = vector3(4449.84, -4474.66, 6.85),
        cam1fov = 60.0,
        cam1LookTo = vector3(4442.46, -4467.34, 3.1),

        cam2 = vector3(4444.99, -4455.55, 6.16),
        cam2fov = 30.0,
        cam2LookTo = vector3(4442.46, -4467.34, 5.1),

        entity = {
            model = "sabref16",
            pos = vector4(4442.46, -4467.34, 3.4, 198.37),
        },
    },

    {
        cam1 = vector3(1427.99, 3017.01, 41.73),
        cam1fov = 30.0,
        cam1LookTo = vector3(1355.48, 2908.48, 41.73),

        cam2 = vector3(1405.86, 3033.51, 41.73),
        cam2fov = 20.0,
        cam2LookTo = vector3(1355.48, 2908.48, 41.73),

        entity = {
            model = "blackjack",
            pos = vector4(1412.54, 3011.07, 40.51, 288.39),
        },
    },

    {
        cam1 = vector3(-60.137535095215, -1111.6331787109, 28.331649780273),
        cam1fov = 40.0,
        cam1LookTo = vector3(-66.277770996094, -1113.6544189453, 30.822368621826),

        cam2 = vector3(-65.160697937012, -1107.6329345703, 26.849964141846),
        cam2fov = 35.0,
        cam2LookTo = vector3(-73.790664672852, -1106.6363525391, 25.570594787598),

        entity = {
            model = "ssg_ballerstd",
            pos = vector4(-72.35034942627, -1107.6314697266, 25.253856658936, 106.37840270996),
        },
    },
}

local possibleMusic = {
    "kendrik",
    "antdot",
    "leon",
    "kendrik",
}

function startCinematic()

    Citizen.CreateThread(function()
        exports.spawnmanager.spawnPlayer()
        cam.create("CAM_1")
        cam.create("CAM_2")
        local music = possibleMusic[math.random(1,#possibleMusic)]
        TriggerEvent("InteractSound_CL:PlayOnOne", music, 0.07)

        while waitingSpawn do
            for k,v in pairs(possibleCam) do
                if not waitingSpawn then break end
                local entity = nil
                if v.entity ~= nil then
                    LoadModel(v.entity.model)
                    entity = CreateVehicle(GetHashKey(v.entity.model), v.entity.pos, 0, 1)
                    SetVehicleDirtLevel(entity, 0.0)
                    SetVehicleOnGroundProperly(entity)
                end

                DoScreenFadeIn(2000)
                cam.setPos("CAM_1", v.cam1)
                cam.setFov("CAM_1", v.cam1fov)
                cam.lookAtCoords("CAM_1", v.cam1LookTo)
                cam.setActive("CAM_1")
                cam.render("CAM_1", true, false, 0)

                cam.setPos("CAM_2", v.cam2)
                cam.setFov("CAM_2", v.cam2fov)
                cam.lookAtCoords("CAM_2", v.cam2LookTo)

                cam.setActive("CAM_2")
                cam.switchToCam("CAM_2", "CAM_1", 15000)

                local timer = GetGameTimer() + 10000
                while GetGameTimer() < timer do
                    Wait(1)
                end

                if not waitingSpawn then
                    DeleteEntity(entity)
                    break
                end

                DoScreenFadeOut(2000)
                Wait(2100)
                if entity ~= nil then
                    DeleteEntity(entity)
                end
            end

            Wait(0)
        end
    end)

    DisplayRadar(false)
    SetNuiFocus(true, true)

    SendNUIMessage({
        containerJoins = true,
    })

    local music = possibleMusic[math.random(1,#possibleMusic)]
    TriggerEvent("InteractSound_CL:PlayOnOne", music, 0.07)
end

RegisterNUICallback('joinServer', function(data)
    if not waitingSpawn then return end

    waitingSpawn = false

    SendNUIMessage({ joinClick = true })
    TriggerEvent("InteractSound_CL:Stop")

    DoScreenFadeOut(1500)
    Wait(1500)
    DoScreenFadeIn(2000)

    RenderScriptCams(false, false, false, 0, 0)
    SetNuiFocus(false, false)

    cam.delete("CAM_1")
    cam.delete("CAM_2")
    DisplayRadar(true)

    SetAudioFlag("LoadMPData", true)
    SetBigmapActive(false, false)
    EnableLobby()
end)
