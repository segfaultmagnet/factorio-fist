data:extend(
{
  {
    type = "logistic-container",
    name = "fdc",
    icon = "__FIST__/graphics/icons/fdc.png",
    flags = {"placeable-player", "player-creation"},
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    corpse = "medium-remnants",
    dying_explosion = "medium-explosion",
    inventory_size = 10,
    logistic_mode = "requester",
    max_health = 200,
    minable = {mining_time = 0.5, result = "fdc"},
    circuit_wire_connection_point =
    {
      shadow =
      {
        red = {0, 0},
        green = {0.2, 0.1},
      },
      wire =
      {
        red = {0, 0},
        green = {0.2, 0.1},
      }
    },
    circuit_wire_max_distance = 3,
    resistances =
    {
      {
        type = "physical",
        decrease = 2,
        percent = 10
      },
      {
        type = "explosion",
        decrease = 2,
        percent = 10
      },
      {
        type = "fire",
        decrease = 5,
        percent = 20
      }
    },
    picture =
    {
      filename = "__FIST__/graphics/entity/fdc.png",
      priority = "high",
      width = 100,
      height = 101
    },
    vehicle_impact_sound =
    {
      filename = "__base__/sound/car-metal-impact.ogg",
      volume = 0.65
    }
  },
  {
    type = "inserter",
    name = "mortar-81",
    icon = "__FIST__/graphics/icons/mortar-81.png",
    flags = {"placeable-player", "player-creation"},
    collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
    selection_box = {{-1, -1}, {1, 1}},
    resistances =
    {
      {
        type = "explosion",
        decrease = 1,
        percent = 10
      },
      {
        type = "fire",
        decrease = 2,
        percent = 10
      }
    },
    corpse = "small-remnants",
    dying_explosion = "medium-explosion",
    inventory_size = 1,
    max_health = 150,
    minable = {mining_time = 0.5, result = "mortar-81"},
    inventory_size = 0,
    pickup_position = {0, -1},
    insert_position = {0, 1},
    energy_per_movement = 0,
    energy_per_rotation = 0,
    energy_source = { type = "burner", effectivity = 1, fuel_inventory_size = 1 },
    rotation_speed = 0.01,
    extension_speed = 0.01,
    vehicle_impact_sound =
    {
      filename = "__base__/sound/car-metal-impact.ogg",
      volume = 0.65
    },
    platform_picture =
    {
      north =
      {
        filename = "__FIST__/graphics/entity/mortar-81.png",
        priority = "high",
        width = 60,
        height = 60
      },
      east =
      {
        filename = "__FIST__/graphics/entity/mortar-81.png",
        priority = "high",
        width = 60,
        height = 60
      },
      south =
      {
        filename = "__FIST__/graphics/entity/mortar-81.png",
        priority = "high",
        width = 60,
        height = 60
      },
      west =
      {
        filename = "__FIST__/graphics/entity/mortar-81.png",
        priority = "high",
        width = 60,
        height = 60
      }
    },
    hand_base_picture =
    {
      filename = "__core__/graphics/empty.png",
      priority = "low",
      width = 1,
      height = 1,
    },
    hand_open_picture =
    {
      filename = "__core__/graphics/empty.png",
      priority = "low",
      width = 1,
      height = 1,
    },
    hand_closed_picture =
    {
      filename = "__core__/graphics/empty.png",
      priority = "low",
      width = 1,
      height = 1,
    },
    circuit_wire_connection_point =
    {
      shadow =
      {
        red = {0, 0},
        green = {0.2, 0.1},
      },
      wire =
      {
        red = {0, 0},
        green = {0.2, 0.1},
      }
    },
    circuit_wire_max_distance = 3
  }

--[[ Old mortar-81 definition:

  {
    type = "logistic-container",
    name = "mortar-81",
    icon = "__FIST__/graphics/icons/mortar-81.png",
    flags = {"placeable-player", "player-creation"},
    collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
    selection_box = {{-1, -1}, {1, 1}},
    corpse = "small-remnants",
    dying_explosion = "medium-explosion",
    inventory_size = 1,
    logistic_mode = "requester",
    max_health = 150,
    minable = {mining_time = 0.5, result = "mortar-81"},
    circuit_wire_connection_point =
    {
      shadow =
      {
        red = {0, 0},
        green = {0.2, 0.1},
      },
      wire =
      {
        red = {0, 0},
        green = {0.2, 0.1},
      }
    },
    circuit_wire_max_distance = 3,
    resistances =
    {
      {
        type = "explosion",
        decrease = 1,
        percent = 10
      },
      {
        type = "fire",
        decrease = 2,
        percent = 10
      }
    },
    picture =
    {
      filename = "__FIST__/graphics/entity/mortar-81.png",
      priority = "high",
      width = 60,
      height = 60
    },
    vehicle_impact_sound =
    {
      filename = "__base__/sound/car-metal-impact.ogg",
      volume = 0.65
    }
  }

--]]

}
)
