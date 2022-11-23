SimpleTooltipModifier = { }

local frame = CreateFrame("Frame")

-- trigger event with /reloadui or /rl
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(this, event, ...)
    SimpleTooltipModifier[event](MyAddon, ...)
end)

function SimpleTooltipModifier:PLAYER_LOGIN()
    SimpleTooltipModifier:SetDefaults()
end

function SimpleTooltipModifier:SetDefaults()
    if not SimpleTooltipModifierConfig then 
        SimpleTooltipModifierConfig = {
            showIds = true,
            showUnitHealth = true,
            showCreatureUptime = true,
            attachToCursor = true,
            attachToCursorAlt = false,
            detachToCursorInCombat = true
        }
    end
end