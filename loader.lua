local Discord = "https://discord.com/invite/9krxH9g4MH"

print("Thanks for using EyeHub.")
print("Dont forget to join our discord!".. Discord)

local GameScripts = {
    [124180759222403] = "https://raw.githubusercontent.com/deadhoes/ForgeHub/main/scripts/ants",
    [73727760725654] = "https://raw.githubusercontent.com/deadhoes/ForgeHub/main/scripts/stealacapybara"
	  [75794995434025] = "https://raw.githubusercontent.com/deadhoes/ForgeHub/refs/heads/main/scripts/growabusiness"
}

local currentGame = game.PlaceId
local scriptUrl = GameScripts[currentGame]

if scriptUrl then
    local success, err = pcall(function()
        loadstring(game:HttpGet(scriptUrl, true))()
    end)
    if not success then
        warn("Script Error: "..tostring(err))
    end
else
    warn("No script for this game (ID: "..currentGame)
end
