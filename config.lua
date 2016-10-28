--[[
Name:         config.lua
Authors:      Matthew Sheridan
Date:         23 October 2016
Revision:     24 October 2016
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

GUN_TYPES = {"mortar-81"}
COOLDOWN_BETWEEN_ROUNDS = {}
COOLDOWN_BETWEEN_ROUNDS[GUN_TYPES[1]] = 180
MAX_RANGE = {}
MAX_RANGE[GUN_TYPES[1]] = 300
MUZZLE_VELOCITY = {}
MUZZLE_VELOCITY[GUN_TYPES[1]] = 0.1
ROUND_TYPES = {}
ROUND_TYPES[GUN_TYPES[1]] = {"HE", "VT"}

DEFAULT_ROUND_TYPE = "HE"
FDC_CONTROL_RADIUS = 3
FIRE_LOCKOUT = 60
MINIMUM_SAFE_DISTANCE = 40
MAX_ROUNDS = 5
MAX_TRP = 8

ROUND_DESCRIPTION = {}
ROUND_DESCRIPTION["HE"] = "High Explosive"
ROUND_DESCRIPTION["VT"] = "High Explosive, Proximity Fuze (Air Burst)"

ROUND_DISPERSION_FACTOR = {}
ROUND_DISPERSION_FACTOR["HE"] = 0.05
ROUND_DISPERSION_FACTOR["VT"] = 0.08
