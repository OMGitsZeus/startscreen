function LoadModel(name)
    local model = GetHashKey(name)
    if not IsModelInCdimage(model) then return false end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    return true
end

function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y = World3dToScreen2d(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function ShowLoadingMessage(text, spinner)
    BeginTextCommandBusyspinnerOn("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandBusyspinnerOn(spinner or 4)
end

-- =========================
-- FIXED FUNCTION (LINE 119 ISSUE)
-- =========================
function ShowLoadingMessageTimed(duration, text, spinner)
    Citizen.CreateThread(function()
        Citizen.Wait(0)

        -- Visual.Prompt does not exist on all servers
        if Visual ~= nil and Visual.Prompt ~= nil then
            Visual.Prompt(text, spinner)
        else
            ShowLoadingMessage(text, spinner)
        end

        Citizen.Wait(duration)

        if BusyspinnerIsOn() then
            BusyspinnerOff()
        end
    end)
end

function ClearScreen()
    SetCloudHatOpacity(0.0)
    HideHudAndRadarThisFrame()
end

RegisterNetEvent("DeleteEntity", function(ent)
    local entity = NetworkGetEntityFromNetworkId(ent)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    else
        print("Entity does not exist for network ID: " .. tostring(ent))
    end
end)

function GroupDigits(value)
    local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)','%1 '):reverse()) .. right
end
