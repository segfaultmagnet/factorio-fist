data:extend(
{
  {
    type = "ammo-category",
    name = "blank"
  },
  {
    type = "ammo-category",
    name = "mortar-60"
  },
  {
    type = "ammo",
    name = "fo-gun-blank",
    icon = "__FIST__/graphics/icons/blank.png",
    flags = {"goes-to-main-inventory"},
    magazine_size = 1,
    subgroup = "ammo",
    order = "a-e",
    stack_size = 10,
    ammo_type =
    {
      category = "blank",
      clamp_position = true,
      target_type = "position",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            type = "create-entity",
            entity_name = "fo-target-marker",
            trigger_created_entity = "true"
          }
        }
      }
    }
  },
  {
    type = "ammo",
    name = "mortar-60-he",
    icon = "__FIST__/graphics/icons/mortar-60-he.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "ammo",
    order = "d[mortar-60]-a[he]",
    stack_size = 100,
    ammo_type =
    {
      category = "mortar-60",
      clamp_position = true,
      target_type = "position",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "mortar-60-he",
          starting_speed = 0.5,
          direction_deviation = 0.5,
          range_deviation = 0.5,
          max_range = 50,
          source_effects =
          {
            type = "create-explosion",
            entity_name = "explosion-gunshot"
          }
        }
      }
    }
  }
}
)
