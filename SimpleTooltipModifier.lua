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
local _c = addonTable.config
local db = {} -- local database

DevTools_Dump({(Enum.TooltipDataType})
--TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, onTooltipSetUnit)