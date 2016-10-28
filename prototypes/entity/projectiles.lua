data:extend(
{
  {
    type = "projectile",
    name = "mortar-81-he",
    flags = {"not-on-map"},
    acceleration = 0.005,
    speed = 0.1,
    piercing_damage = 50,
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "create-entity",
            entity_name = "medium-explosion",
            check_buildability = true
          },
          {
            type = "nested-result",
            action =
            {
              type = "direct",
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "damage",
                    damage =
                    {
                      type = "physical",
                      amount = 30
                    }
                  }
                }
              }
            }
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              perimeter = 3,
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "damage",
                    damage =
                    {
                      type = "explosion",
                      amount = 80
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    light = {intensity = 0, size = 1},
    animation =
    {
      filename = "__FIST__/graphics/icons/blank.png",
      frame_count = 1,
      line_length = 1,
      width = 8,
      height = 8,
      shift = {0, 0},
      priority = "high"
    }
  },
  {
    type = "projectile",
    name = "mortar-81-vt",
    flags = {"not-on-map"},
    acceleration = 0.005,
    speed = 0.1,
    piercing_damage = 0,
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "create-entity",
            entity_name = "explosion",
            check_buildability = true
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              perimeter = 6,
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "damage",
                    damage =
                    {
                      type = "explosion",
                      amount = 60
                    },
                    {
                      type = "create-entity",
                      entity_name = "explosion"
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    light = {intensity = 0, size = 1},
    animation =
    {
      filename = "__FIST__/graphics/icons/blank.png",
      frame_count = 1,
      line_length = 1,
      width = 8,
      height = 8,
      shift = {0, 0},
      priority = "high"
    }
  }
}
)
