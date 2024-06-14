local isAdmin = false
local isGodMode = false
local inDuty = false
local isNoClip = false

RegisterNetEvent('nkhd_admin:setAdmin')
AddEventHandler('nkhd_admin:setAdmin', function(status)
    isAdmin = status
end)

RegisterCommand(Config.Commands.aduty, function()
    TriggerServerEvent('nkhd_admin:requestAdmin', source)
    if isAdmin then
        inDuty = not inDuty
        local playerPed = PlayerPedId()

        if inDuty then
            local playerGender = IsPedMale(playerPed) and 'male' or 'female'
            local outfit = Config.AdminClothing[playerGender].outfit

            SetPedComponentVariation(playerPed, 8, outfit.tshirt, outfit.tshirt2, 0)
            SetPedComponentVariation(playerPed, 11, outfit.torso, outfit.torso2, 0)
            SetPedComponentVariation(playerPed, 4, outfit.pants, outfit.pants2, 0)
            SetPedComponentVariation(playerPed, 6, outfit.shoes, outfit.shoes2, 0)
            SetPedComponentVariation(playerPed, 9, outfit.bproof_1, outfit.bproof_2, 0)
            SetPedComponentVariation(playerPed, 3, outfit.arms, 0, 0)
            SetPedPropIndex(playerPed, 0, outfit.helmet, false)
            if UseESXNotification == true then
                ESX.ShowNotification(_U('aduty_on'))
            else
                ShowNotification(_U('aduty_on'))
            end
        else

            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
            if UseESXNotification == true then
                ESX.ShowNotification(_U('aduty_off'))
            else
                ShowNotification(_U('aduty_off'))
            end
        end
    else
        if UseESXNotification == true then
            ESX.ShowNotification(_U('no_permission'))
        else
            ShowNotification(_U('no_permission'))
        end
    end
end, false)

RegisterCommand(Config.Commands.godmode, function()
    TriggerServerEvent('nkhd_admin:requestAdmin', source)
    if isAdmin then
        if isGodMode == false then
            SetEntityInvincible(PlayerPedId(), true)
            if UseESXNotification == true then
                ESX.ShowNotification(_U('godmode_on'))
            else
                ShowNotification(_U('godmode_on'))
            end
            isGodMode = true
        else
            SetEntityInvincible(PlayerPedId(), false)
            if UseESXNotification == true then
                ESX.ShowNotification(_U('godmode_off'))
            else
                ShowNotification(_U('godmode_off'))
            end
            isGodMode = false
        end
    else
        if UseESXNotification == true then
            ESX.ShowNotification(_U('no_permission'))
        else
            ShowNotification(_U('no_permission'))
        end
    end
end, false)

RegisterCommand(Config.Commands.vanish, function()
    TriggerServerEvent('nkhd_admin:requestAdmin', source)
    if isAdmin then
        local player = PlayerId()
        local ped = GetPlayerPed(-1)
    
        if IsPedInAnyVehicle(ped, false) then
            ped = GetVehiclePedIsIn(ped, false)
        end
    
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
            SetEntityInvincible(ped, false)
        else
            SetEntityVisible(ped, false)
            SetEntityInvincible(ped, true)
        end
    else
        if UseESXNotification == true then
            ESX.ShowNotification(_U('no_permission'))
        else
            ShowNotification(_U('no_permission'))
        end
    end
end, false)

RegisterCommand(Config.Commands.noclip, function()
    TriggerServerEvent('nkhd_admin:requestAdmin', source)
    if isAdmin then
        if isNoClip == false then 
            isNoClip = true
            SetNoClip(true)
            if UseESXNotification == true then
                ESX.ShowNotification(_U('noclip_on'))
            else
                ShowNotification(_U('noclip_on'))
            end
        elseif isNoClip == true then
            isNoClip = false
            SetNoClip(false)
            if UseESXNotification == true then
                ESX.ShowNotification(_U('noclip_off'))
            else
                ShowNotification(_U('noclip_off'))
            end
        end
    else
        if UseESXNotification == true then
            ESX.ShowNotification(_U('no_permission'))
        else
            ShowNotification(_U('no_permission'))
        end
    end
end, false)

-- Noclip

MOVE_UP_KEY = 20
MOVE_DOWN_KEY = 44
CHANGE_SPEED_KEY = 21
MOVE_LEFT_RIGHT = 30
MOVE_UP_DOWN = 31
NOCLIP_TOGGLE_KEY = 289
NO_CLIP_NORMAL_SPEED = 0.5
NO_CLIP_FAST_SPEED = 2.5
ENABLE_TOGGLE_NO_CLIP = true
ENABLE_NO_CLIP_SOUND = true

