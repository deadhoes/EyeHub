local Discord = "https://discord.com/invite/9krxH9g4MH"

print("Thanks for using EyeHub.")
print("Dont forget to join our discord!".. Discord)

local GameScripts = {
    [126884695634066] = "https://raw.githubusercontent.com/deadhoes/EyeHub/main/scripts/growagarden.lua",
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
