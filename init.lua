--[[
EyeHub Interface
by EyeHub
deadhoes | Designing + Programming
--]]

local EyeHub = {}
EyeHub.__index = EyeHub

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

function EyeHub:Create(config)
    local self = setmetatable({}, EyeHub)
    
    self.Config = config or {}
    self.Title = self.Config.Title or "EyeHub"
    self.Game = self.Config.Game or "Universal"
    self.Tabs = {}
    self.CurrentTab = nil
    self.Notifications = {}
    
    self:CreateGui()
    
    return self
end

function EyeHub:CreateGui()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "EyeHub"
    self.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "Main"
    self.MainFrame.Parent = self.ScreenGui
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.Size = UDim2.new(0, 650, 0, 400)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainFrame
    
    self:CreateTitleBar()
    self:CreateTabContainer()
    self:CreateContentContainer()
    self:MakeDraggable()
end

function EyeHub:CreateTitleBar()
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = self.MainFrame
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = titleBar
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = self.Title .. " - " .. self.Game
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local closeButton = Instance.new("ImageButton")
    closeButton.Parent = titleBar
    closeButton.BackgroundTransparency = 1
    closeButton.Position = UDim2.new(1, -30, 0, 7)
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Image = "rbxassetid://2777727756"
    closeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    
    closeButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
end

function EyeHub:CreateTabContainer()
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Parent = self.MainFrame
    self.TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Position = UDim2.new(0, 0, 0, 35)
    self.TabContainer.Size = UDim2.new(0, 150, 1, -35)
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = self.TabContainer
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2)
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.Parent = self.TabContainer
    tabPadding.PaddingTop = UDim.new(0, 5)
end

function EyeHub:CreateContentContainer()
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Parent = self.MainFrame
    self.ContentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.Position = UDim2.new(0, 150, 0, 35)
    self.ContentContainer.Size = UDim2.new(1, -150, 1, -35)
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = self.ContentContainer
end

function EyeHub:CreateTab(name)
    local tab = {
        Name = name,
        Elements = {},
        Container = nil,
        Button = nil,
        Active = false
    }
    
    tab.Button = Instance.new("TextButton")
    tab.Button.Parent = self.TabContainer
    tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tab.Button.BorderSizePixel = 0
    tab.Button.Size = UDim2.new(1, -10, 0, 35)
    tab.Button.Font = Enum.Font.Gotham
    tab.Button.Text = name
    tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    tab.Button.TextSize = 13
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = tab.Button
    
    tab.Container = Instance.new("ScrollingFrame")
    tab.Container.Parent = self.ContentContainer
    tab.Container.BackgroundTransparency = 1
    tab.Container.BorderSizePixel = 0
    tab.Container.Size = UDim2.new(1, 0, 1, 0)
    tab.Container.ScrollBarThickness = 6
    tab.Container.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    tab.Container.Visible = false
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = tab.Container
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    
    local padding = Instance.new("UIPadding")
    padding.Parent = tab.Container
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    
    tab.Button.MouseButton1Click:Connect(function()
        self:SwitchTab(tab)
    end)
    
    table.insert(self.Tabs, tab)
    
    if not self.CurrentTab then
        self:SwitchTab(tab)
    end
    
    return self:CreateTabMethods(tab)
end

