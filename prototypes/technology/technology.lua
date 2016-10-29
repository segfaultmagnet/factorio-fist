data:extend(
{
  {
    type = "technology",
    name = "fist-1",
    icon = "__FIST__/graphics/technology/fist.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "fdc"
      },
      {
        type = "unlock-recipe",
        recipe = "mortar-81"
      },
      {
        type = "unlock-recipe",
        recipe = "mortar-81-he"
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
  },
  {
    type = "technology",
    name = "fist-2",
    icon = "__FIST__/graphics/technology/fist.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "howitzer-155"
      },
      {
        type = "unlock-recipe",
        recipe = "howitzer-155-he"
      }
    },
    prerequisites = {"fist-1"},
    unit =
    {
      count = 250,
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
