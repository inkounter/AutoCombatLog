local thisAddonName, namespace = ...

local logMessage = function(message)
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
    ["loggingEnabled"] = false,

    ["enableLogging"] = function(self)
        if self.loggingEnabled then
            return
        end

        self.loggingEnabled = true
        logMessage("|cFF00FF00ENABLING|r combat logging.")
        LoggingCombat(true)
    end,

    ["disableLogging"] = function(self)
        if not self.loggingEnabled then
            return
        end

        self.loggingEnabled = false
        logMessage("|cFFFF0000DISABLING|r combat logging.")
        LoggingCombat(false)
    end,

    ["UPDATE_INSTANCE_INFO"] = function(self)
        local difficultyId = select(3, GetInstanceInfo())
        if enabledDifficultyIds[difficultyId] then
            self:enableLogging()
        else
            self:disableLogging()
        end
    end,

    ["ADDON_LOADED"] = function(self, addonName)
        if addonName ~= thisAddonName then
            return
        end

        self:UnregisterEvent("ADDON_LOADED")

        enabledDifficultyIds = _G["AutoCombatLogEnabledDifficultyIds"] or defaultEnabledDifficultyIds

        DevTools_Dump(enabledDifficultyIds)

        self:UPDATE_INSTANCE_INFO()
    end,

    ["registerEvents"] = function(self)
        self:RegisterEvent("UPDATE_INSTANCE_INFO")
        self:RegisterEvent("ADDON_LOADED")

        self:SetScript("OnEvent",
                       function(self, event, ...) self[event](self, ...) end)
    end,
}

local frame = CreateFrame("Frame")
Mixin(frame, CombatLoggerMixin)

frame:registerEvents()
