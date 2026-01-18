--!strict

local Ripple = require("@pkg/Ripple")

local CoinsFolder = workspace:WaitForChild("World"):WaitForChild("Coins")

local CoinAnimation = {}
local activeCoins = {}

local function registerCoin(instance: Instance)
	if not instance:IsA("BasePart") or activeCoins[instance] then
		return
	end

	activeCoins[instance] = {
		initialCF = instance.CFrame,
		phase = math.random() * math.pi * 2,
		startRotation = math.rad(math.random(0, 360)),
	}
end

function CoinAnimation.PlayCollectEffect(part: BasePart)
	activeCoins[part] = nil

	local startSize = part.Size
	local startCF = part.CFrame

	local tween = Ripple.createTween(0, {
		easing = "quartOut",
		duration = 0.6,
		start = true,
	})
	tween:setGoal(1)

	tween:onChange(function(value)
		part.Transparency = value
		part.Size = startSize * (1 - value)
		part.CFrame = startCF + Vector3.new(0, value * 0.5, 0)
	end)

	tween:onComplete(function()
		part:Destroy()
	end)
end

function CoinAnimation.Start()
	for _, instance in ipairs(CoinsFolder:GetChildren()) do
		registerCoin(instance)
	end

	CoinsFolder.ChildAdded:Connect(registerCoin)

	local function StartCycle()
		local tween = Ripple.createTween(0, {
			easing = "linear",
			duration = 5,
			start = true,
		})
		tween:setGoal(360)

		tween:onComplete(StartCycle)

		tween:onChange(function(value)
			local amplitude = 0.5
			local rotationAngle = math.rad(value)

			for part, data in pairs(activeCoins) do
				local verticalOffset = math.sin(rotationAngle + data.phase) * amplitude
				local finalRotation = data.startRotation + rotationAngle

				part.CFrame = data.initialCF
				part.CFrame *= CFrame.Angles(0, finalRotation, 0)
				part.CFrame += Vector3.new(0, verticalOffset, 0)
			end
		end)
	end

	StartCycle()
end

return CoinAnimation
