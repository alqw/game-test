--!strict
local Ripple = require("@pkg/Ripple")

local PuzzleAnimation = {}

local COLORS = {
	ON = Color3.fromRGB(0, 255, 127),
	OFF = Color3.fromRGB(40, 40, 40),
}

function PuzzleAnimation.Animate(part: BasePart, isOn: boolean)
	local targetColor = isOn and COLORS.ON or COLORS.OFF

	local tween = Ripple.createTween(part.Color, {
		easing = "quadInOut",
		duration = 0.4,
		start = true,
	})
	tween:setGoal(targetColor)

	tween:onChange(function(value)
		if typeof(value) == "Vector3" then
			part.Color = Color3.new(value.X, value.Y, value.Z)
		else
			part.Color = value
		end
	end)
end

return PuzzleAnimation
