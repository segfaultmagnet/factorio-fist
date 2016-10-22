--[[
function turkeyrunanimation()
  return
  {
    layers=
    {
      {
        width = 70,
        height = 70,
        direction_count = 4,
        frame_count = 4,
        scale = 0.5,
        stripes =
        {
         {
          filename = "__Tofurkey__/graphics/entity/turkey/turkey-run.png",
          width_in_frames = 4,
          height_in_frames = 4,
         }
        }
      }
    }
  }
end

function turkeyattackanimation()
  return
  {
    layers=
    {
      {
        width = 70,
        height = 70,
        animation_speed = 0.3,
        direction_count = 4,
        frame_count = 2,
        scale = 0.5,
        stripes =
        {
          {
            filename = "__Tofurkey__/graphics/entity/turkey/turkey-attack.png",
            width_in_frames = 2,
            height_in_frames = 4,
          }
        }
      }
    }
  }
end

function turkeydieanimation()
  return
  {
    layers=
    {
      {
        width = 90,
        height = 80,
        direction_count = 4,
        frame_count = 3,
        scale = 0.5,
        stripes =
        {
          {
            filename = "__Tofurkey__/graphics/entity/turkey/turkey-die.png",
            width_in_frames = 3,
            height_in_frames = 4,
          }
        }
      }
    }
  }
end
--]]
