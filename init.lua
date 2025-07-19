--!strict

local UILibrary = {}

local Themes = {
    Dark = {
        MainBackground = Color3.fromRGB(5, 5, 5),
        AccentColor = Color3.fromRGB(33, 33, 33),
        TextColor = Color3.fromRGB(200, 200, 200),
        Transparent = Color3.fromRGB(255, 255, 255),
        BorderColor = Color3.fromRGB(0, 0, 0),
        CloseButton = Color3.fromRGB(255, 255, 255),
    },
    Light = {
        MainBackground = Color3.fromRGB(240, 240, 240),
        AccentColor = Color3.fromRGB(180, 180, 180),
        TextColor = Color3.fromRGB(50, 50, 50),
        Transparent = Color3.fromRGB(255, 255, 255),
        BorderColor = Color3.fromRGB(0, 0, 0),
        CloseButton = Color3.fromRGB(50, 50, 50),
    }
}

local currentTheme = "Dark"

local ThemeManager = {}

function ThemeManager.applyTheme(uiElement: GuiObject, theme: { [string]: Color3 })
    if uiElement:IsA("Frame") then
        if uiElement.Name == "Main" then
            uiElement.BackgroundColor3 = theme.MainBackground
        elseif uiElement.Name == "Topbar" then
            uiElement.BackgroundTransparency = 1.0
        elseif uiElement.Name == "Tabs" then
            uiElement.BackgroundTransparency = 1.0
        elseif uiElement.Name == "Frame" and uiElement.Parent and uiElement.Parent.Name == "Tabs" then
            uiElement.BackgroundTransparency = 1.0
        elseif uiElement.Name == "Frame_3" then
            uiElement.BackgroundColor3 = theme.AccentColor
        elseif uiElement.Name == "Elements" then
            uiElement.BackgroundTransparency = 1.0
        end
    elseif uiElement:IsA("TextLabel") then
        uiElement.TextColor3 = theme.TextColor
        uiElement.BackgroundTransparency = 1.0
    elseif uiElement:IsA("ImageLabel") then
        uiElement.BackgroundTransparency = 1.0
    elseif uiElement:IsA("ImageButton") then
        if uiElement.Name == "CloseButton" then
            uiElement.BackgroundTransparency = 1.0
        end
    elseif uiElement:IsA("ScrollingFrame") then
        uiElement.BackgroundTransparency = 1.0
    elseif uiElement:IsA("TextButton") then
        uiElement.BackgroundColor3 = theme.AccentColor
        uiElement.TextColor3 = theme.TextColor
    end

    for _, child in ipairs(uiElement:GetChildren()) do
        if child:IsA("GuiObject") then
            ThemeManager.applyTheme(child, theme)
        end
    end
end

function UILibrary.setTheme(themeName: string)
    if Themes[themeName] then
        currentTheme = themeName
        local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        local screenGui = playerGui:FindFirstChild("EyeHubUI")

        if screenGui and screenGui:IsA("ScreenGui") then
            ThemeManager.applyTheme(screenGui, Themes[currentTheme])
        end
        print("Theme set to: " .. themeName)
    else
        warn("Theme '" .. themeName .. "' not found!")
    end
end

function UILibrary.getCurrentTheme(): { [string]: Color3 }
    return Themes[currentTheme]
end

function UILibrary.createMainUI(playerGui: PlayerGui): Frame
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EyeHubUI"
    ScreenGui.Parent = playerGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    ScreenGui.IgnoreGuiInset = true
    game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = UILibrary.getCurrentTheme().MainBackground
    Main.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.124204189, 0, 0.207956925, 0)
    Main.Size = UDim2.new(0, 537, 0, 410)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = Main

    ThemeManager.applyTheme(Main, UILibrary.getCurrentTheme())

    return Main
end