function EyeHub:CreateTabMethods(tab)
    local tabMethods = {}
    
    function tabMethods:CreateButton(text, callback)
        local button = Instance.new("TextButton")
        button.Parent = tab.Container
        button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        button.BorderSizePixel = 0
        button.Size = UDim2.new(1, -20, 0, 35)
        button.Font = Enum.Font.Gotham
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 13
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
        
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end)
        
        self:UpdateCanvasSize(tab)
        return button
    end
    
    function tabMethods:CreateToggle(text, default, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Parent = tab.Container
        toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Size = UDim2.new(1, -20, 0, 35)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = toggleFrame
        
        local label = Instance.new("TextLabel")
        label.Parent = toggleFrame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Size = UDim2.new(1, -70, 1, 0)
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local switch = Instance.new("Frame")
        switch.Parent = toggleFrame
        switch.BackgroundColor3 = default and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(60, 60, 60)
        switch.BorderSizePixel = 0
        switch.Position = UDim2.new(1, -45, 0.5, -8)
        switch.Size = UDim2.new(0, 35, 0, 16)
        
        local switchCorner = Instance.new("UICorner")
        switchCorner.CornerRadius = UDim.new(0, 8)
        switchCorner.Parent = switch
        
        local knob = Instance.new("Frame")
        knob.Parent = switch
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.Position = default and UDim2.new(1, -14, 0, 2) or UDim2.new(0, 2, 0, 2)
        knob.Size = UDim2.new(0, 12, 0, 12)
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(0, 6)
        knobCorner.Parent = knob
        
        local enabled = default or false
        
        local button = Instance.new("TextButton")
        button.Parent = toggleFrame
        button.BackgroundTransparency = 1
        button.Size = UDim2.new(1, 0, 1, 0)
        button.Text = ""
        
        button.MouseButton1Click:Connect(function()
            enabled = not enabled
            
            local switchColor = enabled and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(60, 60, 60)
            local knobPosition = enabled and UDim2.new(1, -14, 0, 2) or UDim2.new(0, 2, 0, 2)
            
            TweenService:Create(switch, TweenInfo.new(0.3), {BackgroundColor3 = switchColor}):Play()
            TweenService:Create(knob, TweenInfo.new(0.3), {Position = knobPosition}):Play()
            
            if callback then callback(enabled) end
        end)
        
        self:UpdateCanvasSize(tab)
        return toggleFrame
    end
    
    function tabMethods:CreateSlider(text, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Parent = tab.Container
        sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Size = UDim2.new(1, -20, 0, 50)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = sliderFrame
        
        local label = Instance.new("TextLabel")
        label.Parent = sliderFrame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 15, 0, 5)
        label.Size = UDim2.new(1, -30, 0, 20)
        label.Font = Enum.Font.Gotham
        label.Text = text .. ": " .. tostring(default)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Parent = sliderFrame
        sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        sliderBg.BorderSizePixel = 0
        sliderBg.Position = UDim2.new(0, 15, 1, -20)
        sliderBg.Size = UDim2.new(1, -30, 0, 6)
        
        local sliderBgCorner = Instance.new("UICorner")
        sliderBgCorner.CornerRadius = UDim.new(0, 3)
        sliderBgCorner.Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Parent = sliderBg
        sliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        sliderFill.BorderSizePixel = 0
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        
        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(0, 3)
        sliderFillCorner.Parent = sliderFill
        
        local dragging = false
        local value = default
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouse = UserInputService:GetMouseLocation()
                local relativePos = (mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
                relativePos = math.clamp(relativePos, 0, 1)
                
                value = min + (relativePos * (max - min))
                value = math.floor(value + 0.5)
                
                sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                label.Text = text .. ": " .. tostring(value)
                
                if callback then callback(value) end
            end
        end)
        
        self:UpdateCanvasSize(tab)
        return sliderFrame
    end
    
    function tabMethods:CreateDropdown(text, options, callback)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Parent = tab.Container
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.Size = UDim2.new(1, -20, 0, 35)
        dropdownFrame.ClipsDescendants = true
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = dropdownFrame
        
        local label = Instance.new("TextLabel")
        label.Parent = dropdownFrame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Size = UDim2.new(1, -50, 0, 35)
        label.Font = Enum.Font.Gotham
        label.Text = text .. ": " .. (options[1] or "None")
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local arrow = Instance.new("ImageLabel")
        arrow.Parent = dropdownFrame
        arrow.BackgroundTransparency = 1
        arrow.Position = UDim2.new(1, -30, 0, 9)
        arrow.Size = UDim2.new(0, 16, 0, 16)
        arrow.Image = "rbxassetid://2777862738"
        arrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
        
        local optionsFrame = Instance.new("Frame")
        optionsFrame.Parent = dropdownFrame
        optionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        optionsFrame.BorderSizePixel = 0
        optionsFrame.Position = UDim2.new(0, 0, 0, 35)
        optionsFrame.Size = UDim2.new(1, 0, 0, #options * 30)
        
        local optionsLayout = Instance.new("UIListLayout")
        optionsLayout.Parent = optionsFrame
        
        local isOpen = false
        local selectedOption = options[1]
        
        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Parent = optionsFrame
            optionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            optionButton.BorderSizePixel = 0
            optionButton.Size = UDim2.new(1, 0, 0, 30)
            optionButton.Font = Enum.Font.Gotham
            optionButton.Text = option
            optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            optionButton.TextSize = 12
            
            optionButton.MouseButton1Click:Connect(function()
                selectedOption = option
                label.Text = text .. ": " .. option
                
                isOpen = false
                TweenService:Create(dropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 0, 35)}):Play()
                TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                
                if callback then callback(option) end
                self:UpdateCanvasSize(tab)
            end)
            
            optionButton.MouseEnter:Connect(function()
                optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end)
            
            optionButton.MouseLeave:Connect(function()
                optionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end)
        end
        
        local button = Instance.new("TextButton")
        button.Parent = dropdownFrame
        button.BackgroundTransparency = 1
        button.Size = UDim2.new(1, 0, 0, 35)
        button.Text = ""
        
        button.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            
            if isOpen then
                TweenService:Create(dropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 0, 35 + #options * 30)}):Play()
                TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
            else
                TweenService:Create(dropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 0, 35)}):Play()
                TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
            end
            
            wait(0.3)
            self:UpdateCanvasSize(tab)
        end)
        
        self:UpdateCanvasSize(tab)
        return dropdownFrame
    end
    
    function tabMethods:CreateTextBox(text, placeholder, callback)
        local textboxFrame = Instance.new("Frame")
        textboxFrame.Parent = tab.Container
        textboxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        textboxFrame.BorderSizePixel = 0
        textboxFrame.Size = UDim2.new(1, -20, 0, 35)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = textboxFrame
        
        local label = Instance.new("TextLabel")
        label.Parent = textboxFrame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Size = UDim2.new(0, 150, 1, 0)
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local textbox = Instance.new("TextBox")
        textbox.Parent = textboxFrame
        textbox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        textbox.BorderSizePixel = 0
        textbox.Position = UDim2.new(0, 170, 0, 7)
        textbox.Size = UDim2.new(1, -185, 0, 21)
        textbox.Font = Enum.Font.Gotham
        textbox.PlaceholderText = placeholder
        textbox.Text = ""
        textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textbox.TextSize = 12
        
        local textboxCorner = Instance.new("UICorner")
        textboxCorner.CornerRadius = UDim.new(0, 4)
        textboxCorner.Parent = textbox
        
        textbox.FocusLost:Connect(function(enterPressed)
            if callback then callback(textbox.Text) end
        end)
        
        self:UpdateCanvasSize(tab)
        return textboxFrame
    end
    
    return tabMethods
