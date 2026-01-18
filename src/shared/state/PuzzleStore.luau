--!strict

local Charm = require("@pkg/Charm")

export type State = {
	buttons: { [number]: boolean },
}

local initialState: State = {
	buttons = { [1] = false, [2] = false, [3] = false },
}

local mainAtom = Charm.atom(initialState)

local function toggleButton(index: number)
	mainAtom(function(state)
		local newButtons = table.clone(state.buttons)
		newButtons[index] = not newButtons[index]
		return { buttons = newButtons }
	end)
end

local getLightsState = Charm.computed(function()
	local buttons = mainAtom().buttons
	local B1, B2, B3 = buttons[1], buttons[2], buttons[3]
	return {
		light1 = B1 ~= B2,
		light2 = B2 ~= B3,
		light3 = (B1 == B3) ~= B2,
	}
end)

return {
	mainAtom = mainAtom,
	toggleButton = toggleButton,
	getLightsState = getLightsState,
}
