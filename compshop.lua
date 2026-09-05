-- Compshop Game - Delta Executor Script
-- FIXED VERSION: Proper menu display + Draggable KEV Logo

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local gameActive = false
local ScreenGui = nil
local ToggleGui = nil
local LogoGui = nil
local ScrollingFrame = nil
local ListLayout = nil
local Padding = nil

-- Ensure we have the local player and PlayerGui
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    LocalPlayer = Players.PlayerAdded:Wait()
end
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Get screen size
local screen_size = nil
if workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize then
    screen_size = workspace.CurrentCamera.ViewportSize
elseif UserInputService.GetDeviceViewportSize then
    screen_size = UserInputService:GetDeviceViewportSize()
else
    screen_size = Vector2.new(1280, 720)
end

local UI_SCALE = (screen_size and screen_size.X and screen_size.X < 400) and 0.8 or 1

-- ============================================
-- DRAGGABLE KEV LOGO
-- ============================================
local function CreateDraggableLogo()
    LogoGui = Instance.new("ScreenGui")
    LogoGui.Name = "KEVLogo"
    LogoGui.ResetOnSpawn = false
    LogoGui.DisplayOrder = 1001
    LogoGui.Parent = PlayerGui

    -- Main Logo Frame
    local LogoFrame = Instance.new("Frame")
    LogoFrame.Name = "LogoFrame"
    LogoFrame.Size = UDim2.new(0, 100, 0, 100)
    LogoFrame.Position = UDim2.new(0.85, 0, 0.05, 0)
    LogoFrame.BackgroundColor3 = Color3.fromRGB(30, 140, 255)
    LogoFrame.BorderSizePixel = 0
    LogoFrame.Parent = LogoGui

    -- Logo Corner
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 15)
    LogoCorner.Parent = LogoFrame

    -- Logo Stroke
    local LogoStroke = Instance.new("UIStroke")
    LogoStroke.Color = Color3.fromRGB(100, 200, 255)
    LogoStroke.Thickness = 3
    LogoStroke.Parent = LogoFrame

    -- KEV Text
    local LogoText = Instance.new("TextLabel")
    LogoText.Name = "LogoText"
    LogoText.Size = UDim2.new(1, 0, 1, 0)
    LogoText.BackgroundTransparency = 1
    LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoText.TextSize = 32 * UI_SCALE
    LogoText.Font = Enum.Font.GothamBold
    LogoText.Text = "KEV"
    LogoText.Parent = LogoFrame

    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil

    LogoFrame.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = LogoFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            LogoFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    print("✅ KEV Logo created! (Draggable)")
end

