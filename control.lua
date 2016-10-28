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

Implement inventory for FDC and mortars.
----------------------------------------
--]]

DEBUG = true

require("stdlib.area.position")
require("stdlib.event.event")
require("stdlib.gui.gui")
require("stdlib.string")
require("stdlib.table")
require("config")
require("fist")
require("gui")

TESTING_GUN_TYPE = GUN_TYPES[1]
TESTING_ROUND_COUNT = 4

-- Table of Fire Direction Centers and counters for naming.
global.fdc = {}
global.fdc_cooldown = {}

-- Table of Target Reference Points and counters for naming.
global.trp = {}
global.trp_counter = {1, 1, -1}

-- Table of queued Fire Missions.
global.new_fire_missions = {}
global.assigned_fire_missions = {}

-- Used to temporarily lock out the Fire button.
fire_button_disable = 0

local new_trp_player_index = nil
local new_trp_pos = nil

-- Check for newly-created players.
Event.register(defines.events.on_player_created, function(event)
  if game ~= nil then
    local player_index = event.player_index
    ShowOpenButton(player_index)

    ----------------------------------------
    if DEBUG == true then
      local player = game.players[player_index]
      for i = 1, 8 do
        if player.get_inventory(i) ~= nil then
          player.get_inventory(i).clear()
        end
      end
      player.character.destructible = false
      player.character.insert({name="steel-axe",count=3})
      player.character.insert({name="fo-gun",count=1})
      player.character.insert({name="grenade",count=20})
      player.character.insert({name="red-wire",count=30})
      player.character.insert({name="fdc",count=5})
      player.character.insert({name="mortar-81",count=20})
      player.character.insert({name="mortar-81-he",count=30})
    end
    ----------------------------------------
  end
end)

-- Post: Check for fo-gun-blanks each tick.
--       Check if the player has marked a new target with his/her fo-gun.
Event.register(defines.events.on_tick, function(event)
  -- Decrement the Fire button lockout and firing cooldowns.
  if fire_button_disable > 0 then
    fire_button_disable = fire_button_disable - 1
  end
  for k,_ in pairs(global.fdc) do
    if global.fdc_cooldown[k] > 0 then
      global.fdc_cooldown[k] = global.fdc_cooldown[k] - 1
    end
  end

  -- Check for fo-gun-blanks.
  FoGunBlankCheckAll()

  -- Process any newly-marked targets.
  if new_trp_player_index ~= nil and new_trp_pos ~= nil then
    EvaluateNewTargets(new_trp_player_index, new_trp_pos)
    ShowTrpController(new_trp_player_index)
  end
  new_trp_player_index = nil
  new_trp_pos = nil

  -- Process queued fire missions.
  for k,v in pairs(global.fdc) do
    if global.fdc_cooldown[k] == 0 and #global.assigned_fire_missions[k] > 0 then
      local foo = table.remove(global.assigned_fire_missions[k], 1)
      global.fdc_cooldown[k] = COOLDOWN_BETWEEN_ROUNDS[foo[1]]
      ExecuteFireMission(k, foo[1], foo[2], foo[3])
    end
  end
end)

-- Check for newly-built FDCs and guns.
Event.register(defines.events.on_built_entity, function(event)
  if event.created_entity.name == "fdc" then
    OnFdcPlaced(event)
  elseif event.created_entity.name == "mortar-81" then
    OnGunPlaced(event)
  end
end)

-- Check for newly-built FDCs and guns.
Event.register(defines.events.on_robot_built_entity, function(event)
  if event.entity.name == "fdc" then
    OnFdcPlaced(event)
  elseif event.created_entity.name == "mortar-81" then
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

-- Handling for GUI checkboxes.
Event.register(defines.events.on_gui_checked_state_changed, function(event)
  local element = event.element
  local player_index = event.player_index
  local trp_ctrl = game.players[player_index].gui.left.trp_ctrl

  -- Target selection checkboxes.
  if element.parent.parent == trp_ctrl.left_flow.list then
    SetTargetReference(player_index, element.parent.name)
  end

  -- Round selection checkboxes.
  if element.parent.parent == trp_ctrl.center_flow.type_flow then
    SetRoundType(player_index, element.parent.name)
  end
end)

-- Handling for general GUI cliks.
Event.register(defines.events.on_gui_click, function(event)
  local name = event.element.name
  local player_index = event.player_index

  if string.contains(name, "button_fire") then
    OnFireButton(player_index)
  elseif string.contains(name, "button_del") then
    OnDeleteButton(player_index)
  elseif string.contains(name, "button_clr") then
    OnClearButton(player_index)
  elseif string.contains(name, "button_exit") then
    ShowOpenButton(player_index)
  elseif string.contains(name, "button_open") then
    ShowTrpController(player_index)
  elseif string.contains(name, "button_rounds_") then
    OnButtonRoundCount(player_index, name)
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
