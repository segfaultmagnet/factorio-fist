--[[
Name:         fist.lua
Authors:      Matthew Sheridan
Date:         22 October 2016
Revision:     28 October 2016
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
-- Post: Determines which FDC will handle the fire mission and adds it to that
--       FDC's queue.
function EvaluateNewFireMissions(player_index, round_type, round_count)
  local player = game.players[player_index]
  while #global.new_fire_missions > 0 do

    -- Handle each new fire mission FIFO.
    local i = 0
    for _,new_mission in pairs(global.new_fire_missions) do
      local nearest_fdc_key = nil
      local nearest_range = nil
      local gun_count = 0
      local guns_able = {}
      i = i + 1

      -- Determine nearest FDC to TRP.
      local fdc_count = 0
      for l,w in pairs(global.fdc) do
        fdc_count = fdc_count + 1
      end
      if fdc_count > 0 then
        for key,fdc_entity in pairs(global.fdc) do
          local tgt_range = Position.distance(fdc_entity.position, global.trp[new_mission])
          local fdc_gun_count = 0
          local fdc_guns_able = {}

          if tgt_range >= MINIMUM_SAFE_DISTANCE then
            -- Determine guns within range at this FDC.
            for _,g in pairs(guns) do
              if g.max_range >= tgt_range then
                local count = #GetFdcConnectedGuns(key, g)
                if count > 0 then
                  fdc_gun_count = fdc_gun_count + count
                  table.insert(fdc_guns_able, g)
                end
              end
            end

            -- If this FDC is able to fire on the TRP, compare it to the nearest
            -- other FDC evaluated thus far.
            if fdc_gun_count > 0 and (nearest_range == nil or tgt_range < nearest_range) then
              nearest_fdc_key = key
              nearest_range = tgt_range
              gun_count = fdc_gun_count
              guns_able = fdc_guns_able
            end
          end
        end

        -- If there is a nearest FDC, give this mission to it and send MTO.
        if nearest_fdc_key ~= nil then
          for j = 1, round_count do
            table.insert(global.assigned_fire_missions[nearest_fdc_key],
              {
                guns_able = guns_able,
                round_type = round_type,
                target = global.trp[new_mission]
              })
          end
          player.print(GetMTO(nearest_fdc_key, gun_count, string.upper(round_type),
                              round_count, new_mission))
        else
          player.print("No FDC able to fire "..new_mission.."!")
        end
      else
        player.print("No FDC available!")
      end

      table.remove(global.new_fire_missions, i)
    end
  end
end

-- Post: Spawns new projectiles of round type, moving from gun_pos to tgt_pos.
--       Appropriate amount of ammunition for this mission is removed from FDC.
function ExecuteFireMission(fdc_key, gun_type, round_type, tgt_pos)
  local fdc_pos = global.fdc[fdc_key].position
  local fdc_guns = GetFdcConnectedGuns(fdc_key, gun_type)
  local stack = global.fdc[fdc_key].get_inventory(1).find_item_stack(gun_type.ammo_type[round_type])
  for _,g in pairs(fdc_guns) do
    local go = false
    local gun_stack = g.get_inventory(1).find_item_stack(gun_type.ammo_type[round_type])
    if gun_stack ~= nil and gun_stack.valid_for_read and gun_stack.count > 0 then
      gun_stack.count = gun_stack.count - 1
      go = true
    elseif stack ~= nil and stack.valid_for_read and stack.count > 0 then
      stack.count = stack.count - 1
      go = true
    end

    if go then
      local gun_pos = g.position
      local dist = Position.distance(gun_pos, tgt_pos)
      local new_tgt = 
      {
      tgt_pos.x + (gun_pos.x - fdc_pos.x)
                + (dist * gun_type.dispersion[round_type] * (math.random() - 0.5)),
      tgt_pos.y + (gun_pos.y - fdc_pos.y)
                + (dist * gun_type.dispersion[round_type] * (math.random() - 0.5))
      }

      game.surfaces["nauvis"].create_entity({
        name = gun_type.projectile_type[round_type],
        amount = 1,
        position = gun_pos,
        target = new_tgt,
        speed = gun_type.velocity * (1 + (gun_type.max_velocity_variation * (math.random() - 0.5)))
      })
      game.surfaces["nauvis"].create_entity({
        name = gun_type.muzzle_entity,
        amount = 1,
        position = gun_pos,
        target = new_tgt
      })
    end
  end

  if stack ~= nil and stack.valid_for_read then
    if stack.count < ROUND_COUNT_WARNING["red"] then
      PrintLowAmmo(fdc_key, "red", gun_type.caliber, round_type)
    elseif stack.count < ROUND_COUNT_WARNING["amber"] then
      PrintLowAmmo(fdc_key, "amber", gun_type.caliber, round_type)
    end
  else
    PrintLowAmmo(fdc_key, "black", gun_type.caliber, round_type)
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
    key = HOLLYWOOD[math.ceil(#HOLLYWOOD * math.random())].." "
          ..math.ceil(9 * math.random()).."-"
          ..math.ceil(9 * math.random())
  until global.fdc[tostring(key)] == nil
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
    key = ALPHA[global.trp_counter[1]]..ALPHA[global.trp_counter[2]]
          ..tostring(global.trp_counter[3])
  until global.trp[tostring(key)] == nil
  return key
end

-- Pre:  fdc is the FDC.
--       gun_type is type of the guns to be searched for (see table: guns).
-- Post: Returns a table of all guns within the FDC's circuit network.
function GetFdcConnectedGuns(fdc_key, gun_type)
  if type(fdc_key) ~= "string" then
    error("Not a string!")
    print(debug.traceback)
  end
  local connected = global.fdc[fdc_key].circuit_connected_entities
  local guns = {}
  if connected ~= nil then
    for _,v in pairs(connected["red"]) do
      if v.name == gun_type.entity_name then
        table.insert(guns, v)
      end
    end
  end

  return guns
end

-- Post: Sends message to the player calling the fire mission.
function GetMTO(fdc_name, gun_count, round_type, round_count, trp_key)
  local round_plural = "round"
  if round_count > 1 then
    round_plural = round_plural.."s"
  end
  return ("Message to observer: "..tostring(fdc_name)..", "..tostring(gun_count)
         .." guns, "..tostring(round_type)..", "..tostring(round_count).." "
         ..round_plural..", "..tostring(trp_key)..".")
end

-- Pre:  Called when an FDC is destroyed.
-- Post: Removes the destroyed FDC from global.fdc, global.fdc_cooldown, and
--       global.assigned_fire_missions.
function OnFdcDestroyed(event)
  local entity = event.entity
  for k,v in pairs(global.fdc) do
    if v == entity then
      global.fdc[k] = nil
      global.fdc_cooldown[k] = nil
      global.assigned_fire_missions[k] = nil
      break
    end
  end
end

-- Pre:  Called when an FDC is mined by a player.
-- Post: Removes the mined FDC from global.fdc, global.fdc_cooldown, and
--       global.assigned_fire_missions.
function OnFdcMined(event)
  for k,v in pairs(global.fdc) do
    if v == nil or v.valid == false then
      global.fdc[k] = nil
      global.fdc_cooldown[k] = nil
      global.assigned_fire_missions[k] = nil
    end
  end
end

-- Pre:  Called when an FDC is placed, either by player or robot.
-- Post: New name for FDC is generated and a table of name and entity pointer
--       are appended to fdc.
function OnFdcPlaced(event)
  local new_fdc_name = GenerateFdcName()
  global.fdc[new_fdc_name] = event.created_entity
  global.fdc_cooldown[new_fdc_name] = 0
  global.assigned_fire_missions[new_fdc_name] = {}
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

  -- Wire gun to nearest FDC.
  if nearest_fdc ~= nil then
    nearest_fdc.connect_neighbour({wire = defines.wire_type.red, target_entity = gun})
  end
end

function PrintLowAmmo(fdc_key, condition, caliber, round_type)
  Game.print_all("Warning: "..fdc_key.." is "..string.upper(condition).." on "
                 ..caliber.." "..round_type.." ammo!")
end

-- Post: Fire missions for each FDC are handled and executed in order.
function ProcessAssignedFireMissions()
  for k,v in pairs(global.fdc) do
    if global.fdc_cooldown[k] == 0 and #global.assigned_fire_missions[k] > 0 then
      local mission = table.remove(global.assigned_fire_missions[k], 1)
      local longest_cooldown = 0
      for _,g in pairs(mission.guns_able) do
        if g.cooldown > longest_cooldown then
          longest_cooldown = g.cooldown
        end
        ExecuteFireMission(k, g, mission.round_type, mission.target)
      end
      global.fdc_cooldown[k] = longest_cooldown
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
