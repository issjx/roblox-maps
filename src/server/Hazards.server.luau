-- Shared by every map: any part inside Map/Hazards kills the character that touches it.

local map = workspace:WaitForChild("Map")
local hazards = map:FindFirstChild("Hazards")
if hazards == nil then
	return
end

local function arm(part: Instance)
	if part:IsA("BasePart") then
		part.Touched:Connect(function(hit)
			local humanoid = hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 then
				humanoid.Health = 0
			end
		end)
	end
end

for _, part in hazards:GetDescendants() do
	arm(part)
end
hazards.DescendantAdded:Connect(arm)
