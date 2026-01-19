--!strict
local Ripple = require("@pkg/Ripple")

local PuzzleAnimation = {}

local COLORS = {
	ON = Color3.fromRGB(0, 255, 127),
	OFF = Color3.fromRGB(40, 40, 40),
}

local activeTweens: { [BasePart]: any } = {}

function PuzzleAnimation.Animate(part: BasePart, isOn: boolean)
	local targetColor = isOn and COLORS.ON or COLORS.OFF

	if activeTweens[part] then
		activeTweens[part]:stop()
		activeTweens[part] = nil
	end

	local startColor = part.Color

	local tween = Ripple.createTween({
		r = startColor.R,
		g = startColor.G,
		b = startColor.B,
	}, {
		easing = "quadInOut",
		duration = 0.4,
		start = true,
	})

	activeTweens[part] = tween
	tween:setGoal({
		r = targetColor.R,
		g = targetColor.G,
		b = targetColor.B,
	})

	tween:onChange(function(value)
		if not part.Parent then
			tween:stop()
			activeTweens[part] = nil
			return
		end

		part.Color = Color3.new(value.r, value.g, value.b)
	end)

	tween:onComplete(function()
		if activeTweens[part] == tween then
			activeTweens[part] = nil
		end
	end)
end

function PuzzleAnimation.Reset()
	for part, tween in pairs(activeTweens) do
		tween:stop()
	end
	table.clear(activeTweens)
end

return PuzzleAnimation
