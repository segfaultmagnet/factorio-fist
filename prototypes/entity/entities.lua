data:extend(
{
  {
    type = "explosion",
    name = "fo-target-marker",
    flags = {"not-on-map"},
    animations =
    {
      {
        filename = "__core__/graphics/empty.png",
        priority = "extra-high",
        width = 1,
        height = 1,
        frame_count = 1
      }
    }
  },

  {
    type = "explosion",
    name = "gunshot-mortar",
    flags = {"not-on-map"},
    animations =
    {
      {
        filename = "__base__/graphics/entity/explosion-gunshot/explosion-gunshot.png",
        priority = "extra-high",
        width = 34,
        height = 38,
        frame_count = 2,
        animation_speed = 1.5,
        shift = {0, 0}
      },
      {
        filename = "__base__/graphics/entity/explosion-gunshot/explosion-gunshot.png",
        priority = "extra-high",
        width = 34,
        height = 38,
        x = 34 * 2,
        frame_count = 2,
        animation_speed = 1.5,
        shift = {0, 0}
      },
      {
        filename = "__base__/graphics/entity/explosion-gunshot/explosion-gunshot.png",
        priority = "extra-high",
        width = 34,
        height = 38,
        x = 34 * 4,
        frame_count = 3,
        animation_speed = 1.5,
        shift = {0, 0}
      },
      {
        filename = "__base__/graphics/entity/explosion-gunshot/explosion-gunshot.png",
        priority = "extra-high",
        width = 34,
        height = 38,
        x = 34 * 7,
        frame_count = 3,
        animation_speed = 1.5,
        shift = {0, 0}
      },
      {
        filename = "__base__/graphics/entity/explosion-gunshot/explosion-gunshot.png",
        priority = "extra-high",
        width = 34,
        height = 38,
        x = 34 * 10,
        frame_count = 3,
        animation_speed = 1.5,
        shift = {0, 0}
      }
    },
    rotate = true,
    light = {intensity = 1, size = 10},
    smoke = "smoke-fast",
    smoke_count = 1,
    smoke_slow_down_factor = 1,
    sound =
    {
      aggregation =
      {
        max_count = 1,
        remove = true
      },
      variations =
      {
        {
          filename = "__base__/sound/fight/heavy-gunshot-1.ogg",
          volume = 0.75
        },
        {
          filename = "__base__/sound/fight/heavy-gunshot-2.ogg",
          volume = 0.75
        },
        {
          filename = "__base__/sound/fight/heavy-gunshot-3.ogg",
          volume = 0.75
        },
        {
          filename = "__base__/sound/fight/heavy-gunshot-3.ogg",
          volume = 0.75
        }
      }
    }
  }
}
)
