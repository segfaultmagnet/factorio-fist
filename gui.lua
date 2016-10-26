--[[
Name:         gui.lua
Authors:      Matthew Sheridan
Date:         21 October 2016
Revision:     24 October 2016
Copyright:    Matthew Sheridan 2016
Licence:      Beer-Ware License Rev. 42

GUI elements for FIST mod.
--]]

-- Pre:  Created when FIST Controller is closed.
-- Post: Returns a pane which can re-open the FIST Controller.
function GuiRestorePane(player_index)
  local player_gui = game.players[player_index].gui.left

  if player_gui.trp_ctrl ~= nil and player_gui.trp_ctrl.valid then
    player_gui.trp_ctrl.destroy()
  end

  player_gui.add
  {
    type = "button",
    name = "button_open",
    caption = "OPEN FIST"
  }
  player_gui.button_open.style.minimal_width = 100
  player_gui.button_open.style.maximal_width = 100
  player_gui.button_open.tooltip = "Opens the FIST fire support controller."
end

-- Post: Returns the FIST Controller frame.
function GuiTrpController(player_index)
  local player_gui = game.players[player_index].gui.left

  if player_gui.button_open ~= nil and player_gui.button_open.valid then
    player_gui.button_open.destroy()
  end

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
      caption = "Fire Support Controller",
      direction = "horizontal"
    }
    player_gui.trp_ctrl.style.minimal_width = 545
    player_gui.trp_ctrl.style.maximal_width = 545
    player_gui.trp_ctrl.style.minimal_height = 400
    player_gui.trp_ctrl.style.maximal_height = 400

    GuiTrpControllerLeft(player_index)
    GuiTrpControllerCenter(player_index)
    GuiTrpControllerRight(player_index)
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
    foo.add
    {
      type = "label",
      name = "label",
      caption = k..": "..FormatPosition(v)
    }
    foo.label.style.minimal_width = 280
    foo.add
    {
      type = "checkbox",
      name = k,
      state = false
    }
    foo[k].style.top_padding = 4
  end

  SetGuiTrpDefaults(player_index)
end

-- Post: Creates left side of GUI for targets.
function GuiTrpControllerLeft(player_index)
  local trp_ctrl = game.players[player_index].gui.left.trp_ctrl
  trp_ctrl.add
  {
    type = "frame",
    name = "left_flow",
    direction = "vertical"
  }
  trp_ctrl.left_flow.style.minimal_width = 340
  trp_ctrl.left_flow.style.maximal_width = 340
  trp_ctrl.left_flow.style.minimal_height = 340
  trp_ctrl.left_flow.style.maximal_height = 340
  
  -- Labels and such.
  trp_ctrl.left_flow.add
  {
    type = "flow",
    name = "header",
    direction = "horizontal"
  }
  trp_ctrl.left_flow.header.add
  {
    type = "label",
    name = "label_trp",
    caption = "Target Reference Points"
  }
  trp_ctrl.left_flow.header.label_trp.style.minimal_width = 271
  trp_ctrl.left_flow.header.add
  {
    type = "label",
    name = "label_select",
    caption = "Select"
  }
end

-- Post: Creates center section of GUI for options.
function GuiTrpControllerCenter(player_index)
  local trp_ctrl = game.players[player_index].gui.left.trp_ctrl
  trp_ctrl.add
  {
    type = "frame",
    name = "center_flow",
    direction = "vertical"
  }
  trp_ctrl.center_flow.style.minimal_width = 100
  trp_ctrl.center_flow.style.maximal_width = 100
  trp_ctrl.center_flow.style.minimal_height = 340
  trp_ctrl.center_flow.style.maximal_height = 340

  -- Round type selection.
  trp_ctrl.center_flow.add
  {
    type = "label",
    name = "label_round_type",
    caption = "Round Type"
  }
  -- Labels.
  trp_ctrl.center_flow.add
  {
    type = "flow",
    name = "round_label_flow",
    direction = "vertical"
  }
  for k,_ in pairs(ROUND_TYPES) do
    local label = trp_ctrl.center_flow.round_label_flow.add
    {
      type = "label",
      name = k,
      caption = k
    }
    label.style.minimal_width = 40
  end
  -- Checkboxes.
  trp_ctrl.center_flow.add
  {
    type = "flow",
    name = "checkbox_flow",
    direction = "vertical"
  }
  for k,v in pairs(ROUND_TYPES) do
    local box = trp_ctrl.center_flow.checkbox_flow.add
    {
      type = "checkbox",
      name = k,
      state = false
    }
    box.style.top_padding = 4
    box.tooltip = v
  end
end

