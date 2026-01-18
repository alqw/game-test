--!strict

local Ripple = require("@pkg/Ripple")

local GateAnimation = {}

function GateAnimation.Open(gateName: string)
	local gatesFolder = workspace:WaitForChild("World"):WaitForChild("Gates")
	local gate = gatesFolder:WaitForChild(gateName) :: BasePart

	local startPivot = gate:GetPivot()
	local targetAngle = math.rad(90)

	local tween = Ripple.createTween(0, {
		easing = "quartInOut",
		duration = 1.5,
		start = true,
	})
	tween:setGoal(1)

	tween:onChange(function(value)
		local currentRotation = CFrame.Angles(0, targetAngle * value, 0)
		gate:PivotTo(startPivot * currentRotation)
	end)
end

return GateAnimation
