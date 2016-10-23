data:extend(
{
  {
    type = "projectile",
    name = "mortar-60-he",
    flags = {"not-on-map"},
    acceleration = 0.005,
    piercing_damage = 10,
    action =
    {
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
                amount = 5
              }
            }
          }
        },
        final_action = 
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
                  type = "area",
                  perimeter = 4,
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
                          amount = 20
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    animation =
    {
      filename = "__FIST__/graphics/icons/blank.png",
      frame_count = 1,
      width = 5,
      height = 5,
      priority = "high"
    }
  }
}
)
