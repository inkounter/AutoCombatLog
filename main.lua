local addonName, namespace = ...

local logMessage = function(message)
    print(string.format("|cFF5555BB%s:|r %s", addonName, message))
end

local defaultDifficultyIds = {
    [8] = true,     -- Mythic Keystone
    [15] = true,    -- Heroic Raid
    [16] = true,    -- Mythic Raid
    [23] = true,    -- Mythic Dungeon
}

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

    ["handleEvent"] = function(self, event)
        local difficultyId = select(3, GetInstanceInfo())
        if defaultDifficultyIds[difficultyId] then
            self:enableLogging()
        else
            self:disableLogging()
        end
    end,

    ["registerEvents"] = function(self)
        self:RegisterEvent("UPDATE_INSTANCE_INFO")
        self:SetScript("OnEvent", self.handleEvent)
    end,
}

local frame = CreateFrame("Frame")
Mixin(frame, CombatLoggerMixin)

frame:registerEvents()
