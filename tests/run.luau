-- Runs every tests/*.spec.luau with Lune.   Usage (repo root):  lune run tests/run

local fs = require("@lune/fs")
local process = require("@lune/process")

local TestKit = require("./TestKit")

local files = fs.readDir("tests")
table.sort(files)

for _, file in files do
	local name = string.match(file, "^(.+%.spec)%.luau$")
	if name then
		print(file)
		local spec = (require :: any)("./" .. name)
		spec(TestKit)
	end
end

print(string.format("\n%d passed, %d failed", TestKit.passed, TestKit.failed))
if TestKit.failed > 0 or TestKit.passed == 0 then
	process.exit(1)
end
