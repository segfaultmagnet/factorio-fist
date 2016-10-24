--[[
Name:         fist.lua
Authors:      Matthew Sheridan
Date:         22 October 2016
Revision:     24 October 2016
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
    for k,v in pairs(global.trp) do
      i = i + 1
    end

    if i > MAX_TRP then
      player.print("TRP not assigned: too many targets.")
    else
      global.trp[key] = pos
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
  elseif global.trp[key] == nil then
    player.print(key.." is not a valid TRP.")
  else
    global.trp[key] = nil
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
-- Post: Determines which FDC will handle the fire mission and executes it.
function ExecuteFireMissions(player_index, gun_type, round_type, round_count)
  local player = game.players[player_index]
  while #fire_mission_queue > 0 do

    local i = 0
    for _,v in pairs(fire_mission_queue) do
      local nearest_fdc_key = nil
      local nearest_fdc_entity = nil
      local nearest_range = nil
      i = i + 1

      -- Determine distances to TRP from each FDC.
      if #global.fdc > 0 then
        for _,w in pairs(global.fdc) do
          local gun_count = #GetFdcConnectedGuns(w[2], gun_type)
          local this_range = Position.distance(w[2].position, global.trp[v])
          if this_range <= MAX_RANGE[gun_type] and gun_count > 0
            and (nearest_range == nil or this_range < nearest_range) then
            nearest_fdc_key = w[1]
            nearest_fdc_entity = w[2]
            nearest_range = this_range
          end
        end

        -- If there is an FDC in range of the TRP, give the current mission to the
        -- nearest one for firing.
        if nearest_fdc_key ~= nil then
          local guns = GetFdcConnectedGuns(nearest_fdc_entity, gun_type)
          MessageToObserver(player_index, nearest_fdc_key, #guns, round_type, round_count, v)

          for _,g in pairs(guns) do
            SpawnProjectile(gun_type, round_type, round_count, g.position, global.trp[v])
          end
        else
          player.print("No FDC within range of "..v.."!")
        end
      else
        player.print("No FDC available!")
      end

      table.remove(fire_mission_queue, i)
    end
  end
end

-- Pre:  fdc is the FDC.
--       gun_type is the name of the guns to be searched for (e.g. "mortar-60").
-- Post: Returns a table of all guns within the FDC's circuit network.
function GetFdcConnectedGuns(fdc, gun_type)
  local connected = fdc.circuit_connected_entities
  local guns = {}
  if connected ~= nil then
    for _,v in pairs(connected["red"]) do
      if v.name == gun_type then
        table.insert(guns, v)
      end
    end
  end

  return guns
end

-- Pre:  Note: deprecated. Use GetFdcConnectedGuns instead.
--       fdc is the FDC.
--       gun_type is the name of the guns to be searched for (e.g. "mortar-60").
-- Post: Returns a table of all guns within the FDC's control radius.
function GetFdcGunsRadius(fdc, gun_type)
  local fdc_pos = fdc.position
  local guns = {}
  local bound =
  {
    left_top = { fdc_pos.x - FDC_CONTROL_RADIUS, fdc_pos.y - FDC_CONTROL_RADIUS },
    right_bottom = { fdc_pos.x + FDC_CONTROL_RADIUS, fdc_pos.y + FDC_CONTROL_RADIUS }
  }
  local nearby = game.surfaces["nauvis"].find_entities_filtered{area = bound, name = gun_type}
  local i = 0
  for k,v in pairs(nearby) do
    i = i + 1
    if Position.distance(fdc_pos, v.position) < FDC_CONTROL_RADIUS then
      table.insert(guns, v)
    end
  end
  return guns
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
    local sel = player.opened
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
    global.fdc_counter[2] = global.fdc_counter[2] + 1
    if global.fdc_counter[2] > 26 then
      global.fdc_counter[2] = 1
      global.fdc_counter[1] = global.fdc_counter[1] + 1
    end
    if global.fdc_counter[1] > 26 then
      global.fdc_counter[1] = 1
    end

    -- New key.
    key = PHONETIC[global.fdc_counter[1]].." "..PHONETIC[global.fdc_counter[2]]
  until global.fdc[key] == nil
  return key
end

-- Post: Generates a new, unique key for use in trp.
function GenerateTargetReference()
  local key
  repeat
    -- Increment identifier.
    global.trp_counter[3] = global.trp_counter[3] + 1
    if global.trp_counter[3] > 9 then
      global.trp_counter[3] = 0
      global.trp_counter[2] = global.trp_counter[2] + 1
    end
    if global.trp_counter[2] > 26 then
      global.trp_counter[2] = 1
      global.trp_counter[1] = global.trp_counter[1] + 1
    end
    if global.trp_counter[1] > 26 then
      global.trp_counter[1] = 1
    end

    -- New key.
    key = ALPHA[global.trp_counter[1]]..ALPHA[global.trp_counter[2]]..tostring(global.trp_counter[3])
  until global.trp[key] == nil
  return key
end

-- Post: Sends message to the player calling the fire mission.
function MessageToObserver(player_index, fdc_name, gun_count, round_type, round_count, trp_key)
  local player = game.players[player_index]
  player.print("Message to observer:")
  player.print(fdc_name..", "..gun_count.." guns, "..round_type.." in effect, "
               ..round_count.." rounds, target number "..trp_key..".")
  -- Implement later:
  -- player.print() time in flight
end

-- Pre:  Called when an FDC is placed, either by player or robot.
-- Post: New name for FDC is generated and a table of name and entity pointer
--       are appended to fdc.
function OnFdcPlaced(event)
  local new_fdc_name = GenerateFdcName()
  table.insert(global.fdc, {new_fdc_name, event.created_entity})
  --[[
  if event.player_index ~= nil then
    game.players[event.player_index].print("New FDC "..new_fdc_name)
  -- Check to see how to get force that robot is on.
  elseif event.robot ~= nil then
    Game.print_force(event.robot.force).print("New FDC "..new_fdc_name)
  end
  --]]
end

-- Pre:  Called when an FDC is destroyed.
-- Post: FDC is removed from fdc.
function OnFdcDestroyed(event)
  local entity = event.entity
  for k,v in pairs(global.fdc) do
    if v[2] == entity then
      table.remove(global.fdc, k)
      break
    end
  end
end

-- Pre:  Called when an FDC is mined by a player.
-- Post: FDC is removed from fdc.
function OnFdcMined(event)
  for k,v in pairs(global.fdc) do
    if v[2] == nil or v[2].valid == false then
      table.remove(global.fdc, k)
    end
  end
end

-- Pre:  Called when a gun is placed, either by player or robot.
-- Post: The gun is connected to the nearest FDC, if there is one.
function OnGunPlaced(event)
  local gun = event.created_entity
  local nearest_fdc = nil
  local nearest_dist = nil
  local bound =
  {
    left_top = { gun.position.x - FDC_CONTROL_RADIUS, gun.position.y - FDC_CONTROL_RADIUS },
    right_bottom = { gun.position.x + FDC_CONTROL_RADIUS, gun.position.y + FDC_CONTROL_RADIUS }
  }

  -- Determine nearest FDC to this gun.
  local nearby = game.surfaces["nauvis"].find_entities_filtered{area = bound, name = "fdc"}
  local i = 0
  for k,v in pairs(nearby) do
    i = i + 1
    local dist = Position.distance(gun.position, v.position)
    if dist < FDC_CONTROL_RADIUS and (nearest_dist == nil or dist < nearest_dist) then
      nearest_fdc = v
      nearest_dist = dist
    end
  end

  -- Wire them together.
  if nearest_fdc ~= nil then
    nearest_fdc.connect_neighbour({wire = defines.wire_type.red, target_entity = gun})
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

-- Post: Spawns new projectiles of round type, moving from gun_pos to tgt_pos.
function SpawnProjectile(gun_type, round_type, round_count, gun_pos, tgt_pos)
  -- Need to randomize impact position.
  for i = 1, round_count do
    local dist = Position.distance(gun_pos, tgt_pos)
    local new_tgt = 
    {
    tgt_pos.x + (dist * ROUND_DISPERSION_FACTOR * (math.random() - 0.5)),
    tgt_pos.y + (dist * ROUND_DISPERSION_FACTOR * (math.random() - 0.5))
    }

    game.surfaces["nauvis"].create_entity({
      name = round_type,
      amount = 1,
      position = gun_pos,
      target = new_tgt,
      speed = MUZZLE_VELOCITY[gun_type]
    })
    game.surfaces["nauvis"].create_entity({
      name = "gunshot-mortar",
      amount = 1,
      position = gun_pos,
      target = new_tgt
    })
  end
end
