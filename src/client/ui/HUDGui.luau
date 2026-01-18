--!strict

local React = require("@pkg/React")
local ReactCharm = require("@pkg/ReactCharm")
local Store = require("@shared/state/Store")

local CoinLabel = require("@shared/components/CoinLabel")

type ScreenGuiProps = { [any]: any } & ScreenGui

local function HUDGui()
	local state = ReactCharm.useAtom(Store.mainAtom)

	return React.createElement(
		"ScreenGui",
		{
			Name = "HUDGui",
			ResetOnSpawn = false,
		} :: ScreenGuiProps,
		{
			CoinLabel = React.createElement(
				CoinLabel,
				{
					Text = "Coins: " .. tostring(state.coins) .. "/20",
					Position = UDim2.new(0, 30, 0, 30),
				} :: CoinLabel.Props
			),
		}
	)
end

return HUDGui
