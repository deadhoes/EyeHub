--!strict

local EyeUI = {}
local uiInstances = {} -- Store references to created UI elements for management

local Themes = {
    Dark = {
        MainBackground = Color3.fromRGB(6, 6, 6), -- From G2L[2], G2L[4], G2L[5]
        AccentColor = Color3.fromRGB(31, 31, 31), -- From G2L[5].BorderColor3, G2L[f].Color
        TextColor = Color3.fromRGB(151, 151, 151), -- From G2L[6].ImageColor3, G2L[7].PlaceholderColor3 etc.
        SubTextColor = Color3.fromRGB(131, 131, 131), -- From G2L[14].TextColor3
        Transparent = Color3.fromRGB(255, 255, 255), -- Common transparent background color
        BorderColor = Color3.fromRGB(0, 0, 0), -- From G2L[2].BorderColor3
        CloseButtonColor = Color3.fromRGB(151, 151, 151), -- From G2L[8].ImageColor3
        ToggleButtonOn = Color3.fromRGB(0, 150, 255), -- Example color, not in G2L direct
        ToggleButtonOff = Color3.fromRGB(231, 231, 231), -- From G2L[26].BackgroundColor3
        ToggleCircleOn = Color3.fromRGB(255, 255, 255), -- From G2L[28].BackgroundColor3
        ToggleCircleOff = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(31, 31, 31), -- From G2L[1e].BackgroundColor3
        SliderBackground = Color3.fromRGB(6, 6, 6), -- From G2L[1d].BackgroundColor3
        SliderHandle = Color3.fromRGB(255, 255, 255), -- Not explicitly defined as handle, using white for clarity
        InputFieldBackground = Color3.fromRGB(6, 6, 6), -- From G2L[7].BackgroundColor3
        InputFieldTextColor = Color3.fromRGB(151, 151, 151), -- From G2L[7].PlaceholderColor3 (changed to textcolor)
        InputFieldPlaceholderColor = Color3.fromRGB(151, 151, 151), -- From G2L[7].PlaceholderColor3
    },
    Light = {
        MainBackground = Color3.fromRGB(240, 240, 240),
        AccentColor = Color3.fromRGB(200, 200, 200),
        TextColor = Color3.fromRGB(50, 50, 50),
        SubTextColor = Color3.fromRGB(80, 80, 80),
        Transparent = Color3.fromRGB(255, 255, 255),
        BorderColor = Color3.fromRGB(100, 100, 100),
        CloseButtonColor = Color3.fromRGB(80, 80, 80),
        ToggleButtonOn = Color3.fromRGB(0, 120, 200),
        ToggleButtonOff = Color3.fromRGB(180, 180, 180),
        ToggleCircleOn = Color3.fromRGB(255, 255, 255),
        ToggleCircleOff = Color3.fromRGB(255, 255, 255),
        SliderFill = Color3.fromRGB(120, 120, 120),
        SliderBackground = Color3.fromRGB(220, 220, 220),
        SliderHandle = Color3.fromRGB(50, 50, 50),
        InputFieldBackground = Color3.fromRGB(230, 230, 230),
        InputFieldTextColor = Color3.fromRGB(30, 30, 30),
        InputFieldPlaceholderColor = Color3.fromRGB(100, 100, 100),
    }
}

local currentThemeName = "Dark"

local ThemeManager = {}