function UILibrary.createTopbar(parent: Frame): Frame
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = parent
    Topbar.BackgroundColor3 = UILibrary.getCurrentTheme().Transparent
    Topbar.BackgroundTransparency = 1.000
    Topbar.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    Topbar.BorderSizePixel = 0
    Topbar.Size = UDim2.new(0, 537, 0, 37)

    local ImageButton = Instance.new("ImageButton")
    ImageButton.Parent = Topbar
    ImageButton.Name = "CloseButton"
    ImageButton.BackgroundColor3 = UILibrary.getCurrentTheme().Transparent
    ImageButton.BackgroundTransparency = 1.000
    ImageButton.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    ImageButton.BorderSizePixel = 0
    ImageButton.Position = UDim2.new(0.942782104, 0, 0.325140059, 0)
    ImageButton.Size = UDim2.new(0, 20, 0, 20)
    ImageButton.Image = "rbxassetid://10747384394"

    local TextLabel_3 = Instance.new("TextLabel")
    TextLabel_3.Parent = Topbar
    TextLabel_3.BackgroundColor3 = UILibrary.getCurrentTheme().Transparent
    TextLabel_3.BackgroundTransparency = 1.000
    TextLabel_3.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    TextLabel_3.BorderSizePixel = 0
    TextLabel_3.Position = UDim2.new(0.0368748941, 0, 0.210121363, 0)
    TextLabel_3.Size = UDim2.new(0, 189, 0, 27)
    TextLabel_3.Font = Enum.Font.GothamBold
    TextLabel_3.Text = "EyeHub"
    TextLabel_3.TextColor3 = UILibrary.getCurrentTheme().TextColor
    TextLabel_3.TextSize = 14.000
    TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left

    local Frame_3 = Instance.new("Frame")
    Frame_3.Parent = Topbar
    Frame_3.BackgroundColor3 = UILibrary.getCurrentTheme().AccentColor
    Frame_3.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    Frame_3.BorderSizePixel = 0
    Frame_3.Position = UDim2.new(0, 0, 1.13513517, 0)
    Frame_3.Size = UDim2.new(0, 537, 0, 1)

    return Topbar
end

function UILibrary.createTabsSection(parent: Frame): Frame
    local Tabs = Instance.new("Frame")
    Tabs.Name = "Tabs"
    Tabs.Parent = parent
    Tabs.BackgroundColor3 = UILibrary.getCurrentTheme().Transparent
    Tabs.BackgroundTransparency = 1.000
    Tabs.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    Tabs.BorderSizePixel = 0
    Tabs.Position = UDim2.new(0, 0, 0.104878046, 0)
    Tabs.Size = UDim2.new(0, 150, 0, 367)

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = Tabs
    UIPadding.PaddingBottom = UDim.new(0, 15)
    UIPadding.PaddingRight = UDim.new(0, 5)
    UIPadding.PaddingTop = UDim.new(0, 10)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Tabs
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local Frame = Instance.new("Frame")
    Frame.Parent = Tabs
    Frame.Name = "MainTabButton"
    Frame.BackgroundColor3 = UILibrary.getCurrentTheme().Transparent
    Frame.BackgroundTransparency = 1.000
    Frame.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(0, 150, 0, 33)

    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Parent = Frame
    ImageLabel.BackgroundColor3 = UILibrary.getCurrentTheme().Transparent
    ImageLabel.BackgroundTransparency = 1.000
    ImageLabel.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Position = UDim2.new(0.126666665, 0, 0.217900485, 0)
    ImageLabel.Size = UDim2.new(0, 19, 0, 19)
    ImageLabel.Image = "rbxassetid://10723407389"

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = Frame
    TextLabel.BackgroundColor3 = UILibrary.getCurrentTheme().Transparent
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    TextLabel.BorderSizePixel = 0
    TextLabel.Position = UDim2.new(0.340000004, 0, 0.16469042, 0)
    TextLabel.Size = UDim2.new(0, 103, 0, 21)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = "Main"
    TextLabel.TextColor3 = UILibrary.getCurrentTheme().TextColor
    TextLabel.TextSize = 14.000
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

    local Frame_2 = Instance.new("Frame")
    Frame_2.Parent = Tabs
    Frame_2.Name = "ChromeTabButton"
    Frame_2.BackgroundColor3 = UILibrary.getCurrentTheme().Transparent
    Frame_2.BackgroundTransparency = 1.000
    Frame_2.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    Frame_2.BorderSizePixel = 0
    Frame_2.Size = UDim2.new(0, 150, 0, 33)

    local ImageLabel_2 = Instance.new("ImageLabel")
    ImageLabel_2.Parent = Frame_2
    ImageLabel_2.BackgroundColor3 = UILibrary.getCurrentTheme().Transparent
    ImageLabel_2.BackgroundTransparency = 1.000
    ImageLabel_2.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    ImageLabel_2.BorderSizePixel = 0
    ImageLabel_2.Position = UDim2.new(0.126666665, 0, 0.217900485, 0)
    ImageLabel_2.Size = UDim2.new(0, 19, 0, 19)
    ImageLabel_2.Image = "rbxassetid://10709797725"

    local TextLabel_2 = Instance.new("TextLabel")
    TextLabel_2.Parent = Frame_2
    TextLabel_2.BackgroundColor3 = UILibrary.getCurrentTheme().Transparent
    TextLabel_2.BackgroundTransparency = 1.000
    TextLabel_2.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    TextLabel_2.BorderSizePixel = 0
    TextLabel_2.Position = UDim2.new(0.340000004, 0, 0.16469042, 0)
    TextLabel_2.Size = UDim2.new(0, 103, 0, 21)
    TextLabel_2.Font = Enum.Font.GothamBold
    TextLabel_2.Text = "Chrome"
    TextLabel_2.TextColor3 = UILibrary.getCurrentTheme().TextColor
    TextLabel_2.TextSize = 14.000
    TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

    return Tabs
