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

local MANA_POTIONS = {
    {id=57192,  level=80},  -- mythical mana potion 9250-10750
    {id=42545,  level=70},  -- runic mana injector 4200-4400
    {id=33448,  level=70},  -- runic mana potion 4200-4400
    {id=43570,  level=1},   -- endless mana potion 1800-3000
    {id=43530,  level=55},  -- argent mana potion 1800-3000
    {id=32948,  level=55},  -- auchenai mana potion 1800-3000
    {id=33935,  level=55},  -- crystal mana potion 1800-3000
    {id=40067,  level=65},  -- icy potion injector 1800-3000
    {id=33093,  level=55},  -- mana potion injector 1800-3000
    {id=22832,  level=55},  -- super mana potion 1800-3000
    {id=31840,  level=61},  -- major combat mana potion 1350-2250 (arathi)
    {id=31841,  level=61},  -- major combat mana potion 1350-2250 (alterac)
    {id=31855,  level=61},  -- major combat mana potion 1350-2250 (warsong)
    {id=31854,  level=61},  -- major combat mana potion 1350-2250 (eye)
    {id=28101,  level=55},  -- unstable mana potion 1350-2250
    {id=13444,  level=49},  -- major mana potion 1350-2250
    {id=13443,  level=41},  -- superior mana potion 900-1500
    {id=6149,   level=31},  -- greater mana potion 700-900
    {id=3827,   level=22},  -- mana potion 455-585
    {id=3385,   level=14},  -- lesser mana potion 280-360
    {id=2455,   level=5},   -- minor mana potion 140-180
}

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

function GetManaPotionID(level)
    for i=1, #MANA_POTIONS do
        if level >= MANA_POTIONS[i]["level"] and HasItem(MANA_POTIONS[i]["id"]) then
            return MANA_POTIONS[i]["id"]
        end
    end

    return MANA_POTIONS[#MANA_POTIONS]["id"]
end

function GetHPPotionID(level)
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
end

function UpdateMacros()
    local level = UnitLevel("player");
    if level == nil then return end
    
    local waterID = GetWaterID(level);
    UpdateMacro(MACRO_DRINK, waterID);

    -- local mapID = C_Map.GetBestMapForUnit("player");
    -- if mapID == nil then return end
    
    local manaPotionID = GetManaPotionID(level);
    UpdateMacro(MACRO_MANA_POTION, manaPotionID);
    
    local hpPotionID = GetHPPotionID(level);
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