function ThemeManager.applyTheme(uiElement: GuiObject, theme: { [string]: Color3 })
    if uiElement:IsA("Frame") or uiElement:IsA("CanvasGroup") then
        if uiElement.Name == "OptionsTab" or uiElement.Name == "Stuff" then
            uiElement.BackgroundColor3 = theme.MainBackground
        elseif uiElement.Name == "TopBar" then
            uiElement.BackgroundColor3 = theme.MainBackground
            uiElement.BorderColor3 = theme.AccentColor
        elseif uiElement.Name == "List" then
            uiElement.BackgroundColor3 = theme.MainBackground
        elseif uiElement.Name == "Tab" then
            uiElement.ImageColor3 = theme.AccentColor -- For the background image
        elseif uiElement.Name == "Tabs" then
            uiElement.BackgroundColor3 = theme.MainBackground
        elseif uiElement.Name == "Toggle" then
            -- Handled by toggle button logic via Button.BackgroundColor3
        elseif uiElement.Name == "Text" or uiElement.Name == "Button" or uiElement.Name == "Slider" then
            uiElement.BackgroundColor3 = theme.MainBackground
            uiElement.BorderColor3 = theme.AccentColor
        elseif uiElement.Name == "SliderTrack" then -- This is the outer frame of the slider
             uiElement.BackgroundColor3 = theme.SliderBackground
        elseif uiElement.Name == "Fill" then
            uiElement.BackgroundColor3 = theme.SliderFill
        end
    elseif uiElement:IsA("TextLabel") then
        if uiElement.Name == "Name" then
            uiElement.TextColor3 = theme.TextColor
        elseif uiElement.Name == "Description" then
            uiElement.TextColor3 = theme.SubTextColor
        else
            uiElement.TextColor3 = theme.TextColor
        end
        uiElement.BackgroundTransparency = 1.0
    elseif uiElement:IsA("ImageLabel") then
        if uiElement.Name == "Close" or uiElement.Name == "Minimize" or uiElement.Name == "TabButton" then
            uiElement.ImageColor3 = theme.CloseButtonColor -- Reusing for general icons
        elseif uiElement.Name == "Icon" then
            uiElement.ImageColor3 = theme.TextColor -- Icons within components
        elseif uiElement.Name == "Circle" then
            uiElement.BackgroundColor3 = theme.ToggleCircleOn -- Default state
        end
        uiElement.BackgroundTransparency = 1.0
    elseif uiElement:IsA("TextButton") then
        -- Buttons that are part of components, e.g., the trigger for a slider or toggle
        if uiElement.Name == "Trigger" then
             uiElement.BackgroundTransparency = 1.0
        elseif uiElement.Name == "Button" and uiElement.Parent and uiElement.Parent.Name == "Toggle" then
            uiElement.BackgroundTransparency = 1.0 -- The invisible button over the toggle frame
        end
    elseif uiElement:IsA("TextBox") then
        uiElement.BackgroundColor3 = theme.InputFieldBackground
        uiElement.TextColor3 = theme.InputFieldTextColor
        uiElement.PlaceholderColor3 = theme.InputFieldPlaceholderColor
        uiElement.BackgroundTransparency = 1.0 -- Assuming you want transparency for the search box
    elseif uiElement:IsA("UIStroke") then
        uiElement.Color = theme.AccentColor
    end

    for _, child in ipairs(uiElement:GetChildren()) do
        if child:IsA("GuiObject") or child:IsA("UIStroke") then
            ThemeManager.applyTheme(child, theme)
        end
    end
end

-- Reusable component creation functions (internal to EyeUI)
local function createButtonInternal(parent: GuiObject, config: { Name: string, Description: string?, Icon: string?, Callback: (function) -> () }): TextButton
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Parent = parent
    ButtonFrame.Name = "Button"
    ButtonFrame.BackgroundColor3 = Themes[currentThemeName].MainBackground
    ButtonFrame.Size = UDim2.new(1, 0, 0, 42)
    ButtonFrame.BorderColor3 = Themes[currentThemeName].AccentColor
    ButtonFrame.BorderSizePixel = 1 -- G2L[16] has border

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Parent = ButtonFrame
    NameLabel.Name = "Name"
    NameLabel.TextWrapped = true
    NameLabel.BorderSizePixel = 0
    NameLabel.TextSize = 14
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.TextYAlignment = Enum.TextYAlignment.Top
    NameLabel.BackgroundColor3 = Themes[currentThemeName].Transparent
    NameLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    NameLabel.TextColor3 = Themes[currentThemeName].TextColor
    NameLabel.BackgroundTransparency = 1
    NameLabel.Size = UDim2.new(0, 327, 0, 35)
    NameLabel.AutomaticSize = Enum.AutomaticSize.Y
    NameLabel.Text = config.Name
    NameLabel.Position = UDim2.new(0.019, 0, 0.07943, 0)

    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Parent = NameLabel -- Parented to Name in G2L[18]
    DescriptionLabel.Name = "Description"
    DescriptionLabel.TextWrapped = true
    DescriptionLabel.BorderSizePixel = 0
    DescriptionLabel.TextSize = 12
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescriptionLabel.BackgroundColor3 = Themes[currentThemeName].Transparent
    DescriptionLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    DescriptionLabel.TextColor3 = Themes[currentThemeName].SubTextColor
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Size = UDim2.new(0, 235, 0, 14)
    DescriptionLabel.AutomaticSize = Enum.AutomaticSize.Y
    DescriptionLabel.Text = config.Description or ""
    DescriptionLabel.Position = UDim2.new(0, 0, 0.4605, 0)

    local Icon = Instance.new("ImageLabel")
    Icon.Parent = ButtonFrame
    Icon.Name = "Icon"
    Icon.BorderSizePixel = 0
    Icon.BackgroundColor3 = Themes[currentThemeName].Transparent
    Icon.ImageColor3 = Themes[currentThemeName].TextColor
    Icon.Image = config.Icon or "rbxassetid://12974400533" -- Default from G2L[19]
    Icon.Size = UDim2.new(0, 20, 0, 20)
    Icon.Position = UDim2.new(0.92493, 0, 0.22782, 0)

    local InvisibleButton = Instance.new("TextButton")
    InvisibleButton.Parent = ButtonFrame
    InvisibleButton.Size = UDim2.new(1, 0, 1, 0)
    InvisibleButton.Text = ""
    InvisibleButton.BackgroundTransparency = 1
    InvisibleButton.ZIndex = 2 -- Ensure it's clickable over other elements in the frame

    if config.Callback then
        InvisibleButton.MouseButton1Click:Connect(config.Callback)
    end
    
    return ButtonFrame -- Return the main frame holding the button content