-- Post: Creates right side of GUI for buttons.
function GuiTrpControllerRight(player_index)
  local trp_ctrl = game.players[player_index].gui.left.trp_ctrl
  trp_ctrl.add
  {
    type = "flow",
    name = "right_flow",
    direction = "vertical"
  }
  trp_ctrl.right_flow.style.minimal_width = 80
  trp_ctrl.right_flow.style.maximal_width = 80

  -- Fire button.
  trp_ctrl.right_flow.add
  {
    type = "button",
    name = "button_fire",
    caption = "FIRE"
  }
  trp_ctrl.right_flow.button_fire.style.minimal_width = 70
  trp_ctrl.right_flow.button_fire.style.maximal_width = 70
  trp_ctrl.right_flow.button_fire.tooltip = "Fire selected mission."

  -- Remove button.
  trp_ctrl.right_flow.add
  {
    type = "button",
    name = "button_del",
    caption = "DEL"
  }
  trp_ctrl.right_flow.button_del.style.minimal_width = 70
  trp_ctrl.right_flow.button_del.style.maximal_width = 70
  trp_ctrl.right_flow.button_del.tooltip = "Remove selected target reference point."

  -- Clear button.
  trp_ctrl.right_flow.add
  {
    type = "button",
    name = "button_clr",
    caption = "CLEAR"
  }
  trp_ctrl.right_flow.button_clr.style.minimal_width = 70
  trp_ctrl.right_flow.button_clr.style.maximal_width = 70
  trp_ctrl.right_flow.button_clr.tooltip = "Removes all target reference points."

  -- Close button.
  trp_ctrl.right_flow.add
  {
    type = "button",
    name = "button_exit",
    caption = "EXIT"
  }
  trp_ctrl.right_flow.button_exit.style.minimal_width = 70
  trp_ctrl.right_flow.button_exit.style.maximal_width = 70
  trp_ctrl.right_flow.button_exit.tooltip = "Close the fire support controller."
end

-- Post: Removes all TRPs.
function OnClearButton(player_index)
  local list = game.players[player_index].gui.left.trp_ctrl.left_flow.list
  for k,v in pairs(list.children_names) do
    RemoveTargetReference(player_index, v)
  end
  ShowTrpController(player_index)
end

-- Post: Removes the selected TRPs.
function OnDeleteButton(player_index)
  local list = game.players[player_index].gui.left.trp_ctrl.left_flow.list
  for k,v in pairs(list.children_names) do
    if list[v][v].state == true then
      RemoveTargetReference(player_index, v)
    end
  end
  ShowTrpController(player_index)
end

-- Post: Executes fire mission against currently selected TRP.
function OnFireButton(player_index)
  local gun_type = TESTING_GUN_TYPE
  local round_type
  local round_count = TESTING_ROUND_COUNT
  local trp_ctrl = game.players[player_index].gui.left.trp_ctrl

  if fire_button_disable == 0 then
    -- Get targets to fire and insert into fire mission queue.
    local list = trp_ctrl.left_flow.list
    for k,v in pairs(list.children_names) do
      if list[v][v].state == true then
        table.insert(fire_mission_queue, v)
      end
    end

    -- Get round type to fire.
    local checkboxes = trp_ctrl.center_flow.checkbox_flow
    for _,v in pairs(checkboxes.children_names) do
      if checkboxes[v].state == true then
        round_type = v
      end
    end

    -- Call the fire mission(s).
    if #fire_mission_queue > 0 then
      ExecuteFireMissions(player_index, gun_type, round_type, round_count)
      fire_button_disable = FIRE_LOCKOUT
    end

    -- ShowTrpController(player_index)
  end
end

-- Post: Ensures that only one TRP is selected for firing.
function OnTrpSelection(player_index, key)
  local list = game.players[player_index].gui.left.trp_ctrl.left_flow.list
  for k,v in pairs(list.children_names) do
    if v ~= key then
      list[v][v].state = false
    end
  end
end

-- Post: Ensures that only one type of round is selected for firing.
function OnRoundTypeSelection(player_index, key)
  local checkbox_flow = game.players[player_index].gui.left.trp_ctrl.center_flow.checkbox_flow
  for k,v in pairs(checkbox_flow.children_names) do
    if v ~= key then
      checkbox_flow[v].state = false
    end
  end
end

-- Post: Sets default options for GUI.
function SetGuiTrpDefaults(player_index)
  local checkbox_flow = game.players[player_index].gui.left.trp_ctrl.center_flow.checkbox_flow
  for k,v in pairs(checkbox_flow.children_names) do
    if v == "HE" then
      checkbox_flow[v].state = true
    else
      checkbox_flow[v].state = false
    end
  end
end

-- Post: Displays the open button.
function ShowOpenButton(player_index)
  GuiRestorePane(player_index)
end

-- Post: Displays the controller.
function ShowTrpController(player_index)
  GuiTrpController(player_index)
end
