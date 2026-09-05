-- Compshop Game - Delta Executor Script
-- Mobile Optimized with Scrollable Menus & Toggle Button

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local gameActive = false
local ScreenGui = nil
local ToggleGui = nil
local ToggleButton = nil

-- Ensure we have the local player and PlayerGui (safe wait if needed)
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    LocalPlayer = Players.PlayerAdded:Wait()
end
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Safely get the screen size (viewport). Fall back to device API or a default.
local screen_size = nil
if workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize then
    screen_size = workspace.CurrentCamera.ViewportSize
elseif UserInputService.GetDeviceViewportSize then
    screen_size = UserInputService:GetDeviceViewportSize()
else
    screen_size = Vector2.new(800, 600)
end

-- Configuration
local UI_SCALE = (screen_size and screen_size.X and screen_size.X < 400) and 0.8 or 1 -- Scale down for very small screens

-- Function to create the main UI
local function CreateGameUI()
    -- Create ScreenGui
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CompshopUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = PlayerGui

    -- Main Container (Scrollable)
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0.9, 0, 0.95, 0)
    MainContainer.Position = UDim2.new(0.05, 0, 0.025, 0)
    MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainContainer.BorderSizePixel = 0
    MainContainer.Parent = ScreenGui

    -- Add corner radius
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainContainer

    -- Add stroke
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(100, 150, 255)
    MainStroke.Thickness = 2
    MainStroke.Parent = MainContainer

    -- Scrolling Frame for menu items
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "ScrollingFrame"
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 8
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.Parent = MainContainer

    -- UIListLayout for scrolling
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = ScrollingFrame

    -- Update canvas size
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
    end)

    -- Add padding to scrolling frame
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 12)
    Padding.PaddingRight = UDim.new(0, 12)
    Padding.PaddingTop = UDim.new(0, 12)
    Padding.PaddingBottom = UDim.new(0, 12)
    Padding.Parent = ScrollingFrame

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
    TitleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    TitleLabel.TextSize = 24 * UI_SCALE
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "🛒 COMPSHOP GAME"
    TitleLabel.BorderSizePixel = 0
    TitleLabel.LayoutOrder = 1
    TitleLabel.Parent = ScrollingFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleLabel

    -- Function to create menu buttons
    local function CreateButton(name, text, layoutOrder, callback)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(1, 0, 0, 45 * UI_SCALE)
        Button.BackgroundColor3 = Color3.fromRGB(40, 60, 100)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 16 * UI_SCALE
        Button.Font = Enum.Font.Gotham
        Button.Text = text
        Button.BorderSizePixel = 0
        Button.LayoutOrder = layoutOrder
        Button.Parent = ScrollingFrame
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button
        
        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Color = Color3.fromRGB(70, 120, 200)
        ButtonStroke.Thickness = 1
        ButtonStroke.Parent = Button
        
        -- Hover effect
        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(60, 100, 150)
            ButtonStroke.Color = Color3.fromRGB(100, 180, 255)
        end)
        
        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(40, 60, 100)
            ButtonStroke.Color = Color3.fromRGB(70, 120, 200)
        end)
        
        -- Click effect
        Button.MouseButton1Down:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(30, 50, 80)
        end)
        
        Button.MouseButton1Up:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(60, 100, 150)
            if callback then callback() end
        end)
        
        return Button
    end

    -- Menu Callbacks
    local function ShopMenu()
        ScrollingFrame:ClearAllChildren()
        ListLayout.Parent = ScrollingFrame
        Padding.Parent = ScrollingFrame
        
        CreateButton("BackBtn", "⬅️ Back", 1, function() MainMenu() end)
        CreateButton("Item1", "🖥️ Gaming PC - $999", 2, function()
            print("Purchased Gaming PC!")
        end)
        CreateButton("Item2", "⌨️ Mechanical Keyboard - $149", 3, function()
            print("Purchased Mechanical Keyboard!")
        end)
        CreateButton("Item3", "🖱️ Gaming Mouse - $79", 4, function()
            print("Purchased Gaming Mouse!")
        end)
        CreateButton("Item4", "🎧 Gaming Headset - $199", 5, function()
            print("Purchased Gaming Headset!")
        end)
        CreateButton("Item5", "📺 4K Monitor - $399", 6, function()
            print("Purchased 4K Monitor!")
        end)
        CreateButton("Item6", "💻 Laptop - $1,299", 7, function()
            print("Purchased Laptop!")
        end)
    end

    local function InventoryMenu()
        ScrollingFrame:ClearAllChildren()
        ListLayout.Parent = ScrollingFrame
        Padding.Parent = ScrollingFrame
        
        CreateButton("BackBtn", "⬅️ Back", 1, function() MainMenu() end)
        CreateButton("Inv1", "🖥️ Gaming PC x1", 2, function() end)
        CreateButton("Inv2", "⌨️ Mechanical Keyboard x2", 3, function() end)
        CreateButton("Inv3", "🖱️ Gaming Mouse x3", 4, function() end)
        CreateButton("Inv4", "🎧 Gaming Headset x1", 5, function() end)
        CreateButton("Inv5", "Empty Slot", 6, function() end)
        CreateButton("Inv6", "Empty Slot", 7, function() end)
    end

    local function SettingsMenu()
        ScrollingFrame:ClearAllChildren()
        ListLayout.Parent = ScrollingFrame
        Padding.Parent = ScrollingFrame
        
        CreateButton("BackBtn", "⬅️ Back", 1, function() MainMenu() end)
        CreateButton("Vol", "🔊 Volume: 80%", 2, function()
            print("Volume adjusted!")
        end)
        CreateButton("Graphics", "🎨 Graphics: High", 3, function()
            print("Graphics changed!")
        end)
        CreateButton("Notifications", "🔔 Notifications: ON", 4, function()
            print("Notifications toggled!")
        end)
        CreateButton("ClearData", "🗑️ Clear Data", 5, function()
            print("Data cleared!")
        end)
        CreateButton("About", "ℹ️ About v1.0", 6, function()
            print("Compshop Game v1.0")
        end)
    end

    local function StatsMenu()
        ScrollingFrame:ClearAllChildren()
        ListLayout.Parent = ScrollingFrame
        Padding.Parent = ScrollingFrame
        
        CreateButton("BackBtn", "⬅️ Back", 1, function() MainMenu() end)
        
        local StatLabel = Instance.new("TextLabel")
        StatLabel.Name = "Stats"
        StatLabel.Size = UDim2.new(1, 0, 0, 140 * UI_SCALE)
        StatLabel.BackgroundColor3 = Color3.fromRGB(30, 50, 80)
        StatLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
        StatLabel.TextSize = 14 * UI_SCALE
        StatLabel.Font = Enum.Font.Gotham
        StatLabel.Text = "💰 Balance: $5,000\n⭐ Level: 15\n🏆 Total Spent: $12,500\n📦 Items Owned: 6\n🎯 Achievements: 8/20\n⏱️ Playtime: 45 hrs"
        StatLabel.TextWrapped = true
        StatLabel.TextXAlignment = Enum.TextXAlignment.Left
        StatLabel.BorderSizePixel = 0
        StatLabel.LayoutOrder = 2
        StatLabel.Parent = ScrollingFrame
        
        local StatCorner = Instance.new("UICorner")
        StatCorner.CornerRadius = UDim.new(0, 8)
        StatCorner.Parent = StatLabel
        
        local StatPadding = Instance.new("UIPadding")
        StatPadding.PaddingLeft = UDim.new(0, 12)
        StatPadding.PaddingRight = UDim.new(0, 12)
        StatPadding.PaddingTop = UDim.new(0, 12)
        StatPadding.PaddingBottom = UDim.new(0, 12)
        StatPadding.Parent = StatLabel
    end

    local function MainMenu()
        ScrollingFrame:ClearAllChildren()
        ListLayout.Parent = ScrollingFrame
        Padding.Parent = ScrollingFrame
        
        local titleBtn = CreateButton("Title", "🛒 COMPSHOP GAME", 1, function() end)
        titleBtn.AutoButtonColor = false
        CreateButton("Shop", "🛍️ Shop", 2, ShopMenu)
        CreateButton("Inventory", "🎒 Inventory", 3, InventoryMenu)
        CreateButton("Stats", "📊 Stats", 4, StatsMenu)
        CreateButton("Settings", "⚙️ Settings", 5, SettingsMenu)
    end

    -- Close button (Top right)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(0.95, -40, 0.025, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = ScreenGui

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        CloseGameUI()
    end)

    -- Initialize main menu
    MainMenu()

    print("✅ Compshop Game opened!")
