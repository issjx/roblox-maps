-- Shared by every map: leaderstats "Stage" + respawn at the last checkpoint reached.
-- Active only when the map has a folder Map/Checkpoints with parts named Stage1, Stage2, ...

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Stages = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Stages"))

local map = workspace:WaitForChild("Map")
local checkpoints = map:FindFirstChild("Checkpoints")
if checkpoints == nil then
	return
end

local function stageValue(player: Player): IntValue?
	local stats = player:FindFirstChild("leaderstats")
	return stats and stats:FindFirstChild("Stage") :: IntValue?
end

Players.PlayerAdded:Connect(function(player)
	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	local stage = Instance.new("IntValue")
	stage.Name = "Stage"
	stage.Parent = stats
	stats.Parent = player

	player.CharacterAdded:Connect(function(character)
		local pad = checkpoints:FindFirstChild("Stage" .. stage.Value)
		if pad and pad:IsA("BasePart") then
			task.defer(function()
				character:PivotTo(pad.CFrame + Vector3.new(0, 4, 0))
			end)
		end
	end)
end)

for _, pad in checkpoints:GetChildren() do
	local n = Stages.parse(pad.Name)
	if n and pad:IsA("BasePart") then
		pad.Touched:Connect(function(hit)
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			local stage = player and stageValue(player)
			if stage and Stages.canAdvance(stage.Value, n) then
				stage.Value = n
			end
		end)
	end
end
