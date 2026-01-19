--!strict

local Ripple = require("@pkg/Ripple")

local GateAnimation = {}
local activeTweens = {}
local openedGates = {}

function GateAnimation.Open(gateName: string)
	if openedGates[gateName] then
		return
	end
	openedGates[gateName] = true

	local gatesFolder = workspace:WaitForChild("World"):WaitForChild("Gates")
	local gate = gatesFolder:FindFirstChild(gateName) :: BasePart

	if not gate then
		warn("⚠️ GateAnimation: Gate not found ->", gateName)
		openedGates[gateName] = nil
		return
	end

	if activeTweens[gateName] then
		activeTweens[gateName]:stop()
	end

	local startPivot = gate:GetPivot()
	local targetAngle = math.rad(90)

	local tween = Ripple.createTween(0, {
		easing = "quartInOut",
		duration = 1.5,
		start = true,
	})

	activeTweens[gateName] = tween
	tween:setGoal(1)

	tween:onChange(function(value)
		if not gate.Parent then
			tween:stop()
			activeTweens[gateName] = nil
			return
		end

		local currentRotation = CFrame.Angles(0, targetAngle * value, 0)
		gate:PivotTo(startPivot * currentRotation)
	end)

	tween:onComplete(function()
		activeTweens[gateName] = nil
	end)
end

function GateAnimation.Reset()
	for name, tween in pairs(activeTweens) do
		tween:stop()
	end
	table.clear(activeTweens)
	table.clear(openedGates)
	print("GateAnimation: Reset complete")
end

return GateAnimation