-- ============================================
-- MAIN GAME UI
-- ============================================
local function CreateGameUI()
    -- Create ScreenGui
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CompshopUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = PlayerGui

    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0.75, 0, 0.85, 0)
    MainContainer.Position = UDim2.new(0.125, 0, 0.075, 0)
    MainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainContainer.BorderSizePixel = 0
    MainContainer.Parent = ScreenGui

    -- Main Corner
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainContainer

    -- Main Stroke
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(100, 150, 255)
    MainStroke.Thickness = 2
    MainStroke.Parent = MainContainer

    -- Scrolling Frame
    ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "ScrollingFrame"
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 10
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.Parent = MainContainer

    -- UIListLayout
    ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = ScrollingFrame

    -- Update canvas size
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 30)
    end)

    -- Padding
    Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 15)
    Padding.PaddingRight = UDim.new(0, 15)
    Padding.PaddingTop = UDim.new(0, 15)
    Padding.PaddingBottom = UDim.new(0, 15)
    Padding.Parent = ScrollingFrame

    -- Function to create buttons
    local function CreateButton(name, text, layoutOrder, callback)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(1, 0, 0, 50 * UI_SCALE)
        Button.BackgroundColor3 = Color3.fromRGB(35, 60, 120)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 18 * UI_SCALE
        Button.Font = Enum.Font.GothamBold
        Button.Text = text
        Button.BorderSizePixel = 0
        Button.LayoutOrder = layoutOrder
        Button.AutoButtonColor = false
        Button.Parent = ScrollingFrame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 10)
        ButtonCorner.Parent = Button

        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Color = Color3.fromRGB(70, 120, 200)
        ButtonStroke.Thickness = 1.5
        ButtonStroke.Parent = Button

        -- Hover effect
        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(60, 100, 160)
            ButtonStroke.Color = Color3.fromRGB(120, 180, 255)
        end)

        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(35, 60, 120)
            ButtonStroke.Color = Color3.fromRGB(70, 120, 200)
        end)

        -- Click effect
        Button.MouseButton1Down:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(20, 40, 90)
        end)

        Button.MouseButton1Up:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(60, 100, 160)
            if callback then callback() end
        end)

        return Button
    end

    -- Menu Functions
    local function ClearMenu()
        for _, child in pairs(ScrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") and child ~= ListLayout and child ~= Padding then
                child:Destroy()
            end
        end
    end

    local function ShopMenu()
        ClearMenu()
        CreateButton("BackBtn", "⬅️  BACK", 1, MainMenu)
        CreateButton("Title", "🛍️  SHOP", 2, nil)
        CreateButton("Item1", "🖥️  Gaming PC - $999", 3, function() print("Purchased Gaming PC!") end)
        CreateButton("Item2", "⌨️  Mechanical Keyboard - $149", 4, function() print("Purchased Keyboard!") end)
        CreateButton("Item3", "🖱️  Gaming Mouse - $79", 5, function() print("Purchased Mouse!") end)
        CreateButton("Item4", "🎧  Gaming Headset - $199", 6, function() print("Purchased Headset!") end)
        CreateButton("Item5", "📺  4K Monitor - $399", 7, function() print("Purchased Monitor!") end)
        CreateButton("Item6", "💻  Laptop - $1,299", 8, function() print("Purchased Laptop!") end)
        CreateButton("Item7", "🎮  Console - $499", 9, function() print("Purchased Console!") end)
        ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
    end

    local function InventoryMenu()
        ClearMenu()
        CreateButton("BackBtn", "⬅️  BACK", 1, MainMenu)
        CreateButton("Title", "🎒  INVENTORY", 2, nil)
        CreateButton("Inv1", "🖥️  Gaming PC x1", 3, nil)
        CreateButton("Inv2", "⌨️  Keyboard x2", 4, nil)
        CreateButton("Inv3", "🖱️  Mouse x3", 5, nil)
        CreateButton("Inv4", "🎧  Headset x1", 6, nil)
        CreateButton("Inv5", "📺  Monitor x1", 7, nil)
        CreateButton("Inv6", "❌  Empty Slot", 8, nil)
        ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
    end

    local function StatsMenu()
        ClearMenu()
        CreateButton("BackBtn", "⬅️  BACK", 1, MainMenu)
        CreateButton("Title", "📊  STATS", 2, nil)

        local StatLabel = Instance.new("TextLabel")
        StatLabel.Name = "Stats"
        StatLabel.Size = UDim2.new(1, 0, 0, 180)
        StatLabel.BackgroundColor3 = Color3.fromRGB(30, 50, 90)
        StatLabel.TextColor3 = Color3.fromRGB(150, 220, 255)
        StatLabel.TextSize = 14 * UI_SCALE
        StatLabel.Font = Enum.Font.Gotham
        StatLabel.Text = "💰 Balance: $5,000\n⭐ Level: 15\n🏆 Total Spent: $12,500\n📦 Items Owned: 6\n🎯 Achievements: 8/20\n⏱️  Playtime: 45 hrs"
        StatLabel.TextWrapped = true
        StatLabel.TextXAlignment = Enum.TextXAlignment.Left
        StatLabel.BorderSizePixel = 0
        StatLabel.LayoutOrder = 3
        StatLabel.Parent = ScrollingFrame

        local StatCorner = Instance.new("UICorner")
        StatCorner.CornerRadius = UDim.new(0, 10)
        StatCorner.Parent = StatLabel

        local StatPadding = Instance.new("UIPadding")
        StatPadding.PaddingLeft = UDim.new(0, 15)
        StatPadding.PaddingRight = UDim.new(0, 15)
        StatPadding.PaddingTop = UDim.new(0, 15)
        StatPadding.PaddingBottom = UDim.new(0, 15)
        StatPadding.Parent = StatLabel

        local StatStroke = Instance.new("UIStroke")
        StatStroke.Color = Color3.fromRGB(70, 120, 200)
        StatStroke.Thickness = 1.5
        StatStroke.Parent = StatLabel

        ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
    end

    local function SettingsMenu()
        ClearMenu()
        CreateButton("BackBtn", "⬅️  BACK", 1, MainMenu)
        CreateButton("Title", "⚙️  SETTINGS", 2, nil)
        CreateButton("Vol", "🔊 Volume: 80%", 3, function() print("Volume adjusted!") end)
        CreateButton("Graphics", "🎨 Graphics: High", 4, function() print("Graphics changed!") end)
        CreateButton("Notifications", "🔔 Notifications: ON", 5, function() print("Notifications toggled!") end)
        CreateButton("ClearData", "🗑️  Clear Data", 6, function() print("Data cleared!") end)
        CreateButton("About", "ℹ️  About v2.0", 7, function() print("Compshop Game v2.0") end)
        ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
    end

    function MainMenu()
        ClearMenu()
        CreateButton("Title", "🛒  COMPSHOP GAME", 1, nil)
        CreateButton("Shop", "🛍️  SHOP", 2, ShopMenu)
        CreateButton("Inventory", "🎒  INVENTORY", 3, InventoryMenu)
        CreateButton("Stats", "📊  STATS", 4, StatsMenu)
        CreateButton("Settings", "⚙️  SETTINGS", 5, SettingsMenu)
        ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
    end

    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 45, 0, 45)
    CloseButton.Position = UDim2.new(0.98, -45, 0.02, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 24
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "✕"
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = ScreenGui
    CloseButton.AutoButtonColor = false

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton

    local CloseStroke = Instance.new("UIStroke")
    CloseStroke.Color = Color3.fromRGB(255, 100, 100)
    CloseStroke.Thickness = 1.5
    CloseStroke.Parent = CloseButton

    CloseButton.MouseEnter:Connect(function()
        CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    end)

    CloseButton.MouseLeave:Connect(function()
        CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    end)

    CloseButton.MouseButton1Click:Connect(CloseGameUI)

    -- Initialize main menu
    MainMenu()

    print("✅ Compshop Game opened!")
end

-- Close function
function CloseGameUI()
    if ScreenGui then
        ScreenGui:Destroy()
        ScreenGui = nil
    end
    gameActive = false
    print("❌ Compshop Game closed!")
end

-- ============================================
-- TOGGLE BUTTON
-- ============================================
local function CreateToggleButton()
    ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "CompshopToggleGui"
    ToggleGui.ResetOnSpawn = false
    ToggleGui.DisplayOrder = 1000
    ToggleGui.Parent = PlayerGui

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "CompshopToggle"
    ToggleButton.Size = UDim2.new(0, 70, 0, 70)
    ToggleButton.Position = UDim2.new(0.02, 0, 0.45, -35)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 32
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "🛒"
    ToggleButton.BorderSizePixel = 0
    ToggleButton.ZIndex = 1000
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = ToggleGui

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 35)
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

    print("✅ Toggle button created! Click 🛒 to open/close.")
end

-- ============================================
-- KEYBOARD SHORTCUTS
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- ESC to close
    if input.KeyCode == Enum.KeyCode.Escape and gameActive then
        CloseGameUI()
    end

    -- G to toggle
    if input.KeyCode == Enum.KeyCode.G then
        if gameActive then
            CloseGameUI()
        else
            gameActive = true
            CreateGameUI()
        end
    end
end)

-- ============================================
-- INITIALIZATION
-- ============================================
CreateDraggableLogo()
CreateToggleButton()

print("═══════════════════════════════════════")
print("🛒 COMPSHOP GAME v2.0 - LOADED")
print("═══════════════════════════════════════")
print("📱 Click 🛒 button to toggle UI")
print("⌨️  Press G to open/close")
print("⌨️  Press ESC to close")
print("🖱️  Drag KEV logo to move it")
print("═══════════════════════════════════════")
