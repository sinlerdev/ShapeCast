
type configTypes = {
	RAY_COLOR: Color3,
	RAY_WIDTH: number,
	RAY_NAME: string,
	FAR_AWAY_CFRAME: CFrame,
}


local function createLine(RAY_NAME, RAY_COLOR, RAY_WIDTH, FAR_AWAY_CFRAME, origin)
	local line: LineHandleAdornment = Instance.new("LineHandleAdornment")
	line.Name = RAY_NAME
	line.Color3 = RAY_COLOR
	line.Thickness = RAY_WIDTH

	line.Length = 0
	line.CFrame = FAR_AWAY_CFRAME

	line.Adornee = origin
	line.Parent = origin
	return line
end


local Visualizer = {}
Visualizer.__index = Visualizer

function Visualizer.new(config : configTypes)
	local self = setmetatable({
		InUse = {},
		InCache = {},
		RAY_COLOR = config.RAY_COLOR,
		RAY_WIDTH = config.RAY_WIDTH,
		RAY_NAME = config.RAY_NAME,
		FAR_AWAY_CFRAME = config.FAR_AWAY_CFRAME,
	}, Visualizer)
		
	local OriginPart = Instance.new("Part")
	OriginPart.Name = "ORIGIN_PART"
	OriginPart.Transparency = 1
	OriginPart.Orientation = Vector3.zero
	OriginPart.Position = Vector3.zero
	OriginPart.CanCollide = false
	OriginPart.CanTouch = false
	OriginPart.CanQuery = false
	OriginPart.Anchored = true
	OriginPart.Parent = workspace
	
	self.origin = OriginPart

	

	return self
end


function Visualizer:PrepareLines(numOfLines : number)
	for Index = 1, numOfLines do
		local currentLine = createLine(
			self.RAY_NAME,
			self.RAY_COLOR,
			self.RAY_WIDTH, 
			self.FAR_AWAY_CFRAME,
			self.origin
		)
		
		self.InCache[currentLine] = true
	end
	
end

function Visualizer:getAdornmentFromCache(ignoreError : boolean)
	for Cache in self.InCache do
		return Cache
	end
	
	if not ignoreError then
		error("Visualizing rays before prepartion.", 2)	
	end

	return nil
end

function Visualizer:castRay(origin : Vector3, direction : Vector3)
	local currentLine : LineHandleAdornment = self:getAdornmentFromCache(true)
	
	if not currentLine then
		self:PrepareLines(1)
		self:castRay(origin, direction)
		return
	end
	
	
	local PartToUse = self.origin
	
	self.InCache[currentLine] = nil
	self.InUse[currentLine] = true
		
	currentLine.Length = direction.Magnitude
	currentLine.CFrame = CFrame.lookAt(origin, origin + direction)
	currentLine.Adornee = PartToUse
	currentLine.Parent = PartToUse
	
	task.delay(0.5, function()
		currentLine.Length = 0		
		currentLine.CFrame = self.FAR_AWAY_CFRAME

		self.InUse[currentLine] = nil
		self.InCache[currentLine] = true
	end)
end

return Visualizer