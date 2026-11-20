-- Sky Garden mechanics: Bounce Mushroom (BouncePower) and Swinging Vine Seat (Swing*).
-- Server-authoritative; pure maths lives in ReplicatedStorage.Shared (Bounce, Swing).

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local shared = ReplicatedStorage:WaitForChild("Shared")
local Bounce = require(shared:WaitForChild("Bounce"))
local Swing = require(shared:WaitForChild("Swing"))

local map = workspace:WaitForChild("Map")
local course = map:WaitForChild("Course")
local bonus = map:FindFirstChild("Bonus")
local decoration = map:FindFirstChild("Decoration")

local lastBounce: { [Instance]: number } = setmetatable({}, { __mode = "k" }) :: any
Players.PlayerRemoving:Connect(function(player)
	if player.Character then
		lastBounce[player.Character] = nil
	end
end)

-- Bounce Mushroom ------------------------------------------------------------------------------
local function armMushroom(cap: BasePart)
	local restSize = cap.Size
	local squashing = false
	local conn = cap.Touched:Connect(function(hit)
		local character = hit.Parent
		if character == nil or not character:IsA("Model") then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local root = character:FindFirstChild("HumanoidRootPart")
		if humanoid == nil or humanoid.Health <= 0 or root == nil or not root:IsA("BasePart") then
			return
		end
		local power = cap:GetAttribute("BouncePower")
		local now = os.clock()
		local velocity = root.AssemblyLinearVelocity
		if not Bounce.shouldBounce(power, velocity.Y, lastBounce[character], now) then
			return
		end
		lastBounce[character] = now
		root.AssemblyLinearVelocity = Vector3.new(velocity.X, power :: number, velocity.Z)

		if not squashing then
			squashing = true
			cap.Size = Vector3.new(restSize.X, restSize.Y * 0.7, restSize.Z)
			local tween = TweenService:Create(cap, TweenInfo.new(0.2), { Size = restSize })
			tween.Completed:Once(function()
				squashing = false
			end)
			tween:Play()
		end
	end)
	cap.Destroying:Once(function()
		conn:Disconnect()
	end)
end

local function scanMushrooms(folder: Instance?)
	if folder == nil then
		return
	end
	for _, part in folder:GetDescendants() do
		if part:IsA("BasePart") and type(part:GetAttribute("BouncePower")) == "number" then
			armMushroom(part)
		end
	end
end

scanMushrooms(course)
scanMushrooms(bonus)

-- Swinging Vine Seat ---------------------------------------------------------------------------
type Seat = {
	part: BasePart,
	pivot: Vector3,
	length: number,
	angle: number,
	period: number,
	phase: number,
	rope: BasePart?,
	ropeDist: number,
}

local seats: { Seat } = {}

for _, part in course:GetChildren() do
	if part:IsA("BasePart") and part:GetAttribute("SwingLength") ~= nil then
		local length = part:GetAttribute("SwingLength")
		local angle = part:GetAttribute("SwingAngle")
		local period = part:GetAttribute("SwingPeriod")
		local phase = part:GetAttribute("SwingPhase") or 0
		if Swing.valid(length, angle, period, phase) then
			part.Anchored = true
			local pivot = part.Position + Vector3.new(0, length :: number, 0)
			local rope = decoration and decoration:FindFirstChild("Rope_" .. part.Name)
			local ropePart = if rope and rope:IsA("BasePart") then rope else nil
			if ropePart == nil then
				warn(`[sky-garden] no Decoration/Rope_{part.Name}; seat swings without a rope`)
			end
			table.insert(seats, {
				part = part,
				pivot = pivot,
				length = length :: number,
				angle = angle :: number,
				period = period :: number,
				phase = phase :: number,
				rope = ropePart,
				ropeDist = if ropePart then pivot.Y - ropePart.Position.Y else 0,
			})
		else
			warn(`[sky-garden] {part.Name} has invalid Swing* attributes; left static`)
		end
	end
end

if #seats > 0 then
	local conn = RunService.Heartbeat:Connect(function()
		local t = workspace:GetServerTimeNow()
		for _, seat in seats do
			if seat.part.Parent == nil then
				continue
			end
			local s = Swing.state(t, seat.length, seat.angle, seat.period, seat.phase)
			seat.part.CFrame = CFrame.new(seat.pivot + Vector3.new(s.x, s.y, 0))
			seat.part.AssemblyLinearVelocity = Vector3.new(s.vx, s.vy, 0)
			local rope = seat.rope
			if rope then
				local d = seat.ropeDist
				rope.CFrame = CFrame.new(
					seat.pivot + Vector3.new(d * math.sin(s.theta), -d * math.cos(s.theta), 0)
				) * CFrame.Angles(0, 0, s.theta)
			end
		end
	end)
	course.Destroying:Once(function()
		conn:Disconnect()
	end)
end
