--!strict
-- Can a default Roblox character make this jump? Pure math, so CI (Lune) and the AI level designer
-- use exactly the same numbers.
--
-- Physics (Roblox defaults): Gravity 196.2, JumpHeight 7.2, WalkSpeed 16.
-- FAIR = 0.85 keeps every jump comfortably inside the limit; a pixel-perfect jump is not fun.

local Jump = {}

Jump.GRAVITY = 196.2
Jump.JUMP_HEIGHT = 7.2
Jump.WALK_SPEED = 16
Jump.FAIR = 0.85
Jump.OVERHANG = 1 -- the character's body hangs over the edges it jumps from and lands on

export type Box = { position: { x: number, y: number, z: number }, size: { x: number, y: number, z: number } }

-- Highest step up (studs, top to top) a fair jump can make.
function Jump.maxRise(): number
	return Jump.JUMP_HEIGHT * Jump.FAIR
end

-- Widest horizontal edge-to-edge gap a fair jump can clear when landing `rise` studs higher
-- (negative = lower). nil when the rise itself is too high.
function Jump.maxGap(rise: number): number?
	if rise > Jump.maxRise() then
		return nil
	end
	local v = math.sqrt(2 * Jump.GRAVITY * Jump.JUMP_HEIGHT)
	-- time until the character comes back down to height `rise`
	local t = (v + math.sqrt(v * v - 2 * Jump.GRAVITY * rise)) / Jump.GRAVITY
	return Jump.WALK_SPEED * t * Jump.FAIR + Jump.OVERHANG
end

-- Horizontal edge-to-edge gap and top-to-top rise from box a to box b (rotation ignored).
function Jump.measure(a: Box, b: Box): (number, number)
	local dx = math.max(0, math.abs(a.position.x - b.position.x) - (a.size.x + b.size.x) / 2)
	local dz = math.max(0, math.abs(a.position.z - b.position.z) - (a.size.z + b.size.z) / 2)
	local rise = (b.position.y + b.size.y / 2) - (a.position.y + a.size.y / 2)
	return math.sqrt(dx * dx + dz * dz), rise
end

-- ok, gap, rise, maxGap (maxGap nil = the step up is too high)
function Jump.check(a: Box, b: Box): (boolean, number, number, number?)
	local gap, rise = Jump.measure(a, b)
	local limit = Jump.maxGap(rise)
	return limit ~= nil and gap <= limit, gap, rise, limit
end

return Jump
