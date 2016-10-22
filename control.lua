--[[
Name:         control.lua
Authors:      Matthew Sheridan
Date:         20 October 2016
Revision:     22 October 2016
Copyright:    Matthew Sheridan 2016
Licence:      Beer-Ware License Rev. 42

Event handling and globals for FIST mod.

Needs more handling for fo-gun-blank leaving the player's inventory for uncommon
cases (e.g. put into another entity's inventory with shift-click or ctrl-click).

----------------------------------------
To-Do:

Implement fire mission functionality.
----------------------------------------
--]]

require("stdlib.area.position")
require("stdlib.event.event")
require("stdlib.gui.gui")
require("stdlib.table")
require("fist")
require("gui")

DEBUG = true

ALPHA = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q",
         "R","S","T","U","V","W","X","Y","Z"}
PONETIC = {"Alpha","Bravo","Charlie","Delta","Echo","Foxtrot","Golf","Hotel",
           "India","Juliet","Kilo","Lima","Mike","November","Oscar","Papa",
           "Quebec","Romeo","Sierra","Tango","Uniform","Victor","Whiskey",
           "X-ray","Yankee","Zulu"}
AUTO_REMOVE_TRP = false
MAX_TRP = 8

trp = {}
trp_counter = {1, 1, 0}

local new_trp_player_index = nil
local new_trp_pos = nil
local trp

-- Post: Check for fo-gun blanks each tick.
--       Check if the player has marked a new target with his/her fo-gun.
Event.register(defines.events.on_tick, function(event)
  FoGunBlankCheckAll()
  if new_trp_player_index ~= nil and new_trp_pos ~= nil then
    local player = game.players[new_trp_player_index]
    new_trp_key = GenerateTargetReference()
    AddTargetReference(new_trp_player_index, new_trp_key, new_trp_pos)
    ShowTrpController(new_trp_player_index)
  end
  new_trp_player_index = nil
  new_trp_pos = nil
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

-- Handling for general GUI cliks.
Event.register(defines.events.on_gui_click, function(event)
  local element = event.element
  local player = game.players[event.player_index]

  if string.find(element.name, "button_fire") then
    OnFireMission(event.player_index)
  elseif string.find(element.name, "button_del") then
    OnDeleteButton(event.player_index)
  elseif string.find(element.name, "button_exit") then
    ExitFistController(event.player_index)
  end
end)

----------------------------------------
if DEBUG == true then
  Event.register(defines.events.on_player_created, function(event)
    if game ~= nil then
      local p = game.players[event.player_index]
      p.character.insert({name="fo-gun",count=1})
      p.character.insert({name="fo-gun-blank",count=1})
    end
  end)
end
----------------------------------------
