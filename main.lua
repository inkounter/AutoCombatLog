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

    ["_UPDATE_INSTANCE_INFO"] = function(self)
        -- Check the current instance difficulty and enable or disable combat
        -- logging accordingly.  Note that this handles the
        -- "UPDATE_INSTANCE_INFO" event.

        local difficultyId = select(3, GetInstanceInfo())
        if namespace.enabledDifficultyIds[difficultyId] then
            self:_enableLogging()
        else
            self:_disableLogging()
        end
    end,

    ["_ADDON_LOADED"] = function(self, addonName)
        -- If the specified 'addonName' is the name of this addon, then stop
        -- listening for "ADDON_LOADED" events, load the saved variable, and
        -- re-execute the enablement/disablement of combat logging.  Otherwise,
        -- if 'addonName' is not the name of this addon, do nothing.

        if addonName ~= thisAddonName then
            return
        end

        self:UnregisterEvent("ADDON_LOADED")

        local config = _G["AutoCombatLogEnabledDifficultyIds"]
        if config ~= nil then
            namespace.enabledDifficultyIds = config
        end

        self:_UPDATE_INSTANCE_INFO()
    end,

    ["registerEvents"] = function(self)
        -- Invoke methods from the 'Frame' mixin to listen for API events and
        -- to match those events to callbacks.

        self:RegisterEvent("UPDATE_INSTANCE_INFO")
        self:RegisterEvent("ADDON_LOADED")

        self:SetScript("OnEvent",
                       function(self, event, ...) self["_" .. event](self, ...) end)
    end,
}

local frame = CreateFrame("Frame")
Mixin(frame, CombatLoggerMixin)

frame:registerEvents()
