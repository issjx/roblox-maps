local Jump = require("../src/shared/Jump")

local function box(x, y, z, sx, sy, sz)
	return { position = { x = x, y = y, z = z }, size = { x = sx or 6, y = sy or 1, z = sz or 6 } }
end

return function(t)
	local test, expect = t.test, t.expect

	test("a flat gap of 6 studs is fair", function()
		local ok, gap = Jump.check(box(0, 0, 0), box(0, 0, 12))
		expect(gap).toBe(6)
		expect(ok).toBe(true)
	end)

	test("a flat gap of 12 studs is too far", function()
		expect((Jump.check(box(0, 0, 0), box(0, 0, 18)))).toBe(false)
	end)

	test("stepping up more than the fair jump height is impossible", function()
		local ok, _, rise, limit = Jump.check(box(0, 0, 0), box(0, 7, 7))
		expect(rise).toBe(7)
		expect(ok).toBe(false)
		expect(limit).toBe(nil)
	end)

	test("dropping down lets you clear a wider gap", function()
		local flat = Jump.maxGap(0) :: number
		local drop = Jump.maxGap(-10) :: number
		expect(drop > flat).toBe(true)
	end)

	test("touching platforms have no gap", function()
		local _, gap = Jump.measure(box(0, 0, 0), box(6, 0, 0))
		expect(gap).toBe(0)
	end)
end
