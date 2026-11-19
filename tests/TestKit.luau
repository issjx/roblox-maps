-- A deliberately tiny test framework for Lune: `test(name, fn)` and `expect(x).toBe(y)`.

local TestKit = {
	passed = 0,
	failed = 0,
}

function TestKit.test(name: string, fn: () -> ())
	local ok, err = pcall(fn)
	if ok then
		TestKit.passed += 1
		print("  ok    " .. name)
	else
		TestKit.failed += 1
		print("  FAIL  " .. name .. "\n        " .. tostring(err))
	end
end

function TestKit.expect(actual: any)
	return {
		toBe = function(expected: any)
			if actual ~= expected then
				error(string.format("expected %s, got %s", tostring(expected), tostring(actual)), 2)
			end
		end,
	}
end

return TestKit
