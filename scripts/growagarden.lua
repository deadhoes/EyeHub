local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "EyeHub | Grow A Garden",
    SubTitle = "by EyeHub",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Farm = Window:AddTab({ Title = "Farm", Icon = "leaf" }),
    Merchant = Window:AddTab({ Title = "Merchant", Icon = "coins" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

Tabs.Main:AddParagraph({
    Title = "What's New?",
    Content = "nga I just released"
})

Tabs.Main:AddButton({
    Title = "Copy Discord Invite",
    Description = "Join our Discord server",
    Callback = function()
        setclipboard("https://discord.gg/9krxH9g4MH")
        Fluent:Notify({
            Title = "Copied!",
            Content = "Discord link copied to clipboard.",
            Duration = 5
        })
    end
})

local SellEvent = ReplicatedStorage:FindFirstChild("GameEvents")
if SellEvent then
    SellEvent = SellEvent:FindFirstChild("SellInventoryItem")
end

if SellEvent then
    local sellItems = {
        "Carrot", "Strawberry", "Blueberry", "Rose", "Orange Tulip", "Stonebite", "Tomato", "Daffodil", 
        "Cauliflower", "Raspberry", "Foxglove", "Peace Lily", "Corn", "Paradise Petal", "Horsetail", 
        "Watermelon", "Pumpkin", "Avocado", "Green Apple", "Banana", "Lilac", "Aloe Vera", "Bamboo", 
        "Rafflesia", "Lingonberry", "Horned Dinoshroom", "Boneboo", "Peach", "Pineapple", "Guanabana", 
        "Amber Spine", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Kiwi", "Bell Pepper", "Prickly Pear", 
        "Pink Lily", "Purple Dahlia", "Firefly Fern", "Grape", "Loquat", "Mushroom", "Pepper", "Cacao", 
        "Feijoa", "Pitcher Plant", "Grand", "Sunflower", "Fossilight", "Beanstalk", "Ember Lily", 
        "Sugar Apple", "Burning Bud", "Giant Pinecone", "Bone Blossom", "All Items"
    }
    
    local AutoSellEnabled = false
    local SelectedSellItem = sellItems[1]
    
    Tabs.Sell:AddDropdown("SellSelect", {
        Title = "Select Item to Sell",
        Values = sellItems,
        Multi = false,
        Default = 1,
        Callback = function(Value)
            SelectedSellItem = Value
        end
    })
    
    Tabs.Sell:AddToggle("AutoSell", {
        Title = "Auto Sell Items",
        Default = false,
        Callback = function(Value)
            AutoSellEnabled = Value
        end
    })
    
    spawn(function()
        while wait(1) do
            if AutoSellEnabled and SelectedSellItem then
                if SelectedSellItem == "All Items" then
                    for _, item in ipairs(sellItems) do
                        if item ~= "All Items" then
                            SellEvent:FireServer(item, 999999)
                            wait(0.1)
                        end
                    end
                else
                    SellEvent:FireServer(SelectedSellItem, 999999)
                end
            end
        end
    end)
end

Tabs.Settings:AddParagraph({
    Title = "UI Settings",
    Content = "Customize your interface settings"
})

Tabs.Settings:AddButton({
    Title = "Toggle UI Visibility",
    Description = "Show/Hide the interface",
    Callback = function()
        Window.Minimized = not Window.Minimized
    end
})

Tabs.Settings:AddButton({
    Title = "Destroy UI",
    Description = "Close the interface completely",
    Callback = function()
        Fluent:Destroy()
    end
})

local themes = {"Dark", "Light", "Rose", "Amethyst"}
Tabs.Settings:AddDropdown("ThemeSelect", {
    Title = "Select Theme",
    Values = themes,
    Multi = false,
    Default = 1,
    Callback = function(Value)
        Fluent:SetTheme(Value)
    end
})

Tabs.Settings:AddToggle("Acrylic", {
    Title = "Acrylic Background",
    Default = true,
    Callback = function(Value)
        Window.Acrylic = Value
    end
})

Tabs.Settings:AddButton({
    Title = "Reset All Settings",
    Description = "Reset all toggles and settings",
    Callback = function()
        Fluent:Notify({
            Title = "Reset Complete",
            Content = "All settings have been reset!",
            Duration = 3
        })
    end
})

wait(2)

local Plant_RE = ReplicatedStorage:FindFirstChild("GameEvents")
if Plant_RE then
    Plant_RE = Plant_RE:FindFirstChild("Plant_RE")
end

if Plant_RE then
    local AutoPlantEnabled = false
    local SelectedSeed = "Carrot"

    local seedNames = {
        "Carrot", "Strawberry", "Blueberry", "Rose", "Orange Tulip", "Stonebite", "Tomato", "Daffodil", 
        "Cauliflower", "Raspberry", "Foxglove", "Peace Lily", "Corn", "Paradise Petal", "Horsetail", 
        "Watermelon", "Pumpkin", "Avocado", "Green Apple", "Banana", "Lilac", "Aloe Vera", "Bamboo", 
        "Rafflesia", "Lingonberry", "Horned Dinoshroom", "Boneboo", "Peach", "Pineapple", "Guanabana", 
        "Amber Spine", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Kiwi", "Bell Pepper", "Prickly Pear", 
        "Pink Lily", "Purple Dahlia", "Firefly Fern", "Grape", "Loquat", "Mushroom", "Pepper", "Cacao", 
        "Feijoa", "Pitcher Plant", "Grand", "Sunflower", "Fossilight", "Beanstalk", "Ember Lily", 
        "Sugar Apple", "Burning Bud", "Giant Pinecone", "Bone Blossom"
    }

    local SeedDropdown = Tabs.Farm:AddDropdown("SeedSelect", {
        Title = "Select Seed to Plant",
        Values = seedNames,
        Multi = false,
        Default = 1,
        Callback = function(Value)
            SelectedSeed = Value
        end
    })

    local PlantToggle = Tabs.Farm:AddToggle("AutoPlant", {
        Title = "Auto Plant Below Feet",
        Default = false,
        Callback = function(Value)
            AutoPlantEnabled = Value
        end
    })

    spawn(function()
        while wait(1) do
            if AutoPlantEnabled and SelectedSeed then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local pos = char.HumanoidRootPart.Position
                    local plantPos = Vector3.new(pos.X, 0.1355, pos.Z)
                    Plant_RE:FireServer(plantPos, SelectedSeed)
                end
            end
        end
    end)
end

local Farms = workspace:FindFirstChild("Farm")
if Farms then
    local FarmName = LocalPlayer.Name
    local MyFarm = nil
    
    for _, Farm in Farms:GetChildren() do
        if Farm:FindFirstChild("Important") and Farm.Important:FindFirstChild("Data") then
            local Data = Farm.Important.Data
            if Data:FindFirstChild("Owner") and Data.Owner.Value == FarmName then
                MyFarm = Farm
                break
            end
        end
    end

    if MyFarm and MyFarm:FindFirstChild("Important") and MyFarm.Important:FindFirstChild("Plants_Physical") then
        local PlantsPhysical = MyFarm.Important.Plants_Physical
        local AutoHarvestEnabled = false

        local function CanHarvest(Plant)
            local Prompt = Plant:FindFirstChild("ProximityPrompt", true)
            return Prompt and Prompt.Enabled
        end

        local function HarvestPlant(Plant)
            local Prompt = Plant:FindFirstChild("ProximityPrompt", true)
            if Prompt then
                fireproximityprompt(Prompt)
            end
        end

        local function GetHarvestablePlants()
            local Plants = {}
            local Character = LocalPlayer.Character
            if not Character or not Character:FindFirstChild("HumanoidRootPart") then return Plants end
            local Position = Character.HumanoidRootPart.Position

            local function Collect(Parent)
                for _, Plant in Parent:GetChildren() do
                    if Plant:FindFirstChild("Fruits") then
                        Collect(Plant.Fruits)
                    end

                    if Plant:IsA("Model") and CanHarvest(Plant) then
                        local PlantPos = Plant:GetPivot().Position
                        local Distance = (PlantPos - Position).Magnitude
                        if Distance <= 15 then
                            table.insert(Plants, Plant)
                        end
                    end
                end
            end

            Collect(PlantsPhysical)
            return Plants
        end

        RunService.Heartbeat:Connect(function()
            if AutoHarvestEnabled then
                local Plants = GetHarvestablePlants()
                for _, Plant in ipairs(Plants) do
                    HarvestPlant(Plant)
                end
            end
        end)

        Tabs.Farm:AddToggle("AutoHarvest", {
            Title = "Auto-Harvest",
            Default = false,
            Callback = function(Value)
                AutoHarvestEnabled = Value
            end
        })
    end
end

local MerchantEvent = ReplicatedStorage:FindFirstChild("GameEvents")
if MerchantEvent then
    MerchantEvent = MerchantEvent:FindFirstChild("BuyTravelingMerchantShopStock")
end

if MerchantEvent then
    local merchantItems = {
        "Cauliflower", "Rafflesia", "Green Apple", "Avocado", "Banana", "Pineapple", "Kiwi", 
        "Bell Pepper", "Prickly Pear", "Loquat", "Feijoa", "Pitcher", "All"
    }
    local AutoBuyEnabled = false
    local SelectedItem = merchantItems[1]

    Tabs.Merchant:AddDropdown("MerchantSelect", {
        Title = "Select Seed Merchant",
        Values = merchantItems,
        Multi = false,
        Default = 1,
        Callback = function(Value)
            SelectedItem = Value
        end
    })

    Tabs.Merchant:AddToggle("MerchantBuy", {
        Title = "Buy Seed Merchant",
        Default = false,
        Callback = function(Value)
            AutoBuyEnabled = Value
        end
    })

    spawn(function()
        while wait(1) do
            if AutoBuyEnabled and SelectedItem then
                if SelectedItem == "All" then
                    for _, item in ipairs(merchantItems) do
                        if item ~= "All" then
                            MerchantEvent:FireServer(item)
                            wait(0.1)
                        end
                    end
                else
                    MerchantEvent:FireServer(SelectedItem)
                end
            end
        end
    end)
end

local BuyEvent = ReplicatedStorage:FindFirstChild("GameEvents")
local BuyGearEvent, BuyEggEvent

if BuyEvent then
    BuyGearEvent = BuyEvent:FindFirstChild("BuyGearStock")
    BuyEggEvent = BuyEvent:FindFirstChild("BuyEggStock")
    BuyEvent = BuyEvent:FindFirstChild("BuySeedStock")
end

if BuyEvent or BuyGearEvent or BuyEggEvent then
    local seeds = {
        "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil",
        "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus",
        "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk",
        "Ember Lily", "Sugar Apple", "Burning Bud"
    }

    local gear = {
        "Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler",
        "Godly Sprinkler", "Magnifying Glass", "Tanning Mirror", "Master Sprinkler", 
        "Cleaning Spray", "Favorite Tool", "Harvest Tool", "Friendship Pot"
    }

    local eggs = {
        "Common Egg", "Common Summer Egg", "Rare Summer Egg", "Mythical Egg", "Paradise Egg", "Bug Egg"
    }

    local enabledSeeds = {}
    local enabledGear = {}
    local enabledEggs = {}

    local SelectedSeedToBuy = seeds[1] or "Carrot"
    local SelectedGearToBuy = gear[1] or "Watering Can"
    local SelectedEggToBuy = eggs[1] or "Common Egg"
    
    local AutoBuySeeds = false
    local AutoBuyGear = false
    local AutoBuyEggs = false

    if BuyEvent then
        Tabs.Shop:AddDropdown("SeedToBuy", {
            Title = "Select Seed to Buy",
            Values = seeds,
            Multi = false,
            Default = 1,
            Callback = function(Value)
                SelectedSeedToBuy = Value
            end
        })
        
        Tabs.Shop:AddToggle("AutoBuySeeds", {
            Title = "Auto Buy Seeds",
            Default = false,
            Callback = function(Value)
                AutoBuySeeds = Value
            end
        })
    end

    if BuyGearEvent then
        Tabs.Shop:AddDropdown("GearToBuy", {
            Title = "Select Gear to Buy",
            Values = gear,
            Multi = false,
            Default = 1,
            Callback = function(Value)
                SelectedGearToBuy = Value
            end
        })
        
        Tabs.Shop:AddToggle("AutoBuyGear", {
            Title = "Auto Buy Gear",
            Default = false,
            Callback = function(Value)
                AutoBuyGear = Value
            end
        })
    end

    if BuyEggEvent then
        Tabs.Shop:AddDropdown("EggToBuy", {
            Title = "Select Egg to Buy",
            Values = eggs,
            Multi = false,
            Default = 1,
            Callback = function(Value)
                SelectedEggToBuy = Value
            end
        })
        
        Tabs.Shop:AddToggle("AutoBuyEggs", {
            Title = "Auto Buy Eggs",
            Default = false,
            Callback = function(Value)
                AutoBuyEggs = Value
            end
        })
    end

    spawn(function()
        while wait(0.5) do
            if BuyEvent and AutoBuySeeds and SelectedSeedToBuy then
                BuyEvent:FireServer(SelectedSeedToBuy)
            end
            
            if BuyGearEvent and AutoBuyGear and SelectedGearToBuy then
                BuyGearEvent:FireServer(SelectedGearToBuy)
            end
            
            if BuyEggEvent and AutoBuyEggs and SelectedEggToBuy then
                BuyEggEvent:FireServer(SelectedEggToBuy)
            end
        end
    end)
end

Tabs.Visual:AddButton({
    Title = "Copy Discord Invite",
    Description = "Join our Discord server",
    Callback = function()
        setclipboard("https://discord.gg/9krxH9g4MH")
        Fluent:Notify({
            Title = "Copied!",
            Content = "Discord link copied to clipboard.",
            Duration = 5
        })
    end
})

Fluent:Notify({
    Title = "EyeHub",
    Content = "Script loaded successfully!",
    Duration = 5
})

Window:SelectTab(1)
