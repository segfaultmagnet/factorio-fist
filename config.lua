--[[
Name:         config.lua
Authors:      Matthew Sheridan
Date:         23 October 2016
Revision:     28 October 2016
Copyright:    Matthew Sheridan 2016
Licence:      Beer-Ware License Rev. 42

Configuration data for FIST mod, notably projectile information.
--]]


ALPHA = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q",
         "R","S","T","U","V","W","X","Y","Z"}
PHONETIC = {"Alpha","Bravo","Charlie","Delta","Echo","Foxtrot","Golf","Hotel",
           "India","Juliet","Kilo","Lima","Mike","November","Oscar","Papa",
           "Quebec","Romeo","Sierra","Tango","Uniform","Victor","Whiskey",
           "X-ray","Yankee","Zulu"}
HOLLYWOOD = {"Hangman", "Lightning", "Rain", "Slinger", "Steel", "Storm",
             "Thunder", "Twisted"}

DEFAULT_ROUND_TYPE = "HE"
FDC_CONTROL_RADIUS = 3.5
FIRE_LOCKOUT = 60
MINIMUM_SAFE_DISTANCE = 40
MAX_ROUNDS = 5
MAX_TRP = 8

ROUND_COUNT_WARNING = {}
ROUND_COUNT_WARNING["amber"] = 25
ROUND_COUNT_WARNING["red"] = 15

ROUND_DESCRIPTION = {}
ROUND_DESCRIPTION["HE"] = "High Explosive"
ROUND_DESCRIPTION["VT"] = "High Explosive, Proximity Fuze (Air Burst)"

guns =
{
  howitzer_155 =
  {
    name = "Howitzer, 155mm",
    entity_name = "howitzer-155",
    caliber = "155mm",
    cooldown = 900,
    max_range = 1500,
    ammo_type = {
      HE = "howitzer-155-he",
      VT = "howitzer-155-he"
    },
    projectile_type = {
      HE = "howitzer-155-he",
      VT = "howitzer-155-vt"
    },
    dispersion = {
      HE = 0.04,
      VT = 0.06
    },
    velocity = 0.25,
    max_velocity_variation = 2,
    muzzle_entity = "gunshot-howitzer"
  },
  mortar_81 = 
  {
    name = "Mortar, 81mm",
    entity_name = "mortar-81",
    caliber = "81mm",
    cooldown = 240,
    max_range = 300,
    ammo_type = {
      HE = "mortar-81-he",
      VT = "mortar-81-he"
    },
    projectile_type = {
      HE = "mortar-81-he",
      VT = "mortar-81-vt"
    },
    dispersion = {
      HE = 0.05,
      VT = 0.08
    },
    velocity = 0.1,
    max_velocity_variation = 3,
    muzzle_entity = "gunshot-mortar"
  }
}
