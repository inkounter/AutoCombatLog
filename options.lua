-- Define the available options and their default values.

local thisAddonName, namespace = ...

local instanceDifficulties = {
    -- These values are derived from WeakAuras v3.4.1.

    { ["id"] = 0,   ["name"] = "No Instance" },
    { ["id"] = 1,   ["name"] = "Dungeon (Normal)" },
    { ["id"] = 2,   ["name"] = "Dungeon (Heroic)" },
    { ["id"] = 23,  ["name"] = "Dungeon (Mythic)",  ["default"] = true },
    { ["id"] = 8,   ["name"] = "Mythic Keystone",   ["default"] = true },
    { ["id"] = 17,  ["name"] = "Looking for Raid" },
    { ["id"] = 14,  ["name"] = "Raid (Normal)" },
    { ["id"] = 15,  ["name"] = "Raid (Heroic)",     ["default"] = true },
    { ["id"] = 16,  ["name"] = "Raid (Mythic)",     ["default"] = true },
    { ["id"] = 24,  ["name"] = "Dungeon (Timewalking)" },
    { ["id"] = 33,  ["name"] = "Raid (Timewalking)" },
    { ["id"] = 167, ["name"] = "Torghast" },
}
namespace.instanceDifficulties = instanceDifficulties

local defaultEnabledDifficultyIds = {}
for _, difficultyInfo in ipairs(instanceDifficulties) do
    if difficultyInfo.default == true then
        defaultEnabledDifficultyIds[difficultyInfo.id] = true
    end
end

namespace.getDefaultEnabledDifficultyIds = function()
    -- Return a clone of the table of default enabled difficulty IDs.

    local clone = {}
    for k, v in pairs(defaultEnabledDifficultyIds) do
        clone[k] = v
    end

    return clone
end
