local EyeHub = {}
EyeHub.__index = EyeHub

function EyeHub.new()
    local self = setmetatable({}, EyeHub)
    
    -- Create main GUI
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "Eye"
    self.GUI.ResetOnSpawn = false
    
    -- Main container
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.Size = UDim2.new(0, 683, 0, 452)
    self.Main.Position = UDim2.new(0, 353, 0, 216)
    self.Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.Main.Parent = self.GUI
    
    -- Elements container
    self.Elements = Instance.new("Frame")
    self.Elements.Name = "Elements"
    self.Elements.Size = UDim2.new(0.977, 0, 0.893, 0)
    self.Elements.Position = UDim2.new(0.011, 0, 0.084, 0)
    self.Elements.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.Elements.BackgroundTransparency = 0.5
    self.Elements.Parent = self.Main
    
    -- Scrolling frame for elements
    self.ScrollingFrame = Instance.new("ScrollingFrame")
    self.ScrollingFrame.Name = "ScrollingFrame"
    self.ScrollingFrame.Size = UDim2.new(0, 528, 0, 394)
    self.ScrollingFrame.Position = UDim2.new(0.221, 0, 0, 0)
    self.ScrollingFrame.BackgroundTransparency = 1
    self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
    self.ScrollingFrame.ScrollBarThickness = 13
    self.ScrollingFrame.ScrollBarImageTransparency = 1
    self.ScrollingFrame.Parent = self.Elements
    
    -- Layout for scrolling frame
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = self.ScrollingFrame
    
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 15)
    UIPadding.Parent = self.ScrollingFrame
    
    -- Tabs container
    self.Tabs = Instance.new("Frame")
    self.Tabs.Name = "Tabs"
    self.Tabs.Size = UDim2.new(0.23, 0, 0.893, 0)
    self.Tabs.Position = UDim2.new(0.011, 0, 0.084, 0)
    self.Tabs.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.Tabs.BackgroundTransparency = 0.5
    self.Tabs.Parent = self.Main
    
    -- Title label
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Label"
    self.Title.Size = UDim2.new(0, 658, 0, 37)
    self.Title.Position = UDim2.new(0.024, 0, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = "EyeHub - Grow a Garden"
    self.Title.Font = Enum.Font.Inconsolata
    self.Title.TextColor3 = Color3.fromRGB(230, 230, 230)
    self.Title.TextSize = 14
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Main
    
    -- Hide button
    self.HideButton = Instance.new("ImageButton")
    self.HideButton.Name = "hide"
    self.HideButton.Size = UDim2.new(0, 20, 0, 20)
    self.HideButton.Position = UDim2.new(0.959, 0, 0.018, 0)
    self.HideButton.BackgroundTransparency = 1
    self.HideButton.Image = "rbxassetid://2777727756"
    self.HideButton.Parent = self.Main
    
    -- Tab management
    self.TabButtons = {}
    self.CurrentTab = nil
    
    -- Initialize
    self:SetupUI()
    
    return self
end

function EyeHub:SetupUI()
    -- Add UI strokes and gradients
    local function addStroke(frame)
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(44, 44, 44)
        stroke.Thickness = 2
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
        })
        gradient.Rotation = 90
        gradient.Parent = stroke
        
        stroke.Parent = frame
    end
    
    addStroke(self.Main)
    addStroke(self.Elements)
    addStroke(self.Tabs)
    
    -- Hide button functionality
    self.HideButton.MouseButton1Click:Connect(function()
        self.GUI.Enabled = not self.GUI.Enabled
    end)
end

function EyeHub:AddTab(name)
    local tabButton = Instance.new("Frame")
    tabButton.Name = "TabButton"
    tabButton.Size = UDim2.new(0, 172, 0, 26)
    tabButton.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "TextLabel"
    label.Size = UDim2.new(0, 113, 0, 26)
    label.Position = UDim2.new(0.119, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.Inconsolata
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tabButton
    
    -- Add to tabs container
    tabButton.Parent = self.Tabs
    
    -- Create tab content container
    local tabContent = Instance.new("Frame")
    tabContent.Name = name
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = self.ScrollingFrame
    
    -- Store references
    self.TabButtons[name] = {
        Button = tabButton,
        Content = tabContent
    }
    
    -- Select first tab by default
    if not self.CurrentTab then
        self:SelectTab(name)
    end
    
    -- Tab button click event
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
    return tabContent
end

function EyeHub:SelectTab(name)
    if self.CurrentTab then
        -- Deselect current tab
        local current = self.TabButtons[self.CurrentTab]
        if current then
            current.Content.Visible = false
            local stroke = current.Button:FindFirstChild("UIStroke")
            if stroke then stroke:Destroy() end
        end
    end
    
    -- Select new tab
    local tab = self.TabButtons[name]
    if tab then
        tab.Content.Visible = true
        self.CurrentTab = name
        
        -- Add selection indicator
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(70, 70, 70)
        stroke.Thickness = 2
        stroke.Parent = tab.Button
        
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
        })
        gradient.Rotation = 90
        gradient.Parent = stroke
    end
