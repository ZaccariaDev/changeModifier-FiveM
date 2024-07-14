local modifiersFile = LoadResourceFile(GetCurrentResourceName(), "timecycle_modifiers.json")

RegisterNetEvent('changeModifiers:requestModifiers')
AddEventHandler('changeModifiers:requestModifiers', function()
    local src = source
    
    if not modifiersFile then
        modifiersFile = LoadResourceFile(GetCurrentResourceName(), "timecycle_modifiers.json")
        if not modifiersFile then
            print("Erreur: Impossible de charger le fichier timecycle_modifiers.json")
            return
        end
    end

    local modifiers = json.decode(modifiersFile)
    if not modifiers then
        print("Erreur: Impossible de décoder le contenu du fichier JSON")
        return
    end

    TriggerClientEvent('changeModifiers:receiveModifiers', src, modifiers)
end)