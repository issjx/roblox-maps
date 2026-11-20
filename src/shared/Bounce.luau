--!strict
-- Bounce Mushroom rules (pure, no Roblox APIs).

local Bounce = {}

Bounce.MAX_ENTRY_VY = 5 -- only landing/standing contacts trigger, not rising side hits
Bounce.COOLDOWN = 0.4 -- per character, seconds

-- Does a touch at time `now` trigger? `last` = time of this character's last bounce (nil = never).
function Bounce.shouldBounce(power: any, verticalVelocity: number, last: number?, now: number): boolean
	if type(power) ~= "number" or power <= 0 then
		return false
	end
	if verticalVelocity > Bounce.MAX_ENTRY_VY then
		return false
	end
	if last ~= nil and now - last < Bounce.COOLDOWN then
		return false
	end
	return true
end

return Bounce
