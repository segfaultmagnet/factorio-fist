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
    type = "decorative",
    name = "minus",
    flags = {"not-on-map"},
    icon = "__FIST__/graphics/icons/minus.png",
    pictures =
    {
      {
        filename = "__FIST__/graphics/icons/minus.png",
        width = 32,
        height = 32
      }
    }
  },
  {
    type = "decorative",
    name = "plus",
    flags = {"not-on-map"},
    icon = "__FIST__/graphics/icons/plus.png",
    pictures =
    {
      {
        filename = "__FIST__/graphics/icons/plus.png",
        width = 32,
        height = 32
      }
    }
  },
  {
    type = "explosion",
    name = "gunshot-howitzer",
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
    light = {intensity = 2, size = 20},
    smoke = "smoke-fast",
    smoke_count = 3,
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
          volume = 1
        },
        {
          filename = "__base__/sound/fight/heavy-gunshot-2.ogg",
          volume = 1
        },
        {
          filename = "__base__/sound/fight/heavy-gunshot-3.ogg",
          volume = 1
        },
        {
          filename = "__base__/sound/fight/heavy-gunshot-3.ogg",
          volume = 1
        }
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
    light = {intensity = 1, size = 6},
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
          volume = 0.6
        },
        {
          filename = "__base__/sound/fight/heavy-gunshot-2.ogg",
          volume = 0.6
        },
        {
          filename = "__base__/sound/fight/heavy-gunshot-3.ogg",
          volume = 0.6
        },
        {
          filename = "__base__/sound/fight/heavy-gunshot-3.ogg",
          volume = 0.6
        }
      }
    }
  }
}
)
