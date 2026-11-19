-- Prints the fair-jump limits the validator enforces.   lune run scripts/jump-table
local Jump = require("../src/shared/Jump")

print(string.format("Max fair step up: %.1f studs (top to top)\n", Jump.maxRise()))
print("rise (studs)   max horizontal gap (edge to edge)")
for _, rise in { 6, 5, 4, 3, 2, 1, 0, -2, -4, -8, -12, -20 } do
	print(string.format("%6d         %5.1f", rise, Jump.maxGap(rise) :: number))
end
