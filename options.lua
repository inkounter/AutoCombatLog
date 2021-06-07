local thisAddonName, namespace = ...

local instanceDifficulties = {
    -- These values are taken from WeakAuras v3.4.1.

    [0]   = { ["name"] = "No Instance" },
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

-- Create and attach the interface options frame.

local optionsFrame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
optionsFrame.name = thisAddonName

optionsFrame.checkButtons = {}
optionsFrame.okay = function(self)
    -- Save the enabled difficulty IDs based on the checkbuttons' states.

    local enabledDifficultyIds = _G["AutoCombatLogEnabledDifficultyIds"]

    for difficultyId, checkButton in pairs(self.checkButtons) do
        enabledDifficultyIds[difficultyId] = checkButton:GetChecked() or nil
    end

    namespace.updateLogging()
end

-- TODO: add 'default' and 'refresh' methods
optionsFrame.refresh = function(self)
    -- Update the checkbuttons' states based on the enabled difficulty IDs.

    local enabledDifficultyIds = _G["AutoCombatLogEnabledDifficultyIds"]

    for difficultyId, checkButton in pairs(self.checkButtons) do
        checkButton:SetChecked(enabledDifficultyIds[difficultyId] or false)
    end
end

InterfaceOptions_AddCategory(optionsFrame)

local title = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(thisAddonName)

local description = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
description:SetPoint("RIGHT", -32, 0)
description:SetJustifyH("LEFT")
description:SetJustifyV("TOP")
description:SetMaxLines(3)
description:SetHeight(40)
description:SetText(string.gsub(
    [[Automatically enable combat logging when in an instance of any of the
        following difficulties.  Otherwise, disable combat logging.]],
    "%s+",
    " "))

-- TODO: put check buttons in a scrollable window

local previousFrame = description

local createLabeledCheckbox = function(parent, labelText)
    -- Create a 'CheckButton' frame with an additional 'FontString' whose value
    -- is the specified 'labelText'.

    local checkbox = CreateFrame("CheckButton",
                                 nil,
                                 parent,
                                 "OptionsBaseCheckButtonTemplate")
    checkbox.SetValue = function() end

    local label = checkbox:CreateFontString(nil,
                                            "ARTWORK",
                                            "GameFontHighlight")
    label:SetPoint("LEFT", checkbox, "RIGHT", 2, 0)
    label:SetJustifyH("LEFT")
    label:SetText(labelText)

    return checkbox
end

for difficultyId, difficultyInfo in pairs(instanceDifficulties) do
    local labeledCheckbox = createLabeledCheckbox(optionsFrame, difficultyInfo.name)
    labeledCheckbox:SetPoint("TOPLEFT", previousFrame, "BOTTOMLEFT", 0, 0)

    optionsFrame.checkButtons[difficultyId] = labeledCheckbox

    previousFrame = labeledCheckbox
end
