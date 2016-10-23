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
    logistic_mode = "storage",
    max_health = 200,
    minable = {mining_time = 0.5, result = "fdc"},
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
    type = "container",
    name = "mortar-60",
    icon = "__FIST__/graphics/icons/mortar-60.png",
    flags = {"placeable-player", "player-creation"},
    collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
    selection_box = {{-1, -1}, {1, 1}},
    corpse = "small-remnants",
    dying_explosion = "medium-explosion",
    inventory_size = 1,
    max_health = 150,
    minable = {mining_time = 0.5, result = "mortar-60"},
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
      filename = "__FIST__/graphics/entity/mortar-60.png",
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
}
)