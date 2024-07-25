-- Define the available options and their default values.

local thisAddonName, namespace = ...

namespace.instanceDifficulties = {
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
}

namespace.asVariableName = function(difficultyId)
    -- Return the variable name corresponding to the specified 'difficultyId'.

    return thisAddonName .. '_' .. difficultyId
end
