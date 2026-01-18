--!strict

local function main()
	InitLogic()
end

function InitLogic()
	local CoinLogic = require("@server/logic/CoinLogic")
	local GateLogic = require("@server/logic/GateLogic")
	local PuzzleLogic = require("@server/logic/PuzzleLogic")

	CoinLogic.Start()
	GateLogic.Start()
	PuzzleLogic.Start()
end

main()
