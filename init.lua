--[[
EyeHub Interface
by EyeHub
deadhoes | Designing + Programming
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local EyeHub = {}
EyeHub.__index = EyeHub

local function CreateTween(object, properties, duration, easing)
    local info = TweenInfo.new(
        duration or 0.3,
        easing or Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )
    return TweenService:Create(object, info, properties)
end

local function CreateGradient(parent, colors)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = 90
    gradient.Parent = parent
    return gradient
end

function EyeHub.new(title)
    local self = setmetatable({}, EyeHub)
    self.title = title or "EyeHub"
    self.tabs = {}
    self.currentTab = nil
    
    self:CreateGui()
    self:SetupAnimations()
    
    return self
end

function EyeHub:CreateGui()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "EyeHub"
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.Parent = self.ScreenGui
    self.Main.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.Main.BorderSizePixel = 0
    self.Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.Main.Size = UDim2.new(0, 700, 0, 450)
    self.Main.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.Main
    
    self:CreateTitleBar()
    self:CreateTabContainer()
    self:CreateContentArea()
    self:SetupDragging()
end

function EyeHub:CreateTitleBar()
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Parent = self.Main
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = self.TitleBar
    
    local bottomCover = Instance.new("Frame")
    bottomCover.Parent = self.TitleBar
    bottomCover.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    bottomCover.BorderSizePixel = 0
    bottomCover.Position = UDim2.new(0, 0, 0.5, 0)
    bottomCover.Size = UDim2.new(1, 0, 0.5, 0)
    
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "TitleLabel"
    self.TitleLabel.Parent = self.TitleBar
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    self.TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    self.TitleLabel.Font = Enum.Font.Code
    self.TitleLabel.Text = self.title
    self.TitleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    self.TitleLabel.TextSize = 16
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    self.CloseButton = Instance.new("ImageButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Parent = self.TitleBar
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Position = UDim2.new(1, -35, 0.5, -10)
    self.CloseButton.Size = UDim2.new(0, 20, 0, 20)
    self.CloseButton.Image = "rbxassetid://2777727756"
    self.CloseButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
    
    self.CloseButton.MouseEnter:Connect(function()
        CreateTween(self.CloseButton, {ImageColor3 = Color3.fromRGB(255, 100, 100)}, 0.2):Play()
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        CreateTween(self.CloseButton, {ImageColor3 = Color3.fromRGB(200, 200, 200)}, 0.2):Play()
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
end

function EyeHub:CreateTabContainer()
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Parent = self.Main
    self.TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Position = UDim2.new(0, 10, 0, 50)
    self.TabContainer.Size = UDim2.new(0, 150, 1, -60)
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = self.TabContainer
    
    CreateGradient(self.TabContainer, {
        Color3.fromRGB(25, 25, 25),
        Color3.fromRGB(20, 20, 20)
    })
    
    self.TabList = Instance.new("UIListLayout")
    self.TabList.Parent = self.TabContainer
    self.TabList.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabList.Padding = UDim.new(0, 5)
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = self.TabContainer
end

function EyeHub:CreateContentArea()
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.Parent = self.Main
    self.ContentArea.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.Position = UDim2.new(0, 170, 0, 50)
    self.ContentArea.Size = UDim2.new(1, -180, 1, -60)
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = self.ContentArea
    
    local pattern = Instance.new("ImageLabel")
    pattern.Name = "Pattern"
    pattern.Parent = self.ContentArea
    pattern.BackgroundTransparency = 1
    pattern.Size = UDim2.new(1, 0, 1, 0)
    pattern.Image = "http://www.roblox.com/asset/?id=306565057"
    pattern.ImageTransparency = 0.9
    pattern.ScaleType = Enum.ScaleType.Tile
    pattern.TileSize = UDim2.new(0, 100, 0, 100)
    
    local patternCorner = Instance.new("UICorner")
    patternCorner.CornerRadius = UDim.new(0, 8)
    patternCorner.Parent = pattern
end

function EyeHub:SetupDragging()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
            CreateTween(self.Main, {Position = newPos}, 0.1):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function EyeHub:SetupAnimations()
    self.Main.Size = UDim2.new(0, 0, 0, 0)
    CreateTween(self.Main, {Size = UDim2.new(0, 700, 0, 450)}, 0.5, Enum.EasingStyle.Back):Play()
    
    wait(0.1)
    self.TitleBar.Position = UDim2.new(0, 0, 0, -40)
    CreateTween(self.TitleBar, {Position = UDim2.new(0, 0, 0, 0)}, 0.4):Play()
    
    wait(0.1)
    self.TabContainer.Position = UDim2.new(0, -150, 0, 50)
    CreateTween(self.TabContainer, {Position = UDim2.new(0, 10, 0, 50)}, 0.4):Play()
    
    wait(0.1)
    self.ContentArea.Position = UDim2.new(1, 0, 0, 50)
    CreateTween(self.ContentArea, {Position = UDim2.new(0, 170, 0, 50)}, 0.4):Play()
end

function EyeHub:CreateTab(name)
    local tab = {}
    tab.name = name
    tab.elements = {}
    
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = name
    tab.Button.Parent = self.TabContainer
    tab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tab.Button.BorderSizePixel = 0
    tab.Button.Size = UDim2.new(1, -10, 0, 35)
    tab.Button.Font = Enum.Font.Code
    tab.Button.Text = name
    tab.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
    tab.Button.TextSize = 14
    tab.Button.AutoButtonColor = false
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = tab.Button
    
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Name = name .. "Content"
    tab.Content.Parent = self.ContentArea
    tab.Content.BackgroundTransparency = 1
    tab.Content.BorderSizePixel = 0
    tab.Content.Size = UDim2.new(1, 0, 1, 0)
    tab.Content.ScrollBarThickness = 6
    tab.Content.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Content.Visible = false
    
    local contentList = Instance.new("UIListLayout")
    contentList.Parent = tab.Content
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Padding = UDim.new(0, 8)
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingAll = UDim.new(0, 15)
    contentPadding.Parent = tab.Content
    
    contentList.Changed:Connect(function()
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 30)
    end)
    
    tab.Button.MouseEnter:Connect(function()
        if self.currentTab ~= tab then
            CreateTween(tab.Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2):Play()
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if self.currentTab ~= tab then
            CreateTween(tab.Button, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2):Play()
        end
    end)
    
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    if not self.currentTab then
        self:SelectTab(tab)
    end
    
    self.tabs[name] = tab
    return tab
end

function EyeHub:SelectTab(tab)
    if self.currentTab then
        CreateTween(self.currentTab.Button, {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            TextColor3 = Color3.fromRGB(180, 180, 180)
        }, 0.2):Play()
        self.currentTab.Content.Visible = false
    end
    
    self.currentTab = tab
    CreateTween(tab.Button, {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, 0.2):Play()
    
    tab.Content.Visible = true
end

function EyeHub:CreateButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Name = text
    button.Parent = tab.Content
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Font = Enum.Font.Code
    button.Text = text
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.TextSize = 14
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        CreateTween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2):Play()
    end)
    
    button.MouseLeave:Connect(function()
        CreateTween(button, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        CreateTween(button, {Size = UDim2.new(1, -5, 0, 38)}, 0.1):Play()
        wait(0.1)
        CreateTween(button, {Size = UDim2.new(1, 0, 0, 40)}, 0.1):Play()
        if callback then callback() end
    end)
    
    return button
end

function EyeHub:CreateToggle(tab, text, default, callback)
    local container = Instance.new("Frame")
    container.Name = text
    container.Parent = tab.Content
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 40)
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Font = Enum.Font.Code
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggle = Instance.new("TextButton")
    toggle.Parent = container
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    toggle.BorderSizePixel = 0
    toggle.Position = UDim2.new(1, -40, 0.5, -10)
    toggle.Size = UDim2.new(0, 35, 0, 20)
    toggle.Text = ""
    toggle.AutoButtonColor = false
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggle
    
    local indicator = Instance.new("Frame")
    indicator.Parent = toggle
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BorderSizePixel = 0
    indicator.Position = default and UDim2.new(0, 17, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    indicator.Size = UDim2.new(0, 16, 0, 16)
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 8)
    indicatorCorner.Parent = indicator
    
    local enabled = default or false
    
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        local bgColor = enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
        local indicatorPos = enabled and UDim2.new(0, 17, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        
        CreateTween(toggle, {BackgroundColor3 = bgColor}, 0.2):Play()
        CreateTween(indicator, {Position = indicatorPos}, 0.2):Play()
        
        if callback then callback(enabled) end
    end)
    
    return container
end

function EyeHub:Notification(title, description, duration)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Parent = self.ScreenGui
    notification.AnchorPoint = Vector2.new(1, 0)
    notification.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(1, 20, 0, 50)
    notification.Size = UDim2.new(0, 300, 0, 80)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notification
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.Size = UDim2.new(1, -30, 0, 20)
    titleLabel.Font = Enum.Font.Code
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = notification
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 15, 0, 30)
    descLabel.Size = UDim2.new(1, -30, 0, 40)
    descLabel.Font = Enum.Font.Code
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.TextSize = 12
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    CreateTween(notification, {Position = UDim2.new(1, -20, 0, 50)}, 0.4):Play()
    
    wait(duration or 3)
    
    CreateTween(notification, {Position = UDim2.new(1, 20, 0, 50)}, 0.4):Play()
    wait(0.4)
    notification:Destroy()
end

function EyeHub:Destroy()
    CreateTween(self.Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back):Play()
    wait(0.3)
    self.ScreenGui:Destroy()
end

return EyeHub
