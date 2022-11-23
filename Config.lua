--[[
    https://wowpedia.fandom.com/wiki/Using_the_AddOn_namespace
    https://wowpedia.fandom.com/wiki/WOW_PROJECT_ID
    https://github.com/Stanzilla/WoWUIBugs/issues/68#issuecomment-830351390
    https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/SharedXML/SharedColorConstants.lua
]]

local addonName, addonTable = ...

local panel = CreateFrame("Frame")
panel.name = addonName
panel:SetScript("OnHide",function(frame)

end)
panel:SetScript("OnShow", function(frame)
	local function newCheckbox(label, description, onClick)
		local check = CreateFrame("CheckButton", "BugSackCheck" .. label, frame, "InterfaceOptionsCheckButtonTemplate")
		check:SetScript("OnClick", function(self)
			local tick = self:GetChecked()
			onClick(self, tick and true or false)
			if tick then
				PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
			else
				PlaySound(857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
			end
		end)
		check.label = _G[check:GetName() .. "Text"]
		check.label:SetText(label)
		check.tooltipText = label
		check.tooltipRequirement = description
		return check
	end

	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(addonName)

    -- Show Id Checkbox
	local showIdCheckbox = newCheckbox(
		"Show ids",
		"Show ids (Spells and Auras)",
		function(self, value) 
            SimpleTooltipModifierConfig.showIds = value
        end)
	showIdCheckbox:SetChecked(SimpleTooltipModifierConfig.showIds)
	showIdCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -2, -16)

    -- Show Unit Health Checkbox
    local showUnitHealth = newCheckbox(
		"Show unit health",
		"Show unit health in tooltips",
		function(self, value) 
            SimpleTooltipModifierConfig.showUnitHealth = value
        end)
    showUnitHealth:SetChecked(SimpleTooltipModifierConfig.showUnitHealth)
    showUnitHealth:SetPoint("TOPLEFT", showIdCheckbox, "BOTTOMLEFT", 0, -8)

    -- Show Alive uptime Checkbox
    local showAliveUptime = newCheckbox(
		"Show unit alive uptime",
		"Show unit alive uptime",
		function(self, value) 
            SimpleTooltipModifierConfig.showCreatureUptime = value
        end)
    showAliveUptime:SetChecked(SimpleTooltipModifierConfig.showCreatureUptime)
    showAliveUptime:SetPoint("TOPLEFT", showUnitHealth, "BOTTOMLEFT", 0, -8)

    -- Attach tooltip to cursor
    local attachTooltipToCursor = newCheckbox(
		"Attach tooltip to cursor",
		"Attach tooltip to cursor",
		function(self, value) 
            SimpleTooltipModifierConfig.attachToCursor = value
            --disableDetachTooltipByValue()
        end)
        attachTooltipToCursor:SetChecked(SimpleTooltipModifierConfig.attachToCursor)
        attachTooltipToCursor:SetPoint("TOPLEFT", showAliveUptime, "BOTTOMLEFT", 0, -8)
    -- Detach tooltip to cursor in Battle
    local detachTooltipInBattle = newCheckbox(
		"Detach tooltip in battle",
		"Detach tooltip in battle",
		function(self, value) 
            SimpleTooltipModifierConfig.detachToCursorInCombat = value
        end)
        detachTooltipInBattle:SetChecked(SimpleTooltipModifierConfig.detachToCursorInCombat)
        detachTooltipInBattle:SetPoint("TOPLEFT", attachTooltipToCursor, "BOTTOMLEFT", 0, -8)
        --detachTooltipInBattle:SetEnabled(SimpleTooltipModifierConfig.attachToCursor)
        --disableDetachTooltipByValue()
    local function disableDetachTooltipByValue()
        if(SimpleTooltipModifierConfig.attachToCursor == true) then
            detachTooltipInBattle:Enable()
        else
            detachTooltipInBattle:Disable()
        end
    end
	frame:SetScript("OnShow", nil)
end)
InterfaceOptions_AddCategory(panel)