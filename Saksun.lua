local ADDON_NAME, saksun = ...;
local _G = _G
local strfind = strfind

local cache = setmetatable({}, { __mode = "kv" })
saksun.cache = cache

local Tooltips = {
    "ItemRefToolTip"
}

local ITEM_SPELL_TRIGGER_ONEQUIP = ITEM_SPELL_TRIGGER_ONEQUIP


local function ReformatTooltipLine(tooltip, index, text)
    if strfind(text, ITEM_SPELL_TRIGGER_ONEQUIP) then
        print("FIND equip line index=", index, " text=", text)

        if not cache[text] then
            cache[text] = "HELLO: " .. text
        end

        if cache[text] then
            line:SetText(cache[text])
        end
    end
end


local function ReformatTooltip(tooltip)
    local textLeft = tooltip.textLeft
    if not textLeft then return end

    for i = 2, tooltip:NumLines() do
        local line = textLeft[i]
        local text = line:GetText()
        if text do
            print("index: ", i, " value: ", text)
            ReformatTooltipLine(tooltip, i, text)
        end
    end
end


local Loader = CreateFrame("Frame")
Loader:RegisterEvent("ADDON_LOADED")
Loader:SetScript("OnEvent", function(self, event, arg)
    if arg == ADDON_NAME then
        print("VAR ONEQUIP ", ITEM_SPELL_TRIGGER_ONEQUIP)

        for i, tooltip in pairs(Tooltips) do
            tooltip = _G[tooltip]
            if tooltip and tooltip.HookScript then
                tooltip:HookScript("OnTooltipSetItem", ReformatTooltip)
                itemTooltips[i] = nil
            end
        end
        
        if not next(itemTooltips) then
            self:UnregisterEvent(event)
            self:SetScript("OnEvent", nil)
        end
	end
end)