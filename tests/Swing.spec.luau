local Swing = require("../src/shared/Swing")

return function(t)
	local test, expect = t.test, t.expect

	test("swing starts at the bottom for phase 0", function()
		local s = Swing.state(0, 16, 25, 4, 0)
		expect(math.abs(s.x) < 1e-9).toBe(true)
		expect(math.abs(s.y + 16) < 1e-9).toBe(true)
	end)

	test("swing extreme is length*sin(angle) sideways and stops", function()
		local s = Swing.state(1, 16, 25, 4, 0) -- quarter period
		expect(math.abs(s.x - 16 * math.sin(math.rad(25))) < 1e-9).toBe(true)
		expect(math.abs(s.vx) < 1e-9).toBe(true)
	end)

	test("swing is fastest at the bottom", function()
		local s = Swing.state(0, 16, 25, 4, 0)
		expect(s.vx > 10).toBe(true)
	end)

	test("valid rejects bad attributes", function()
		expect(Swing.valid(16, 25, 4, 0)).toBe(true)
		expect(Swing.valid(0, 25, 4, 0)).toBe(false)
		expect(Swing.valid(16, 25, 0, 0)).toBe(false)
		expect(Swing.valid(nil, 25, 4, 0)).toBe(false)
	end)
end