end

local function createToggleInternal(parent: GuiObject, config: { Name: string, Description: string?, Default: boolean, Callback: (boolean) -> () }): Frame
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.Name = "Toggle"
    ToggleFrame.BackgroundColor3 = Themes[currentThemeName].MainBackground
    ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
    ToggleFrame.BorderColor3 = Themes[currentThemeName].AccentColor
    ToggleFrame.BorderSizePixel = 1 -- From G2L[23]

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Parent = ToggleFrame
    NameLabel.Name = "Name"
    NameLabel.TextWrapped = true
    NameLabel.BorderSizePixel = 0
    NameLabel.TextSize = 14
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.TextYAlignment = Enum.TextYAlignment.Top
    NameLabel.BackgroundColor3 = Themes[currentThemeName].Transparent
    NameLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    NameLabel.TextColor3 = Themes[currentThemeName].TextColor
    NameLabel.BackgroundTransparency = 1
    NameLabel.Size = UDim2.new(0, 305, 0, 25)
    NameLabel.AutomaticSize = Enum.AutomaticSize.Y
    NameLabel.Text = config.Name
    NameLabel.Position = UDim2.new(0.01632, 0, 0.23943, 0)

    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Parent = NameLabel
    DescriptionLabel.Name = "Description"
    DescriptionLabel.TextWrapped = true
    DescriptionLabel.BorderSizePixel = 0
    DescriptionLabel.TextSize = 12
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescriptionLabel.BackgroundColor3 = Themes[currentThemeName].Transparent
    DescriptionLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    DescriptionLabel.TextColor3 = Themes[currentThemeName].SubTextColor
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Size = UDim2.new(0, 235, 0, 14)
    DescriptionLabel.AutomaticSize = Enum.AutomaticSize.Y
    DescriptionLabel.Text = config.Description or ""
    DescriptionLabel.Position = UDim2.new(0, 0, 0.40907, 0)

    local ToggleSwitch = Instance.new("Frame")
    ToggleSwitch.Parent = ToggleFrame
    ToggleSwitch.Name = "Toggle" -- Inner toggle frame
    ToggleSwitch.BorderSizePixel = 0
    ToggleSwitch.BackgroundColor3 = Themes[currentThemeName].ToggleButtonOff -- Initial color
    ToggleSwitch.Size = UDim2.new(0, 40, 0, 22)
    ToggleSwitch.Position = UDim2.new(0.87131, 0, 0.28222, 0)

    local UICornerSwitch = Instance.new("UICorner")
    UICornerSwitch.CornerRadius = UDim.new(1, 0)
    UICornerSwitch.Parent = ToggleSwitch

    local ToggleCircle = Instance.new("ImageLabel")
    ToggleCircle.Parent = ToggleSwitch
    ToggleCircle.Name = "Circle"
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.BackgroundColor3 = Themes[currentThemeName].ToggleCircleOff -- G2L[28] is white
    ToggleCircle.Image = "rbxassetid://6755657357" -- Circle image
    ToggleCircle.Size = UDim2.new(0, 19, 0, 19)
    ToggleCircle.Position = UDim2.new(0, 1, 0.045, 0) -- Initial position (left)

    local ToggleButtonHitbox = Instance.new("TextButton")
    ToggleButtonHitbox.Parent = ToggleSwitch
    ToggleButtonHitbox.Name = "Button" -- The clickable part
    ToggleButtonHitbox.Size = UDim2.new(1, 0, 1, 0)
    ToggleButtonHitbox.BackgroundTransparency = 1
    ToggleButtonHitbox.Text = ""

    local currentState = config.Default or false

    local function updateToggleVisual()
        ToggleSwitch.BackgroundColor3 = currentState and Themes[currentThemeName].ToggleButtonOn or Themes[currentThemeName].ToggleButtonOff
        if currentState then
            ToggleCircle:TweenPosition(UDim2.new(0, ToggleSwitch.AbsoluteSize.X - ToggleCircle.AbsoluteSize.X - 1, 0.045, 0), "Out", "Quad", 0.15, true)
        else
            ToggleCircle:TweenPosition(UDim2.new(0, 1, 0.045, 0), "Out", "Quad", 0.15, true)
        end
    end

    ToggleButtonHitbox.MouseButton1Click:Connect(function()
        currentState = not currentState
        updateToggleVisual()
        if config.Callback then
            config.Callback(currentState)
        end
    end)
    
    updateToggleVisual() -- Set initial visual state

    return ToggleFrame