end

-- Element creation functions
function EyeHub:CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Name = "Section"
    section.Size = UDim2.new(0, 483, 0, 31)
    section.BackgroundTransparency = 1
    section.Parent = parent or self.ScrollingFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "label"
    label.Size = UDim2.new(0, 476, 0, 18)
    label.Position = UDim2.new(0, 0, 0.355, 0)
    label.BackgroundTransparency = 1
    label.Text = title or "section bro"
    label.Font = Enum.Font.Inconsolata
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
    
    return section
end

function EyeHub:CreateButton(parent, text, callback)
    local button = Instance.new("Frame")
    button.Name = "Button"
    button.Size = UDim2.new(0, 483, 0, 31)
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    button.Parent = parent or self.ScrollingFrame
    
    -- Add stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(44, 44, 44)
    stroke.Thickness = 2
    stroke.Parent = button
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
    })
    gradient.Rotation = 90
    gradient.Parent = stroke
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "label"
    label.Size = UDim2.new(0, 200, 0, 29)
    label.Position = UDim2.new(0.039, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "click me pls"
    label.Font = Enum.Font.Inconsolata
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button
    
    -- Type indicator
    local typeLabel = Instance.new("TextLabel")
    typeLabel.Name = "type"
    typeLabel.Size = UDim2.new(0, 194, 0, 29)
    typeLabel.Position = UDim2.new(0.571, 0, 0.065, 0)
    typeLabel.BackgroundTransparency = 1
    typeLabel.Text = "button"
    label.Font = Enum.Font.Inconsolata
    typeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    typeLabel.TextSize = 10
    typeLabel.TextXAlignment = Enum.TextXAlignment.Right
    typeLabel.Parent = button
    
    -- Interactive button
    local interact = Instance.new("TextButton")
    interact.Name = "interact"
    interact.Size = UDim2.new(1, 0, 1, 0)
    interact.BackgroundTransparency = 1
    interact.Text = ""
    interact.Parent = button
    
    -- Connect callback
    if callback then
        interact.MouseButton1Click:Connect(callback)
    end
    
    return button
end

function EyeHub:CreateToggle(parent, text, default, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = "Toggle"
    toggle.Size = UDim2.new(0, 483, 0, 31)
    toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    toggle.Parent = parent or self.ScrollingFrame
    
    -- Add stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(44, 44, 44)
    stroke.Thickness = 2
    stroke.Parent = toggle
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
    })
    gradient.Rotation = 90
    gradient.Parent = stroke
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "label"
    label.Size = UDim2.new(0, 200, 0, 29)
    label.Position = UDim2.new(0.039, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "toggle me bro"
    label.Font = Enum.Font.Inconsolata
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle
    
    -- Switch
    local switch = Instance.new("Frame")
    switch.Name = "Switch"
    switch.Size = UDim2.new(0, 37, 0, 14)
    switch.Position = UDim2.new(0.896, 0, 0.29, 0)
    switch.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    switch.Parent = toggle
    
    local switchStroke = Instance.new("UIStroke")
    switchStroke.Color = Color3.fromRGB(44, 44, 44)
    switchStroke.Thickness = 2
    switchStroke.Parent = switch
    
    local switchGradient = Instance.new("UIGradient")
    switchGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
    })
    switchGradient.Rotation = 90
    switchGradient.Parent = switchStroke
    
    -- Toggle button
    local button = Instance.new("Frame")
    button.Name = "Button"
    button.Size = UDim2.new(0, 14, 0, 12)
    button.Position = UDim2.new(-0.022, 0, -0.014, 0)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Parent = switch
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(44, 44, 44)
    buttonStroke.Thickness = 2
    buttonStroke.Parent = button
    
    local buttonGradient = Instance.new("UIGradient")
    buttonGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
    })
    buttonGradient.Rotation = 90
    buttonGradient.Parent = buttonStroke
    
    -- Interactive button
    local interact = Instance.new("TextButton")
    interact.Name = "interact"
    interact.Size = UDim2.new(1, 0, 1, 0)
    interact.BackgroundTransparency = 1
    interact.Text = ""
    interact.Parent = toggle
    
    -- State management
    local state = default or false
    
    local function updateState()
        if state then
            button.Position = UDim2.new(0.5, 0, -0.014, 0)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        else
            button.Position = UDim2.new(-0.022, 0, -0.014, 0)
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
    end
    
    -- Toggle functionality
    interact.MouseButton1Click:Connect(function()
        state = not state
        updateState()
        if callback then callback(state) end
    end)
    
    -- Initialize state
    updateState()
    
    return {
        Toggle = toggle,
        SetState = function(newState)
            state = newState
            updateState()
        end,
        GetState = function() return state end
    }
