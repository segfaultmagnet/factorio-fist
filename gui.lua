--[[
Name:         gui.lua
Authors:      Matthew Sheridan
Date:         21 October 2016
Revision:     24 October 2016
Copyright:    Matthew Sheridan 2016
Licence:      Beer-Ware License Rev. 42

GUI elements for FIST mod.
--]]

-- CLoses the controller.
function ExitFistController(player_index)
  local trp_ctrl = game.players[player_index].gui.center.trp_ctrl
  if trp_ctrl ~= nil and trp_ctrl.valid then
    trp_ctrl.destroy()
  end
end

-- Pre:  player_index is a valid index to the player getting this popup.
-- Post: Returns the FIST Controller frame.
function GuiTrpController(player_index)
  local player_gui = game.players[player_index].gui.center

  -- Reset the list element if it already exists and start fresh.
  if player_gui.trp_ctrl ~= nil
    and player_gui.trp_ctrl.valid
    and player_gui.trp_ctrl.left_flow ~= nil
    and player_gui.trp_ctrl.left_flow.list.valid then
    player_gui.trp_ctrl.left_flow.list.destroy()

  else
    -- Main GUI frame.
    player_gui.add
    {
      type = "frame",
      name = "trp_ctrl",
      caption = "FIST Controller",
      direction = "horizontal"
    }
    player_gui.trp_ctrl.style.minimal_width = 500
    player_gui.trp_ctrl.style.maximal_width = 500
    player_gui.trp_ctrl.style.minimal_height = 400
    player_gui.trp_ctrl.style.maximal_height = 400

    -- Left side of frame for targets.
    player_gui.trp_ctrl.add
    {
      type = "frame",
      name = "left_flow",
      caption = "Target Reference Points",
      direction = "vertical"
    }
    player_gui.trp_ctrl.left_flow.style.minimal_width = 400
    player_gui.trp_ctrl.left_flow.style.maximal_width = 400
    player_gui.trp_ctrl.left_flow.style.minimal_height = 340
    player_gui.trp_ctrl.left_flow.style.maximal_height = 340

    -- Right side of frame for buttons.
    player_gui.trp_ctrl.add
    {
      type = "flow",
      name = "right_flow",
      direction = "vertical"
    }
    player_gui.trp_ctrl.right_flow.style.minimal_width = 100
    player_gui.trp_ctrl.right_flow.style.maximal_width = 100

    -- Fire button.
    player_gui.trp_ctrl.right_flow.add
    {
      type = "button",
      name = "button_fire",
      caption = "FIRE"
    }
    player_gui.trp_ctrl.right_flow.button_fire.style.minimal_width = 70
    player_gui.trp_ctrl.right_flow.button_fire.style.maximal_width = 70

    -- Remove button.
    player_gui.trp_ctrl.right_flow.add
    {
      type = "button",
      name = "button_del",
      caption = "DEL"
    }
    player_gui.trp_ctrl.right_flow.button_del.style.minimal_width = 70
    player_gui.trp_ctrl.right_flow.button_del.style.maximal_width = 70

    -- Close button.
    player_gui.trp_ctrl.right_flow.add
    {
      type = "button",
      name = "button_exit",
      caption = "EXIT"
    }
    player_gui.trp_ctrl.right_flow.button_exit.style.minimal_width = 70
    player_gui.trp_ctrl.right_flow.button_exit.style.maximal_width = 70
  end

  -- List of targets.
  player_gui.trp_ctrl.left_flow.add
  {
    type = "scroll-pane",
    name = "list",
    style = scroll_pane_style,
    direction = "vertical",
    horizontal_scroll_policy = "never",
    vertical_scroll_policy = "always"
  }
  for k,v in pairs(global.trp) do
    local foo = player_gui.trp_ctrl.left_flow.list.add
    {
      type = "flow",
      name = k,
      direction = "horizontal"
    }
    foo.style.minimal_height = 25
    foo.style.maximal_height = 25
    local foo_label = foo.add
    {
      type = "label",
      name = "label",
      caption = k..": "..FormatPosition(v)
    }
    foo_label.style.minimal_width = 320
    foo.add
    {
      type = "checkbox",
      name = "checkbox",
      state = false
    }
  end
  return player_gui.trp_ctrl
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
  local gun_type = TESTING_GUN_TYPE
  local round_type = TESTING_ROUND_TYPE
  local round_count = TESTING_ROUND_COUNT

  local list = game.players[player_index].gui.center.trp_ctrl.left_flow.list
  for k,v in pairs(list.children_names) do
    if list[v].checkbox.state == true then
      table.insert(fire_mission_queue, v)
    end
  end
  if #fire_mission_queue > 0 then
    ExecuteFireMissions(player_index, gun_type, round_type, round_count)
  end

  ShowTrpController(player_index)
end

-- Displays the controller.
function ShowTrpController(player_index)
  local trp_ctrl = GuiTrpController(player_index)
end