end

local function createSliderInternal(parent: GuiObject, config: { Name: string, Description: string?, Min: number, Max: number, Default: number, Callback: (number) -> () }): Frame
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = parent
    SliderFrame.Name = "Slider"
    SliderFrame.BackgroundColor3 = Themes[currentThemeName].MainBackground
    SliderFrame.Size = UDim2.new(1, 0, 0, 50) -- From G2L[1a]
    SliderFrame.BorderColor3 = Themes[currentThemeName].AccentColor
    SliderFrame.BorderSizePixel = 1 -- From G2L[1a]

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Parent = SliderFrame
    NameLabel.Name = "Name"
    NameLabel.TextWrapped = true
    NameLabel.BorderSizePixel = 0
    NameLabel.TextSize = 14
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.TextYAlignment = Enum.TextYAlignment.Top
    NameLabel.BackgroundColor3 = Themes[currentThemeName].Transparent
    NameLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    NameLabel.TextColor3 = Themes[currentThemeName].TextColor
    NameLabel.BackgroundTransparency = 1
    NameLabel.Size = UDim2.new(0, 327, 0, 32)
    NameLabel.AutomaticSize = Enum.AutomaticSize.Y
    NameLabel.Text = config.Name .. " (" .. tostring(math.floor(config.Default or config.Min)) .. ")"
    NameLabel.Position = UDim2.new(0.019, 0, 0.07943, 0)

    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Parent = NameLabel
    DescriptionLabel.Name = "Description"
    DescriptionLabel.TextWrapped = true
    DescriptionLabel.BorderSizePixel = 0
    DescriptionLabel.TextSize = 12
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescriptionLabel.BackgroundColor3 = Themes[currentThemeName].Transparent
    DescriptionLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    DescriptionLabel.TextColor3 = Themes[currentThemeName].SubTextColor
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Size = UDim2.new(0, 235, 0, 14)
    DescriptionLabel.AutomaticSize = Enum.AutomaticSize.Y
    DescriptionLabel.Text = config.Description or ""
    DescriptionLabel.Position = UDim2.new(0, 0, 0.28907, 0)

    local SliderContainer = Instance.new("CanvasGroup")
    SliderContainer.Parent = NameLabel -- Parented to Name in G2L[1d]
    SliderContainer.Name = "SliderTrack"
    SliderContainer.BorderSizePixel = 0
    SliderContainer.BackgroundColor3 = Themes[currentThemeName].SliderBackground
    SliderContainer.Size = UDim2.new(0, 150, 0, 15)
    SliderContainer.Position = UDim2.new(-0.003, 0, 0.762, 0)

    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderContainer
    SliderFill.Name = "Fill"
    SliderFill.BorderSizePixel = 0
    SliderFill.BackgroundColor3 = Themes[currentThemeName].SliderFill
    SliderFill.Size = UDim2.new(0, 0, 1, 0) -- Will be updated
    SliderFill.Position = UDim2.new(0, 0, 0, 0)

    local SliderStroke = Instance.new("UIStroke")
    SliderStroke.Parent = SliderContainer
    SliderStroke.Color = Themes[currentThemeName].AccentColor

    local UICornerSlider = Instance.new("UICorner")
    UICornerSlider.Parent = SliderContainer

    local SliderTrigger = Instance.new("TextButton")
    SliderTrigger.Parent = SliderContainer
    SliderTrigger.Name = "Trigger"
    SliderTrigger.BorderSizePixel = 0
    SliderTrigger.TextSize = 13
    SliderTrigger.TextColor3 = Themes[currentThemeName].TextColor
    SliderTrigger.BackgroundColor3 = Themes[currentThemeName].Transparent
    SliderTrigger.BackgroundTransparency = 1
    SliderTrigger.Size = UDim2.new(1, 0, 1, 0) -- Fills the container
    SliderTrigger.Text = ""

    local currentValue = config.Default or config.Min
    local isDragging = false
    local minVal = config.Min or 0
    local maxVal = config.Max or 100

    local function updateSlider(xPos: number)
        local trackWidth = SliderContainer.AbsoluteSize.X
        if trackWidth == 0 then return end -- Avoid division by zero

        local newX = math.clamp(xPos - SliderContainer.AbsolutePosition.X, 0, trackWidth)
        local normalizedValue = newX / trackWidth
        currentValue = minVal + (maxVal - minVal) * normalizedValue
        
        SliderFill.Size = UDim2.new(normalizedValue, 0, 1, 0)
        NameLabel.Text = config.Name .. " (" .. tostring(math.floor(currentValue)) .. ")"
        
        if config.Callback then
            config.Callback(currentValue)
        end
    end

    SliderTrigger.MouseButton1Down:Connect(function()
        isDragging = true
        game.UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end)

    game.UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
            updateSlider(input.Position.X)
        end
    end)

    game.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and isDragging then
            isDragging = false
            game.UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end)

    -- Initial update based on default value
    local initialNormalized = (currentValue - minVal) / (maxVal - minVal)
    SliderFill.Size = UDim2.new(initialNormalized, 0, 1, 0)
    
    return SliderFrame
