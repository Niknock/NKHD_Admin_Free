ESX = nil

if Config.ESX == 'old' then
     TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif Config.ESX == 'new' then
    ESX = exports["es_extended"]:getSharedObject()
else
    print('Wrong ESX Type!')
end

AddEventHandler('esx:playerLoaded', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer ~= nil then
        if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
            TriggerClientEvent('nkhd_admin:setAdmin', source, true)
        else
            TriggerClientEvent('nkhd_admin:setAdmin', source, false)
        end
    else
    end
end)

RegisterServerEvent('nkhd_admin:requestAdmin')
AddEventHandler('nkhd_admin:requestAdmin', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer ~= nil then
        if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
            TriggerClientEvent('nkhd_admin:setAdmin', source, true)
        else
            TriggerClientEvent('nkhd_admin:setAdmin', source, false)
        end
    else
    end
end)

SetConvarServerInfo("Admin Script:", "NKHD Admin Free")

ESX.RegisterServerCallback('nkhd_admin:getPlayerInfo', function(source, cb)
    local players = ESX.GetPlayers()
    local playerInfo = {}

    for i = 1, #players do
        local xPlayer = ESX.GetPlayerFromId(players[i])
        if xPlayer then
            local ped = GetPlayerPed(players[i])
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local name = GetPlayerName(players[i])
            playerInfo[players[i]] = {id = players[i], coords = coords, heading = heading, name = name}
        end
    end

    cb(playerInfo)
end)