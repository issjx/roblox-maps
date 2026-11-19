--!strict
-- Stage / checkpoint rules shared by every map.
--
-- Pure Luau, no Roblox APIs: that is what lets `tests/` run it with Lune in CI, outside Studio.
-- Keep game rules here and keep the Roblox wiring (events, parts, players) in src/server.

local Stages = {}

-- "Stage12" -> 12. Anything else (wrong prefix, Stage0, Stage-1, Stage1a) -> nil.
function Stages.parse(name: string): number?
	local digits = string.match(name, "^Stage(%d+)$")
	if digits == nil then
		return nil
	end
	local n = tonumber(digits)
	if n == nil or n < 1 then
		return nil
	end
	return n
end

-- A player moves forward exactly one stage at a time, so touching a later pad cannot skip the map.
function Stages.canAdvance(current: number, touched: number): boolean
	return touched == current + 1
end

-- Highest N such that Stage1..StageN all exist. A gap means the map is broken after the gap.
function Stages.contiguousCount(names: { string }): number
	local present: { [number]: boolean } = {}
	for _, name in names do
		local n = Stages.parse(name)
		if n then
			present[n] = true
		end
	end
	local count = 0
	while present[count + 1] do
		count += 1
	end
	return count
end

return Stages
