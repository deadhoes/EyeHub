local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local EyeHub = {}

local UI_COLORS = {
    PRIMARY_BACKGROUND = Color3.fromRGB(30, 30, 30),
    SECONDARY_BACKGROUND = Color3.fromRGB(45, 45, 45),
    ACCENT_COLOR = Color3.fromRGB(0, 120, 215),
    TEXT_COLOR = Color3.fromRGB(200, 200, 200),
    BORDER_COLOR = Color3.fromRGB(20, 20, 20),
    HOVER_COLOR = Color3.fromRGB(60, 60, 60),
    TOGGLE_ON_COLOR = Color3.fromRGB(0, 170, 0),
    TOGGLE_OFF_COLOR = Color3.fromRGB(150, 0, 0),
}

local UI_SIZES = {
    WINDOW_WIDTH_SCALE = 0.25,
    WINDOW_HEIGHT_SCALE = 0.6,
    HEADER_HEIGHT_PIXELS = 40,
    TAB_BUTTON_HEIGHT_PIXELS = 35,
    SECTION_PADDING_PIXELS = 10,
    CONTROL_HEIGHT_PIXELS = 30,
    CORNER_RADIUS = 8,
    SHADOW_OFFSET = Vector2.new(3, 3),
    SHADOW_TRANSPARENCY = 0.5,
}

local function CreateUIElement(className, parent, name, size, position, anchorPoint, backgroundColor, transparency, cornerRadius, zIndex)
    local element = Instance.new(className)
    element.Name = name or className
    element.Size = size or UDim2.new(0, 0, 0, 0)
    element.Position = position or UDim2.new(0, 0, 0, 0)
    element.AnchorPoint = anchorPoint or Vector2.new(0, 0)
    element.BackgroundTransparency = transparency or 0
    element.BackgroundColor3 = backgroundColor or Color3.fromRGB(255, 255, 255)
    element.BorderSizePixel = 0
    element.ZIndex = zIndex or 1

    if cornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, cornerRadius)
        corner.Parent = element
    end

    element.Parent = parent
    return element
end

local function CreateTextLabel(parent, text, size, position, anchorPoint, textColor, fontSize, font, textXAlignment, textYAlignment, transparency, cornerRadius, zIndex)
    local label = CreateUIElement("TextLabel", parent, nil, size, position, anchorPoint, nil, transparency or 1, cornerRadius, zIndex)
    label.Text = text
    label.TextColor3 = textColor or UI_COLORS.TEXT_COLOR
    label.TextScaled = false
    label.TextSize = fontSize or 16
    label.Font = font or Enum.Font.SourceSans
    label.TextXAlignment = textXAlignment or Enum.TextXAlignment.Center
    label.TextYAlignment = textYAlignment or Enum.TextYAlignment.Center
    return label
end

local function CreateShadow(parent, size, position, cornerRadius)
    local shadow = CreateUIElement("Frame", parent, "Shadow", size, position + UDim2.new(0, UI_SIZES.SHADOW_OFFSET.X, 0, UI_SIZES.SHADOW_OFFSET.Y), nil, Color3.fromRGB(0, 0, 0), UI_SIZES.SHADOW_TRANSPARENCY, cornerRadius, 0)
    return shadow
end

