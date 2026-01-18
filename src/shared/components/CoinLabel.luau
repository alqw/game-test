--!strict

local React = require("@pkg/React")

export type Props = {
	Text: string,
	Position: UDim2?,
}
type TextLabelProps = { [any]: any } & TextLabel

local function CoinLabel(props: Props)
	return React.createElement(
		"TextLabel",
		{
			Text = props.Text,
			Position = props.Position or UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(0, 0),
			-- BackgroundColor3 = Color3.new(1, 1, 1),
			-- TextScaled = false,
			Font = Enum.Font.FredokaOne,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 0,
			TextStrokeColor3 = Color3.new(0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			TextSize = 64,
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
		} :: TextLabelProps
	)
end

return CoinLabel