end

function EyeHub:SwitchTab(targetTab)
    for _, tab in pairs(self.Tabs) do
        if tab == targetTab then
            tab.Container.Visible = true
            tab.Button.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            tab.Active = true
            self.CurrentTab = tab
        else
            tab.Container.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            tab.Active = false
        end
    end
end

function EyeHub:UpdateCanvasSize(tab)
    wait()
    tab.Container.CanvasSize = UDim2.new(0, 0, 0, tab.Container.UIListLayout.AbsoluteContentSize.Y + 20)
end

function EyeHub:MakeDraggable()
    local dragging = false
    local dragInput, mousePos, framePos
    
    self.MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            self.MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function EyeHub:Toggle()
    self.MainFrame.Visible = not self.MainFrame.Visible
end

function EyeHub:Notify(title, description, duration)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Parent = self.ScreenGui
    notification.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(1, 10, 1, -100)
    notification.Size = UDim2.new(0, 300, 0, 80)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notification
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.Size = UDim2.new(1, -30, 0, 20)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = notification
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 15, 0, 30)
    descLabel.Size = UDim2.new(1, -30, 0, 40)
    descLabel.Font = Enum.Font.Gotham
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.TextSize = 12
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    TweenService:Create(notification, TweenInfo.new(0.5), {Position = UDim2.new(1, -310, 1, -100)}):Play()
    
    wait(duration or 3)
    
    TweenService:Create(notification, TweenInfo.new(0.5), {Position = UDim2.new(1, 10, 1, -100)}):Play()
    
    wait(0.5)
    notification:Destroy()
end

return EyeHub
