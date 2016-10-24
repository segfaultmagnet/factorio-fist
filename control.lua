--[[
Name:         control.lua
Authors:      Matthew Sheridan
Date:         20 October 2016
Revision:     24 October 2016
Copyright:    Matthew Sheridan 2016
Licence:      Beer-Ware License Rev. 42

Event handling and globals for FIST mod. See fist.lua and gui.lua for function
calls seen here.

----------------------------------------
To-Do:

Clean up GUI:
  Make smaller replacement GUI on close so that fo-gun doesn't need to be fired
    in order to bring up controller.
  Add round type selection.
  Add round count selection.

Implement inventory for FDC and mortars.

Maybe change 60mm to 81mm?

Time in flight?
----------------------------------------
--]]

require("stdlib.area.position")
require("stdlib.event.event")
require("stdlib.gui.gui")
require("stdlib.string")
require("stdlib.table")
require("config")
require("fist")
require("gui")

-- Table of Fire Direction Centers and counters for naming.
global.fdc = {}
global.fdc_counter = {1, 0}

-- Table of Target Reference Points and counters for naming.
global.trp = {}
global.trp_counter = {1, 1, -1}

-- Table of queued Fire Missions.
fire_mission_queue = {}

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

-- Check for newly-built FDCs and guns.
Event.register(defines.events.on_built_entity, function(event)
  if event.created_entity.name == "fdc" then
    OnFdcPlaced(event)
  elseif event.created_entity.name == "mortar-60" then
    OnGunPlaced(event)
  end
end)

-- Check for newly-built FDCs and guns.
Event.register(defines.events.on_robot_built_entity, function(event)
  if event.entity.name == "fdc" then
    OnFdcPlaced(event)
  elseif event.created_entity.name == "mortar-60" then
    OnGunPlaced(event)
  end
end)

-- Check for destroyed FDCs.
Event.register(defines.events.on_entity_died, function(event)
  if event.entity.name == "fdc" then
    OnFdcDestroyed(event)
  end
end)

-- Check for mined FDCs.
Event.register(defines.events.on_player_mined_item, function(event)
  if event.item_stack.name == "fdc" then
    OnFdcMined(event)
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
      local player = game.players[event.player_index]
      for i = 1, 8 do
        if player.get_inventory(i) ~= nil then
          player.get_inventory(i).clear()
        end
      end
      player.character.insert({name="steel-axe",count=3})
      player.character.insert({name="fo-gun",count=1})
      player.character.insert({name="grenade",count=20})
      player.character.insert({name="red-wire",count=30})
      player.character.insert({name="fdc",count=5})
      player.character.insert({name="mortar-60",count=20})
      player.character.insert({name="mortar-60-he",count=30})
      player.character.insert({name="mortar-60-vt",count=30})
    end
  end)
end
----------------------------------------
