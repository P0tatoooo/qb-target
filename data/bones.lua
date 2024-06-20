local Bones = {Options = {}, Vehicle = {'chassis', 'windscreen', 'seat_pside_r', 'seat_dside_r', 'bodyshell', 'suspension_lm', 'suspension_lr', 'platelight', 'attach_female', 'attach_male', 'bonnet', 'boot', 'chassis_dummy', 'chassis_Control', 'door_dside_f', 'door_dside_r', 'door_pside_f', 'door_pside_r', 'Gun_GripR', 'windscreen_f', 'platelight', 'VFX_Emitter', 'window_lf', 'window_lr', 'window_rf', 'window_rr', 'engine', 'gun_ammo', 'ROPE_ATTATCH', 'wheel_lf', 'wheel_lr', 'wheel_rf', 'wheel_rr', 'exhaust', 'overheat', 'seat_dside_f', 'seat_pside_f', 'Gun_Nuzzle', 'seat_r'}}
QBCore = exports['qb-core']:GetCoreObject()

if Config.EnableDefaultOptions then
    local BackEngineVehicles = {
        [`ninef`] = true,
        [`adder`] = true,
        [`vagner`] = true,
        [`t20`] = true,
        [`infernus`] = true,
        [`zentorno`] = true,
        [`reaper`] = true,
        [`comet2`] = true,
        [`comet3`] = true,
        [`jester`] = true,
        [`jester2`] = true,
        [`cheetah`] = true,
        [`cheetah2`] = true,
        [`prototipo`] = true,
        [`turismor`] = true,
        [`pfister811`] = true,
        [`ardent`] = true,
        [`nero`] = true,
        [`nero2`] = true,
        [`tempesta`] = true,
        [`vacca`] = true,
        [`bullet`] = true,
        [`osiris`] = true,
        [`entityxf`] = true,
        [`turismo2`] = true,
        [`fmj`] = true,
        [`re7b`] = true,
        [`tyrus`] = true,
        [`italigtb`] = true,
        [`penetrator`] = true,
        [`monroe`] = true,
        [`ninef2`] = true,
        [`stingergt`] = true,
        [`surfer`] = true,
        [`surfer2`] = true,
        [`gp1`] = true,
        [`autarch`] = true,
        [`tyrant`] = true
    }

    local vehicleClasses = {
        [0] = true,
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true,
        [5] = true,
        [6] = true,
        [7] = true,
        [8] = true,
        [9] = true,
        [10] = true,
        [11] = true,
        [12] = true,
        [13] = false,
        [14] = false,
        [15] = false,
        [16] = false,
        [17] = true,
        [18] = true,
        [19] = true,
        [20] = true,
        [21] = false
    }

    local function ToggleDoor(vehicle, door)
        local driverPed = GetPedInVehicleSeat(vehicle, -1)
        if not driverPed or driverPed == PlayerPedId() or not IsPedAPlayer(driverPed) then
            if GetVehicleDoorLockStatus(vehicle) < 2 then
                if GetVehicleDoorAngleRatio(vehicle, door) > 0.0 then
                    SetVehicleDoorShut(vehicle, door, false)
                else
                    SetVehicleDoorOpen(vehicle, door, false)
                end
            end
        else
            TriggerServerEvent('MyCity_CoreV2:VehicleUtils:SyncDoorSv', GetPlayerServerId(NetworkGetPlayerIndexFromPed(driverPed)), door)
        end
    end

    Bones.Options['seat_dside_f'] = {
        ["Ouvrir/Fermer la porte conducteur"] = {
            icon = "fas fa-door-open",
            label = "Ouvrir/Fermer la porte conducteur",
            canInteract = function(entity)
                if GetVehicleDoorLockStatus(entity) > 1 then return false end
                return GetEntityBoneIndexByName(entity, 'door_dside_f') ~= -1
            end,
            action = function(entity)
                ToggleDoor(entity, 0)
            end,
            distance = 1.5
        },
        ["Utiliser la radio"] = {
            icon = "fas fa-radio",
            label = "Utiliser la radio",
            canInteract = function(entity)
                return GetVehiclePedIsIn(PlayerPedId()) == entity
            end,
            action = function(entity)
                ExecuteCommand('carradio')
            end,
            distance = 1.5
        },
        ["Ouvrir/Fermer le capot"] = {
            icon = "fas fa-truck-ramp-box",
            label = "Ouvrir/Fermer le capot",
            action = function(entity)
                ToggleDoor(entity, BackEngineVehicles[GetEntityModel(entity)] and 5 or 4)
            end,
            canInteract = function(entity)
                return GetVehiclePedIsIn(PlayerPedId()) == entity
            end,
            distance = 1.5
        },
        ["Ouvrir/Fermer le coffre"] = {
            icon = "fas fa-truck-ramp-box",
            label = "Ouvrir/Fermer le coffre",
            action = function(entity)
                ToggleDoor(entity, BackEngineVehicles[GetEntityModel(entity)] and 4 or 5)
            end,
            canInteract = function(entity)
                return GetVehiclePedIsIn(PlayerPedId()) == entity
            end,
            distance = 1.5
        },
        ["Activer le mode drift"] = {
            icon = "fa-solid fa-car",
            label = "Activer le mode drift",
            canInteract = function(entity)
                return GetVehiclePedIsIn(PlayerPedId()) == entity and not GetDriftTyresEnabled(entity) and vehicleClasses[GetEntityModel(entity)]
            end,
            action = function(entity)
                SetDriftTyresEnabled(entity, true)
                SetVehicleEngineOn(entity, true, false)
            end,
            distance = 1.5
        },
        ["Désactiver le mode drift"] = {
            icon = "fa-solid fa-car",
            label = "Désactiver le mode drift",
            canInteract = function(entity)
                return GetVehiclePedIsIn(PlayerPedId()) == entity and GetDriftTyresEnabled(entity)
            end,
            action = function(entity)
                SetDriftTyresEnabled(entity, false)
                SetVehicleEngineOn(entity, true, false)
            end,
            distance = 1.5
        },
        ["Sortir la personne du véhicule"] = {
            icon = "fas fa-door-open",
            label = "Sortir la personne du véhicule",
            job = {police = 0, ambulance = 0},
            canInteract = function(entity)
                if GetVehicleDoorLockStatus(entity) > 1 then return false end
                return IsPedOnFoot(PlayerPedId()) and not IsVehicleSeatFree(entity, -1)
            end,
            action = function(entity)
                TriggerServerEvent('police:server:SetPlayerOutVehicle', GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(entity, -1))))
            end,
            distance = 1.5
        },
        ["Crocheter le véhicule"] = {
            icon = "fas fa-door-open",
            label = "Crocheter le véhicule",
            job = {police = 0},
            canInteract = function(entity)
                if GetVehicleDoorLockStatus(entity) ~= 2 and GetVehicleDoorLockStatus(entity) ~= 7 then return false end
                return IsPedOnFoot(PlayerPedId())
            end,
            action = function(entity)
                TriggerEvent('MyCity_CoreV2:Police:UnlockVehicle', entity)
            end,
            distance = 1.5
        },
        ["Utiliser la radio LSPD"] = {
            icon = "fas fa-radio",
            label = "Utiliser la radio LSPD",
            job = 'police',
            canInteract = function(entity)
                return GetVehiclePedIsIn(PlayerPedId()) == entity and GetVehicleClass(entity) == 18
            end,
            action = function(entity)
                TriggerEvent('MyCity_VehicleRadio:ToggleRadio')
            end,
            distance = 1.5
        },
        ["Prendre les appels de la centrale MyTaxis"] = {
            icon = "fas fa-radio",
            label = "Prendre les appels de la centrale MyTaxis",
            job = 'taxi',
            canInteract = function(entity)
                return GetVehiclePedIsIn(PlayerPedId()) == entity and GetEntityModel(entity) == `streitertaxi`
            end,
            action = function(entity)
                TriggerEvent('MyCity_Jobs:Taxi:startNpcJob')
            end,
            distance = 1.5
        },
        ["Gérer les clés du véhicule"] = {
            icon = "fas fa-key",
            label = "Gérer les clés du véhicule",
            canInteract = function(entity)
                if GetVehicleDoorLockStatus(entity) > 1 then return false end
                return QBCore.Functions.GetPlayerData().citizenid == Entity(entity).state.owner
            end,
            action = function(entity)
                TriggerEvent('MyCity_CoreV2:VehicleLock:OpenVehicleKeysMenu', {entity = entity})
            end,
            distance = 1.5
        },
    }

    Bones.Options['seat_pside_f'] = {
        ["Ouvrir/Fermer la porte avant droite"] = {
            icon = "fas fa-door-open",
            label = "Ouvrir/Fermer la porte avant droite",
            canInteract = function(entity)
                if GetVehicleDoorLockStatus(entity) > 1 then return false end
                return GetEntityBoneIndexByName(entity, 'door_pside_f') ~= -1
            end,
            action = function(entity)
                ToggleDoor(entity, 1)
            end,
            distance = 1.5
        },
        ["Utiliser la radio"] = {
            icon = "fas fa-radio",
            label = "Utiliser la radio",
            canInteract = function(entity)
                return GetVehiclePedIsIn(PlayerPedId()) == entity
            end,
            action = function(entity)
                ExecuteCommand('carradio')
            end,
            distance = 1.5
        },
        ["Sortir la personne du véhicule"] = {
            icon = "fas fa-door-open",
            label = "Sortir la personne du véhicule",
            job = {police = 0, ambulance = 0},
            canInteract = function(entity)
                if GetVehicleDoorLockStatus(entity) > 1 then return false end
                return IsPedOnFoot(PlayerPedId()) and not IsVehicleSeatFree(entity, 0)
            end,
            action = function(entity)
                TriggerServerEvent('police:server:SetPlayerOutVehicle', GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(entity, 0))))
            end,
            distance = 1.5
        },
        ["Utiliser la radio LSPD"] = {
            icon = "fas fa-radio",
            label = "Utiliser la radio LSPD",
            job = 'police',
            canInteract = function(entity)
                return GetVehiclePedIsIn(PlayerPedId()) == entity and GetVehicleClass(entity) == 18
            end,
            action = function(entity)
                TriggerEvent('MyCity_VehicleRadio:ToggleRadio')
            end,
            distance = 1.5
        },
    }

    Bones.Options['seat_dside_r'] = {
        ["Ouvrir/Fermer la porte arrière gauche"] = {
            icon = "fas fa-door-open",
            label = "Ouvrir/Fermer la porte arrière gauche",
            canInteract = function(entity)
                if GetVehicleDoorLockStatus(entity) > 1 then return false end
                return GetEntityBoneIndexByName(entity, 'door_dside_r') ~= -1
            end,
            action = function(entity)
                ToggleDoor(entity, 2)
            end,
            distance = 1.5
        },
        ["Utiliser la radio"] = {
            icon = "fas fa-radio",
            label = "Utiliser la radio",
            canInteract = function(entity)
                return GetVehiclePedIsIn(PlayerPedId()) == entity
            end,
            action = function(entity)
                ExecuteCommand('carradio')
            end,
            distance = 1.5
        },
        ["Sortir la personne du véhicule"] = {
            icon = "fas fa-door-open",
            label = "Sortir la personne du véhicule",
            job = {police = 0, ambulance = 0},
            canInteract = function(entity)
                if GetVehicleDoorLockStatus(entity) > 1 then return false end
                return IsPedOnFoot(PlayerPedId()) and not IsVehicleSeatFree(entity, 1)
            end,
            action = function(entity)
                TriggerServerEvent('police:server:SetPlayerOutVehicle', GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(entity, 1))))
            end,
            distance = 1.5
        },
    }

    Bones.Options['seat_pside_r'] = {
        ["Ouvrir/Fermer la porte arrière droite"] = {
            icon = "fas fa-door-open",
            label = "Ouvrir/Fermer la porte arrière droite",
            canInteract = function(entity)
                if GetVehicleDoorLockStatus(entity) > 1 then return false end
                return GetEntityBoneIndexByName(entity, 'door_pside_r') ~= -1
            end,
            action = function(entity)
                ToggleDoor(entity, 3)
            end,
            distance = 1.5
        },
        ["Utiliser la radio"] = {
            icon = "fas fa-radio",
            label = "Utiliser la radio",
            canInteract = function(entity)
                return GetEntityBoneIndexByName(entity, 'door_pside_r') ~= -1 and GetVehiclePedIsIn(PlayerPedId()) == entity
            end,
            action = function(entity)
                ExecuteCommand('carradio')
            end,
            distance = 1.5
        },
        ["Sortir la personne du véhicule"] = {
            icon = "fas fa-door-open",
            label = "Sortir la personne du véhicule",
            job = {police = 0, ambulance = 0},
            canInteract = function(entity)
                if GetVehicleDoorLockStatus(entity) > 1 then return false end
                return IsPedOnFoot(PlayerPedId()) and not IsVehicleSeatFree(entity, 2)
            end,
            action = function(entity)
                TriggerServerEvent('police:server:SetPlayerOutVehicle', GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(entity, 2))))
            end,
            distance = 1.5
        },
    }

    Bones.Options['overheat'] = {
        ["Ouvrir/Fermer le capot"] = {
            icon = "fas fa-hands",
            label = "Ouvrir/Fermer le capot",
            action = function(entity)
                ToggleDoor(entity, BackEngineVehicles[GetEntityModel(entity)] and 5 or 4)
            end,
            canInteract = function(entity)
                if GetVehicleDoorLockStatus(entity) > 1 then return false end
                return IsPedOnFoot(PlayerPedId())
            end,
            distance = 1.5
        },
        ["Pousser le véhicule"] = {
            icon = "fas fa-hands",
            label = "Pousser le véhicule",
            action = function(entity)
                TriggerEvent('vehiclepush:client:push', entity)
            end,
            canInteract = function(entity)
                return IsPedOnFoot(PlayerPedId()) and not Entity(entity).state.clamped
            end,
            distance = 1.5
        }
    }

    Bones.Options['boot'] = {
        ["Accéder au coffre"] = {
            icon = "fas fa-truck-ramp-box",
            label = "Accéder au coffre",
            action = function(entity)
                exports.ox_inventory:OpenTrunk(entity)
            end,
            canInteract = function(entity)
                if GetVehicleDoorLockStatus(entity) > 1 then return false end
                return IsPedOnFoot(PlayerPedId())
            end,
            distance = 1.5
        },
        ["Ouvrir/Fermer le coffre"] = {
            icon = "fas fa-truck-ramp-box",
            label = "Ouvrir/Fermer le coffre",
            action = function(entity)
                ToggleDoor(entity, BackEngineVehicles[GetEntityModel(entity)] and 4 or 5)
            end,
            canInteract = function(entity)
                if GetVehicleDoorLockStatus(entity) > 1 then return false end
                return IsPedOnFoot(PlayerPedId())
            end,
            distance = 1.5
        },
        ["Pousser le véhicule"] = {
            icon = "fas fa-hands",
            label = "Pousser le véhicule",
            action = function(entity)
                TriggerEvent('vehiclepush:client:push', entity)
            end,
            canInteract = function(entity)
                return IsPedOnFoot(PlayerPedId()) and not Entity(entity).state.clamped
            end,
            distance = 1.5
        }
    }
end

return Bones