end

local function createTextboxInternal(parent: GuiObject, config: { Name: string, Placeholder: string, Callback: (string) -> () }): Frame
    local TextboxFrame = Instance.new("Frame")
    TextboxFrame.Parent = parent
    TextboxFrame.Name = "Text" -- Naming it 'Text' as per G2L[12]
    TextboxFrame.BackgroundColor3 = Themes[currentThemeName].MainBackground
    TextboxFrame.Size = UDim2.new(1, 0, 0, 42) -- From G2L[12]
    TextboxFrame.BorderColor3 = Themes[currentThemeName].AccentColor
    TextboxFrame.BorderSizePixel = 1 -- From G2L[12]

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Parent = TextboxFrame
    NameLabel.Name = "Name"
    NameLabel.TextWrapped = true
    NameLabel.BorderSizePixel = 0
    NameLabel.TextSize = 14
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.TextYAlignment = Enum.TextYAlignment.Top
    NameLabel.BackgroundColor3 = Themes[currentThemeName].Transparent
    NameLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    NameLabel.TextColor3 = Themes[currentThemeName].TextColor
    NameLabel.BackgroundTransparency = 1
    NameLabel.Size = UDim2.new(0, 327, 0, 35)
    NameLabel.AutomaticSize = Enum.AutomaticSize.Y
    NameLabel.Text = config.Name
    NameLabel.Position = UDim2.new(0.01646, 0, 0.07989, 0)

    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Parent = NameLabel
    DescriptionLabel.Name = "Description"
    DescriptionLabel.TextWrapped = true
    DescriptionLabel.BorderSizePixel = 0
    DescriptionLabel.TextSize = 12
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescriptionLabel.BackgroundColor3 = Themes[currentThemeName].Transparent
    DescriptionLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    DescriptionLabel.TextColor3 = Themes[currentThemeName].SubTextColor
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Size = UDim2.new(0, 235, 0, 16)
    DescriptionLabel.AutomaticSize = Enum.AutomaticSize.Y
    DescriptionLabel.Text = config.Placeholder or "Enter text..."
    DescriptionLabel.Position = UDim2.new(0, 0, 0.4605, 0)

    local Icon = Instance.new("ImageLabel")
    Icon.Parent = TextboxFrame
    Icon.Name = "Icon"
    Icon.BorderSizePixel = 0
    Icon.BackgroundColor3 = Themes[currentThemeName].Transparent
    Icon.ImageColor3 = Themes[currentThemeName].TextColor
    Icon.Image = "rbxassetid://11432857440" -- Default from G2L[15]
    Icon.Size = UDim2.new(0, 20, 0, 20)
    Icon.Position = UDim2.new(0.92493, 0, 0.22782, 0)

    local InputField = Instance.new("TextBox")
    InputField.Parent = TextboxFrame
    InputField.Name = "InputField" -- Internal name for the actual textbox
    InputField.Size = UDim2.new(0.8, 0, 0.5, 0) -- Adjusted size
    InputField.Position = UDim2.new(0.1, 0, 0.3, 0) -- Adjusted position
    InputField.BackgroundColor3 = Themes[currentThemeName].InputFieldBackground
    InputField.TextColor3 = Themes[currentThemeName].InputFieldTextColor
    InputField.PlaceholderColor3 = Themes[currentThemeName].InputFieldPlaceholderColor
    InputField.Font = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    InputField.TextSize = 14
    InputField.TextWrapped = true
    InputField.MultiLine = false
    InputField.ClearTextOnFocus = false
    InputField.BackgroundTransparency = 1.0
    InputField.Text = config.Placeholder or ""

    local originalPlaceholder = config.Placeholder or ""

    InputField.Focused:Connect(function()
        if InputField.Text == originalPlaceholder then
            InputField.Text = ""
        end
        DescriptionLabel.Visible = false -- Hide description when focused
    end)
    
    InputField.FocusLost:Connect(function(enterPressed)
        if InputField.Text == "" then
            InputField.Text = originalPlaceholder
            DescriptionLabel.Visible = true -- Show description if empty
        end
        if enterPressed and config.Callback then
            config.Callback(InputField.Text)
        end
    end)

    return TextboxFrame
