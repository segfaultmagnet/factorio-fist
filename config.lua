--[[
Name:         config.lua
Authors:      Matthew Sheridan
Date:         23 October 2016
Revision:     24 October 2016
Copyright:    Matthew Sheridan 2016
Licence:      Beer-Ware License Rev. 42

Configuration data for FIST mod, notably projectile information.
--]]

DEBUG = true

TESTING_GUN_TYPE = "mortar-60"
TESTING_ROUND_TYPE = "mortar-60-vt"
TESTING_ROUND_COUNT = 1

ALPHA = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q",
         "R","S","T","U","V","W","X","Y","Z"}
PHONETIC = {"Alpha","Bravo","Charlie","Delta","Echo","Foxtrot","Golf","Hotel",
           "India","Juliet","Kilo","Lima","Mike","November","Oscar","Papa",
           "Quebec","Romeo","Sierra","Tango","Uniform","Victor","Whiskey",
           "X-ray","Yankee","Zulu"}

MAX_TRP = 8

MAX_RANGE = {}
MAX_RANGE["mortar-60"] = 80

MUZZLE_VELOCITY = {}
MUZZLE_VELOCITY["mortar-60"] = 0.1

FDC_CONTROL_RADIUS = 3

ROUND_DISPERSION_FACTOR = 0.15
