-- Generates Map.rbxmx for every map that has a build.luau (or the ones named).
--   lune run scripts/build-maps                 regenerate all
--   lune run scripts/build-maps lava-run        regenerate one
--   lune run scripts/build-maps --check         CI: fail if any Map.rbxmx is out of date with its build.luau

local fs = require("@lune/fs")
local process = require("@lune/process")
local roblox = require("@lune/roblox")

local MapKit = require("../tools/MapKit")

local check = false
local only: { [string]: boolean } = {}
local anyNamed = false
for _, arg in process.args do
	if arg == "--check" then
		check = true
	else
		only[arg] = true
		anyNamed = true
	end
end

local stale = 0
local dirs = fs.readDir("maps")
table.sort(dirs)

for _, dir in dirs do
	local script = "maps/" .. dir .. "/build.luau"
	if fs.isFile(script) and (not anyNamed or only[dir]) then
		local build = (require :: any)("../maps/" .. dir .. "/build")
		local model = build(MapKit)
		assert(model and model.Name == "Map", dir .. "/build.luau must return MapKit.map()")
		local out = "maps/" .. dir .. "/Map.rbxmx"

		if check then
			local current = fs.isFile(out) and roblox.deserializeModel(fs.readFile(out))[1]
			if not current or MapKit.fingerprint(current) ~= MapKit.fingerprint(model) then
				stale += 1
				print("  STALE " .. out .. " — run: lune run scripts/build-maps " .. dir)
			else
				print("  ok    " .. out)
			end
		else
			fs.writeFile(out, roblox.serializeModel({ model }, true))
			print("  wrote " .. out)
		end
	end
end

if stale > 0 then
	print(
		"\nA map built by code was edited by hand (or not regenerated). Change build.luau, then regenerate."
	)
	process.exit(1)
end