end


-- Tab Object
local Tab = {}
Tab.__index = Tab

function Tab.new(parentContentFrame: ScrollingFrame, parentTabsContainer: CanvasGroup, name: string)
    local self = setmetatable({}, Tab)

    self._tabName = name
    self._parentContentFrame = parentContentFrame -- The scrolling frame where elements go
    self._parentTabsContainer = parentTabsContainer -- The container for tab buttons

    local TabButton = Instance.new("TextButton")
    TabButton.Parent = parentTabsContainer
    TabButton.Name = "TabButton"
    TabButton.TextSize = 14
    TabButton.TextColor3 = Themes[currentThemeName].TextColor
    TabButton.BackgroundColor3 = Themes[currentThemeName].MainBackground
    TabButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    TabButton.Size = UDim2.new(0, 147, 0, 41)
    TabButton.BorderColor3 = Themes[currentThemeName].AccentColor
    TabButton.BorderSizePixel = 1 -- from G2L[2c]
    TabButton.Text = "" -- Text is in sub-label

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Parent = TabButton
    NameLabel.Name = "Name"
    NameLabel.BorderSizePixel = 0
    NameLabel.TextSize = 15
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.BackgroundColor3 = Themes[currentThemeName].Transparent
    NameLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    NameLabel.TextColor3 = Themes[currentThemeName].TextColor
    NameLabel.BackgroundTransparency = 1
    NameLabel.Size = UDim2.new(0, 117, 0, 40)
    NameLabel.Text = name
    NameLabel.Position = UDim2.new(0.20946, 0, 0, 0)

    local Icon = Instance.new("ImageLabel")
    Icon.Parent = TabButton
    Icon.Name = "Icon"
    Icon.BorderSizePixel = 0
    Icon.BackgroundColor3 = Themes[currentThemeName].Transparent
    Icon.ImageColor3 = Themes[currentThemeName].TextColor
    Icon.Image = "rbxassetid://12967526257" -- Default from G2L[2e]
    Icon.Size = UDim2.new(0, 20, 0, 20)
    Icon.Position = UDim2.new(0, 5, 0.244, 0)

    self._tabButton = TabButton
    
    -- The actual content frame for this specific tab
    self._tabContentScrollingFrame = Instance.new("ScrollingFrame")
    self._tabContentScrollingFrame.Parent = parentContentFrame -- Parent to the main content area
    self._tabContentScrollingFrame.Name = "TabContent_" .. name
    self._tabContentScrollingFrame.Active = true
    self._tabContentScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    self._tabContentScrollingFrame.BorderSizePixel = 0
    self._tabContentScrollingFrame.BackgroundColor3 = Themes[currentThemeName].MainBackground
    self._tabContentScrollingFrame.Size = UDim2.new(1, 0, 1, 0) -- Fill the elements parent
    self._tabContentScrollingFrame.ScrollBarImageColor3 = Themes[currentThemeName].AccentColor
    self._tabContentScrollingFrame.ScrollBarThickness = 3
    self._tabContentScrollingFrame.BackgroundTransparency = 1.0
    self._tabContentScrollingFrame.Visible = false -- Initially hidden

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = self._tabContentScrollingFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = self._tabContentScrollingFrame
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)

    self._elementsContainer = self._tabContentScrollingFrame

    self._tabButton.MouseButton1Click:Connect(function()
        -- Hide all other tab content frames
        for _, child in ipairs(parentContentFrame:GetChildren()) do
            if child:IsA("ScrollingFrame") and string.find(child.Name, "TabContent_") then
                child.Visible = false
            end
        end
        self._tabContentScrollingFrame.Visible = true
    end)
    
    -- Make the first tab created visible by default
    if #parentTabsContainer:GetChildren() == 1 then
        self._tabContentScrollingFrame.Visible = true
    end

    return self
