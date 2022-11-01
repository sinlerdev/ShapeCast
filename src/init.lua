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
}

local resolveDirections = require(script.resolveDirections)
local visualizer = require(script.Visualizer).new({
	RAY_COLOR = Color3.fromRGB(255, 0, 0),
	RAY_WIDTH = 1,
	RAY_NAME = "sup",
	FAR_AWAY_CFRAME = CFrame.new(math.huge, math.huge, math.huge),
	EXPIRE_AFTER = 1,
})

visualizer:PrepareLines(100 * 16)

local function createShape(config: ShapeConfig)
	local numOfPlanes = #config.Steps
	local stepInfo = table.create(numOfPlanes) :: { set<set<Vector3>> }
	local planeInfo = {}
	local lastPointVector = Vector3.zero
	local lastPlaneVector = Vector3.zero
	
	for _, plane in config.Steps do
		local computedSteps = table.create(#plane)

		local planeGroup = {}
		for i = config.PlaneAdvancement, 1, config.PlaneAdvancement do
			local I = i
			
			table.insert(planeGroup, lastPlaneVector + Vector3.new(I, I, I))
		end

		lastPlaneVector += Vector3.one
		for _, isStepIncluded in plane do
			if isStepIncluded then
				local step = {}

				for i = config.PointAdvancement, 1, config.PointAdvancement do
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
	} :: Shape
end

local function castShape(shape: Shape, Position: Vector3, direction: Vector3, shouldDebug: boolean)
	local stepInfo = shape.StepInfo
	local planeInfo = shape.PlaneInfo

	local cframe = CFrame.lookAt(Position, Position + direction)

	local resolvedUp = resolveDirections(cframe.UpVector)
	local resolvedRight = resolveDirections(cframe.RightVector)
	for planeIndex, planeSteps in stepInfo do
		local chosenPlane = planeInfo[planeIndex]

		for _, PlaneVector in chosenPlane do
			local up = resolvedUp * PlaneVector

			for _, Step in planeSteps do
				for _, Point in Step do
					local right = resolvedRight * Point

					workspace:Raycast(Position + (right + up), direction)

					if shouldDebug then
						visualizer:castRay(Position + (right + up), direction)
					end
				end
			end
		end
	end
end

return {
	createShape = createShape,
	castShape = castShape,
}
