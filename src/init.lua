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
}

local visualizer = require(script.Visualizer).new({
	RAY_COLOR = Color3.fromRGB(255, 0, 0),
	RAY_WIDTH = 1,
	RAY_NAME = "sup",
	FAR_AWAY_CFRAME = CFrame.new(math.huge, math.huge, math.huge),
	EXPIRE_AFTER = .5,
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

local function createShape(config: ShapeConfig): Shape
	local numOfPlanes = #config.Steps
	local stepInfo = table.create(numOfPlanes) :: { set<set<Vector3>> }
	local planeInfo = table.create(numOfPlanes) :: { set<Vector3> }
	local lastPointVector = Vector3.zero
	local lastPlaneVector = Vector3.zero

	local PlaneAdvancement = config.PlaneAdvancement or 1
	local PointAdvancement = config.PointAdvancement or 1

	local planeAdvancementIterations = findNumOfIterationFromAdvancement(PlaneAdvancement)
	local pointAdvancementIterations = findNumOfIterationFromAdvancement(PointAdvancement)
	local numOfPoints = 0
	for _, plane in config.Steps do
		local computedSteps = table.create(#plane)

		local planeGroup = table.create(planeAdvancementIterations)
		for i = PlaneAdvancement, 1, PlaneAdvancement do
			local I = i

			table.insert(planeGroup, lastPlaneVector + Vector3.new(I, I, I))
		end

		lastPlaneVector += Vector3.one
		for _, isStepIncluded in plane do
			if isStepIncluded then
				local step = table.create(pointAdvancementIterations)
				numOfPoints += pointAdvancementIterations
				for i = PointAdvancement, 1, PointAdvancement do
					local I = i

					table.insert(step, lastPointVector + Vector3.new(I, I, I))
				end

				table.insert(computedSteps, step)
			end
			lastPointVector += Vector3.one
		end
		lastPointVector = Vector3.zero
		table.insert(planeInfo, planeGroup)
		table.insert(stepInfo, computedSteps)
	end

	return {
		StepInfo = stepInfo,
		PlaneInfo = planeInfo,
		Rays = table.create(numOfPoints),
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

	local upCframe = cframe.UpVector
	local rightCframe = cframe.RightVector
	local resolvedUp = resolveRelativeVector(upCframe)
	local resolvedRight = resolveRelativeVector(rightCframe)

	local pivotPosition = Vector3.new(2,2,2)
	Position -= (resolvedRight * pivotPosition)
	Position -= (resolvedUp * pivotPosition)

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
	createShape = createShape,
	castShape = castShape,
}
