--[[
Name:         fist.lua
Authors:      Matthew Sheridan
Date:         22 October 2016
Revision:     22 October 2016
Copyright:    Matthew Sheridan 2016
Licence:      Beer-Ware License Rev. 42

Fire control functions for FIST mod.
--]]

-- Pre:  key is the TRP's name.
--       pos is the TRP's position.
-- Post: New TRP added.
--       If there exist more than MAX_TRP targets, remove oldest targets until
--       there are only MAX_TRP remaining.
function AddTargetReference(player_index, key, pos)
  local player = game.players[player_index]

  if MAX_TRP > 0 then
    local i = 0
    for k,v in pairs(trp) do
      i = i + 1
    end

    if i > MAX_TRP then
      player.print("TRP not assigned: too many targets.")
    else
      trp[key] = pos
      player.print("TRP designated: "..key)
    end
  end
end

-- Pre:  key is a valid TRP key.
-- Post: TRP key is removed.
function RemoveTargetReference(player_index, key)
  local player = game.players[player_index]
  if key == nil then
    player.print("No TRP selected.")
  elseif trp[key] == nil then
    player.print(key.." is not a valid TRP.")
  else
    trp[key] = nil
    player.print("TRP "..key.." unassigned.")
  end
end

-- Post: Adds new TRP if determined that current player added it.
function EvaluateNewTargets(player_index, pos)
  local player = game.players[player_index]
  AddTargetReference(player_index, GenerateTargetReference(), pos)
  ShowTrpController(player_index)
end

-- Pre:  Called when there at least one fire mission queued.
-- Post: Determines which FDC will handle the 
function ExecuteFireMissions(player_index)
  local player = game.players[player_index]
  while #fire_mission_queue > 0 do

    local i = 0
    for _,v in pairs(fire_mission_queue) do
      local nearest_fdc = nil
      local ranges = {}
      i = i + 1

      -- Determine distances to TRP from each FDC.
      for _,w in pairs(fdc) do
        new_range = Position.distance(w[2].position, trp[v])
        if new_range <= MAX_RANGE_60 then
          table.insert(ranges, new_range)
        end
        if new_range == table.min(ranges) then
          nearest_fdc = w[1]
        end
      end

      -- If there is an FDC in range of the TRP, give the current mission to the
      -- nearest one for firing.
      if nearest_fdc ~= nil then
        -- Fire here.
        player.print("FDC "..nearest_fdc.." fires "..v)
      else
        player.print("No FDC within range of "..v)
      end

      table.remove(fire_mission_queue, i)
    end
  end
end

-- Post: Checks to see if the player has fo-gun in their gun inventory or if
--       they do not have a blank round. If so, calls SetBlanks to set count of
--       blanks in ammo inventory to one.
--       Otherwise, remove any blanks in the player's inventory.
function FoGunBlankCheck(player_index)
  local player = game.players[player_index]
  if player ~= nil then
    -- Check player's inventories.
    inv_guns = player.get_inventory(defines.inventory.player_guns)
    if inv_guns ~= nil and inv_guns.find_item_stack("fo-gun") ~= nil then
      SetBlanks(player_index, 1)
    else
      SetBlanks(player_index, 0)
    end

    -- Check selected entity's inventories, except when selected entity is
    -- another player. This method should be replaced with one which only checks
    -- the inventory of an entity whose inventory is currently open on-screen,
    -- if possible. Also, double-check on whether sel.name would return "character"
    -- or "player". One of them will not be necessary.
    local sel = player.selected
    if sel ~= nil and sel.valid and sel.name ~= "character" and sel.name ~= "player" then    
      for i = 1, 8 do
        local sel_inv = sel.get_inventory(i)
        if sel_inv ~= nil and sel_inv.is_empty() == false then
          while sel_inv.get_item_count("fo-gun-blank") > 0 do
            local stack = sel_inv.find_item_stack("fo-gun-blank")
            stack.clear()
          end
        end
      end
    end
  end
end

-- Pre:  Called each game tick.
-- Post: Calls FoGunBlankCheck for each player.
function FoGunBlankCheckAll()
  if game ~= nil then
    for k,v in pairs(game.players) do
      FoGunBlankCheck(tonumber(v.index))
    end
  end
end

-- Post: Returns a position as a string with truncated coordinates.
function FormatPosition(pos)
  local x = string.format("%.1f",pos.x)
  local y = string.format("%.1f",pos.y)
  if not string.contains(x, ".") then
    x = x..".0"
  end
  if not string.contains(y, ".") then
    y = y..".0"
  end
  return "("..x..", "..y..")"