end

function EyeHub:CreateSlider(parent, text, min, max, default, callback)
    local slider = Instance.new("Frame")
    slider.Name = "Slider"
    slider.Size = UDim2.new(0, 483, 0, 31)
    slider.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    slider.Parent = parent or self.ScrollingFrame
    
    -- Add stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(44, 44, 44)
    stroke.Thickness = 2
    stroke.Parent = slider
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
    })
    gradient.Rotation = 90
    gradient.Parent = stroke
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "label"
    label.Size = UDim2.new(0, 200, 0, 29)
    label.Position = UDim2.new(0.039, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "slide me to value"
    label.Font = Enum.Font.Inconsolata
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = slider
    
    -- Slider track
    local track = Instance.new("Frame")
    track.Name = "slider"
    track.Size = UDim2.new(0, 162, 0, 8)
    track.Position = UDim2.new(0.638, 0, 0.419, 0)
    track.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    track.Parent = slider
    
    local trackStroke = Instance.new("UIStroke")
    trackStroke.Color = Color3.fromRGB(44, 44, 44)
    trackStroke.Thickness = 2
    trackStroke.Parent = track
    
    local trackGradient = Instance.new("UIGradient")
    trackGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
    })
    trackGradient.Rotation = 90
    trackGradient.Parent = trackStroke
    
    -- Slider fill
    local fill = Instance.new("Frame")
    fill.Name = "mankey"
    fill.Size = UDim2.new(0, 90, 0, 8)
    fill.Position = UDim2.new(-0.022, 0, -0.014, 0)
    fill.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    fill.Parent = track
    
    local fillStroke = Instance.new("UIStroke")
    fillStroke.Color = Color3.fromRGB(44, 44, 44)
    fillStroke.Thickness = 2
    fillStroke.Parent = fill
    
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
    })
    fillGradient.Rotation = 90
    fillGradient.Parent = fillStroke
    
    -- Interactive button
    local interact = Instance.new("TextButton")
    interact.Name = "interact"
    interact.Size = UDim2.new(1, 0, 1, 0)
    interact.BackgroundTransparency = 1
    interact.Text = ""
    interact.Parent = slider
    
    -- Slider logic
    min = min or 0
    max = max or 100
    default = default or min
    
    local value = math.clamp(default, min, max)
    local dragging = false
    
    local function updateSlider()
        local ratio = (value - min) / (max - min)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        label.Text = text .. ": " .. tostring(math.floor(value))
    end
    
    interact.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    interact.MouseMoved:Connect(function()
        if dragging then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local trackPos = track.AbsolutePosition
            local trackSize = track.AbsoluteSize
            
            local relativeX = math.clamp(mousePos.X - trackPos.X, 0, trackSize.X)
            local ratio = relativeX / trackSize.X
            
            value = math.floor(min + (max - min) * ratio)
            updateSlider()
            
            if callback then callback(value) end
        end
    end)
    
    -- Initialize
    updateSlider()
    
    return {
        Slider = slider,
        SetValue = function(newValue)
            value = math.clamp(newValue, min, max)
            updateSlider()
        end,
        GetValue = function() return value end
    }
end

function EyeHub:CreateInput(parent, text, placeholder, callback)
    local input = Instance.new("Frame")
    input.Name = "Input"
    input.Size = UDim2.new(0, 483, 0, 31)
    input.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    input.Parent = parent or self.ScrollingFrame
    
    -- Add stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(44, 44, 44)
    stroke.Thickness = 2
    stroke.Parent = input
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
    })
    gradient.Rotation = 90
    gradient.Parent = stroke
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "label"
    label.Size = UDim2.new(0, 200, 0, 29)
    label.Position = UDim2.new(0.039, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "type for input"
    label.Font = Enum.Font.Inconsolata
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = input
    
    -- Text box
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = UDim2.new(0, 171, 0, 18)
    textBox.Position = UDim2.new(0.617, 0, 0.194, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    textBox.TextColor3 = Color3.fromRGB(230, 230, 230)
    textBox.Text = ""
    textBox.PlaceholderText = placeholder or "..."
    textBox.Font = Enum.Font.Code
    textBox.TextSize = 14
    textBox.ClearTextOnFocus = false
    textBox.Parent = input
    
    local textBoxStroke = Instance.new("UIStroke")
    textBoxStroke.Color = Color3.fromRGB(44, 44, 44)
    textBoxStroke.Thickness = 2
    textBoxStroke.Parent = textBox
    
    local textBoxGradient = Instance.new("UIGradient")
    textBoxGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
    })
    textBoxGradient.Rotation = 90
    textBoxGradient.Parent = textBoxStroke
    
    -- Callback on focus lost
    if callback then
        textBox.FocusLost:Connect(function()
            callback(textBox.Text)
        end)
    end
    
    return {
        Input = input,
        SetText = function(newText) textBox.Text = newText end,
        GetText = function() return textBox.Text end
    }
