-- Create the Interface Options.

local thisAddonName, namespace = ...

local optionsFrame = CreateFrame("Frame",
                                 nil,
                                 InterfaceOptionsFramePanelContainer)
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

optionsFrame.default = function(self)
    -- Reset the enabled difficulty IDs to the default set, and force the addon
    -- to update.

    _G["AutoCombatLogEnabledDifficultyIds"] = namespace.getDefaultEnabledDifficultyIds()

    namespace.updateLogging()
end

optionsFrame.refresh = function(self)
    -- Update the checkbuttons' states based on the enabled difficulty IDs.

    local enabledDifficultyIds = _G["AutoCombatLogEnabledDifficultyIds"]

    for difficultyId, checkButton in pairs(self.checkButtons) do
        checkButton:SetChecked(enabledDifficultyIds[difficultyId] or false)
    end
end

InterfaceOptions_AddCategory(optionsFrame)

local title = optionsFrame:CreateFontString(nil,
                                            "ARTWORK",
                                            "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(thisAddonName)

local description = optionsFrame:CreateFontString(nil,
                                                  "ARTWORK",
                                                  "GameFontHighlightSmall")
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

for _, difficultyInfo in ipairs(namespace.instanceDifficulties) do
    local labeledCheckbox = createLabeledCheckbox(optionsFrame,
                                                  difficultyInfo.name)
    labeledCheckbox:SetPoint("TOPLEFT", previousFrame, "BOTTOMLEFT", 0, 0)

    optionsFrame.checkButtons[difficultyInfo.id] = labeledCheckbox

    previousFrame = labeledCheckbox
end
