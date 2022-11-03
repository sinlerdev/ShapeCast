return function(Vector: Vector3)
	--[[
        We round the axies from the given vector to avoid unwanted results like (0.01, 0.001, 0.02)
    ]]

	return Vector3.new(math.round(Vector.X), math.round(Vector.Y), math.round(Vector.Z))
end
