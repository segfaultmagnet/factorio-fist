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
      -- Auto remove oldest TRP if this functionality is desired.
      if auto_remove_trp then
        for k,v in pairs(trp) do
          RemoveTargetReference(player_index, k)
          break
        end
      -- Otherwise: don't!
      else
        player.print("TRP not assigned: too many targets.")
      end
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
    -- if possible.
    local sel = player.selected
    if sel ~= nil and sel.valid and sel.player == nil then    
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
  local x_coord = tonumber(string.format("%.1f",pos.x))
  local y_coord = tonumber(string.format("%.1f",pos.y))
  return "("..x_coord..", "..y_coord..")"
end

-- Post: Generates a new, unique key for use in trp.
function GenerateTargetReference()
  local key
  repeat
    key = ALPHA[trp_counter[1]]..ALPHA[trp_counter[2]]..tostring(trp_counter[3])
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
function OnFireMission(player_index)
  local list = game.players[player_index].gui.center.trp_ctrl.left_flow.list
  for k,v in pairs(list.children_names) do
    if list[v].checkbox.state == true then
      -- Fire mission
      game.players[player_index].print("Firing mission "..v)
    end
  end
  ShowTrpController(player_index)
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
