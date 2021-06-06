local thisAddonName, namespace = ...

local logMessage = function(message)
    -- Log the specified 'message' with an addon-specific prefix.

    print(string.format("|cFF5555BB%s:|r %s", thisAddonName, message))
end

local defaultEnabledDifficultyIds = {
    [8] = true,     -- Mythic Keystone
    [15] = true,    -- Heroic Raid
    [16] = true,    -- Mythic Raid
    [23] = true,    -- Mythic Dungeon
}

local enabledDifficultyIds = defaultEnabledDifficultyIds

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
        if enabledDifficultyIds[difficultyId] then
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

        enabledDifficultyIds = _G["AutoCombatLogEnabledDifficultyIds"] or defaultEnabledDifficultyIds

        DevTools_Dump(enabledDifficultyIds)

        self:_UPDATE_INSTANCE_INFO()
    end,

    ["_registerEvents"] = function(self)
        -- Invoke methods from the 'Frame' mixin to listen for API events and
        -- to match those events to callbacks.

        self:RegisterEvent("UPDATE_INSTANCE_INFO")
        self:RegisterEvent("ADDON_LOADED")

        self:SetScript("OnEvent",
                       function(self, event, ...) self["_" .. event](self, ...) end)
    end,

    ["_createOptions"] = function(self)
        -- Create and attach the interface options frame.
    end,

    ["install"] = function(self)
        -- Initialize this object.

        self:_registerEvents()
        self:_createOptions()
    end,
}

local frame = CreateFrame("Frame")
Mixin(frame, CombatLoggerMixin)

frame:install()
