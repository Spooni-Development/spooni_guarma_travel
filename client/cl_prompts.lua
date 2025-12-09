function initializeGuarmaPrompt()
    local str = Translation[Config.Locale]['prompt_guarma']
    guarmaPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(guarmaPrompt, Config.Key)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    UiPromptSetText(guarmaPrompt, str)
    UiPromptSetEnabled(guarmaPrompt, 1)
    UiPromptSetVisible(guarmaPrompt, 1)
    UiPromptSetStandardMode(guarmaPrompt, 1)
    UiPromptSetGroup(guarmaPrompt, promptGroupGuarma)
    UiPromptSetUrgentPulsingEnabled(guarmaPrompt, true)
    UiPromptRegisterEnd(guarmaPrompt)
    Debug('Guarma prompt initialized')
end

function initializeMainlandPrompt()
    local str = Translation[Config.Locale]['prompt_mainland']
    mainlandPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(mainlandPrompt, Config.Key)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    UiPromptSetText(mainlandPrompt, str)
    UiPromptSetEnabled(mainlandPrompt, 1)
    UiPromptSetVisible(mainlandPrompt, 1)
    UiPromptSetStandardMode(mainlandPrompt, 1)
    UiPromptSetGroup(mainlandPrompt, promptGroupMainland)
    UiPromptSetUrgentPulsingEnabled(mainlandPrompt, true)
    UiPromptRegisterEnd(mainlandPrompt)
    Debug('Mainland prompt initialized')
end

function showTeleportPrompt(teleporter, destinationId)
    local priceDisplay = formatPrice(teleporter.price)
    local label = CreateVarString(10, 'LITERAL_STRING', teleporter.name .. ' - ' .. priceDisplay)
    UiPromptSetActiveGroupThisFrame(destinationId == 'guarma' and promptGroupGuarma or promptGroupMainland, label)
end