function EyeHub.CreateWindow(title)
    local ScreenGui = CreateUIElement("ScreenGui", PlayerGui, "EyeHubGui")
    ScreenGui.IgnoreGuiInset = true

    local Shadow = CreateShadow(ScreenGui, UDim2.new(UI_SIZES.WINDOW_WIDTH_SCALE, 0, UI_SIZES.WINDOW_HEIGHT_SCALE, 0), UDim2.new(0.5, 0, 0.5, 0), UI_SIZES.CORNER_RADIUS)
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)

    local Window = CreateUIElement("Frame", ScreenGui, "Window", UDim2.new(UI_SIZES.WINDOW_WIDTH_SCALE, 0, UI_SIZES.WINDOW_HEIGHT_SCALE, 0), UDim2.new(0.5, 0, 0.5, 0), Vector2.new(0.5, 0.5), UI_COLORS.PRIMARY_BACKGROUND, 0, UI_SIZES.CORNER_RADIUS, 1)

    local Header = CreateUIElement("Frame", Window, "Header", UDim2.new(1, 0, 0, UI_SIZES.HEADER_HEIGHT_PIXELS), UDim2.new(0, 0, 0, 0), nil, UI_COLORS.SECONDARY_BACKGROUND, 0, nil, 2)
    CreateUIElement("UIStroke", Header, nil, nil, nil, nil, nil, nil, nil, nil).Color = UI_COLORS.BORDER_COLOR
    CreateUIElement("UIStroke", Header, nil, nil, nil, nil, nil, nil, nil, nil).Thickness = 1
    CreateUIElement("UIStroke", Header, nil, nil, nil, nil, nil, nil, nil, nil).ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    CreateTextLabel(Header, title, UDim2.new(1, 0, 1, 0), nil, nil, UI_COLORS.TEXT_COLOR, 20, Enum.Font.SourceSansBold)

    local isDragging = false
    local dragStartPos
    local initialMousePos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStartPos = Window.Position
            initialMousePos = UserInputService:GetMouseLocation()
            UserInputService.InputChanged:Connect(function(inputChanged)
                if isDragging and (inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch) then
                    local currentMousePos = UserInputService:GetMouseLocation()
                    local delta = currentMousePos - initialMousePos
                    Window.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
                    Shadow.Position = Window.Position + UDim2.new(0, UI_SIZES.SHADOW_OFFSET.X, 0, UI_SIZES.SHADOW_OFFSET.Y)
                end
            end)
        end
    end)

    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    local TabContainer = CreateUIElement("Frame", Window, "TabContainer", UDim2.new(0, 100, 1, -UI_SIZES.HEADER_HEIGHT_PIXELS), UDim2.new(0, 0, 0, UI_SIZES.HEADER_HEIGHT_PIXELS), nil, UI_COLORS.SECONDARY_BACKGROUND, 0, nil, 2)
    local TabListLayout = CreateUIElement("UIListLayout", TabContainer, "TabListLayout")
    TabListLayout.FillDirection = Enum.FillDirection.Vertical
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Padding = UDim.new(0, 5)

    local Pages = CreateUIElement("Frame", Window, "Pages", UDim2.new(1, -100, 1, -UI_SIZES.HEADER_HEIGHT_PIXELS), UDim2.new(0, 100, 0, UI_SIZES.HEADER_HEIGHT_PIXELS), nil, UI_COLORS.PRIMARY_BACKGROUND, 0, nil, 2)
    Pages.ClipsDescendants = true

    local currentTab = nil

    local library = {
        Window = Window,
        Tabs = {},
        Pages = Pages,
        _TabButtons = {},
    }

    function library:CreateTab(name)
        local TabButton = CreateUIElement("TextButton", TabContainer, name .. "TabButton", UDim2.new(1, -10, 0, UI_SIZES.TAB_BUTTON_HEIGHT_PIXELS), nil, nil, UI_COLORS.PRIMARY_BACKGROUND, 0, UI_SIZES.CORNER_RADIUS, 2)
        TabButton.Text = name
        TabButton.TextColor3 = UI_COLORS.TEXT_COLOR
        TabButton.TextSize = 16
        TabButton.Font = Enum.Font.SourceSansBold

        local Page = CreateUIElement("Frame", Pages, name .. "Page", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), nil, UI_COLORS.PRIMARY_BACKGROUND, 1, nil, 2)
        local PageListLayout = CreateUIElement("UIListLayout", Page, "PageListLayout")
        PageListLayout.FillDirection = Enum.FillDirection.Vertical
        PageListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageListLayout.Padding = UDim.new(0, UI_SIZES.SECTION_PADDING_PIXELS)
        PageListLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local tab = {
            Page = Page,
            Sections = {},
            _TabButton = TabButton,
            _PageListLayout = PageListLayout,
        }

        TabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Page.BackgroundTransparency = 1
                currentTab._TabButton.BackgroundColor3 = UI_COLORS.PRIMARY_BACKGROUND
            end
            Page.BackgroundTransparency = 0
            TabButton.BackgroundColor3 = UI_COLORS.ACCENT_COLOR
            currentTab = tab
        end)

        if not currentTab then
            TabButton.MouseButton1Click:Fire()
        end

        function tab:CreateSection(sectionName)
            local SectionFrame = CreateUIElement("Frame", Page, sectionName .. "Section", UDim2.new(1, -UI_SIZES.SECTION_PADDING_PIXELS * 2, 0, 0), nil, nil, UI_COLORS.SECONDARY_BACKGROUND, 0, UI_SIZES.CORNER_RADIUS, 2)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.LayoutOrder = #tab.Sections + 1

            local SectionListLayout = CreateUIElement("UIListLayout", SectionFrame, "SectionListLayout")
            SectionListLayout.FillDirection = Enum.FillDirection.Vertical
            SectionListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            SectionListLayout.Padding = UDim.new(0, 5)
            SectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local SectionTitle = CreateTextLabel(SectionFrame, sectionName, UDim2.new(1, 0, 0, UI_SIZES.CONTROL_HEIGHT_PIXELS), nil, nil, UI_COLORS.ACCENT_COLOR, 18, Enum.Font.SourceSansBold)
            SectionTitle.BackgroundTransparency = 1

            local section = {
                Frame = SectionFrame,
                Controls = {},
                _ListLayout = SectionListLayout,
            }

            function section:CreateButton(options)
                local Button = CreateUIElement("TextButton", SectionFrame, options.Name .. "Button", UDim2.new(1, -10, 0, UI_SIZES.CONTROL_HEIGHT_PIXELS), nil, nil, UI_COLORS.PRIMARY_BACKGROUND, 0, UI_SIZES.CORNER_RADIUS, 2)
                Button.Text = options.Name
                Button.TextColor3 = UI_COLORS.TEXT_COLOR
                Button.TextSize = 16
                Button.Font = Enum.Font.SourceSans
                Button.LayoutOrder = #section.Controls + 1

                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = UI_COLORS.HOVER_COLOR}):Play()
                end)
                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = UI_COLORS.PRIMARY_BACKGROUND}):Play()
                end)

                Button.MouseButton1Click:Connect(function()
                    if options.Callback then
                        options.Callback()
                    end
                end)
                table.insert(section.Controls, Button)
                return Button
            end

            function section:CreateToggle(options)
                local ToggleFrame = CreateUIElement("Frame", SectionFrame, options.Name .. "ToggleFrame", UDim2.new(1, -10, 0, UI_SIZES.CONTROL_HEIGHT_PIXELS), nil, nil, UI_COLORS.PRIMARY_BACKGROUND, 0, UI_SIZES.CORNER_RADIUS, 2)
                ToggleFrame.LayoutOrder = #section.Controls + 1

                local ToggleLabel = CreateTextLabel(ToggleFrame, options.Name, UDim2.new(1, -UI_SIZES.CONTROL_HEIGHT_PIXELS - 5, 1, 0), UDim2.new(0, 5, 0, 0), nil, UI_COLORS.TEXT_COLOR, 16, Enum.Font.SourceSans, Enum.TextXAlignment.Left)
                ToggleLabel.BackgroundTransparency = 1

                local ToggleButton = CreateUIElement("Frame", ToggleFrame, "ToggleButton", UDim2.new(0, UI_SIZES.CONTROL_HEIGHT_PIXELS, 1, 0), UDim2.new(1, -UI_SIZES.CONTROL_HEIGHT_PIXELS - 5, 0, 0), Vector2.new(1, 0), UI_COLORS.TOGGLE_OFF_COLOR, 0, UI_SIZES.CORNER_RADIUS, 2)
                local ToggleCircle = CreateUIElement("Frame", ToggleButton, "ToggleCircle", UDim2.new(0, UI_SIZES.CONTROL_HEIGHT_PIXELS * 0.7, 0, UI_SIZES.CONTROL_HEIGHT_PIXELS * 0.7), UDim2.new(0, UI_SIZES.CONTROL_HEIGHT_PIXELS * 0.15, 0.5, 0), Vector2.new(0, 0.5), Color3.fromRGB(255, 255, 255), 0, UI_SIZES.CORNER_RADIUS, 3)

                local currentValue = options.CurrentValue or false
                local function updateToggleVisual()
                    local targetColor = currentValue and UI_COLORS.TOGGLE_ON_COLOR or UI_COLORS.TOGGLE_OFF_COLOR
                    local targetPosition = currentValue and UDim2.new(1, -UI_SIZES.CONTROL_HEIGHT_PIXELS * 0.15, 0.5, 0) or UDim2.new(0, UI_SIZES.CONTROL_HEIGHT_PIXELS * 0.15, 0.5, 0)
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = targetPosition}):Play()
                end
                updateToggleVisual()

                local function toggle()
                    currentValue = not currentValue
                    updateToggleVisual()
                    if options.Callback then
                        options.Callback(currentValue)
                    end
                end

                ToggleButton.MouseButton1Click:Connect(toggle)
                ToggleLabel.MouseButton1Click:Connect(toggle)

                local toggleControl = {
                    Frame = ToggleFrame,
                    Value = currentValue,
                    Set = function(value)
                        currentValue = value
                        updateToggleVisual()
                    end
                }
                table.insert(section.Controls, toggleControl)
                return toggleControl
            end

            function section:CreateSlider(options)
                local SliderFrame = CreateUIElement("Frame", SectionFrame, options.Name .. "SliderFrame", UDim2.new(1, -10, 0, UI_SIZES.CONTROL_HEIGHT_PIXELS), nil, nil, UI_COLORS.PRIMARY_BACKGROUND, 0, UI_SIZES.CORNER_RADIUS, 2)
                SliderFrame.LayoutOrder = #section.Controls + 1

                local SliderLabel = CreateTextLabel(SliderFrame, options.Name, UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 5, 0, 0), Vector2.new(0, 0.5), UI_COLORS.TEXT_COLOR, 16, Enum.Font.SourceSans, Enum.TextXAlignment.Left)
                SliderLabel.BackgroundTransparency = 1

                local SliderBar = CreateUIElement("Frame", SliderFrame, "SliderBar", UDim2.new(0.6, 0, 0, 5), UDim2.new(0.5, 0, 0.5, 0), Vector2.new(0.5, 0.5), UI_COLORS.SECONDARY_BACKGROUND, 0, 2, 2)
                local SliderFill = CreateUIElement("Frame", SliderBar, "SliderFill", UDim2.new(0, 0, 1, 0), UDim2.new(0, 0, 0, 0), nil, UI_COLORS.ACCENT_COLOR, 0, 2, 3)
                local SliderThumb = CreateUIElement("Frame", SliderBar, "SliderThumb", UDim2.new(0, 15, 0, 15), UDim2.new(0, 0, 0.5, 0), Vector2.new(0.5, 0.5), Color3.fromRGB(255, 255, 255), 0, 7, 4)

                local minValue = options.Min or 0
                local maxValue = options.Max or 100
                local step = options.Step or 1
                local currentValue = options.CurrentValue or minValue

                local function updateSliderVisual()
                    local normalizedValue = (currentValue - minValue) / (maxValue - minValue)
                    SliderFill.Size = UDim2.new(normalizedValue, 0, 1, 0)
                    SliderThumb.Position = UDim2.new(normalizedValue, 0, 0.5, 0)
                    SliderLabel.Text = string.format("%s: %.0f", options.Name, currentValue)
                end
                updateSliderVisual()

                local isSliding = false
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isSliding = true
                        local function onInputChanged(inputChanged)
                            if isSliding and (inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch) then
                                local mouseX = UserInputService:GetMouseLocation().X
                                local barAbsolutePosition = SliderBar.AbsolutePosition.X
                                local barAbsoluteSize = SliderBar.AbsoluteSize.X
                                local relativeX = (mouseX - barAbsolutePosition) / barAbsoluteSize
                                relativeX = math.clamp(relativeX, 0, 1)

                                local newValue = minValue + relativeX * (maxValue - minValue)
                                currentValue = math.round(newValue / step) * step
                                currentValue = math.clamp(currentValue, minValue, maxValue)
                                updateSliderVisual()
                                if options.Callback then
                                    options.Callback(currentValue)
                                end
                            end
                        end
                        local inputChangedConnection = UserInputService.InputChanged:Connect(onInputChanged)
                        local inputEndedConnection = UserInputService.InputEnded:Connect(function(inputEnded)
                            if inputEnded.UserInputType == Enum.UserInputType.MouseButton1 or inputEnded.UserInputType == Enum.UserInputType.Touch then
                                isSliding = false
                                inputChangedConnection:Disconnect()
                                inputEndedConnection:Disconnect()
                            end
                        end)
                        onInputChanged(input)
                    end
                end)

                local sliderControl = {
                    Frame = SliderFrame,
                    Value = currentValue,
                    Set = function(value)
                        currentValue = math.clamp(value, minValue, maxValue)
                        updateSliderVisual()
                    end
                }
                table.insert(section.Controls, sliderControl)
                return sliderControl
            end

            function section:CreateTextBox(options)
                local TextBoxFrame = CreateUIElement("Frame", SectionFrame, options.Name .. "TextBoxFrame", UDim2.new(1, -10, 0, UI_SIZES.CONTROL_HEIGHT_PIXELS), nil, nil, UI_COLORS.PRIMARY_BACKGROUND, 0, UI_SIZES.CORNER_RADIUS, 2)
                TextBoxFrame.LayoutOrder = #section.Controls + 1

                local TextBox = CreateUIElement("TextBox", TextBoxFrame, "InputBox", UDim2.new(1, -10, 1, -10), UDim2.new(0, 5, 0, 5), nil, UI_COLORS.SECONDARY_BACKGROUND, 0, UI_SIZES.CORNER_RADIUS, 2)
                TextBox.Text = options.CurrentValue or ""
                TextBox.PlaceholderText = options.Placeholder or "Enter text..."
                TextBox.TextColor3 = UI_COLORS.TEXT_COLOR
                TextBox.TextSize = 16
                TextBox.Font = Enum.Font.SourceSans
                TextBox.ClearTextOnFocus = false

                TextBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        if options.Callback then
                            options.Callback(TextBox.Text)
                        end
                    end
                end)

                local textBoxControl = {
                    Frame = TextBoxFrame,
                    Value = TextBox.Text,
                    Set = function(value)
                        TextBox.Text = value
                    end,
                    Get = function()
                        return TextBox.Text
                    end
                }
                table.insert(section.Controls, textBoxControl)
                return textBoxControl
            end

            table.insert(tab.Sections, section)
            return section
        end

        table.insert(library.Tabs, tab)
        library._TabButtons[name] = TabButton
        return tab
    end

    return library
end

return EyeHub
