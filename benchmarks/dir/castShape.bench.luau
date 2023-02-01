local ShapeCast = require(game:GetService("ReplicatedStorage").ShapeCast)

local createShape = ShapeCast.createShape
local castShape = ShapeCast.castShape

local origin = Vector3.zero
local direction = Vector3.new(0, 10, 0)

local function caster()
    return 1
end

return {
    {
        name = "castShape with 2*3 square + distances set to the default |",
        calls = 20_000,

        preRun = function()
            return createShape {
                Shape = {
                    {true, true, true},
                    {true, true, true}
                },

                DepthGrid = {
                    {0, 0, 0},
                    {0, 0, 0},
                },
            }
        end,
        run = function(p)
            castShape(p, origin, direction, caster)
        end
    },
    {
        name = "castShape with 3*3 sqaure + distances set to 10|",
        calls = 20_000,

        preRun = function()
            return createShape {
                Shape = {
                    {true, true, true},
                    {true, true, true},
                    {true, true, true}
                },
                DepthGrid = {
                    {0, 0, 0},
                    {0, 0, 0},
                    {0, 0, 0},
                },
                PointDistance = 10,
                PlaneDistance = 10
            }
        end,
        run = function(s)
            castShape(s, origin, direction, caster)
        end
    }
}