end

function UILibrary.createElementsSection(parent: Frame): ScrollingFrame
    local Elements = Instance.new("Frame")
    Elements.Name = "Elements"
    Elements.Parent = parent
    Elements.BackgroundColor3 = UILibrary.getCurrentTheme().Transparent
    Elements.BackgroundTransparency = 1.000
    Elements.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    Elements.BorderSizePixel = 0
    Elements.Position = UDim2.new(0.236499071, 0, 0.104878083, 0)
    Elements.Size = UDim2.new(0, 410, 0, 367)

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Parent = Elements
    ScrollingFrame.Active = true
    ScrollingFrame.BackgroundColor3 = UILibrary.getCurrentTheme().Transparent
    ScrollingFrame.BackgroundTransparency = 1.000
    ScrollingFrame.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.new(0, 410, 0, 367)
    ScrollingFrame.BottomImage = ""
    ScrollingFrame.MidImage = ""
    ScrollingFrame.TopImage = ""

    local UIListLayout_2 = Instance.new("UIListLayout")
    UIListLayout_2.Parent = ScrollingFrame
    UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_2.Padding = UDim.new(0, 10)

    local UIPadding_2 = Instance.new("UIPadding")
    UIPadding_2.Parent = ScrollingFrame
    UIPadding_2.PaddingTop = UDim.new(0, 10)

    return ScrollingFrame
end

function UILibrary.createButton(parent: GuiObject, text: string): TextButton
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.Size = UDim2.new(0, 150, 0, 30)
    Button.BackgroundColor3 = UILibrary.getCurrentTheme().AccentColor
    Button.BorderColor3 = UILibrary.getCurrentTheme().BorderColor
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = UILibrary.getCurrentTheme().TextColor
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.TextWrapped = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Button

    local originalColor = Button.BackgroundColor3
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = originalColor:Lerp(Color3.new(1,1,1), 0.2)
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = originalColor
    end)

    return Button
end

local uiInstances = {}

function UILibrary.initUI(): Frame
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local Main = UILibrary.createMainUI(playerGui)
    local Topbar = UILibrary.createTopbar(Main)
    local Tabs = UILibrary.createTabsSection(Main)
    local Elements = UILibrary.createElementsSection(Main)

    uiInstances.Main = Main
    uiInstances.Topbar = Topbar
    uiInstances.Tabs = Tabs
    uiInstances.Elements = Elements

    local exampleButton = UILibrary.createButton(Elements.ScrollingFrame, "Click Me!")
    exampleButton.MouseButton1Click:Connect(function()
        print("Button clicked!")
    end)

    return Main
end

function UILibrary.toggleUI()
    if uiInstances.Main then
        uiInstances.Main.Visible = not uiInstances.Main.Visible
        game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, uiInstances.Main.Visible)
    end
end

return UILibrary
