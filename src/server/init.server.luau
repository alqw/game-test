--!strict

local TaskUtil = require("@shared/utils/TaskUtil")

local function main()
	InitLogic()
end

function InitLogic()
	local CoinLogic = require("@server/logic/CoinLogic")
	local GateLogic = require("@server/logic/GateLogic")
	local PuzzleLogic = require("@server/logic/PuzzleLogic")

	TaskUtil.SafeInit("CoinLogic", CoinLogic.Start)
	TaskUtil.SafeInit("GateLogic", GateLogic.Start)
	TaskUtil.SafeInit("PuzzleLogic", PuzzleLogic.Start)
end

main()
