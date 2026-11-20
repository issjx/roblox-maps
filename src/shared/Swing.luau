--!strict
-- Pendulum maths for swinging seats (pure, no Roblox APIs). Swing plane is x-y.
-- theta(t) = angle * sin(2*pi*(t/period + phase)); offset from the pivot = length * (sin theta, -cos theta).

local Swing = {}

export type State = { theta: number, x: number, y: number, vx: number, vy: number }

-- angleDeg in degrees; returns theta (radians), offset (x, y) from pivot and velocity (studs/s).
function Swing.state(t: number, length: number, angleDeg: number, period: number, phase: number): State
	local amp = math.rad(angleDeg)
	local w = 2 * math.pi / period
	local arg = w * t + 2 * math.pi * phase
	local theta = amp * math.sin(arg)
	local dTheta = amp * w * math.cos(arg)
	return {
		theta = theta,
		x = length * math.sin(theta),
		y = -length * math.cos(theta),
		vx = length * dTheta * math.cos(theta),
		vy = length * dTheta * math.sin(theta),
	}
end

-- A seat needs positive length and period; angle may be 0 (standing still).
function Swing.valid(length: any, angleDeg: any, period: any, phase: any): boolean
	return type(length) == "number"
		and length > 0
		and type(angleDeg) == "number"
		and type(period) == "number"
		and period > 0
		and type(phase) == "number"
end

return Swing