local eps = 0.01
local RESSOURCE_NAME = GetCurrentResourceName();

local isNoClipping = false
local playerPed = PlayerPedId()
local playerId = PlayerId()
local speed = NO_CLIP_NORMAL_SPEED
local input = vector3(0, 0, 0)
local previousVelocity = vector3(0, 0, 0)
local breakSpeed = 10.0;
local offset = vector3(0, 0, 1);

local noClippingEntity = playerPed;

function ToggleNoClipMode()
    return SetNoClip(not isNoClipping)
end

function IsControlAlwaysPressed(inputGroup, control) return IsControlPressed(inputGroup, control) or IsDisabledControlPressed(inputGroup, control) end

function IsControlAlwaysJustPressed(inputGroup, control) return IsControlJustPressed(inputGroup, control) or IsDisabledControlJustPressed(inputGroup, control) end

function Lerp (a, b, t) return a + (b - a) * t end

function IsPedDrivingVehicle(ped, veh)
    return ped == GetPedInVehicleSeat(veh, -1);
end

function SetInvincible(val, id)
    SetEntityInvincible(id, val)
    return SetPlayerInvincible(id, val)
end

function SetNoClip(val)

    if (isNoClipping ~= val) then

        noClippingEntity = playerPed;

        if IsPedInAnyVehicle(playerPed, false) then
            local veh = GetVehiclePedIsIn(playerPed, false);
            if IsPedDrivingVehicle(playerPed, veh) then
                noClippingEntity = veh;
            end
        end

        local isVeh = IsEntityAVehicle(noClippingEntity);

        isNoClipping = val;

        if ENABLE_NO_CLIP_SOUND then

            if isNoClipping then
                PlaySoundFromEntity(-1, "SELECT", playerPed, "HUD_LIQUOR_STORE_SOUNDSET", 0, 0)
            else
                PlaySoundFromEntity(-1, "CANCEL", playerPed, "HUD_LIQUOR_STORE_SOUNDSET", 0, 0)
            end

        end

        SetUserRadioControlEnabled(not isNoClipping);

        if (isNoClipping) then

            TriggerEvent('instructor:add-instruction', { MOVE_LEFT_RIGHT, MOVE_UP_DOWN }, "move", RESSOURCE_NAME);
            TriggerEvent('instructor:add-instruction', { MOVE_UP_KEY, MOVE_DOWN_KEY }, "move up/down", RESSOURCE_NAME);
            TriggerEvent('instructor:add-instruction', { 1, 2 }, "Turn", RESSOURCE_NAME);
            TriggerEvent('instructor:add-instruction', CHANGE_SPEED_KEY, "(hold) fast mode", RESSOURCE_NAME);
            TriggerEvent('instructor:add-instruction', NOCLIP_TOGGLE_KEY, "Toggle No-clip", RESSOURCE_NAME);
            SetEntityAlpha(noClippingEntity, 51, 0)

            Citizen.CreateThread(function()

                local clipped = noClippingEntity
                local pPed = playerPed;
                local isClippedVeh = isVeh;

                if isGodMode == false then
                    SetInvincible(true, clipped);
                else
                end

                if not isClippedVeh then
                    ClearPedTasksImmediately(pPed)
                end

                while isNoClipping do
                    Citizen.Wait(0);

                    FreezeEntityPosition(clipped, true);
                    SetEntityCollision(clipped, false, false);

                    SetEntityVisible(clipped, false, false);
                    SetLocalPlayerVisibleLocally(true);
                    SetEntityAlpha(clipped, 1, false)

                    SetEveryoneIgnorePlayer(pPed, true);
                    SetPoliceIgnorePlayer(pPed, true);

                    input = vector3(GetControlNormal(0, MOVE_LEFT_RIGHT), GetControlNormal(0, MOVE_UP_DOWN), (IsControlAlwaysPressed(1, MOVE_UP_KEY) and 1) or ((IsControlAlwaysPressed(1, MOVE_DOWN_KEY) and -1) or 0))
                    speed = ((IsControlAlwaysPressed(1, CHANGE_SPEED_KEY) and NO_CLIP_FAST_SPEED) or NO_CLIP_NORMAL_SPEED) * ((isClippedVeh and 2.75) or 1)

                    MoveInNoClip();

                end

                Citizen.Wait(0);

                FreezeEntityPosition(clipped, false);
                SetEntityCollision(clipped, true, true);

                SetEntityVisible(clipped, true, false);
                SetLocalPlayerVisibleLocally(true);
                ResetEntityAlpha(clipped);

                SetEveryoneIgnorePlayer(pPed, false);
                SetPoliceIgnorePlayer(pPed, false);
                ResetEntityAlpha(clipped);

                Citizen.Wait(500);

                if isClippedVeh then

                    while (not IsVehicleOnAllWheels(clipped)) and not isNoClipping do
                        Citizen.Wait(0);
                    end

                    while not isNoClipping do

                        Citizen.Wait(0);

                        if IsVehicleOnAllWheels(clipped) then

                            if isGodMode == false then
                                return SetInvincible(false, clipped);
                            else
                            end

                        end

                    end

                else

                    if (IsPedFalling(clipped) and math.abs(1 - GetEntityHeightAboveGround(clipped)) > eps) then
                        while (IsPedStopped(clipped) or not IsPedFalling(clipped)) and not isNoClipping do
                            Citizen.Wait(0);
                        end
                    end

                    while not isNoClipping do

                        Citizen.Wait(0);

                        if (not IsPedFalling(clipped)) and (not IsPedRagdoll(clipped)) then

                        if isGodMode == false then
                            return SetInvincible(false, clipped);
                        else
                        end

                        end

                    end

                end

            end)

        else
            ResetEntityAlpha(noClippingEntity)
            TriggerEvent('instructor:flush', RESSOURCE_NAME);
        end

    end

