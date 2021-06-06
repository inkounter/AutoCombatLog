local thisAddonName, namespace = ...

local instanceDifficulties = {
    -- These values are taken from WeakAuras v3.4.1.

    [1]   = { ["name"] = "Dungeon (Normal)" },
    [2]   = { ["name"] = "Dungeon (Heroic)" },
    [3]   = { ["name"] = "10 Player Raid (Normal)" },
    [4]   = { ["name"] = "25 Player Raid (Normal)" },
    [5]   = { ["name"] = "10 Player Raid (Heroic)" },
    [6]   = { ["name"] = "25 Player Raid (Heroic)" },
    [7]   = { ["name"] = "Legacy Looking for Raid" },
    [8]   = { ["name"] = "Mythic Keystone",             ["default"] = true  },
    [9]   = { ["name"] = "40 Player Raid" },
    [11]  = { ["name"] = "Scenario (Heroic)" },
    [12]  = { ["name"] = "Scenario (Normal)" },
    [14]  = { ["name"] = "Raid (Normal)" },
    [15]  = { ["name"] = "Raid (Heroic)",               ["default"] = true  },
    [16]  = { ["name"] = "Raid (Mythic)",               ["default"] = true  },
    [17]  = { ["name"] = "Looking for Raid" },
    [23]  = { ["name"] = "Dungeon (Mythic)",            ["default"] = true  },
    [24]  = { ["name"] = "Dungeon (Timewalking)" },
    [33]  = { ["name"] = "Raid (Timewalking)" },
    [38]  = { ["name"] = "Island Expedition (Normal)" },
    [39]  = { ["name"] = "Island Expedition (Heroic)" },
    [40]  = { ["name"] = "Island Expedition (Mythic)" },
    [45]  = { ["name"] = "Island Expeditions (PvP)" },
    [147] = { ["name"] = "Warfront (Normal)" },
    [149] = { ["name"] = "Warfront (Heroic)" },
    [152] = { ["name"] = "Visions of N'Zoth" },
    [167] = { ["name"] = "Torghast" },
    [168] = { ["name"] = "Path of Ascension: Courage" },
    [169] = { ["name"] = "Path of Ascension: Loyalty" },
    [171] = { ["name"] = "Path of Ascension: Humility" },
    [170] = { ["name"] = "Path of Ascension: Wisdom" },
}

local defaultEnabledDifficultyIds = {}
for difficultyId, difficultyInfo in pairs(instanceDifficulties) do
    if difficultyInfo.default == true then
        defaultEnabledDifficultyIds[difficultyId] = true
    end
end
namespace.defaultEnabledDifficultyIds = defaultEnabledDifficultyIds
