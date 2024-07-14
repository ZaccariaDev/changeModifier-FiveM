local txt = "^3changeModifier ^0by ^2XPertise^0"
ESX = exports["es_extended"]:getSharedObject()
local modifiers = nil
local currentModifierIndex = 1
local defaultModifier = "default"
local modifierActive = false
local commandTrigger = false
local modifier = nil
local strength = 0.8 -- Par défaut

SetTimecycleModifier(defaultModifier)

-- Demande au serveur le fichier JSON
Citizen.CreateThread(function()
    TriggerServerEvent('changeModifiers:requestModifiers')
end)

RegisterNetEvent('changeModifiers:receiveModifiers')
AddEventHandler('changeModifiers:receiveModifiers', function(receivedModifiers)
    modifiers = receivedModifiers
    print("Modificateurs reçus")
    modifier = modifiers[currentModifierIndex]
    print(modifier)
end)

function ShowAsST(time, text)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

function handleTimecycleModifier(modify)
    if not modifiers then
        print("Modificateurs non chargés")
        return
    end

    if modify then
        for i, v in ipairs(modifiers) do
            if v == modify then
                currentModifierIndex = i
                modifier = modify -- Déplacer ici
                break
            end
        end
    else
        modifier = modifiers[currentModifierIndex]
    end
    
    SetTimecycleModifier(modifier)
    SetTimecycleModifierStrength(strength)
end

Citizen.CreateThread(function()
    
    local wait = 0
    while not modifier do
    Citizen.Wait(wait)
    end
    print(`^5modifier prêt^3`)
    while true do
        Citizen.Wait(wait)
        if commandTrigger then
            local text = tostring("~y~← ~g~" .. modifier .. " ~y~→")
            ShowAsST(1, text)
           wait = 1
        else
            wait = 100
        end
        if modifierActive then          
            if IsControlJustPressed(1, 174) or IsControlJustPressed(1, 52) then -- Gauche
                currentModifierIndex = (currentModifierIndex - 2) % #modifiers + 1
                modifier = modifiers[currentModifierIndex]
                print("fleche gauche")
                SetTimecycleModifier(modifier)
                text ="~y~← ~g~" .. modifier .. " ~y~→"
                ShowAsST(200, text)
                wait = 200
            elseif IsControlJustPressed(1, 175) or IsControlJustPressed(1, 51) then -- Droite
                currentModifierIndex = currentModifierIndex % #modifiers + 1
                modifier = modifiers[currentModifierIndex]
                print("fleche Droite")
                SetTimecycleModifier(modifier)
                text = "~y~← ~g~" .. modifier .. " ~y~→"
                ShowAsST(200, text)
                wait = 200
            elseif IsControlJustPressed(1, 201) then -- Entrée
                print("Entree")
                text = tostring("~g~Modificateur sélectionné: ~y~" .. modifier)
                ShowAsST(2000, text)
                wait = 2000
                modifierActive = false
                commandTrigger = false
            elseif IsControlJustPressed(1, 177) then -- Retour arrière
                SetTimecycleModifier(defaultModifier)
                print("annuler")
                text = tostring("~r~Modificateur réinitialisé à: ~y~" .. defaultModifier)
                ShowAsST(2000, text)
                wait = 2000
                modifierActive = false
                commandTrigger = false
            end
        end
    end
end)

local function removeColorCodes(text)
    return text:gsub("%^%d", "")
end

local function centeredPrint(text)
    local resourceName = GetCurrentResourceName()
    local prefix = "script:" .. resourceName .. " "
    local totalLength = 205
    local plainText = removeColorCodes(text)
    local textLength = #plainText
    local prefixLength = #prefix
    local remainingLength = totalLength - prefixLength
    local padding = math.floor((remainingLength - textLength) / 2)
    local leftPadding = string.rep("-", padding)
    local rightPadding = string.rep("-", padding)
    print(leftPadding .. text .. rightPadding)
end

RegisterCommand('changemodifier', function(source, args, rawCommand)
    if #args == 0 then
        local notifications = {
            "~y~Le saviez-vous ? ~w~changeModifier a été codé par l'équipe ~b~XPertise~w~, retrouvez-les sur disboard.",
            "~y~Le saviez-vous ? ~w~changeModifier inclut plusieurs paramètres, utilisez ~g~/changemodifier -i~w~ pour en savoir plus.",
            "~y~Le saviez-vous ? ~w~Les abeilles communiquent en dansant.",
            "~y~Les saviez-vous ? ~w~le strength défini par défaut est de ~r~0.8",
            "~y~Le saviez-vous ? ~w~ZaccariaDev a écrit ce script pendant une pause café."
        }
        local randomNotification = notifications[math.random(#notifications)]
        ESX.ShowNotification(randomNotification)
    end

    local inputModifier = nil
    for i = 1, #args do
        if args[i] == '--strength' or args[i] == '-s' then
            strength = tonumber(args[i + 1]) or 0.8
        elseif args[i] == '--default' or args[i] == '-d' then
            modifier = defaultModifier
            SetTimecycleModifier(defaultModifier)
            SetTimecycleModifierStrength(strength)
            return
        elseif args[i] == '--info' or args[i] == '-i' then
            local info = [[
                ^2Commandes disponibles :
                ^3/changemodifier [modifier] --strength [force] -s [force] --default -d --info -i^7 : Change le modificateur de cycle de temps.
                ^3--strength, -s^7 : Définit la force du modificateur (par défaut : 0.8).
                ^3--default, -d^7 : Réinitialise le modificateur au paramètre par défaut.
                ^3--info, -i^7 : Affiche les informations sur les commandes disponibles.
        
                ^2Touches disponibles :
                ^3Utilisez les flèches gauche et droite ou les touches A et E pour naviguer entre les modificateurs.
                ^3Appuyez sur Entrée pour sélectionner le modificateur.
                ^3Appuyez sur Retour arrière pour réinitialiser au modificateur par défaut.
            ]]
            centeredPrint(txt)
            centeredPrint("^2Informations sur les commandes^0")
            print(info)
            TriggerEvent('chat:addMessage', { args = { '~r~Tout est print dans le F8' } })
            ESX.ShowNotification('~g~Tout est print dans le F8')
            return
        else
            inputModifier = args[i]
        end
    end

    if inputModifier then
        modifier = inputModifier
    end
    handleTimecycleModifier(modifier)
    Citizen.Wait(100)
    commandTrigger = not commandTrigger
    modifierActive = true
end, false)

RegisterNetEvent('changeModifier:applyModifier')
AddEventHandler('changeModifier:applyModifier', function(modifier, handle)
    if tonumber(handle) then
        strength = handle
    end
    if modifier then
        handleTimecycleModifier(modifier)
    end
end)