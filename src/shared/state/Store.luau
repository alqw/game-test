--!strict

local Charm = require("@pkg/Charm")

export type State = {
	coins: number,
}

local initialState: State = {
	coins = 0,
}

local mainAtom = Charm.atom(initialState)

local function setCoins(amount: number)
	mainAtom(function(state)
		return {
			coins = amount,
		}
	end)
end

local function getCoins()
	local state = mainAtom()
	return state.coins
end

local function addCoins(amount: number)
	mainAtom(function(state)
		return {
			coins = state.coins + amount,
		}
	end)
end

return {
	mainAtom = mainAtom,
	addCoins = addCoins,
	setCoins = setCoins,
	getCoins = getCoins,
}
