-- Scripts that belong to THIS map only go in this folder (maps/<map>/scripts/).
-- Code every map shares goes in src/ instead. Never put scripts inside Map.rbxmx —
-- CI rejects that, so every line of code that ships is visible in a pull request.

local map = workspace:WaitForChild("Map")
print(string.format("[%s] loaded with %d top-level parts", map.Name, #map:GetChildren()))
