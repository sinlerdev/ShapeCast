--!optimize 2
local LuauBencher = require(script.Parent.LuauBencher)

local BENCHMARK = false

if BENCHMARK then
    task.wait(10)
    print("benchmarking")
    LuauBencher.bootstrapper.run({
        directories = {script.Parent.dir}
    })
end