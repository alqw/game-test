--!strict

local Charm = require("@pkg/Charm")

local mainAtom = Charm.atom(false)

local function setWinVisible(visible: boolean)
	mainAtom(visible)
end

return {
	mainAtom = mainAtom,
	setWinVisible = setWinVisible,
}
