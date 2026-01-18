--!strict
local React = require("@pkg/React")

export type Props = {
	OnClose: () -> (),
}

local function WinModal(props: Props)
	return React.createElement("Frame", {
		Size = UDim2.fromOffset(400, 250),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(35, 35, 35),
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 12) }),

		Title = React.createElement("TextLabel", {
			Text = "YOU WIN!",
			Size = UDim2.new(1, 0, 0.5, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.FredokaOne,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 48,
		}),

		CloseButton = React.createElement("TextButton", {
			Text = "Close",
			Size = UDim2.new(0.7, 0, 0.25, 0),
			Position = UDim2.new(0.5, 0, 0.75, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(200, 60, 60),
			Font = Enum.Font.FredokaOne,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 24,
			[React.Event.Activated] = props.OnClose,
		}, {
			Corner = React.createElement("UICorner"),
		}),
	})
end

return WinModal
