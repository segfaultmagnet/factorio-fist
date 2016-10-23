data:extend(
{
  {
    type = "technology",
    name = "fist-1",
    icon = "__FIST__/graphics/technology/fist.png",
    effects =
    {
--[[
      {
        type = "unlock-recipe",
        recipe = "mortar-60"
      },
--]]
      {
        type = "unlock-recipe",
        recipe = "fdc"
      },
      {
        type = "unlock-recipe",
        recipe = "fo-gun"
      }
    },
    prerequisites = {"military-3"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1},
        {"alien-science-pack", 1}
      },
      time = 15
    }
  }
}
)
