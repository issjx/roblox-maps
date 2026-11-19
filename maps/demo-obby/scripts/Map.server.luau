-- demo-obby has no map-specific gameplay: checkpoints and lava come from the shared scripts in src/server.

local map = workspace:WaitForChild("Map")
print(string.format("[demo-obby] loaded with %d course platforms", #map:WaitForChild("Course"):GetChildren()))
