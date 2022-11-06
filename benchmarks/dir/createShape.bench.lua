local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShapeCast = require(ReplicatedStorage.ShapeCast)

local createShape = ShapeCast.createShape
return {
    {
      
        name = "two plane with 4 steps each - 1 for point/plane advancements",
        calls = 10_000,
        preRun = function()
            return {
                Steps = {
                    {true, true, true, true},
                    {true, true, true, true}
                }
            }
        end,
        run = function(param)
            createShape(param)
        end,
    },
    {
        name = "two planes with 4 step each - 0.5 for point/plane advancements",
        calls = 10_000,
        preRun = function()
            return {
                Steps = {
                    {true, true, true, true},
                    {true, true, true, true}
                },
                PlaneAdvancement = 0.5,
                PointAdvancement = 0.5
            }
        end,
        run = function(param)
            createShape(param)
        end
    },
    {
        name = "two planes with 4 step each - 0.1 for point/plane advancements",
        calls = 10_000,
        preRun = function()
            return {
                Steps = {
                    {true, true, true, true},
                    {true, true, true, true}
                },
                PlaneAdvancement = 0.1,
                PointAdvancement = 0.1
            }
        end,
        run = function(param)
            createShape(param)
        end
    },
    -- stress test
    {
        name = "stress test - 5 for planes and points, 0.1 for advancements",
        calls = 10_000,

        preRun = function()
            return {
                Steps = {
                    {true, true, true, true, true},
                    {true, true, true, true, true},
                    {true, true, true, true, true},
                    {true, true, true, true, true},
                    {true, true, true, true, true},
                },
                PlaneAdvancement = 0.1,
                PointAdvancement = 0.1
            }
        end,

        run = function(param)
            createShape(param)
        end
    }
}