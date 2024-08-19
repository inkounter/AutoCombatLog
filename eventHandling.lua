-- Define and attach event handlers.

local thisAddonName, namespace = ...

local logMessage = function(message)
    -- Log the specified 'message' with an addon-specific prefix.

    print(string.format("|cFF5555BB%s:|r %s", thisAddonName, message))
end

local CombatLoggerMixin = {
    ["_loggingEnabled"] = false,

    ["_enableLogging"] = function(self)
        -- If combat logging is not already enabled, print a message and enable
        -- it.  Otherwise, do nothing.

        if self._loggingEnabled then
            return
        end

        self._loggingEnabled = true
        logMessage("|cFF00FF00ENABLING|r combat logging.")
        LoggingCombat(true)
    end,

    ["_disableLogging"] = function(self)
        -- If combat logging is not already disabled, print a message and
        -- disable it.  Otherwise, do nothing.

        if not self._loggingEnabled then
            return
        end

        self._loggingEnabled = false
        logMessage("|cFFFF0000DISABLING|r combat logging.")
        LoggingCombat(false)
    end,

    ["_registerOptions"] = function(self)
        local category = Settings.RegisterVerticalLayoutCategory(thisAddonName)

        for _, difficultyInfo in ipairs(namespace.instanceDifficulties) do
            local variable = thisAddonName .. '_' .. difficultyInfo['id']
            local setting = Settings.RegisterAddOnSetting(
                                       category,
                                       variable,
                                       difficultyInfo['id'],
                                       _G["AutoCombatLogEnabledDifficultyIds"],
                                       type(true),
                                       difficultyInfo['name'],
                                       difficultyInfo['default'] or false)
            setting['difficultyId'] = difficultyInfo['Id']
            setting:SetValueChangedCallback(function() self:update() end)
            Settings.CreateCheckbox(category, setting)
        end

        Settings.RegisterAddOnCategory(category)
    end,

    ["update"] = function(self)
        -- Check the current instance difficulty and enable or disable combat
        -- logging accordingly.  Note that this handles the
        -- "UPDATE_INSTANCE_INFO" event.

        local difficultyId = select(3, GetInstanceInfo())
        local enabledDifficultyIds = _G["AutoCombatLogEnabledDifficultyIds"] or {}
        if enabledDifficultyIds[difficultyId] then
            self:_enableLogging()
        else
            self:_disableLogging()
        end
    end,

    ["_ADDON_LOADED"] = function(self, addonName)
        -- If the specified 'addonName' is the name of this addon, then stop
        -- listening for "ADDON_LOADED" events and re-execute the
        -- enablement/disablement of combat logging.  Otherwise, if 'addonName'
        -- is not the name of this addon, do nothing.

        if addonName ~= thisAddonName then
            return
        end

        self:UnregisterEvent("ADDON_LOADED")
        self:_registerOptions()
        self:update()
    end,

    ["_UPDATE_INSTANCE_INFO"] = function(self)
        return self:update()
    end,

    ["_PLAYER_DIFFICULTY_CHANGED"] = function(self)
        return self:update()
    end,

    ["registerEvents"] = function(self)
        -- Invoke methods from the 'Frame' mixin to listen for API events and
        -- to match those events to callbacks.

        -- "UPDATE_INSTANCE_INFO" is fired upon entering or leaving an
        -- instance.  "PLAYER_DIFFICULTY_CHANGED" is fired upon starting a
        -- keystone.

        self:RegisterEvent("UPDATE_INSTANCE_INFO")
        self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")

        self:RegisterEvent("ADDON_LOADED")

        self:SetScript("OnEvent",
                       function(self, event, ...) self["_" .. event](self, ...) end)
    end,
}

local frame = CreateFrame("Frame")
Mixin(frame, CombatLoggerMixin)

frame:registerEvents()
