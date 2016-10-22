data:extend(
{
  {
    type = "ammo-category",
    name = "blank"
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
  }
}
)