end

-- Function to close the game UI
function CloseGameUI()
    if ScreenGui then
        ScreenGui:Destroy()
        ScreenGui = nil
    end
    gameActive = false
    print("❌ Compshop Game closed!")
end

-- Create the toggle button (Fixed position, always visible)
local function CreateToggleButton()
    -- Create a small ScreenGui to host the toggle so it works inside PlayerGui
    ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "CompshopToggleGui"
    ToggleGui.ResetOnSpawn = false
    ToggleGui.DisplayOrder = 1000
    ToggleGui.Parent = PlayerGui

    ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "CompshopToggle"
    ToggleButton.Size = UDim2.new(0, 60, 0, 60)
    ToggleButton.Position = UDim2.new(0.05, 0, 0.5, -30)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 28
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "🛒"
    ToggleButton.BorderSizePixel = 0
    ToggleButton.ZIndex = 1000
    ToggleButton.Parent = ToggleGui

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 30)
    ToggleCorner.Parent = ToggleButton

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(150, 200, 255)
    ToggleStroke.Thickness = 2
    ToggleStroke.Parent = ToggleButton

    -- Hover effect
    ToggleButton.MouseEnter:Connect(function()
        ToggleButton.BackgroundColor3 = Color3.fromRGB(130, 180, 255)
        ToggleStroke.Color = Color3.fromRGB(200, 230, 255)
    end)

    ToggleButton.MouseLeave:Connect(function()
        ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        ToggleStroke.Color = Color3.fromRGB(150, 200, 255)
    end)

    -- Click to toggle
    ToggleButton.MouseButton1Click:Connect(function()
        if gameActive then
            CloseGameUI()
        else
            gameActive = true
            CreateGameUI()
        end
    end)

    print("✅ Compshop Game loaded! Click 🛒 to open/close.")
end

-- Keyboard shortcuts
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Press ESC to close
    if input.KeyCode == Enum.KeyCode.Escape and gameActive then
        CloseGameUI()
    end
    
    -- Press G to toggle
    if input.KeyCode == Enum.KeyCode.G then
        if gameActive then
            CloseGameUI()
        else
            gameActive = true
            CreateGameUI()
        end
    end
end)

-- Initialize toggle button
CreateToggleButton()

print("═══════════════════════════════════════")
print("🛒 COMPSHOP GAME - LOADED")
print("═══════════════════════════════════════")
print("📱 Click 🛒 button to toggle UI")
print("⌨️  Press G to open/close")
print("⌨️  Press ESC to close")
print("═══════════════════════════════════════")
