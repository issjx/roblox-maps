local Stages = require("../src/shared/Stages")

return function(t)
	local test, expect = t.test, t.expect

	test("parse reads StageN", function()
		expect(Stages.parse("Stage1")).toBe(1)
		expect(Stages.parse("Stage42")).toBe(42)
	end)

	test("parse rejects anything else", function()
		expect(Stages.parse("Stage0")).toBe(nil)
		expect(Stages.parse("stage1")).toBe(nil)
		expect(Stages.parse("Stage1a")).toBe(nil)
		expect(Stages.parse("Checkpoint1")).toBe(nil)
	end)

	test("canAdvance only allows the next stage", function()
		expect(Stages.canAdvance(0, 1)).toBe(true)
		expect(Stages.canAdvance(1, 3)).toBe(false)
		expect(Stages.canAdvance(3, 3)).toBe(false)
		expect(Stages.canAdvance(3, 2)).toBe(false)
	end)

	test("contiguousCount stops at the first gap", function()
		expect(Stages.contiguousCount({ "Stage1", "Stage2", "Stage4" })).toBe(2)
		expect(Stages.contiguousCount({ "Stage2" })).toBe(0)
		expect(Stages.contiguousCount({})).toBe(0)
	end)
end
