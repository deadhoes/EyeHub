local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local MarketplaceService = game:GetService("MarketplaceService")

local success, gameInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)

local gameName = "Unknown Game"
if success and gameInfo and gameInfo.Name then
    gameName = gameInfo.Name
else
    -- fallback
    gameName = game.Name or "Unknown Game"
end

local Window = Fluent:CreateWindow({
    Title = "EyeHub",
    SubTitle = gameName,
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main" }),
    Other = Window:AddTab({ Title = "Other" }),
    Settings = Window:AddTab({ Title = "Settings" })
}

local Options = Fluent.Options

do
    local Toggle = Tabs.Main:AddToggle("auto_fire_remote", {
        Title = "Fast Auto Roll",
        Default = false
    })

    Toggle:OnChanged(function()
        if Options.auto_fire_remote.Value then
            _G.autoFireRemote = true
            task.spawn(function()
                while _G.autoFireRemote do
                    pcall(function()
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("vq2")
                            :WaitForChild("3f5f6166-b1c8-4f7b-8e8a-95f35fe9fbf5")
                            :FireServer()
                    end)
                    task.wait(0.1)
                end
            end)
        else
            _G.autoFireRemote = false
        end
    end)

    local Toggle2 = Tabs.Main:AddToggle("auto_grab_pickups", {
        Title = "Auto Collect Pickups",
        Default = false
    })

    Toggle2:OnChanged(function()
        if Options.auto_grab_pickups.Value then
            _G.autoGrabPickups = true

            task.spawn(function()
                local Players = game:GetService("Players")
                local player = Players.LocalPlayer

                while _G.autoGrabPickups do
                    local character = player.Character or player.CharacterAdded:Wait()
                    local hrp = character:WaitForChild("HumanoidRootPart")
                    local humanoid = character:WaitForChild("Humanoid")

                    local folder = workspace:WaitForChild("Folder")
                    local models = folder:GetChildren()

                    local function walkTo(part)
                        humanoid:MoveTo(part.Position)
                        humanoid.MoveToFinished:Wait()
                    end

                    for _, model in ipairs(models) do
                        if not _G.autoGrabPickups then return end
                        if model:IsA("Model") then
                            local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
                            if part then
                                local direction = (part.Position - hrp.Position).Unit
                                local teleportPos = part.Position - direction * 7.45
                                hrp.CFrame = CFrame.new(teleportPos + Vector3.new(0, 3, 0))

                                task.wait(0.2)
                                walkTo(part)
                                task.wait(1.5)
                            end
                        end
                    end

                    task.wait(1)
                end
            end)
        else
            _G.autoGrabPickups = false
        end
    end)

    -- Addons:
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)

    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:SetFolder("FluentScriptHub")
    SaveManager:SetFolder("FluentScriptHub/specific-game")

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)

    Window:SelectTab(1)

    Fluent:Notify({
        Title = "Fluent",
        Content = "The script has been loaded.",
        Duration = 8
    })

    SaveManager:LoadAutoloadConfig()
end
