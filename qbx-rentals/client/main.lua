local tabletProp = "prop_cs_tablet"
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)
local isOpen = false
local Renting = false
local rentVehicle = nil
local pedspawned = false
local entity = nil

local QBX = exports['qbx_core']

local function hideTextUI()
    -- Implement logic to hide text UI
end

local function showTextUI(text, options)
    -- Default options
    local defaultOptions = {
        position = 'right-center',
        alignIcon = 'center'
    }

    -- Merge default options with provided options
    options = options or {}
    for key, value in pairs(defaultOptions) do
        if options[key] == nil then
            options[key] = value
        end
    end

    -- Implement logic to show text UI with provided options
end

QBX.RegisterUsableItem("tablet", function(source, item)
    local Player = QBX.PlayerData(source)
    TriggerClientEvent('qb-rentals:client:menu', source)
end)

RegisterNUICallback('rentvehicle', function(data, cb)
    cb(true)
    TriggerEvent("qb-rentals:client:rent", data.vehicleType, data.vehiclePrice)
end)

RegisterNetEvent("qb-rentals:client:rent")
AddEventHandler("qb-rentals:client:rent", function(vehicle, price)
    if Renting then
        EnableGUI(false)
        QBX.Notify(Config.Notify.alreadyrenting)
    else
        TriggerEvent("qb-rentals:client:rentvehicle", price, vehicle)
    end
end)

RegisterNetEvent("qb-rentals:client:rentvehicle")
AddEventHandler("qb-rentals:client:rentvehicle", function(price, vehicle)
    TriggerEvent("qb-rentals:closenui")
    local rentalTime = exports['qb-input']:ShowInput({
        header = "Choose Renting Time",
        submitText = "Submit",
        inputs = {
            {
                type = "select",
                name = "time",
                text = "",
                options = {
                    { value = 1, text = "1 Minute" },
                    { value = 5, text = "5 Minutes"},
                    { value = 10, text = "10 Minutes" },
                    { value = 15, text = "15 Minutes" },
                    { value = 30, text = "30 Minutes" },
                    { value = 60, text = "60 Minutes" },
                },
            }
        }
    })
    TriggerServerEvent("qb-rentals:server:rent", price, vehicle, rentalTime.time)
end)

RegisterNetEvent('qb-rentals:nomoney')
AddEventHandler('qb-rentals:nomoney', function()
    noMoney(true)
end)

RegisterNetEvent('qb-rentals:closenui')
AddEventHandler('qb-rentals:closenui', function()
    EnableGUI(false)
end)

RegisterNetEvent('qb-rentals:client:returnvehicle')
AddEventHandler('qb-rentals:client:returnvehicle', function()
    local veh = GetPlayersLastVehicle(PlayerPedId())
    if Renting then
        if veh == rentVehicle then
            local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(veh))
            if distance <= 5 then
                rentVehicle = 0
                Renting = false
                QBX.DeleteVehicle(veh)
                StopRentalCountdown()
                QBX.Notify(Config.Notify.returned)
            else
                QBX.Notify(Config.Notify.tofar)
            end
        else
            QBX.Notify(Config.Notify.wrongvehicle)
        end
    else
        QBX.Notify(Config.Notify.notrenting)
    end
end)
