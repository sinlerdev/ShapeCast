local benchmark = require(script.Parent.benchmark)

local function readDir(dir: Instance)
	local serDir = {}

	for _, dirFile: Instance in dir:GetChildren() do
		if dirFile:IsA("ModuleScript") and dirFile.Name:match("%.bench") then
			local requiredFile = require(dirFile)
			local fileSections = {}

			for _, benchSection in requiredFile do
				fileSections[benchSection.name] = benchmark(
					benchSection.calls,
					benchSection.preRun or function() end,
					benchSection.run,
					benchSection.postRun or function() end
				)()
				task.wait()
			end

			serDir[dirFile.Name] = fileSections
		else
			serDir[dirFile.Name] = readDir(dirFile)
		end
	end

	return serDir
end

return readDir