end

function Tab:Button(config: { Name: string, Description: string?, Icon: string?, Callback: (function) -> () }): TextButton
    return createButtonInternal(self._elementsContainer, config)
end

function Tab:Toggle(config: { Name: string, Description: string?, Default: boolean, Callback: (boolean) -> () }): Frame
    return createToggleInternal(self._elementsContainer, config)
end

function Tab:Slider(config: { Name: string, Description: string?, Min: number, Max: number, Default: number, Callback: (number) -> () }): Frame
    return createSliderInternal(self._elementsContainer, config)
end

function Tab:Textbox(config: { Name: string, Placeholder: string, Callback: (string) -> () }): Frame
    return createTextboxInternal(self._elementsContainer, config)
end


-- Window Object
local Window = {}
Window.__index = Window

function Window.new(config: { Title: string, Size: Vector2, Theme: string })
    local self = setmetatable({}, Window)

    local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    currentThemeName = config.Theme or "Dark" -- Set theme for this window

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Options"
    ScreenGui.Parent = playerGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    -- game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false) -- Only disable if this is the ONLY UI

    local Main = Instance.new("CanvasGroup") -- Corresponds to G2L[2] OptionsTab
    Main.Name = "OptionsTab"
    Main.Parent = ScreenGui
    Main.BorderSizePixel = 0
    Main.BackgroundColor3 = Themes[currentThemeName].MainBackground
    Main.Size = UDim2.new(0, config.Size.X, 0, config.Size.Y)
    Main.Position = UDim2.new(0.5, -config.Size.X / 2, 0.5, -config.Size.Y / 2) -- Center the window
    Main.BorderColor3 = Themes[currentThemeName].BorderColor

    local UICornerMain = Instance.new("UICorner")
    UICornerMain.Name = "Corner"
    UICornerMain.Parent = Main

    local Topbar = Instance.new("Frame")
    Topbar.Name = "TopBar"
    Topbar.Parent = Main
    Topbar.BackgroundColor3 = Themes[currentThemeName].MainBackground
    Topbar.Size = UDim2.new(1, 0, 0, 41)
    Topbar.BorderColor3 = Themes[currentThemeName].AccentColor
    Topbar.BorderSizePixel = 1 -- From G2L[5]

    local TabButtonIcon = Instance.new("ImageLabel")
    TabButtonIcon.Parent = Topbar
    TabButtonIcon.Name = "TabButton"
    TabButtonIcon.BorderSizePixel = 0
    TabButtonIcon.BackgroundColor3 = Themes[currentThemeName].Transparent
    TabButtonIcon.ImageColor3 = Themes[currentThemeName].CloseButtonColor
    TabButtonIcon.Image = "rbxassetid://11432865277" -- From G2L[6]
    TabButtonIcon.Size = UDim2.new(0, 15, 0, 15)
    TabButtonIcon.Position = UDim2.new(0.01874, 0, 0.30122, 0)

    local SearchBox = Instance.new("TextBox")
    SearchBox.Parent = Topbar
    SearchBox.Name = "SearchBox"
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.PlaceholderColor3 = Themes[currentThemeName].InputFieldPlaceholderColor
    SearchBox.BorderSizePixel = 0
    SearchBox.TextSize = 14
    SearchBox.TextColor3 = Themes[currentThemeName].InputFieldTextColor
    SearchBox.TextYAlignment = Enum.TextYAlignment.Top
    SearchBox.BackgroundColor3 = Themes[currentThemeName].Transparent -- G2L[7] is transparent
    SearchBox.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    SearchBox.AutomaticSize = Enum.AutomaticSize.Y
    SearchBox.PlaceholderText = "Search options.."
    SearchBox.Size = UDim2.new(0, 378, 0, 19)
    SearchBox.Position = UDim2.new(0.09797, 0, 0.31, 0)
    SearchBox.Text = ""

    local CloseButton = Instance.new("ImageLabel")
    CloseButton.Parent = Topbar
    CloseButton.Name = "Close"
    CloseButton.BorderSizePixel = 0
    CloseButton.BackgroundColor3 = Themes[currentThemeName].Transparent
    CloseButton.ImageColor3 = Themes[currentThemeName].CloseButtonColor
    CloseButton.Image = "rbxassetid://11293981586" -- From G2L[8]
    CloseButton.Size = UDim2.new(0, 15, 0, 15)
    CloseButton.Position = UDim2.new(0.95112, 0, 0.31707, 0)
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        -- Potentially re-enable CoreGui if no other custom UIs exist
        local hasOtherCustomUIs = false
        for _, gui in ipairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= ScreenGui.Name then
                hasOtherCustomUIs = true
                break
            end
        end
        if not hasOtherCustomUIs then
            game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
        end
    end)

    local MinimizeButton = Instance.new("ImageLabel")
    MinimizeButton.Parent = Topbar
    MinimizeButton.Name = "Minimize"
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.BackgroundColor3 = Themes[currentThemeName].Transparent
    MinimizeButton.ImageColor3 = Themes[currentThemeName].CloseButtonColor
    MinimizeButton.Image = "rbxassetid://11293980042" -- From G2L[9]
    MinimizeButton.Size = UDim2.new(0, 15, 0, 15)
    MinimizeButton.Position = UDim2.new(0.89721, 0, 0.317, 0)
    MinimizeButton.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    -- Draggable functionality for Topbar
    local drag = false
    local offset = Vector2.new()
    Topbar.MouseButton1Down:Connect(function(x, y)
        drag = true
        offset = Vector2.new(x, y) - Main.Position.Offset
        Topbar.Active = true -- Make Topbar active for dragging
        game.UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end)
    game.UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and drag then
            Main.Position = UDim2.new(0, input.Position.X - offset.X, 0, input.Position.Y - offset.Y)
        end
    end)
    game.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
            Topbar.Active = false
            game.UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end)

    -- Tabs Container (left side)
    local TabsContainer = Instance.new("CanvasGroup") -- Corresponds to G2L[30]
    TabsContainer.Name = "Tabs"
    TabsContainer.Parent = Main
    TabsContainer.BorderSizePixel = 0
    TabsContainer.BackgroundColor3 = Themes[currentThemeName].MainBackground
    TabsContainer.Size = UDim2.new(0, 148, 1, -Topbar.Size.Y.Offset) -- Fills remaining height, adjusted for Topbar
    TabsContainer.Position = UDim2.new(0, 0, Topbar.Size.Y.Scale, Topbar.Size.Y.Offset)
    TabsContainer.BorderColor3 = Themes[currentThemeName].BorderColor

    local TabsListLayout = Instance.new("UIListLayout")
    TabsListLayout.Parent = TabsContainer
    TabsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsListLayout.Padding = UDim.new(0, 5) -- Adjusted padding

    -- Main Content Area (right side)
    local ContentFrame = Instance.new("ScrollingFrame") -- Similar to G2L[2a] TabExample, but for all content
    ContentFrame.Name = "Stuff" -- Corresponds to G2L[4]
    ContentFrame.Parent = Main
    ContentFrame.BorderSizePixel = 0
    ContentFrame.BackgroundColor3 = Themes[currentThemeName].MainBackground
    ContentFrame.Size = UDim2.new(1, -TabsContainer.Size.X.Offset, 1, -Topbar.Size.Y.Offset)
    ContentFrame.Position = UDim2.new(0, TabsContainer.Size.X.Offset, Topbar.Size.Y.Scale, Topbar.Size.Y.Offset)
    ContentFrame.BackgroundTransparency = 1.0
    ContentFrame.Active = true
    ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ContentFrame.ScrollBarImageColor3 = Themes[currentThemeName].AccentColor
    ContentFrame.ScrollBarThickness = 3

    -- A temporary frame to hold elements within the content area, will be filled by tabs
    self._elementsParent = ContentFrame
    self._tabsContainer = TabsContainer
    self._mainFrame = Main -- Reference to the main window GUI

    ThemeManager.applyTheme(ScreenGui, Themes[currentThemeName])

    uiInstances.currentWindow = Main -- Keep track of the active window

    return self
end

function Window:Tab(config: { Name: string }): Tab
    return Tab.new(self._elementsParent, self._tabsContainer, config.Name)
end

-- Global functions
function EyeUI:Window(config: { Title: string, Size: Vector2, Theme: string }): Window
    return Window.new(config)
end

function EyeUI:SetTheme(themeName: string)
    if Themes[themeName] then
        currentThemeName = themeName
        if uiInstances.currentWindow then
            ThemeManager.applyTheme(uiInstances.currentWindow, Themes[currentThemeName])
        end
        print("Theme set to: " .. themeName)
    else
        warn("Theme '" .. themeName .. "' not found!")
    end
end

function EyeUI:ToggleUI()
    if uiInstances.currentWindow then
        uiInstances.currentWindow.Visible = not uiInstances.currentWindow.Visible
        -- You might want more sophisticated CoreGui management if you have multiple UIs
        game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, uiInstances.currentWindow.Visible)
    end
end

return EyeUI
