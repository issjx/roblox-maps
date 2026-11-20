local Bounce = require("../src/shared/Bounce")

return function(t)
	local test, expect = t.test, t.expect

	test("bounce triggers on landing, not on rising or during cooldown", function()
		expect(Bounce.shouldBounce(75, -20, nil, 10)).toBe(true)
		expect(Bounce.shouldBounce(75, 30, nil, 10)).toBe(false)
		expect(Bounce.shouldBounce(75, 0, 9.8, 10)).toBe(false)
		expect(Bounce.shouldBounce(75, 0, 9.5, 10)).toBe(true)
		expect(Bounce.shouldBounce(nil, 0, nil, 10)).toBe(false)
	end)

	test("power <= 0 never bounces", function()
		expect(Bounce.shouldBounce(0, -20, nil, 10)).toBe(false)
		expect(Bounce.shouldBounce(-5, -20, nil, 10)).toBe(false)
	end)

	test("entry velocity boundary is MAX_ENTRY_VY", function()
		expect(Bounce.shouldBounce(75, 5, nil, 10)).toBe(true)
		expect(Bounce.shouldBounce(75, 5.01, nil, 10)).toBe(false)
	end)
end
