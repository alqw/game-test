--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

return {
	CoinCollected = Remotes:WaitForChild("CoinCollected") :: RemoteEvent,
	GateOpened = Remotes:WaitForChild("GateOpened") :: RemoteEvent,
	PuzzleUpdate = Remotes:WaitForChild("PuzzleUpdate") :: RemoteEvent,
	ShowWinUI = Remotes:WaitForChild("ShowWinUI") :: RemoteEvent,
}
