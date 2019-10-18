local ADDON_NAME, addon = ...
local saksun = LibStub("AceAddon-3.0"):NewAddon("Saksun", "AceEvent-3.0")
addon.saksun = saksun
local _G = _G
local strfind, gsub = strfind, gsub

local cache = setmetatable({}, { __mode = "kv" })
saksun.cache = cache

Tooltips = {
    "GameTooltip"
}

function code_dmg(dmg_type)
    return "Increases damage done by " .. dmg_type .. " spells and effects by up to"
end


local ITEM_SPELL_TRIGGER_ONEQUIP = ITEM_SPELL_TRIGGER_ONEQUIP
local CODE_MP5 = "mana per 5 sec"
local CODE_HP5 = "health per 5 sec"
local CODE_HEALING = "Increases healing done by spells and effects by up to"
local CODE_DMG_AND_HEALING = "Increases damage and healing done by magical spells and effects by up to"
local CODE_SHADOW = code_dmg("Shadow")
local CODE_FIRE = code_dmg("Fire")
local CODE_FROST = code_dmg("Frost")


function isPattern(text, pattern)
    return strfind(text, pattern) ~= nil
end

function isMP5(text)
    return isPattern(text, CODE_MP5)
end

function isHP5(text)
    return isPattern(text, CODE_HP5)
end

function isHealing(text)
    return isPattern(text, CODE_HEALING)
end

function isDamageAndHealing(text)
    return isPattern(text, CODE_DMG_AND_HEALING)
end

function isShadowSpell(text)
    return isPattern(text, CODE_SHADOW)
end

function isFireSpell(text)
    return isPattern(text, CODE_FIRE)
end

function isFrostSpell(text)
    return isPattern(text, CODE_FROST)
end



function formatSexy(str)
    str = gsub(str, "Restores ", "")
    str = gsub(str, CODE_MP5, "mp5")
    str = gsub(str, CODE_HP5, "hp5")
    str = gsub(str, CODE_HEALING, "heal")
    str = gsub(str, CODE_DMG_AND_HEALING, "dmg & heal")
    str = gsub(str, CODE_SHADOW, "shadow")
    str = gsub(str, CODE_FIRE, "fire")
    str = gsub(str, CODE_FROST, "frost")
    return gsub(str, "%.", "")
end


function ReformatTooltipLine(tooltip, line, text)
    if strfind(text, ITEM_SPELL_TRIGGER_ONEQUIP) then
        if not cache[text] then

            if isMP5(text)
            or isHP5(text)
                or isHealing(text)
                or isDamageAndHealing(text)
                or isShadowSpell(text)
                or isFireSpell(text)
                or isFrostSpell(text)
            then cache[text] = formatSexy(text) end
        end

        if cache[text] then
            line:SetText(cache[text])
        end
    end
end


function ReformatTooltip(tooltip)
    local textLeft = tooltip.textLeft

    if not textLeft then
		local tooltipName = tooltip:GetName()
		textLeft = setmetatable({}, { __index = function(t, i)
			local line = _G[tooltipName .. "TextLeft" .. i]
			t[i] = line
			return line
		end })
		tooltip.textLeft = textLeft
    end

    for i = 2, tooltip:NumLines() do
        local line = textLeft[i]
        local text = line:GetText()
        if text then
            ReformatTooltipLine(tooltip, line, text)
        end
    end
end


function saksun:PLAYER_ENTERING_WORLD()
    print("PLAYER_ENTERING_WORLD")

    for i, tooltipName in pairs(Tooltips) do
        tooltip = _G[tooltipName]
        if tooltip and tooltip.HookScript then
            print("setting up for ", tooltipName)
            tooltip:HookScript("OnTooltipSetItem", ReformatTooltip)
            Tooltips[i] = nil
        end
    end
end


saksun:RegisterEvent("PLAYER_ENTERING_WORLD");