end

function MoveInNoClip()

    SetEntityRotation(noClippingEntity, GetGameplayCamRot(0), 0, false)
    local forward, right, up, c = GetEntityMatrix(noClippingEntity);
    previousVelocity = Lerp(previousVelocity, (((right * input.x * speed) + (up * -input.z * speed) + (forward * -input.y * speed))), Timestep() * breakSpeed);
    c = c + previousVelocity
    SetEntityCoords(noClippingEntity, c - offset, true, true, true, false)

end

AddEventHandler('playerSpawned', function()

    playerPed = PlayerPedId()
    playerId = PlayerId()

end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == RESSOURCE_NAME then
        SetNoClip(false);
        FreezeEntityPosition(noClippingEntity, false);
        SetEntityCollision(noClippingEntity, true, true);

        SetEntityVisible(noClippingEntity, true, false);
        SetLocalPlayerVisibleLocally(true);
        ResetEntityAlpha(noClippingEntity);

        SetEveryoneIgnorePlayer(playerPed, false);
        SetPoliceIgnorePlayer(playerPed, false);
        ResetEntityAlpha(noClippingEntity);
        SetInvincible(false, noClippingEntity);
    end
end)

local showBlips = false
local playerBlips = {}

RegisterCommand(Config.Commands.blips, function()
    TriggerServerEvent('nkhd_admin:requestAdmin', source)
    if isAdmin then
        showBlips = not showBlips
        if showBlips then
            if UseESXNotification == true then
                ESX.ShowNotification(_U('blips_on'), 1000, 'success')
            else
                ShowNotification(_U('blips_on'))
            end
            showAllPlayerBlips()
        else
            if UseESXNotification == true then
                ESX.ShowNotification(_U('blips_off'), 1000, 'success')
            else
                ShowNotification(_U('blips_off'))
            end
            removeAllPlayerBlips()
        end
    else
        if UseESXNotification == true then
            ESX.ShowNotification(_U('no_permission'))
        else
            ShowNotification(_U('no_permission'))
        end
    end
end, false)


function showAllPlayerBlips()
    Citizen.CreateThread(function()
        while showBlips do
            ESX.TriggerServerCallback('esx_blips:getPlayerInfo', function(playerInfo)
                local playerId = PlayerId()
                local serverId = GetPlayerServerId(playerId)
                for id, info in pairs(playerInfo) do
                    if id ~= serverId then
                        if not playerBlips[id] then
                            local blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
                            SetBlipSprite(blip, 1)
                            ShowHeadingIndicatorOnBlip(blip, true)
                            SetBlipScale(blip, 0.85)
                            SetBlipColour(blip, 0)
                            SetBlipAsShortRange(blip, false)

                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString(info.name)
                            EndTextCommandSetBlipName(blip)

                            playerBlips[id] = blip
                        else
                            local blip = playerBlips[id]
                            SetBlipCoords(blip, info.coords.x, info.coords.y, info.coords.z)
                            SetBlipRotation(blip, math.floor(info.heading))
                        end
                    end
                end
            end)
            Citizen.Wait(Config.BlipsRefreshTime)
        end
        removeAllPlayerBlips()
    end)
end

function removeAllPlayerBlips()
    for id, blip in pairs(playerBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    playerBlips = {}
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end