end

function EyeHub:CreateLabel(parent, text)
    local labelFrame = Instance.new("Frame")
    labelFrame.Name = "Label"
    labelFrame.Size = UDim2.new(0.975, -10, 0, 35)
    labelFrame.Position = UDim2.new(0.035, 0, 0, 0)
    labelFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    labelFrame.Parent = parent or self.ScrollingFrame
    
    -- Add stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(44, 44, 44)
    stroke.Thickness = 2
    stroke.Parent = labelFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
    })
    gradient.Rotation = 90
    gradient.Parent = stroke
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 441, 0, 14)
    title.Position = UDim2.new(0.014, 15, 0.5, 0)
    title.BackgroundTransparency = 1
    title.Text = text or "Label"
    title.Font = Enum.Font.Inconsolata
    title.TextColor3 = Color3.fromRGB(240, 240, 240)
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = labelFrame
    
    return labelFrame
end

function EyeHub:CreateParagraph(parent, titleText, contentText)
    local paragraph = Instance.new("Frame")
    paragraph.Name = "Paragraph"
    paragraph.Size = UDim2.new(0.934, -10, 0.084, 0)
    paragraph.Position = UDim2.new(0.042, 0, 0, 0)
    paragraph.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    paragraph.AutomaticSize = Enum.AutomaticSize.Y
    paragraph.Parent = parent or self.ScrollingFrame
    
    -- Add stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(44, 44, 44)
    stroke.Thickness = 2
    stroke.Parent = paragraph
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
    })
    gradient.Rotation = 90
    gradient.Parent = stroke
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 441, 0, 14)
    title.Position = UDim2.new(0.956, -10, 0.017, 18)
    title.BackgroundTransparency = 1
    title.Text = titleText or "Paragraph Title"
    title.Font = Enum.Font.Inconsolata
    title.TextColor3 = Color3.fromRGB(240, 240, 240)
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = paragraph
    
    -- Content
    local content = Instance.new("TextLabel")
    content.Name = "Content"
    content.Size = UDim2.new(0, 441, 0, 13)
    content.Position = UDim2.new(0.956, -10, 0.595, 0)
    content.BackgroundTransparency = 1
    content.Text = contentText or "hi"
    content.Font = Enum.Font.Inconsolata
    content.TextColor3 = Color3.fromRGB(180, 180, 180)
    content.TextSize = 13
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.TextWrapped = true
    content.Parent = paragraph
    
    -- Buffers
    local bufferTop = Instance.new("Frame")
    bufferTop.Name = "Buffer"
    bufferTop.Size = UDim2.new(0, 0, 0, 8)
    bufferTop.LayoutOrder = -1
    bufferTop.BackgroundTransparency = 1
    bufferTop.Parent = paragraph
    
    local bufferBottom = Instance.new("Frame")
    bufferBottom.Name = "Buffer"
    bufferBottom.Size = UDim2.new(0, 0, 0, 8)
    bufferBottom.LayoutOrder = 5
    bufferBottom.BackgroundTransparency = 1
    bufferBottom.Parent = paragraph
    
    return paragraph
end

function EyeHub:CreateDivider(parent)
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, 0, 0, 20)
    divider.BackgroundTransparency = 1
    divider.Parent = parent or self.ScrollingFrame
    
    local line = Instance.new("Frame")
    line.Name = "Divider"
    line.Size = UDim2.new(1.039, -50, 0, 2)
    line.Position = UDim2.new(0.505, 0, 0.5, 0)
    line.BackgroundTransparency = 0.85
    line.Parent = divider
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(44, 44, 44)
    stroke.Thickness = 2
    stroke.Parent = line
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(149, 149, 149))
    })
    gradient.Rotation = 90
    gradient.Parent = stroke
    
    return divider
end

function EyeHub:Show()
    self.GUI.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    self.GUI.Enabled = true
end

function EyeHub:Hide()
    self.GUI.Enabled = false
end

function EyeHub:Destroy()
    self.GUI:Destroy()
end

return EyeHub
