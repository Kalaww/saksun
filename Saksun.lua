--[[
]]

local ADDON_NAME, addon = ...
local Saksun = LibStub("AceAddon-3.0"):NewAddon("Saksun", "AceEvent-3.0")
addon.Saksun = Saksun

L = LibStub("AceLocale-3.0"):GetLocale("Saksun")

local MACRO_MANA_POTION = "ManaPotion";
local MACRO_HP_POTION = "HealingPotion";
local MACRO_DRINK = "Drink";

local WATER_MAGE_MANNA_BISCUIT = 34062;
local WATER_MAGE_GLACIER_WATER = 22018;
local WATER_STARS_TEARS = 32453;
local WATER_PURIFIED_DRAENIC_WATER = 27860;

local MANA_POTION_SSC = 32903;
local MANA_POTION_TK = 32902;
local MANA_POTION_AV = 31841;
local MANA_POTION_SUPER = 22832;
local MANA_POTION_INJECTOR = 33093;

local HP_POTION_SSC = 32904;
local HP_POTION_TK = 32905;
local HP_POTION_AV = 31839;
local HP_POTION_SUPER = 22829;
local HP_POTION_INJECTOR = 33092;

local ZONES_THE_EYE = {
    267, -- mechanar
    268, -- mechanar
    266, -- botanica
    269, -- arcatraz
    270, -- arcatraz
    271, -- arcatraz
    334, -- tempest keep
};

local ZONES_COILFANG_RESERVOIR = {
    265, -- slaves pens
    262, -- underbog
    263, -- steamvault
    264, -- steamvault
    332, -- serpentshrine cavern
}

local ZONES_BATTLEGROUND = {
    91, -- alterac valley
    92, -- warsong gulch
    93, -- arathi basin
    112, -- eye of the storm
}


function UpdateMacro(name, itemID)
    if InCombatLockdown() then
        return;
    end

    local body = "#showtooltip\n/use item:" .. itemID;
    EditMacro(name, name, nil, body);
end

function Contains(list, x)
	for _, v in ipairs(list) do
		if v == x then return true end
	end
	return false
end

function HasItem(itemID)
    return GetItemCount(itemID, false, false) > 0;
end

function GetManaPotionID(mapID)
    if Contains(ZONES_COILFANG_RESERVOIR, mapID) and HasItem(MANA_POTION_SSC) then
        return MANA_POTION_SSC;
    end
    
    if Contains(ZONES_THE_EYE, mapID) and HasItem(MANA_POTION_TK) then
        return MANA_POTION_TK;
    end
    
    if Contains(ZONES_BATTLEGROUND, mapID) and HasItem(MANA_POTION_AV) then
        return MANA_POTION_AV;    
    end

    if HasItem(MANA_POTION_INJECTOR) then
        return MANA_POTION_INJECTOR;
    end
    
    return MANA_POTION_SUPER;
end

function GetHPPotionID(mapID)
    if Contains(ZONES_COILFANG_RESERVOIR, mapID) and HasItem(HP_POTION_SSC) then
        return HP_POTION_SSC;
    end
    
    if Contains(ZONES_THE_EYE, mapID) and HasItem(HP_POTION_TK) then
        return HP_POTION_TK;
    end
    
    if Contains(ZONES_BATTLEGROUND, mapID) and HasItem(HP_POTION_AV) then
        return HP_POTION_AV;    
    end

    if HasItem(HP_POTION_INJECTOR) then
        return HP_POTION_INJECTOR;
    end
    
    return HP_POTION_SUPER;
end

function GetWaterID()
    if HasItem(WATER_MAGE_MANNA_BISCUIT) then
        return WATER_MAGE_MANNA_BISCUIT;
    end

    if HasItem(WATER_MAGE_GLACIER_WATER) then
        return WATER_MAGE_GLACIER_WATER;
    end

    if HasItem(WATER_STARS_TEARS) and IsActiveBattlefieldArena() then
        return WATER_STARS_TEARS;
    end

    return WATER_PURIFIED_DRAENIC_WATER;
end

function UpdateMacros()
    local waterID = GetWaterID();
    UpdateMacro(MACRO_DRINK, waterID);

    local mapID = C_Map.GetBestMapForUnit("player");
    if mapID == nil then return end
    
    local manaPotionID = GetManaPotionID(mapID);
    UpdateMacro(MACRO_MANA_POTION, manaPotionID);
    
    local hpPotionID = GetHPPotionID(mapID);
    UpdateMacro(MACRO_HP_POTION, hpPotionID);
end




function Saksun:PLAYER_ENTERING_WORLD()
    UpdateMacros()
end

function Saksun:ZONE_CHANGED()
    UpdateMacros()
end

function Saksun:ZONE_CHANGED_INDOORS()
    UpdateMacros()
end

function Saksun:ZONE_CHANGED_NEW_AREA()
    UpdateMacros()
end

function Saksun:PLAYER_REGEN_ENABLED()
    UpdateMacros()
end

function Saksun:BAG_UPDATE()
    UpdateMacros()
end


Saksun:RegisterEvent("PLAYER_ENTERING_WORLD");

Saksun:RegisterEvent("ZONE_CHANGED");
Saksun:RegisterEvent("ZONE_CHANGED_INDOORS");
Saksun:RegisterEvent("ZONE_CHANGED_NEW_AREA");

Saksun:RegisterEvent("PLAYER_REGEN_ENABLED");
Saksun:RegisterEvent("BAG_UPDATE");