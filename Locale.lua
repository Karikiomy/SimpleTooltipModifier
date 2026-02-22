SimpleTooltipModifier_Locale = MyAddon_Locale or {}

local defaultLocale = "enUS"
local locale = GetLocale()

SimpleTooltipModifier_Locale[defaultLocale] = {}
if locale ~= defaultLocale then
    SimpleTooltipModifier_Locale[locale] = {}
end

local L = SimpleTooltipModifier_Locale[locale] or SimpleTooltipModifier_Locale[defaultLocale]

setmetatable(L, {
    __index = function(t, key)
        return SimpleTooltipModifier_Locale[defaultLocale][key] or ("$MISSING_LOCALE-" .. key .. "§")
    end
})

SimpleTooltipModifier_L = L