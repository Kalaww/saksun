--[[
]]

local ADDON_NAME, addon = ...
local Saksun = LibStub("AceAddon-3.0"):NewAddon("Saksun", "AceEvent-3.0")
addon.Saksun = Saksun

L = LibStub("AceLocale-3.0"):GetLocale("Saksun")

local MACRO_MANA_POTION = "ManaPotion";
local MACRO_HEALING_POTION = "HealingPotion";
local MACRO_DRINK = "Drink";

local WATERS = {
    {id=65499,  level=85,   mana=96000},    -- conjured mana cake (mage)
    {id=58257,  level=85,   mana=96000},    -- highland spring water
    
    {id=43523,  level=80,   mana=45000},    -- conjured mana strudel (mage)
    {id=58256,  level=80,   mana=45000},    -- sparkling oasis water

    {id=33445,  level=75,   mana=19200},    -- honeymint tea
    {id=58274,  level=75,   mana=19200},    -- fresh water

    {id=43518,  level=74,   mana=12840},    -- conjured mana pie (mage)
    {id=33444,  level=70,   mana=12840},    -- pungent seal whey

    {id=34062,  level=65,   mana=7200},     -- conjured mana biscuit(mage)
    {id=22018,  level=65,   mana=7200},     -- conjured glacier water (mage)
    {id=34780,  level=65,   mana=7200},     -- naaru nation
    {id=32453,  level=65,   mana=7200},     -- star's tears
    {id=27860,  level=65,   mana=7200},     -- purified draenic water
    {id=44750,  level=65,   mana=7200},     -- mountain water

    {id=65517,  level=64,   mana=4200},     -- conjured mana lollipop (mage)
    {id=28399,  level=60,   mana=5100},     -- filtered draenic water
    {id=65516,  level=54,   mana=2934},     -- conjured mana cupcake (mage)
    {id=8766,   level=45,   mana=2935},     -- morning glory dew
    {id=65515,  level=44,   mana=1992},     -- conjured mana brownie (mage)
    {id=1645,   level=35,   mana=1992},     -- moonberry juice
    {id=65500,  level=34,   mana=1494},     -- conjured mana cookie (mage)
    {id=1708,   level=25,   mana=1344},     -- sweet nectar
    {id=1205,   level=15,   mana=835},      -- melon juice
    {id=1179,   level=5,    mana=437},      -- ice cold milk
    {id=159,    level=1,    mana=151},      -- refreshing spring water
};

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
    for i=1, #WATERS do
        if level >= WATERS[i]["level"] and HasItem(WATERS[i]["id"]) then
            return WATERS[i]["id"]
        end
    end

    return WATERS[#WATERS]["id"]

    -- if level >= 85 and HasItem(WATER_CONJURED_MANA_CAKE) then
    --     return WATER_CONJURED_MANA_CAKE;
    -- end

    -- if level >= 85 and HasItem(WATER_HIGHLAND_SPRING_WATER) then
    --     return WATER_HIGHLAND_SPRING_WATER;
    -- end

    -- if level >= 80 and HasItem(WATER_MAGE_MANA_STRUDEL) then
    --     return WATER_MAGE_MANA_STRUDEL;
    -- end

    -- if level >= 80 and HasItem(WATER_SPARKLING_OASIS_WATER) then
    --     return WATER_SPARKLING_OASIS_WATER;
    -- end

    -- if level >= 75 and HasItem(WATER_HONEYMINT_TEA) then
    --     return WATER_HONEYMINT_TEA;
    -- end

    -- if level >= 74 and HasItem(WATER_MAGE_MANA_PIE) then
    --     return WATER_MAGE_MANA_PIE;
    -- end

    -- if level >= 70 and HasItem(WATER_PUNGENT_SEAL_WHEY) then
    --     return WATER_PUNGENT_SEAL_WHEY;
    -- end

    -- if level >= 65 and HasItem(WATER_MAGE_MANNA_BISCUIT) then
    --     return WATER_MAGE_MANNA_BISCUIT;
    -- end

    -- if level >= 65 and HasItem(WATER_MAGE_GLACIER_WATER) then
    --     return WATER_MAGE_GLACIER_WATER;
    -- end

    -- if level >= 65 and HasItem(WATER_STARS_TEARS) and IsActiveBattlefieldArena() then
    --     return WATER_STARS_TEARS;
    -- end

    -- if level >= 65 and HasItem(WATER_MOUNTAIN_WATER) then
    --     return WATER_MOUNTAIN_WATER;
    -- end

    -- if level >= 65 and HasItem(WATER_NAARU_RATION) then
    --     return WATER_NAARU_RATION;
    -- end

    -- return WATER_PURIFIED_DRAENIC_WATER;
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
