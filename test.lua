local player = game.Players.LocalPlayer
if not player then
	return
end

local Whitelist = {12345678, 87654321}

local WhitelistLookup = {}
for _, userId in ipairs(Whitelist) do
	WhitelistLookup[userId] = true
end

if WhitelistLookup[player.UserId] then
	WhitelistSystem = "2925272B-DBDF-4147-B6B5-2902F7B35642"
else
  WhitelistSystem = ""
end

return WhitelistSystem
