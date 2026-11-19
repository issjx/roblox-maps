-- MapKit — build a map with code (runs in Lune, not in Roblox).
--
-- A map's maps/<name>/build.luau returns   function(kit) -> Model   and
--   lune run scripts/build-maps <name>
-- writes the result to maps/<name>/Map.rbxmx. Positions/sizes are plain {x, y, z} arrays and colours are
-- "#rrggbb", so a design written by a person (or an AI) maps 1:1 to code.
--
-- Conventions the shared scripts and the validator understand:
--   Map/Course/P001, P002, ...   the path, in order. CI checks every jump Spawn -> P001 -> P002 -> ...
--   Map/Checkpoints/Stage1, ...  checkpoint pads (shared server script: leaderstats + respawn)
--   Map/Hazards/*                anything here kills on touch (shared server script)

local roblox = require("@lune/roblox")
local Instance, Vector3, CFrame, Color3, Enum =
	roblox.Instance, roblox.Vector3, roblox.CFrame, roblox.Color3, roblox.Enum

export type Vec = { number }
export type PartProps = {
	position: Vec,
	size: Vec,
	rotation: Vec?, -- degrees around x, y, z
	color: string?, -- "#rrggbb"
	material: string?, -- Enum.Material name, e.g. "Neon", "Slate", "Grass"
	transparency: number?,
	canCollide: boolean?,
	shape: string?, -- "Block" (default), "Ball", "Cylinder", "Wedge"
}

local MapKit = {}

local function color(hex: string)
	local r, g, b = string.match(hex, "^#(%x%x)(%x%x)(%x%x)$")
	assert(r, 'colour must be "#rrggbb", got ' .. tostring(hex))
	return Color3.fromRGB(tonumber(r, 16) :: number, tonumber(g, 16) :: number, tonumber(b, 16) :: number)
end

local function apply(part: any, name: string, props: PartProps, parent: any)
	part.Name = name
	part.Anchored = true
	part.Size = Vector3.new(props.size[1], props.size[2], props.size[3])
	local cf = CFrame.new(props.position[1], props.position[2], props.position[3])
	if props.rotation then
		local r = props.rotation
		cf = cf * CFrame.Angles(math.rad(r[1]), math.rad(r[2]), math.rad(r[3]))
	end
	part.CFrame = cf
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	if props.color then
		part.Color = color(props.color)
	end
	if props.material then
		part.Material = (Enum.Material :: any)[props.material]
	end
	if props.transparency then
		part.Transparency = props.transparency
	end
	if props.canCollide ~= nil then
		part.CanCollide = props.canCollide
	end
	part.Parent = parent
	return part
end

-- The root Model every map must have.
function MapKit.map()
	local model = Instance.new("Model")
	model.Name = "Map"
	return model
end

function MapKit.folder(parent: any, name: string)
	local existing = parent:FindFirstChild(name)
	if existing then
		return existing
	end
	local f = Instance.new("Folder")
	f.Name = name
	f.Parent = parent
	return f
end

function MapKit.part(parent: any, name: string, props: PartProps)
	local shape = props.shape or "Block"
	local part
	if shape == "Wedge" then
		part = Instance.new("WedgePart")
	else
		part = Instance.new("Part")
		part.Shape = (Enum.PartType :: any)[shape]
	end
	return apply(part, name, props, parent)
end

function MapKit.spawn(map: any, props: PartProps)
	return apply(Instance.new("SpawnLocation"), "SpawnLocation", props, map)
end

-- Course platform number i (1-based) -> Map/Course/P001 ...
function MapKit.platform(map: any, i: number, props: PartProps)
	return MapKit.part(MapKit.folder(map, "Course"), string.format("P%03d", i), props)
end

-- Checkpoint n -> Map/Checkpoints/Stage<n>
function MapKit.checkpoint(map: any, n: number, props: PartProps)
	return MapKit.part(MapKit.folder(map, "Checkpoints"), "Stage" .. n, props)
end

-- Kill part -> Map/Hazards/<name>
function MapKit.hazard(map: any, name: string, props: PartProps)
	return MapKit.part(MapKit.folder(map, "Hazards"), name, props)
end

function MapKit.decoration(map: any, name: string, props: PartProps)
	local p = MapKit.part(MapKit.folder(map, "Decoration"), name, props)
	return p
end

-- A stable text summary of a map (names, classes, rounded positions/sizes). Two maps with the same
-- fingerprint are the same map — used to check Map.rbxmx is up to date with build.luau.
function MapKit.fingerprint(model: any): string
	local lines = {}
	for _, inst in model:GetDescendants() do
		local line = inst:GetFullName() .. " " .. inst.ClassName
		if inst:IsA("BasePart") then
			local p, s = inst.CFrame.Position, inst.Size
			line ..= string.format(" %.2f,%.2f,%.2f %.2f,%.2f,%.2f", p.X, p.Y, p.Z, s.X, s.Y, s.Z)
		end
		table.insert(lines, line)
	end
	table.sort(lines)
	return table.concat(lines, "\n")
end

return MapKit
