return function(Vector: Vector3)
	--[[
        We round the axies from the given vector to avoid unwanted results like (0.01, 0.001, 0.02)
    ]]

	local X = math.round(Vector.X)
	local Y = math.round(Vector.Y)
	local Z = math.round(Vector.Z)

	local newVector: Vector3 = Vector3.new(X, Y, Z)

	return newVector
end
