--[[
    https://us.forums.blizzard.com/en/wow/t/wow-classic-ui-api-change-for-unithealth/446596
    https://www.townlong-yak.com/framexml/37176/GlobalStrings.lua/RU
    https://en.wikipedia.org/wiki/International_System_of_Units#Prefixes
    https://stackoverflow.com/questions/9461621/format-a-number-as-2-5k-if-a-thousand-or-more-otherwise-900
    https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/GameTooltip.lua#L94-L157
    https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/SharedXML/SharedColorConstants.lua#L73-L82
    https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/UIParent.lua#L5351-L5362
]]

local _, addonTable = ...

local db = {} -- local database

--Tooltip Set Aura
function onTooltipSetAura(tooltip, data) 
    if tooltip == GameTooltip then
        if SimpleTooltipModifierConfig.showIds then
            tooltip:AddLine("ID: " .. data.id)
        end
    end
end
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.UnitAura, onTooltipSetAura)

--Tooltip Set Unit
function colorizeLinesTooltipPlayer(tooltip)
    local _,unit = tooltip:GetUnit()
    local tooltipCorrect = false
    if(unit)then
        local _,unitClassVar = UnitClass(unit)
        if(unitClassVar) then
            tooltipCorrect = true;
            local unitClassColor = RAID_CLASS_COLORS[ select(2, UnitClass(unit))]
            local unitHaveGuild = not (GetGuildInfo(unit) == nil)
            local unitFactionEn,unitFactionLocal = UnitFactionGroup(unit)
            for i = 1, tooltip:NumLines() do
                local line = _G[tooltip:GetName() .. 'TextLeft' .. i]
                local lineText = line:GetText()

                -- Name line
                if i == 1 then
                    line:SetText( '|c' .. unitClassColor.colorStr .. lineText .. '|r' )
                -- Guild line
                elseif i == 2 and unitHaveGuild then
                    line:SetTextColor( 0.251, 1, 0.251 ) -- ChatTypeInfo['GUILD']
                -- Faction line
                elseif lineText == unitFactionLocal then
                    if(unitFactionEn == "Horde") then
                        line:SetTextColor(0.7,0,0)
                    elseif(unitFactionEn == "Alliance") then
                        line:SetTextColor(0,0.4,1)
                    end
                end
            end
        end
    end
    if(tooltipCorrect == false)then
        tooltip:Hide()
    end
end
function onTooltipSetUnit(tooltip, data) 
    if tooltip == GameTooltip then
        local unitType = (data.guid):match('^(.-)%-'):lower()
        -- unitType => player/creature
        if unitType == "creature" or unitType == "vehicle" then
            local creatureId = select(6, strsplit("-", data.guid))
            if SimpleTooltipModifierConfig.showIds then
                tooltip:AddLine("ID: " .. creatureId)
            end
            if SimpleTooltipModifierConfig.showCreatureUptime then
                local id = tonumber(strsub(data.guid, -6), 16)
                local serverTime = GetServerTime()
                local spawnTime  = ( serverTime - (serverTime % 2^23) ) + bit.band(id, 0x7fffff)

                if spawnTime > serverTime then
                    spawnTime = spawnTime - ((2^23) - 1)
                end
                tooltip:AddLine("Alive: " .. SecondsToTime(serverTime-spawnTime).." ("..date("%H:%M, %d.%m", spawnTime)..")")
            end
        end
        if unitType == "player" then
            colorizeLinesTooltipPlayer(tooltip)
        end
        --HP Bar config
        if(SimpleTooltipModifierConfig.showUnitHealth == false) then
            GameTooltipStatusBar:Hide();
        else
            GameTooltipStatusBar:Hide();
            if unitType == "player" then
                local _,unit = tooltip:GetUnit()
                local tooltipCorrect = false
                if(unit)then
                    local _,unitClassVar = UnitClass(unit)
                    if(unitClassVar) then
                        tooltipCorrect = true
                        local unit = select(2, tooltip:GetUnit())
                        local unitClassColor = RAID_CLASS_COLORS[ select(2, UnitClass(unit))]
                        GameTooltipStatusBar:SetStatusBarColor( unitClassColor.r, unitClassColor.g, unitClassColor.b )
                    end
                end
                if(tooltipCorrect == false)then
                    tooltip:Hide()
                end
            else
                GameTooltipStatusBar:SetStatusBarColor( 0, 1, 0, 1 )
            end
            GameTooltipStatusBar:Show();
        end
    end
end
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, onTooltipSetUnit)

--Tooltip Set Spell
function onTooltipSetSpell(tooltip,data)
    if(tooltip== GameTooltip) then
        if(SimpleTooltipModifierConfig.showIds) then
            local idSpell = select(2, tooltip:GetSpell())
            tooltip:AddLine("Id: " .. idSpell)
        end
    end
end
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, onTooltipSetSpell)

-- Tooltip Set Anchor 
local function setDefaultAnchor(self, parent)
    self:SetOwner(parent, 'ANCHOR_NONE')
    self:ClearAllPoints()
    self:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y)

    -- In this case, SetOwner() must be below SetPoint()
    if SimpleTooltipModifierConfig.attachToCursor
        and ( ( SimpleTooltipModifierConfig.attachToCursorAlt and GetMouseFocus() == WorldFrame ) or not SimpleTooltipModifierConfig.attachToCursorAlt )
        and ( ( SimpleTooltipModifierConfig.detachToCursorInCombat and not InCombatLockdown() ) or not SimpleTooltipModifierConfig.detachToCursorInCombat ) then

        self:SetOwner(parent, 'ANCHOR_CURSOR_LEFT' or 'ANCHOR_CURSOR')
    end
end
hooksecurefunc('GameTooltip_SetDefaultAnchor', setDefaultAnchor)

local function onStatusBarValueChanged(self)

end

GameTooltipStatusBar:HookScript('OnValueChanged', onStatusBarValueChanged)
--DevTools_Dump({Enum.TooltipDataType})