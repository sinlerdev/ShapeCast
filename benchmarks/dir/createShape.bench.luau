local ShapeCast = require(game:GetService("ReplicatedStorage").ShapeCast)

local createShape = ShapeCast.createShape

return {
    {
        name = "createShape with 2*3 square + distances set to the default |",
        calls = 20_000,

        preRun = function()
            return {
                Shape = {
                    {true, true, true},
                    {true, true, true}
                },

                DepthGrid = {
                    {0, 0, 0},
                    {0, 0, 0}
                }
            }
        end,
        run = function(p)
            createShape(p)
        end
    },
    {
        name = "createShape with 3*3 sqaure + distances set to 10 |",
        calls = 20_000,

        preRun = function()
            return {
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
            createShape(s)
        end
    }
}