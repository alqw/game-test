--!strict

local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")

local CoinLabel = require("@shared/components/CoinLabel")

return function(target)
	local root = ReactRoblox.createRoot(target)

	root:render(React.createElement(
		CoinLabel,
		{
			Text = "Coins: 0/20",
			Position = UDim2.new(0, 30, 0, 30),
		} :: CoinLabel.Props
	))

	return function()
		root:unmount()
	end
end
