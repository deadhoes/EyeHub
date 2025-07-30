local EyeHub = {}

function EyeHub:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EyeHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui

    local UICorner = Instance.new("UICorner", Main)
    UICorner.CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel")
    Title.Parent = Main
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = title or "EyeHub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22

    local TabContainer = Instance.new("Frame")
    TabContainer.Parent = Main
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.Size = UDim2.new(1, 0, 1, -50)
    TabContainer.BackgroundTransparency = 1

    local UIList = Instance.new("UIListLayout", TabContainer)
    UIList.Padding = UDim.new(0, 6)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder

    local window = {}

    function window:AddLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Parent = TabContainer
        Label.Size = UDim2.new(1, -20, 0, 28)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 16
        Label.TextXAlignment = Enum.TextXAlignment.Left

        local UICorner = Instance.new("UICorner", Label)
        UICorner.CornerRadius = UDim.new(0, 6)
    end

    function window:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Parent = TabContainer
        Button.Size = UDim2.new(1, -20, 0, 32)
        Button.Position = UDim2.new(0, 10, 0, 0)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 17
        Button.AutoButtonColor = false

        local UICorner = Instance.new("UICorner", Button)
        UICorner.CornerRadius = UDim.new(0, 6)

        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)

        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)

        Button.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
    end

    return window
end

return EyeHub