end

-- Post: Generates a new, unique name for each FDC.
function GenerateFdcName()
  local key
  repeat
    -- Increment identifier.
    fdc_counter[2] = fdc_counter[2] + 1
    if fdc_counter[2] > 26 then
      fdc_counter[2] = 1
      fdc_counter[1] = fdc_counter[1] + 1
    end
    if fdc_counter[1] > 26 then
      fdc_counter[1] = 1
    end

    -- New key.
    key = PHONETIC[fdc_counter[1]].." "..PHONETIC[fdc_counter[2]]
  until fdc[key] == nil
  return key
end

-- Post: Generates a new, unique key for use in trp.
function GenerateTargetReference()
  local key
  repeat
    -- Increment identifier.
    trp_counter[3] = trp_counter[3] + 1
    if trp_counter[3] > 9 then
      trp_counter[3] = 0
      trp_counter[2] = trp_counter[2] + 1
    end
    if trp_counter[2] > 26 then
      trp_counter[2] = 1
      trp_counter[1] = trp_counter[1] + 1
    end
    if trp_counter[1] > 26 then
      trp_counter[1] = 1
    end

    -- New key.
    key = ALPHA[trp_counter[1]]..ALPHA[trp_counter[2]]..tostring(trp_counter[3])
  until trp[key] == nil
  return key
end

-- Post: Removes the selected TRPs.
function OnDeleteButton(player_index)
  local list = game.players[player_index].gui.center.trp_ctrl.left_flow.list
  for k,v in pairs(list.children_names) do
    if list[v].checkbox.state == true then
      RemoveTargetReference(player_index, v)
    end
  end
  ShowTrpController(player_index)
end

-- Pre:  player_index is the player calling fire.
-- Post: Executes fire mission against currently selected TRP.
function OnFireButton(player_index)
  local list = game.players[player_index].gui.center.trp_ctrl.left_flow.list
  for k,v in pairs(list.children_names) do
    if list[v].checkbox.state == true then
      table.insert(fire_mission_queue, v)
    end
  end
  ExecuteFireMissions(player_index)
  ShowTrpController(player_index)
end

-- Pre:  Called when an FDC is placed, either by player or robot.
-- Post: New name for FDC is generated and a table of name and entity pointer
--       are appended to fdc.
function OnFdcPlaced(event)
  local new_fdc_name = GenerateFdcName()
  table.insert(fdc, {new_fdc_name, event.created_entity})
  if event.player_index ~= nil then
    game.players[event.player_index].print("New FDC "..new_fdc_name)
  --[[
  -- Check to see how to get force that robot is on.
  elseif event.robot ~= nil then
    Game.print_force(event.robot.force).print("New FDC "..new_fdc_name)
  --]]
  end
end

-- Pre:  Called when an FDC is destroyed.
-- Post: FDC is removed from fdc.
function OnFdcDestroyed(event)
  local entity = event.entity
  for k,v in pairs(fdc) do
    if v[2] == entity then
      table.remove(fdc, k)
    end
  end
end

-- Post: Sets the number of fo-gun-blank rounds in the player's ammo inventory
--       to count. Removes any found in their main inventory or cursor stack.
function SetBlanks(player_index, count)
  local player = game.players[player_index]
  local inv_main = player.get_inventory(defines.inventory.player_main)
  local inv_ammo = player.get_inventory(defines.inventory.player_ammo)
  local cursor_stack = player.cursor_stack

  -- Remove any blanks from main inventory.
  while inv_main.get_item_count("fo-gun-blank") > 0 do
    local stack = inv_main.find_item_stack("fo-gun-blank")
    if stack ~= nil then
      stack.clear()
    end
  end

  -- Remove any blanks from cursor stack.
  if cursor_stack.valid_for_read and cursor_stack.name == "fo-gun-blank" then
    cursor_stack.clear()
  end

  -- Set number of blanks in ammo inventory to count.
  if inv_ammo.get_item_count("fo-gun-blank") ~= count then
    local stack = inv_ammo.find_item_stack("fo-gun-blank")
    if count > 0 then
      if stack == nil then
        inv_ammo.insert({name="fo-gun-blank", count=count})
      else
        stack.count = count
      end
    else
      if stack ~= nil then
        stack.clear()
      end
    end
  end
end
