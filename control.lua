--[[
Name:         control.lua
Authors:      Matthew Sheridan
Date:         20 October 2016
Revision:     22 October 2016
Copyright:    Matthew Sheridan 2016
Licence:      Beer-Ware License Rev. 42

Event handling and globals for FIST mod. See fist.lua and gui.lua for function
calls seen here.

----------------------------------------
To-Do:

Add Fire Direction Center entities.
Add mortar entities.
Implement fire mission functionality.

Needs more handling for fo-gun-blank leaving the player's inventory for uncommon
cases (e.g. put into another entity's inventory with shift-click or ctrl-click).
----------------------------------------
--]]

require("stdlib.area.position")
require("stdlib.event.event")
require("stdlib.gui.gui")
require("stdlib.string")
require("stdlib.table")
require("fist")
require("gui")

DEBUG = true

ALPHA = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q",
         "R","S","T","U","V","W","X","Y","Z"}
PHONETIC = {"Alpha","Bravo","Charlie","Delta","Echo","Foxtrot","Golf","Hotel",
           "India","Juliet","Kilo","Lima","Mike","November","Oscar","Papa",
           "Quebec","Romeo","Sierra","Tango","Uniform","Victor","Whiskey",
           "X-ray","Yankee","Zulu"}
MAX_TRP = 8

MAX_RANGE_60 = 50

-- Table of Fire Direction Centers and counters for naming.
fdc = {}
fdc_counter = {1, 0}

-- Table of queued Fire Missions.
fire_mission_queue = {}

-- Table of Target Reference Points and counters for naming.
trp = {}
trp_counter = {1, 1, -1}

local new_trp_player_index = nil
local new_trp_pos = nil

-- Post: Check for fo-gun-blanks each tick.
--       Check if the player has marked a new target with his/her fo-gun.
Event.register(defines.events.on_tick, function(event)
  -- Check for fo-gun-blanks.
  FoGunBlankCheckAll()

  -- Process any newly-marked targets.
  if new_trp_player_index ~= nil and new_trp_pos ~= nil then
    EvaluateNewTargets(new_trp_player_index, new_trp_pos)
  end
  new_trp_player_index = nil
  new_trp_pos = nil
end)

-- Check for newly-built FDCs.
Event.register(defines.events.on_built_entity, function(event)
  if event.created_entity.name == "fdc" then
    OnFdcPlaced(event)
  end
end)

-- Check for newly-built FDCs.
Event.register(defines.events.on_robot_built_entity, function(event)
  if event.entity.name == "fdc" then
    OnFdcPlaced(event)
  end
end)

-- Check for destroyed FDCs.
Event.register(defines.events.on_entity_died, function(event)
  if event.entity.name == "fdc" then
    OnFdcDestroyed(event)
  end
end)

-- Handling for general GUI cliks.
Event.register(defines.events.on_gui_click, function(event)
  local element = event.element
  local player = game.players[event.player_index]

  if string.contains(element.name, "button_fire") then
    OnFireButton(event.player_index)
  elseif string.contains(element.name, "button_del") then
    OnDeleteButton(event.player_index)
  elseif string.contains(element.name, "button_exit") then
    ExitFistController(event.player_index)
  end
end)

-- Check for fo-gun blanks on ammo inventory changes.
Event.register(defines.events.on_player_ammo_inventory_changed, function(event)
  if game ~= nil then
    FoGunBlankCheck(event.player_index)
    new_trp_player_index = event.player_index
  end
end)

-- Check for fo-gun blanks on gun inventory changes.
Event.register(defines.events.on_player_gun_inventory_changed, function(event)
  if game ~= nil then
    FoGunBlankCheck(event.player_index)
  end
end)

-- Look for target markers created by firing the fo-gun.
Event.register(defines.events.on_trigger_created_entity, function(event)
  if event.entity.name == "fo-target-marker" then
    new_trp_pos = event.entity.position
  end
end)

----------------------------------------
if DEBUG == true then
  Event.register(defines.events.on_player_created, function(event)
    if game ~= nil then
      local p = game.players[event.player_index]
      p.character.insert({name="fo-gun",count=1})
      p.character.insert({name="fdc",count=5})
      p.character.insert({name="solar-panel",count=1})
      p.character.insert({name="medium-electric-pole",count=3})
    end
  end)
end
----------------------------------------
