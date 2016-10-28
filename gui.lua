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
  trp_ctrl.center_flow.add
  {
    type = "flow",
    name = "type_flow",
    direction = "vertical"
  }
  -- Labels.
  for k,_ in pairs(ROUND_DESCRIPTION) do
    trp_ctrl.center_flow.type_flow.add
    {
      type = "table",
      name = k,
      colspan = 2
    }
    trp_ctrl.center_flow.type_flow[k].add
    {
      type = "label",
      name = "label",
      caption = k
    }
    trp_ctrl.center_flow.type_flow[k].label.style.minimal_width = 40
    trp_ctrl.center_flow.type_flow[k].add
    {
      type = "checkbox",
      name = "checkbox",
      state = false
    }
    trp_ctrl.center_flow.type_flow[k].checkbox.style.top_padding = 4
    trp_ctrl.center_flow.type_flow[k].checkbox.tooltip = v
  end

  -- Round count selection.
  trp_ctrl.center_flow.add
  {
    type = "label",
    name = "label_round_count",
    caption = "Round Count"
  }
  trp_ctrl.center_flow.add
  {
    type = "flow",
    name = "round_count_table",
    colspan = 3
  }
  trp_ctrl.center_flow.round_count_table.add
  {
    type = "sprite-button",
    name = "button_rounds_down",
    sprite = "entity/minus"
  }
  trp_ctrl.center_flow.round_count_table.button_rounds_down.style.minimal_width = 25
  trp_ctrl.center_flow.round_count_table.button_rounds_down.style.maximal_width = 25
  trp_ctrl.center_flow.round_count_table.button_rounds_down.style.minimal_height = 25
  trp_ctrl.center_flow.round_count_table.button_rounds_down.style.maximal_height = 25
  trp_ctrl.center_flow.round_count_table.add
  {
    type = "label",
    name = "round_count",
    caption = "1"
  }
  -- trp_ctrl.center_flow.round_count_table.round_count.style.left_padding = 2
  trp_ctrl.center_flow.round_count_table.round_count.style.minimal_width = 10
  trp_ctrl.center_flow.round_count_table.round_count.style.maximal_width = 10
  trp_ctrl.center_flow.round_count_table.add
  {
    type = "sprite-button",
    name = "button_rounds_up",
    sprite = "entity/plus"
  }
  trp_ctrl.center_flow.round_count_table.button_rounds_up.style.minimal_width = 25
  trp_ctrl.center_flow.round_count_table.button_rounds_up.style.maximal_width = 25
  trp_ctrl.center_flow.round_count_table.button_rounds_up.style.minimal_height = 25
  trp_ctrl.center_flow.round_count_table.button_rounds_up.style.maximal_height = 25

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

-- Post: Changes the number of selected rounds to fire.
function OnButtonRoundCount(player_index, name)
  local round_count_label = game.players[player_index].gui.left.trp_ctrl.center_flow.round_count_table.round_count
  local round_count = tonumber(round_count_label.caption)
  if name == "button_rounds_up" and round_count < MAX_ROUNDS then
    round_count = round_count + 1
  elseif name == "button_rounds_down" and round_count > 1 then
    round_count = round_count - 1
  end
  round_count_label.caption = round_count
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
  local round_type = "HE"
  local round_count = 0
  local trp_ctrl = game.players[player_index].gui.left.trp_ctrl

  if fire_button_disable == 0 then
    -- Get targets to fire and insert into fire mission queue.
    local list = trp_ctrl.left_flow.list
    for k,v in pairs(list.children_names) do
      if list[v][v].state == true then
        table.insert(global.new_fire_missions, v)
      end
    end

    -- Get round type to fire.
    local type_flow = trp_ctrl.center_flow.type_flow
    for _,v in pairs(type_flow.children_names) do
      if type_flow[v].checkbox.state == true then
        round_type = v
        break
      end
    end

    -- Get round count.
    round_count = tonumber(trp_ctrl.center_flow.round_count_table.round_count.caption)
    assert(round_count > 0 and round_count <= MAX_ROUNDS)

    -- Call the fire mission(s).
    if #global.new_fire_missions > 0 then
      EvaluateNewFireMissions(player_index, gun_type, round_type, round_count)
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
  local type_flow = game.players[player_index].gui.left.trp_ctrl.center_flow.type_flow
  for k,v in pairs(type_flow.children_names) do
    if v ~= key then
      type_flow[v].checkbox.state = false
    end
  end
  if type_flow[key].checkbox.state == false then
    SetGuiTrpDefaults(player_index)
  end
end

-- Post: Sets default options for GUI.
function SetGuiTrpDefaults(player_index)
  local center_flow = game.players[player_index].gui.left.trp_ctrl.center_flow
  for k,v in pairs(center_flow.type_flow.children_names) do
    if v == "HE" then
      center_flow.type_flow[v].checkbox.state = true
    else
      center_flow.type_flow[v].checkbox.state = false
    end
  end
  center_flow.round_count_table.round_count.caption = 1
end

-- Post: Displays the open button.
function ShowOpenButton(player_index)
  GuiRestorePane(player_index)
end

-- Post: Displays the controller.
function ShowTrpController(player_index)
  GuiTrpController(player_index)
end
