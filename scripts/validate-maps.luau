-- Checks every maps/<name>/ folder. Run from the repo root:  lune run scripts/validate-maps
--
-- Fails when a map:
--   * has a folder name that isn't kebab-case (or _template)
--   * is missing map.json / default.project.json / Map.rbxmx, or map.json lacks a required field
--   * has a Map.rbxmx that doesn't load, or whose root isn't a Model named "Map"
--   * has no SpawnLocation
--   * contains ANY script inside the geometry (free-model backdoors hide there; code lives in
--     src/ or maps/<name>/scripts/ where reviewers can read it)
--   * has Checkpoints that skip a number (Stage1, Stage2, Stage4)
--   * is bigger than the size / part budget below
--   * has a Course (P001, P002, ...) with a jump a default character can't fairly make

local fs = require("@lune/fs")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")

local Jump = require("../src/shared/Jump")
local Stages = require("../src/shared/Stages")

local function asBox(part: any)
	local p, s = part.CFrame.Position, part.Size
	return { position = { x = p.X, y = p.Y, z = p.Z }, size = { x = s.X, y = s.Y, z = s.Z } }
end

local MAX_FILE_MB = 25
local MAX_PARTS = 30000
local STATUSES = { template = true, wip = true, testing = true, published = true }

local failures = 0

local function fail(map: string, message: string)
	failures += 1
	print(string.format("  FAIL  %s: %s", map, message))
end

local function checkMap(dir: string)
	local root = "maps/" .. dir
	local before = failures
	-- kebab-case: lowercase letters/digits separated by single hyphens (Lua patterns have no groups)
	local kebab = string.match(dir, "^[a-z0-9][a-z0-9%-]*$") ~= nil
		and string.find(dir, "--", 1, true) == nil
		and string.sub(dir, -1) ~= "-"
	if dir ~= "_template" and not kebab then
		fail(dir, "folder name must be kebab-case, e.g. lava-run")
	end

	for _, file in { "map.json", "default.project.json", "Map.rbxmx" } do
		if not fs.isFile(root .. "/" .. file) then
			fail(dir, "missing " .. file)
			return
		end
	end

	-- map.json
	local ok, meta = pcall(serde.decode, "json" :: any, fs.readFile(root .. "/map.json"))
	if not ok or type(meta) ~= "table" then
		fail(dir, "map.json is not valid JSON")
		return
	end
	for _, key in { "name", "description", "owner", "status" } do
		if type(meta[key]) ~= "string" or meta[key] == "" then
			fail(dir, 'map.json needs a non-empty "' .. key .. '"')
		end
	end
	if meta.status and not STATUSES[meta.status] then
		fail(dir, "map.json status must be one of template, wip, testing, published")
	end
	if
		meta.status == "published" and (type(meta.universeId) ~= "number" or type(meta.placeId) ~= "number")
	then
		fail(dir, "a published map needs numeric universeId and placeId")
	end

	-- project name matches folder
	local projectOk, project =
		pcall(serde.decode, "json" :: any, fs.readFile(root .. "/default.project.json"))
	if not projectOk or type(project) ~= "table" then
		fail(dir, "default.project.json is not valid JSON")
	elseif project.name ~= dir then
		fail(dir, 'default.project.json "name" must be "' .. dir .. '"')
	end

	-- geometry
	local bytes = fs.readFile(root .. "/Map.rbxmx")
	if #bytes > MAX_FILE_MB * 1024 * 1024 then
		fail(dir, string.format("Map.rbxmx is over %d MB — split it or remove unused assets", MAX_FILE_MB))
	end
	local loaded, instances = pcall(roblox.deserializeModel, bytes)
	if not loaded then
		fail(dir, "Map.rbxmx does not load: " .. tostring(instances))
		return
	end
	if #instances ~= 1 or instances[1].Name ~= "Map" or not instances[1]:IsA("Model") then
		fail(dir, 'Map.rbxmx must contain exactly one Model named "Map"')
		return
	end
	local map = instances[1]

	local parts, spawns = 0, 0
	for _, inst in map:GetDescendants() do
		if inst:IsA("LuaSourceContainer") then
			fail(
				dir,
				"script inside the map: " .. inst:GetFullName() .. " (move it to maps/" .. dir .. "/scripts/)"
			)
		elseif inst:IsA("SpawnLocation") then
			spawns += 1
		end
		if inst:IsA("BasePart") then
			parts += 1
		end
	end
	if spawns == 0 then
		fail(dir, "no SpawnLocation in the map")
	end
	if parts > MAX_PARTS then
		fail(dir, string.format("%d parts — over the %d budget", parts, MAX_PARTS))
	end

	local checkpoints = map:FindFirstChild("Checkpoints")
	if checkpoints then
		local names = {}
		local numbered = 0
		for _, child in checkpoints:GetChildren() do
			table.insert(names, child.Name)
			if Stages.parse(child.Name) then
				numbered += 1
			end
		end
		if Stages.contiguousCount(names) ~= numbered then
			fail(dir, "Checkpoints skip a number — they must be Stage1, Stage2, Stage3, ...")
		end
	end

	-- Course: every jump SpawnLocation -> P001 -> P002 -> ... must be fair (src/shared/Jump.luau).
	local course = map:FindFirstChild("Course")
	local jumps = 0
	if course then
		local platforms = {}
		for _, child in course:GetChildren() do
			if child:IsA("BasePart") and string.match(child.Name, "^P%d%d%d$") then
				table.insert(platforms, child)
			end
		end
		table.sort(platforms, function(a, b)
			return a.Name < b.Name
		end)
		local spawn = map:FindFirstChildWhichIsA("SpawnLocation")
		if spawn then
			table.insert(platforms, 1, spawn)
		end
		for i = 2, #platforms do
			local a, b = platforms[i - 1], platforms[i]
			local fair, gap, rise, limit = Jump.check(asBox(a), asBox(b))
			jumps += 1
			if not fair then
				local why = if limit == nil
					then string.format("step up %.1f > max %.1f", rise, Jump.maxRise())
					else string.format("gap %.1f > max %.1f at rise %.1f", gap, limit, rise)
				fail(dir, string.format("impossible jump %s -> %s: %s", a.Name, b.Name, why))
			end
		end
	end

	if failures == before then
		print(string.format("  ok    %s (%d parts, %d spawn, %d jumps checked)", dir, parts, spawns, jumps))
	end
end

local dirs = fs.readDir("maps")
table.sort(dirs)
for _, dir in dirs do
	if fs.isDir("maps/" .. dir) then
		checkMap(dir)
	end
end

if failures > 0 then
	print(string.format("\n%d problem(s)", failures))
	process.exit(1)
end
