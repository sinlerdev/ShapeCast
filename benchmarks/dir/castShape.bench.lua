local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShapeCast = require(ReplicatedStorage.ShapeCast)

local castShape = ShapeCast.castShape
local createShape = ShapeCast.createShape

local pos = Vector3.zero
local direction = Vector3.new(0,100,0)

return {
	{

		name = "casting two planes with 4 steps each - 1 for point/plane advancements",
		calls = 10_000,
		preRun = function()
			return createShape({
				Steps = {
					{ true, true, true, true },
					{ true, true, true, true },
				},
			})
		end,
		run = function(param)
			castShape(param, pos, direction)
		end,
	},
	{
		name = "casting two planes with 4 step each - 0.5 for point/plane advancements",
		calls = 10_000,
		preRun = function()
			return createShape({
				Steps = {
					{ true, true, true, true },
					{ true, true, true, true },
				},
				PlaneAdvancement = 0.5,
				PointAdvancement = 0.5,
			})
		end,
		run = function(param)
			castShape(param, pos, direction)
		end,
	},
	{
		name = "casting two planes with 4 step each - 0.1 for point/plane advancements",
		calls = 10_000,
		preRun = function()
			return createShape({
				Steps = {
					{ true, true, true, true },
					{ true, true, true, true },
				},
				PlaneAdvancement = 0.1,
				PointAdvancement = 0.1,
			})
		end,
		run = function(param)
			castShape(param, pos, direction)
		end,
	},
	-- stress test
	{
		name = "stress test - casting 5 for planes and points, 0.1 for advancements",
		calls = 10_000,

		preRun = function()
			return createShape({
				Steps = {
					{ true, true, true, true, true },
					{ true, true, true, true, true },
					{ true, true, true, true, true },
					{ true, true, true, true, true },
					{ true, true, true, true, true },
				},
				PlaneAdvancement = 0.1,
				PointAdvancement = 0.1,
			})
		end,

		run = function(param)
			castShape(param, pos, direction)
		end,
	},
}
