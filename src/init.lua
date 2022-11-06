type ShapeConfig = {
	Steps: { { [number]: boolean } },
	PointAdvancement: number,
	PlaneAdvancement: number,
	PointDistance: number,
	PlaneDistance: number,
}
type set<T> = { T }

type Shape = {
	StepInfo: { set<set<Vector3>> },
	PlaneInfo: { set<Vector3> },
	Rays: { RaycastResult },
	UpPlacer: Vector3,
	RightPlacer: Vector3,
}

local visualizer = require(script.Visualizer).new({
	RAY_COLOR = Color3.fromRGB(255, 0, 0),
	RAY_WIDTH = 1,
	RAY_NAME = "sup",
	FAR_AWAY_CFRAME = CFrame.new(math.huge, math.huge, math.huge),
	EXPIRE_AFTER = 0.5,
})

visualizer:PrepareLines(100 * 16)

local function findNumOfIterationFromAdvancement(advancement: number)
	local finalNum = 0

	for i = advancement, 1, advancement do
		finalNum += 1
	end

	return finalNum
end
local function resolveRelativeVector(Vector: Vector3)
	return Vector3.new(math.round(Vector.X), math.round(Vector.Y), math.round(Vector.Z))
end

local function _bt_createShape(config: ShapeConfig)
	local planeAdvancement = config.PlaneAdvancement or 1
	local pointAdvancement = config.PointAdvancement or 1
	local pointDistance = config.PointDistance or 1
	local planeDistance = config.PlaneDistance or 1

	local iterationsFromPlaneAdvancement = findNumOfIterationFromAdvancement(planeAdvancement)
	local iterationsFromPointAdvancement = findNumOfIterationFromAdvancement(pointAdvancement)

	local lastPlaneLevelVector = Vector3.zero

	local planeInfo = table.create(#config.Steps)
	local stepInfo = table.create(#config.Steps)
	for _, plane in config.Steps do
		local planeLevels = table.create(iterationsFromPlaneAdvancement)

		for planeLevelIndex = 1, iterationsFromPlaneAdvancement do
			local finalProduct = planeLevelIndex * planeDistance

			lastPlaneLevelVector += Vector3.new(finalProduct, finalProduct, finalProduct)
			table.insert(planeLevels, lastPlaneLevelVector)
		end

		table.insert(planeInfo, planeLevels)

		local steps = table.create(#plane)
		local lastStepLevelVector = Vector3.zero
		for _, isDefinedStep in plane do
			if isDefinedStep then
				local stepLevels = table.create(iterationsFromPointAdvancement)

				for stepLevelIndex = 1, iterationsFromPointAdvancement do
					local finalProduct = stepLevelIndex * pointDistance

					lastStepLevelVector += Vector3.new(finalProduct, finalProduct, finalProduct)
					table.insert(stepLevels, lastStepLevelVector)
				end

				table.insert(steps, stepLevels)
			else
				lastStepLevelVector += Vector3.new(pointDistance, pointDistance, pointDistance)
			end
		end

		table.insert(stepInfo, steps)
	end

	return {
		StepInfo = stepInfo,
		PlaneInfo = planeInfo,
		Rays = {},
		UpPlacer = Vector3.new(0, 0, 0),
		RightPlacer = Vector3.new(35, 35, 35),
	} :: Shape
end

local function castShape(
	shape: Shape,
	Position: Vector3,
	direction: Vector3,
	RaycastParam: RaycastParams,
	shouldDebug: boolean
)
	local stepInfo = shape.StepInfo
	local planeInfo = shape.PlaneInfo

	local cframe = CFrame.lookAt(Position, Position + direction)

	local resolvedUp = resolveRelativeVector(cframe.UpVector)
	local resolvedRight = resolveRelativeVector(cframe.RightVector)

	Position -= (resolvedRight * shape.RightPlacer)
	Position -= (resolvedUp * shape.UpPlacer)

	local hit = shape.Rays
	table.clear(hit)

	for planeIndex, planeSteps in stepInfo do
		local chosenPlane = planeInfo[planeIndex]

		for _, PlaneVector in chosenPlane do
			local up = resolvedUp * PlaneVector
			for stepIndex, step in planeSteps do
				for _, point in step do
					local right = resolvedRight * point

					local final = Position + (up + right)

					local result = workspace:Raycast(final, direction)

					if result then
						table.insert(hit, result)
					end

					if shouldDebug then
						visualizer:castRay(final, direction)
					end
				end
			end
		end
	end

	return hit
end

return {
	createShape = _bt_createShape,
	castShape = castShape,
	_bt_createShape = _bt_createShape,
}
