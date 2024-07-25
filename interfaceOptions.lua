-- Create the Interface Options.

local thisAddonName, namespace = ...

local handleSettingChanged = function(_, setting, value)
    _G["AutoCombatLogEnabledDifficultyIds"][setting['difficultyId']] = value or nil
    namespace.updateLogging()
end

local category = Settings.RegisterVerticalLayoutCategory(thisAddonName)

for _, difficultyInfo in ipairs(namespace.instanceDifficulties) do
    local variable = thisAddonName .. '_' .. difficultyInfo['id']
    local setting = Settings.RegisterAddOnSetting(
                                            category,
                                            difficultyInfo['name'],
                                            variable,
                                            type(true),
                                            difficultyInfo['default'] or false)
    setting['difficultyId'] = difficultyInfo['id']
    Settings.CreateCheckbox(category, setting)
    Settings.SetOnValueChangedCallback(variable, handleSettingChanged)
end

Settings.RegisterAddOnCategory(category)
