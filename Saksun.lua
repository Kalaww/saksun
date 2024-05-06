--[[
]]

local ADDON_NAME, addon = ...
local Saksun = LibStub("AceAddon-3.0"):NewAddon("Saksun", "AceEvent-3.0")
addon.Saksun = Saksun

L = LibStub("AceLocale-3.0"):GetLocale("Saksun")

local MACRO_MANA_POTION = "ManaPotion";
local MACRO_HEALING_POTION = "HealingPotion";
local MACRO_DRINK = "Drink";

local WATER_MAGE_MANNA_BISCUIT = 34062;
local WATER_MAGE_GLACIER_WATER = 22018;
local WATER_STARS_TEARS = 32453;
local WATER_PURIFIED_DRAENIC_WATER = 27860;
local WATER_NAARU_RATION = 34780;
local WATER_MAGE_MANA_STRUDEL = 43523;
local WATER_MAGE_MANA_PIE = 43518;
local WATER_HONEYMINT_TEA = 33445;
local WATER_PUNGENT_SEAL_WHEY = 33444;
local WATER_MOUNTAIN_WATER = 44750;
local WATER_SPARKLING_OASIS_WATER = 58256;
local WATER_HIGHLAND_SPRING_WATER = 58257;
local WATER_CONJURED_MANA_CAKE = 65499;

local MANA_POTION_SUPER = 22832;
local MANA_POTION_INJECTOR = 33093;
local MANA_POTION_CRYSTAL = 33935;
local MANA_POTION_RUNIC = 33448;
local MANA_POTION_RUNIC_INJECTOR = 42545;
local MANA_POTION_MYTHICAL = 57192;

local HP_POTION_SUPER = 22829;
local HP_POTION_INJECTOR = 33092;
local HP_POTION_RUNIC = 33447;
local HP_POTION_RUNIC_INJECTOR = 41166;
local HP_POTION_MYTHICAL = 57191;


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

function GetManaPotionID(mapID, level)
    if level >= 80 and HasItem(MANA_POTION_MYTHICAL) then
        return MANA_POTION_MYTHICAL;
    end

    if level >= 70 and HasItem(MANA_POTION_RUNIC_INJECTOR) then
        return MANA_POTION_RUNIC_INJECTOR;
    end

    if level >= 70 and HasItem(MANA_POTION_RUNIC) then
        return MANA_POTION_RUNIC;
    end

    if HasItem(MANA_POTION_CRYSTAL) then
        return MANA_POTION_CRYSTAL;
    end

    if HasItem(MANA_POTION_INJECTOR) then
        return MANA_POTION_INJECTOR;
    end
    
    return MANA_POTION_SUPER;
end

function GetHPPotionID(mapID, level)
    if level >= 80 and HasItem(HP_POTION_MYTHICAL) then
        return HP_POTION_MYTHICAL;
    end

    if level >= 70 and HasItem(HP_POTION_RUNIC_INJECTOR) then
        return HP_POTION_RUNIC_INJECTOR;
    end

    if level >= 70 and HasItem(HP_POTION_RUNIC) then
        return HP_POTION_RUNIC;
    end

    if HasItem(HP_POTION_INJECTOR) then
        return HP_POTION_INJECTOR;
    end
    
    return HP_POTION_SUPER;
end

function GetWaterID(level)
    if level >= 85 and HasItem(WATER_CONJURED_MANA_CAKE) then
        return WATER_CONJURED_MANA_CAKE;
    end

    if level >= 85 and HasItem(WATER_HIGHLAND_SPRING_WATER) then
        return WATER_HIGHLAND_SPRING_WATER;
    end

    if level >= 80 and HasItem(WATER_MAGE_MANA_STRUDEL) then
        return WATER_MAGE_MANA_STRUDEL;
    end

    if level >= 80 and HasItem(WATER_SPARKLING_OASIS_WATER) then
        return WATER_SPARKLING_OASIS_WATER;
    end

    if level >= 75 and HasItem(WATER_HONEYMINT_TEA) then
        return WATER_HONEYMINT_TEA;
    end

    if level >= 74 and HasItem(WATER_MAGE_MANA_PIE) then
        return WATER_MAGE_MANA_PIE;
    end

    if level >= 70 and HasItem(WATER_PUNGENT_SEAL_WHEY) then
        return WATER_PUNGENT_SEAL_WHEY;
    end

    if level >= 65 and HasItem(WATER_MAGE_MANNA_BISCUIT) then
        return WATER_MAGE_MANNA_BISCUIT;
    end

    if level >= 65 and HasItem(WATER_MAGE_GLACIER_WATER) then
        return WATER_MAGE_GLACIER_WATER;
    end

    if level >= 65 and HasItem(WATER_STARS_TEARS) and IsActiveBattlefieldArena() then
        return WATER_STARS_TEARS;
    end

    if level >= 65 and HasItem(WATER_MOUNTAIN_WATER) then
        return WATER_MOUNTAIN_WATER;
    end

    if level >= 65 and HasItem(WATER_NAARU_RATION) then
        return WATER_NAARU_RATION;
    end

    return WATER_PURIFIED_DRAENIC_WATER;
end

function UpdateMacros()
    local level = UnitLevel("player");
    if level == nil then return end
    
    local waterID = GetWaterID(level);
    UpdateMacro(MACRO_DRINK, waterID);

    local mapID = C_Map.GetBestMapForUnit("player");
    if mapID == nil then return end
    
    local manaPotionID = GetManaPotionID(mapID, level);
    UpdateMacro(MACRO_MANA_POTION, manaPotionID);
    
    local hpPotionID = GetHPPotionID(mapID, level);
    UpdateMacro(MACRO_HEALING_POTION, hpPotionID);
end


-- function Saksun:PLAYER_ENTERING_WORLD()
--     UpdateMacros()
-- end

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

function Saksun:BAG_UPDATE_DELAYED()
    UpdateMacros()
end


-- Not needed because when player login it triggers a BAG_UPDATE_DELAYED
-- Saksun:RegisterEvent("PLAYER_ENTERING_WORLD");

Saksun:RegisterEvent("ZONE_CHANGED");
Saksun:RegisterEvent("ZONE_CHANGED_INDOORS");
Saksun:RegisterEvent("ZONE_CHANGED_NEW_AREA");

Saksun:RegisterEvent("PLAYER_REGEN_ENABLED");
Saksun:RegisterEvent("BAG_UPDATE_DELAYED");
