--!strict

local React = require("@pkg/React")
local ReactCharm = require("@pkg/ReactCharm")
local UIStore = require("@shared/state/UIStore")
local WinModal = require("@shared/components/WinModal")

local function WinGui()
	local isVisible = ReactCharm.useAtom(UIStore.mainAtom)

	return React.createElement("ScreenGui", {
		Name = "WinGui",
		Enabled = isVisible,
		ResetOnSpawn = false,
	}, {
		Modal = React.createElement(WinModal, {
			OnClose = function()
				UIStore.setWinVisible(false)
			end,
		}),
	})
end

return WinGui
