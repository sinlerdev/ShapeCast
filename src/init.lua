export type ShapeInfo = {
	Shape: { { true } },
	DepthGrid: { { number } },
	PointDistance: number?,
	PlaneDistance: number?,
}

export type Shape = { Vector3 }

local ShapeCast = {}

function ShapeCast.createShape(info: ShapeInfo): Shape
	local Shape = info.Shape
	local DepthGrid = info.DepthGrid

	local finalShape: Shape = {}
	local PointDistance = info.PointDistance or 1
	local PlaneDistance = info.PlaneDistance or 1
	local finalPlaneIndex = math.round((#Shape - 1) * PlaneDistance / 2)

	for planeIndex, planeContent in Shape do
		local planeContentInDepth = DepthGrid[planeIndex]
		local finalPointIndex = math.round((#planeContent - 1) * PointDistance / 2)

		local upComp = (planeIndex - 1) * PlaneDistance - finalPlaneIndex
		for pointIndex, isPointThere in planeContent do
			if not isPointThere then
				continue
			end
			table.insert(
				finalShape,
				Vector3.new((pointIndex - 1) * PointDistance - finalPointIndex, upComp, planeContentInDepth[pointIndex])
			)
		end
	end

	return finalShape
end

local function roundVector(Vector: Vector3)
	return Vector3.new(math.round(Vector.X), math.round(Vector.Y), math.round(Vector.Z))
end

function ShapeCast.castShape(shape: Shape, origin: Vector3, direction: Vector3, raycaster)
	local selfCframe = CFrame.lookAt(origin, origin + direction)
	local upVector = roundVector(selfCframe.UpVector)
	local rightVector = roundVector(selfCframe.RightVector)
	local lookVector = roundVector(selfCframe.LookVector)

	local tbl = table.create(#shape)
	for _, vector3 in shape do
		local finalOrigin = origin + ((upVector * vector3.Y) + (rightVector * vector3.X) + (lookVector * vector3.Z))

		local result = raycaster(raycaster, finalOrigin, direction)

		if result then
			table.insert(tbl, result)
		end
	end

	return tbl
end

ShapeCast.visualizer = require(script.Visualizer)

return ShapeCast
