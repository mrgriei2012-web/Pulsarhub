-- =====================================================================
-- Pulsar Hub v6.8 - Final Fixed Edition (c00lkidd214anzz)
-- =====================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ConfigFolderName = "PulsarHubConfig"
local ConfigFileName = "PulsarSettingsFixed.json"
local currentScale = 1.0
local currentTransparency = 0.15
local currentMenuColor = Color3.fromRGB(15, 12, 18)
local statsBarVisible = true
local espCustomColor = Color3.fromRGB(255, 100, 180)

local function loadConfig()
    pcall(function()
        if makefolder and not isfolder(ConfigFolderName) then makefolder(ConfigFolderName) end
        if isfile and isfile(ConfigFolderName .. "/" .. ConfigFileName) then
            local data = HttpService:JSONDecode(readfile(ConfigFolderName .. "/" .. ConfigFileName))
            if data then
                if data.Scale then currentScale = data.Scale end
                if data.Transparency then currentTransparency = data.Transparency end
                if data.StatsVisible ~= nil then statsBarVisible = data.StatsVisible end
                if data.ColorR and data.ColorG and data.ColorB then
                    currentMenuColor = Color3.new(data.ColorR, data.ColorG, data.ColorB)
                end
            end
        end
    end)
end

local function saveConfig()
    pcall(function()
        if makefolder and not isfolder(ConfigFolderName) then makefolder(ConfigFolderName) end
        if writefile then
            writefile(ConfigFolderName .. "/" .. ConfigFileName, HttpService:JSONEncode({
                Scale = currentScale,
                Transparency = currentTransparency,
                StatsVisible = statsBarVisible,
                ColorR = currentMenuColor.R,
                ColorG = currentMenuColor.G,
                ColorB = currentMenuColor.B
            }))
        end
    end)
end

loadConfig()

if CoreGui:FindFirstChild("PulsarMobileHub") then
    CoreGui.PulsarMobileHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PulsarMobileHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
end)
ScreenGui.Parent = CoreGui


-- ================= СОСТОЯНИЯ =================
local Aimbot_Enabled = false
local Aimbot_Mode = "Legit" -- Legit / 360 Rage Aimbot
local Aimbot_TargetPart = "Head"
local Aimbot_SmoothVal = 4
local Aimbot_TeamCheck = true
local Aimbot_WallCheck = true
local FOV_Enabled = true
local FOV_Radius = 180

-- Visuals
local ESP_Enabled = true
local ESP_TeamCheck = true -- Тимчек для ESP (теперь есть!)
local CornerBox_Enabled = true   
local Skeleton_Enabled = true
local HealthBar_Enabled = true
local HeadDot_Enabled = true
local GazeLine_Enabled = true    
local OutOfView_Enabled = true
local Tracers_Enabled = true
local Chams_Enabled = true
local Chams_FillTransp = 0.4
local Chams_OutlineTransp = 0.1
local Show_Names = true   
local Show_Dist = true    
local Show_Weapon = true  
local Crosshair_Enabled = true
local Fog_Enabled = false
local RGB_World_Enabled = false

-- Player & Movement
local Noclip_Enabled = false
local InfJump_Enabled = false
local BHop_Enabled = false
local Speed_Enabled = false
local Jump_Enabled = false
local Cheat_Speed = 50
local Cheat_Jump = 80
local Spinbot_Enabled = false   
local Spinbot_Speed = 50        
local ThirdPerson_Enabled = false
local ThirdPerson_Dist = 15
local WalkTrail_Enabled = true
local Unfreeze_Enabled = false
local Hitbox_Enabled = false
local Hitbox_Size = 3
local Fly_Enabled = false
local Fly_Speed = 50

-- MM2 & Fun
local MM2_Revealer = true
local JumpCircle_Enabled = true

local Original_FogEnd = Lighting.FogEnd


-- ================= ПЛАВАЮЩАЯ ПАНЕЛЬ СТАТИСТИКИ =================
local StatsBar = Instance.new("Frame")
StatsBar.Name = "FloatingStatsBar"
StatsBar.Size = UDim2.new(0, 310, 0, 36)
StatsBar.Position = UDim2.new(0.5, -155, 0, 15)
StatsBar.BackgroundColor3 = Color3.fromRGB(12, 10, 15)
StatsBar.BackgroundTransparency = 0.25
StatsBar.Active = true
StatsBar.Draggable = true
StatsBar.ZIndex = 10
StatsBar.Visible = statsBarVisible
StatsBar.Parent = ScreenGui

Instance.new("UICorner", StatsBar).CornerRadius = UDim.new(1, 0)
local StatsStroke = Instance.new("UIStroke")
StatsStroke.Color = Color3.fromRGB(60, 50, 70)
StatsStroke.Thickness = 1.5
StatsStroke.Transparency = 0.3
StatsStroke.Parent = StatsBar

local ChipIcon = Instance.new("TextLabel")
ChipIcon.Size = UDim2.new(0, 24, 0, 24)
ChipIcon.Position = UDim2.new(0, 10, 0.5, -12)
ChipIcon.BackgroundTransparency = 1
ChipIcon.Font = Enum.Font.GothamBold
ChipIcon.Text = "💎"
ChipIcon.TextColor3 = Color3.fromRGB(255, 150, 200)
ChipIcon.TextSize = 13
ChipIcon.ZIndex = 11
ChipIcon.Parent = StatsBar

local HubNameLabel = Instance.new("TextLabel")
HubNameLabel.Size = UDim2.new(0, 85, 1, 0)
HubNameLabel.Position = UDim2.new(0, 34, 0, 0)
HubNameLabel.BackgroundTransparency = 1
HubNameLabel.Font = Enum.Font.GothamBold
HubNameLabel.Text = "Pulsar Hub"
HubNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HubNameLabel.TextSize = 12
HubNameLabel.TextXAlignment = Enum.TextXAlignment.Left
HubNameLabel.ZIndex = 11
HubNameLabel.Parent = StatsBar

local Sep1 = Instance.new("Frame")
Sep1.Size = UDim2.new(0, 1, 0, 18)
Sep1.Position = UDim2.new(0, 120, 0.5, -9)
Sep1.BackgroundColor3 = Color3.fromRGB(70, 60, 80)
Sep1.BorderSizePixel = 0
Sep1.ZIndex = 11
Sep1.Parent = StatsBar

local FpsValueLabel = Instance.new("TextLabel")
FpsValueLabel.Size = UDim2.new(0, 45, 1, 0)
FpsValueLabel.Position = UDim2.new(0, 150, 0, 0)
FpsValueLabel.BackgroundTransparency = 1
FpsValueLabel.Font = Enum.Font.GothamBold
FpsValueLabel.Text = "60"
FpsValueLabel.TextColor3 = Color3.fromRGB(50, 255, 100)
FpsValueLabel.TextSize = 13
FpsValueLabel.TextXAlignment = Enum.TextXAlignment.Left
FpsValueLabel.ZIndex = 11
FpsValueLabel.Parent = StatsBar

local FpsTextLabel = Instance.new("TextLabel")
FpsTextLabel.Size = UDim2.new(0, 30, 1, 0)
FpsTextLabel.Position = UDim2.new(0, 182, 0, 0)
FpsTextLabel.BackgroundTransparency = 1
FpsTextLabel.Font = Enum.Font.GothamMedium
FpsTextLabel.Text = "FPS"
FpsTextLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
FpsTextLabel.TextSize = 11
FpsTextLabel.TextXAlignment = Enum.TextXAlignment.Left
FpsTextLabel.ZIndex = 11
FpsTextLabel.Parent = StatsBar

local Sep2 = Instance.new("Frame")
Sep2.Size = UDim2.new(0, 1, 0, 18)
Sep2.Position = UDim2.new(0, 215, 0.5, -9)
Sep2.BackgroundColor3 = Color3.fromRGB(70, 60, 80)
Sep2.BorderSizePixel = 0
Sep2.ZIndex = 11
Sep2.Parent = StatsBar

local PingValueLabel = Instance.new("TextLabel")
PingValueLabel.Size = UDim2.new(0, 35, 1, 0)
PingValueLabel.Position = UDim2.new(0, 244, 0, 0)
PingValueLabel.BackgroundTransparency = 1
PingValueLabel.Font = Enum.Font.GothamBold
PingValueLabel.Text = "45"
PingValueLabel.TextColor3 = Color3.fromRGB(50, 255, 100)
PingValueLabel.TextSize = 13
PingValueLabel.TextXAlignment = Enum.TextXAlignment.Left
PingValueLabel.ZIndex = 11
PingValueLabel.Parent = StatsBar

local PingTextLabel = Instance.new("TextLabel")
PingTextLabel.Size = UDim2.new(0, 25, 1, 0)
PingTextLabel.Position = UDim2.new(0, 278, 0, 0)
PingTextLabel.BackgroundTransparency = 1
PingTextLabel.Font = Enum.Font.GothamMedium
PingTextLabel.Text = "ms"
PingTextLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
PingTextLabel.TextSize = 11
PingTextLabel.TextXAlignment = Enum.TextXAlignment.Left
PingTextLabel.ZIndex = 11
PingTextLabel.Parent = StatsBar

task.spawn(function()
    local lastTick = tick()
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        if tick() - lastTick >= 1 then
            FpsValueLabel.Text = tostring(math.floor(frameCount / (tick() - lastTick)))
            local pingVal = 45
            pcall(function() pingVal = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            PingValueLabel.Text = tostring(pingVal)
            frameCount = 0
            lastTick = tick()
        end
    end)
end)


-- ================= КНОПКА ОТКРЫТИЯ =================
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "PulsarToggleBtn"
ToggleButton.Size = UDim2.new(0, 145, 0, 42)
ToggleButton.Position = UDim2.new(0, 20, 0.4, -21)
ToggleButton.BackgroundColor3 = Color3.fromRGB(12, 10, 15)
ToggleButton.BackgroundTransparency = 0.25
ToggleButton.Text = ""
ToggleButton.AutoButtonColor = true
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui

Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 100, 180)
ToggleStroke.Thickness = 1.5
ToggleStroke.Transparency = 0.2
ToggleStroke.Parent = ToggleButton

local PulsarIcon = Instance.new("TextLabel")
PulsarIcon.Size = UDim2.new(0, 30, 0, 30)
PulsarIcon.Position = UDim2.new(0, 8, 0.5, -15)
PulsarIcon.BackgroundTransparency = 1
PulsarIcon.Font = Enum.Font.GothamBold
PulsarIcon.Text = "💎"
PulsarIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
PulsarIcon.TextSize = 16
PulsarIcon.ZIndex = 11
PulsarIcon.Parent = ToggleButton

local ToggleText = Instance.new("TextLabel")
ToggleText.Size = UDim2.new(0, 95, 1, 0)
ToggleText.Position = UDim2.new(0, 40, 0, 0)
ToggleText.BackgroundTransparency = 1
ToggleText.Font = Enum.Font.GothamBold
ToggleText.Text = "Pulsar Hub"
ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleText.TextSize = 12
ToggleText.TextXAlignment = Enum.TextXAlignment.Left
ToggleText.ZIndex = 11
ToggleText.Parent = ToggleButton


-- ================= ГЛАВНОЕ ОКНО =================
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, math.floor(580 * currentScale), 0, math.floor(350 * currentScale))
MainWindow.Position = UDim2.new(0.5, math.floor(-290 * currentScale), 0.5, math.floor(-175 * currentScale))
MainWindow.BackgroundColor3 = currentMenuColor
MainWindow.BackgroundTransparency = currentTransparency
MainWindow.ClipsDescendants = true
MainWindow.Visible = false
MainWindow.Active = true
MainWindow.Parent = ScreenGui

Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 10)
local WindowStroke = Instance.new("UIStroke")
WindowStroke.Color = Color3.fromRGB(80, 60, 90)
WindowStroke.Transparency = 0.3
WindowStroke.Thickness = 1.5
WindowStroke.Parent = MainWindow

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 3
TopBar.Parent = MainWindow

local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainWindow.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local isOpen = false
local function toggleMenu()
    isOpen = not isOpen
    if isOpen then
        MainWindow.Visible = true
        MainWindow.Size = UDim2.new(0, 100, 0, 60)
        TweenService:Create(MainWindow, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, math.floor(580 * currentScale), 0, math.floor(350 * currentScale))
        }):Play()
    else
        local tw = TweenService:Create(MainWindow, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 100, 0, 60)})
        tw:Play()
        tw.Completed:Connect(function() if not isOpen then MainWindow.Visible = false end end)
    end
end
ToggleButton.MouseButton1Click:Connect(toggleMenu)

local function createMacDot(color, posX, onClick)
    local dot = Instance.new("TextButton")
    dot.Size = UDim2.new(0, 11, 0, 11)
    dot.Position = UDim2.new(0, posX, 0, 10)
    dot.BackgroundColor3 = color
    dot.Text = ""
    dot.ZIndex = 4
    dot.Parent = TopBar
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    if onClick then dot.MouseButton1Click:Connect(onClick) end
end
createMacDot(Color3.fromRGB(255, 95, 86), 12, toggleMenu)
createMacDot(Color3.fromRGB(255, 189, 46), 28, function()
    currentScale = 1.0; currentTransparency = 0.15; currentMenuColor = Color3.fromRGB(15, 12, 18)
    MainWindow.BackgroundColor3 = currentMenuColor
    saveConfig()
    MainWindow.BackgroundTransparency = currentTransparency
    TweenService:Create(MainWindow, TweenInfo.new(0.3), {Size = UDim2.new(0, 580, 0, 350), Position = UDim2.new(0.5, -290, 0.5, -175)}):Play()
end)
createMacDot(Color3.fromRGB(39, 201, 63), 44, toggleMenu)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 420, 0, 20)
TitleLabel.Position = UDim2.new(0, 70, 0, 6)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.RichText = true
TitleLabel.Text = "Pulsar Hub <font size='9' color='#A0A0B0'>v6.8 Final Edition | c00lkidd214anzz</font>"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
TitleLabel.TextSize = 11
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 3
TitleLabel.Parent = TopBar


-- ================= ВКЛАДКИ (SIDEBAR) =================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 125, 1, -32)
Sidebar.Position = UDim2.new(0, 0, 0, 32)
Sidebar.BackgroundTransparency = 1
Sidebar.ZIndex = 3
Sidebar.Parent = MainWindow

local tabButtons = {}
local tabContainers = {}

local function createTab(name, iconText, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 28)
    btn.Position = UDim2.new(0, 6, 0, (index - 1) * 32 + 6)
    btn.BackgroundColor3 = (index == 1) and Color3.fromRGB(45, 35, 55) or Color3.fromRGB(25, 20, 30)
    btn.BackgroundTransparency = (index == 1) and 0.3 or 0.8
    btn.Font = Enum.Font.GothamMedium
    btn.Text = "  " .. iconText .. "  " .. name
    btn.TextColor3 = Color3.fromRGB(230, 220, 240)
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 3
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -132, 1, -40)
    container.Position = UDim2.new(0, 130, 0, 36)
    container.BackgroundTransparency = 1
    container.CanvasSize = UDim2.new(0, 0, 0, 1150)
    container.ScrollBarThickness = 2
    container.Visible = (index == 1)
    container.ZIndex = 3
    container.Parent = MainWindow

    table.insert(tabButtons, btn)
    table.insert(tabContainers, container)

    btn.MouseButton1Click:Connect(function()
        for i, c in ipairs(tabContainers) do
            c.Visible = (i == index)
            tabButtons[i].BackgroundColor3 = (i == index) and Color3.fromRGB(45, 35, 55) or Color3.fromRGB(25, 20, 30)
            tabButtons[i].BackgroundTransparency = (i == index) and 0.3 or 0.8
        end
    end)
    return container
end

local AimTab = createTab("Rage & Aim", "🎯", 1)
local VisTab = createTab("Visuals", "👁️", 2)
local PlayerTab = createTab("Player", "🏃", 3)
local MM2Tab = createTab("MM2 / Fun", "⚔️", 4)
local SettingsTab = createTab("Settings", "⚙️", 5)


-- UI Хелперы
local function createToggle(parent, title, desc, posY, callback, defaultState)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -16, 0, 42)
    card.Position = UDim2.new(0, 8, 0, posY)
    card.BackgroundColor3 = Color3.fromRGB(25, 20, 30)
    card.BackgroundTransparency = 0.5
    card.ZIndex = 3
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.RichText = true
    lbl.Text = string.format("<font size='10' color='#FFFFFF'><b>%s</b></font>\n<font size='8' color='#B0A0C0'>%s</font>", title, desc)
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
    lbl.Parent = card

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 36, 0, 20)
    toggleBtn.Position = UDim2.new(1, -44, 0.5, -10)
    toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(255, 100, 150) or Color3.fromRGB(60, 50, 70)
    toggleBtn.Text = ""
    toggleBtn.ZIndex = 3
    toggleBtn.Parent = card
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    circle.ZIndex = 3
    circle.Parent = toggleBtn
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local enabled = defaultState or false
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        local goalCirclePos = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local goalColor = enabled and Color3.fromRGB(255, 100, 150) or Color3.fromRGB(60, 50, 70)
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = goalCirclePos}):Play()
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
        if callback then callback(enabled) end
    end)
end

local function createSlider(parent, title, min, max, default, posY, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -16, 0, 50)
    card.Position = UDim2.new(0, 8, 0, posY)
    card.BackgroundColor3 = Color3.fromRGB(25, 20, 30)
    card.BackgroundTransparency = 0.5
    card.ZIndex = 3
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local textLbl = Instance.new("TextLabel")
    textLbl.Size = UDim2.new(1, -20, 0, 20)
    textLbl.Position = UDim2.new(0, 10, 0, 5)
    textLbl.BackgroundTransparency = 1
    textLbl.Font = Enum.Font.GothamMedium
    textLbl.Text = string.format("%s: %d", title, default)
    textLbl.TextColor3 = Color3.fromRGB(210, 200, 220)
    textLbl.TextSize = 10
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.ZIndex = 3
    textLbl.Parent = card

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 6)
    sliderBar.Position = UDim2.new(0, 10, 0, 32)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 40, 60)
    sliderBar.ZIndex = 3
    sliderBar.Parent = card
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)

    local rel = (default - min) / (max - min)
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(rel, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 100, 180)
    sliderFill.ZIndex = 3
    sliderFill.Parent = sliderBar
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 14, 0, 14)
    sliderBtn.Position = UDim2.new(rel, -7, 0.5, -7)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.ZIndex = 4
    sliderBtn.Parent = sliderBar
    Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

    local sliding = false
    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local posRel = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(posRel, 0, 1, 0)
            sliderBtn.Position = UDim2.new(posRel, -7, 0.5, -7)
            local val = math.floor(min + (posRel * (max - min)))
            textLbl.Text = string.format("%s: %d", title, val)
            if callback then callback(val) end
        end
    end)
end


-- ================= ЗАПОЛНЕНИЕ ВКЛАДОК =================

-- 1. RAGE & AIM
createToggle(AimTab, "Включить Аимбот", "Главный переключатель системы наведения", 5, function(v) Aimbot_Enabled = v end)
createToggle(AimTab, "Режим 3600/360 Rage Aimbot", "Яростный 360-градусный аим (Snap Snap / Rage)", 50, function(v) 
    Aimbot_Mode = v and "360Rage" or "Legit"
end)
createToggle(AimTab, "Team Check", "Не наводить на союзников", 95, function(v) Aimbot_TeamCheck = v end, true)
createToggle(AimTab, "Wall Check", "Проверка видимости за стенами", 140, function(v) Aimbot_WallCheck = v end, true)
createToggle(AimTab, "Отображать круг FOV", "Показывать радиус работы аимбота", 185, function(v) FOV_Enabled = v end, true)
createSlider(AimTab, "Радиус FOV", 50, 500, 180, 230, function(v) FOV_Radius = v end)
createSlider(AimTab, "Плавность / Smooth (для Legit)", 1, 20, 4, 290, function(v) Aimbot_SmoothVal = v end)


-- 2. VISUALS
createToggle(VisTab, "Включить ESP Master", "Главный переключатель подсветки игроков", 5, function(v) ESP_Enabled = v end, true)
createToggle(VisTab, "ESP Team Check", "Не подсвечивать союзников по команде", 50, function(v) ESP_TeamCheck = v end, true)
createToggle(VisTab, "Corner Box ESP", "Стильные уголки вокруг противников", 95, function(v) CornerBox_Enabled = v end, true)
createToggle(VisTab, "Skeleton ESP", "Отображение скелета игроков", 140, function(v) Skeleton_Enabled = v end, true)
createToggle(VisTab, "Health Bar", "Полоска здоровья сбоку от бокса", 185, function(v) HealthBar_Enabled = v end, true)
createToggle(VisTab, "Head Dot", "Точка на голове цели", 230, function(v) HeadDot_Enabled = v end, true)
createToggle(VisTab, "Gaze Line", "Линия направления взгляда врага", 275, function(v) GazeLine_Enabled = v end, true)
createToggle(VisTab, "Out-of-View Arrows", "Стрелки-указатели на врагов вне экрана", 320, function(v) OutOfView_Enabled = v end, true)
createToggle(VisTab, "Tracers (Линии до врагов)", "Линии от низа экрана к игрокам", 365, function(v) Tracers_Enabled = v end, true)
createToggle(VisTab, "Neon Chams (Подсветка тел)", "Неоновое подсвечивание тел сквозь стены", 410, function(v) Chams_Enabled = v end, true)
createSlider(VisTab, "Прозрачность Chams (Тело)", 0, 100, 40, 460, function(v) Chams_FillTransp = v / 100 end)
createSlider(VisTab, "Прозрачность Chams (Обводка)", 0, 100, 10, 520, function(v) Chams_OutlineTransp = v / 100 end)
createToggle(VisTab, "Кастомный прицел", "Включить точку по центру экрана", 580, function(v) Crosshair_Enabled = v end, true)
createToggle(VisTab, "Кастомный туман", "Атмосферный туман на карте", 625, function(v) Fog_Enabled = v end)
createToggle(VisTab, "RGB Радужный мир", "Переливание освещения карты в цветах радуги", 670, function(v) RGB_World_Enabled = v end)
createToggle(VisTab, "Никнеймы игроков", "Показывать имена над головой", 715, function(v) Show_Names = v end, true)
createToggle(VisTab, "Дистанция", "Показывать расстояние до противников", 760, function(v) Show_Dist = v end, true)
createToggle(VisTab, "Оружие в руках", "Отображать текущий предмет игрока", 805, function(v) Show_Weapon = v end, true)

-- Выбор цвета ESP
local EspColorTitle = Instance.new("TextLabel")
EspColorTitle.Size = UDim2.new(1, -20, 0, 20)
EspColorTitle.Position = UDim2.new(0, 10, 0, 855)
EspColorTitle.BackgroundTransparency = 1
EspColorTitle.Font = Enum.Font.GothamMedium
EspColorTitle.Text = "Цвет ESP и подсветки:"
EspColorTitle.TextColor3 = Color3.fromRGB(210, 200, 220)
EspColorTitle.TextSize = 10
EspColorTitle.TextXAlignment = Enum.TextXAlignment.Left
EspColorTitle.ZIndex = 3
EspColorTitle.Parent = VisTab

local espColors = {
    {Name = "Розовый неон", Color = Color3.fromRGB(255, 100, 180)},
    {Name = "Кибернетический синий", Color = Color3.fromRGB(50, 180, 255)},
    {Name = "Ядовито-зеленый", Color = Color3.fromRGB(50, 255, 100)},
    {Name = "Ярко-красный", Color = Color3.fromRGB(255, 60, 60)},
    {Name = "Золотой желтый", Color = Color3.fromRGB(255, 215, 0)}
}

for i, colInfo in ipairs(espColors) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 26)
    btn.Position = UDim2.new(0, 10 + ((i - 1) % 3) * 98, 0, 880 + (math.floor((i - 1) / 3) * 34))
    btn.BackgroundColor3 = colInfo.Color
    btn.Font = Enum.Font.GothamMedium
    btn.Text = colInfo.Name
    btn.TextColor3 = Color3.fromRGB(20, 20, 20)
    btn.TextSize = 9
    btn.ZIndex = 3
    btn.Parent = VisTab
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        espCustomColor = colInfo.Color
    end)
end


-- 3. PLAYER
createToggle(PlayerTab, "Крутилка (Spinbot 360/3600)", "Безумное вращение модельки игрока для дезориентации врагов", 5, function(v) Spinbot_Enabled = v end)
createSlider(PlayerTab, "Скорость крутилки (Spin Speed)", 10, 150, 50, 50, function(v) Spinbot_Speed = v end)

createToggle(PlayerTab, "Ноуклип (Noclip)", "Проход сквозь любые стены", 115, function(v) Noclip_Enabled = v end)
createToggle(PlayerTab, "Полет (Fly)", "Свободное перемещение в воздухе", 160, function(v) Fly_Enabled = v end)
createSlider(PlayerTab, "Скорость полета", 10, 200, 50, 205, function(v) Fly_Speed = v end)
createToggle(PlayerTab, "Бесконечный прыжок", "Возможность прыгать в воздухе", 265, function(v) InfJump_Enabled = v end)
createToggle(PlayerTab, "Авто-Прыжок (BHop)", "Автоматический непрерывный распрыг", 310, function(v) BHop_Enabled = v end)
createToggle(PlayerTab, "Быстрый бег (Speed)", "Увеличенная скорость передвижения", 355, function(v) Speed_Enabled = v end)
createToggle(PlayerTab, "Высокий прыжок (Jump)", "Усиленный прыжок персонажа", 400, function(v) Jump_Enabled = v end, false)
createSlider(PlayerTab, "Скорость бега (WalkSpeed)", 16, 150, 50, 445, function(v) Cheat_Speed = v end)
createSlider(PlayerTab, "Высота прыжка (JumpPower)", 50, 200, 80, 505, function(v) Cheat_Jump = v end)

createToggle(PlayerTab, "Вид от 3-го лица", "Свободное отдаление камеры", 565, function(v) 
    ThirdPerson_Enabled = v 
    if v then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMinZoomDistance = 5
        LocalPlayer.CameraMaxZoomDistance = ThirdPerson_Dist
    else
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 15.5
    end
end)
createSlider(PlayerTab, "Дистанция 3-го лица", 5, 60, 15, 610, function(v) 
    ThirdPerson_Dist = v
    if ThirdPerson_Enabled then LocalPlayer.CameraMaxZoomDistance = v end
end)

createToggle(PlayerTab, "Неоновый след (Трейл за игроком)", "Красивый шлейф при ходьбе", 670, function(v) WalkTrail_Enabled = v end, true)
createToggle(PlayerTab, "Ходьба вне раунда (Unfreeze)", "Позволяет двигаться в лобби", 715, function(v) Unfreeze_Enabled = v end)
createToggle(PlayerTab, "Безопасные хитбоксы (Hitbox Extender)", "Увеличение хитбоксов", 760, function(v) Hitbox_Enabled = v end)
createSlider(PlayerTab, "Размер хитбоксов", 2, 8, 3, 805, function(v) Hitbox_Size = v end)

local TpTitle = Instance.new("TextLabel")
TpTitle.Size = UDim2.new(1, -20, 0, 20)
TpTitle.Position = UDim2.new(0, 10, 0, 875)
TpTitle.BackgroundTransparency = 1
TpTitle.Font = Enum.Font.GothamMedium
TpTitle.Text = "Быстрый телепорт к игроку:"
TpTitle.TextColor3 = Color3.fromRGB(210, 200, 220)
TpTitle.TextSize = 10
TpTitle.TextXAlignment = Enum.TextXAlignment.Left
TpTitle.ZIndex = 3
TpTitle.Parent = PlayerTab

local TpButton = Instance.new("TextButton")
TpButton.Size = UDim2.new(1, -20, 0, 30)
TpButton.Position = UDim2.new(0, 10, 0, 900)
TpButton.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
TpButton.Font = Enum.Font.GothamBold
TpButton.Text = "⚡ Телепорт к случайному врагу"
TpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TpButton.TextSize = 10
TpButton.ZIndex = 3
TpButton.Parent = PlayerTab
Instance.new("UICorner", TpButton).CornerRadius = UDim.new(0, 6)

TpButton.MouseButton1Click:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            break
        end
    end
end)


-- 4. MM2 & FUN
createToggle(MM2Tab, "MM2 Role Revealer", "Авто-определение Шерифа и Убийцы в MM2", 5, function(v) MM2_Revealer = v end, true)
createToggle(MM2Tab, "Круг под ногами при прыжке", "Эффект волны при приземлении/прыжке", 50, function(v) JumpCircle_Enabled = v end, true)


-- 5. SETTINGS
createSlider(SettingsTab, "Масштаб интерфейса (%)", 70, 130, 100, 5, function(val)
    currentScale = val / 100
    MainWindow.Size = UDim2.new(0, math.floor(580 * currentScale), 0, math.floor(350 * currentScale))
    saveConfig()
end)

createSlider(SettingsTab, "Прозрачность меню (%)", 0, 80, 15, 65, function(val)
    currentTransparency = val / 100
    MainWindow.BackgroundTransparency = currentTransparency
    saveConfig()
end)

createToggle(SettingsTab, "Показывать панель статистики", "Отображение плавающего FPS / Ping окна сверху", 125, function(v)
    statsBarVisible = v
    StatsBar.Visible = v
    saveConfig()
end, statsBarVisible)

local ColorTitle = Instance.new("TextLabel")
ColorTitle.Size = UDim2.new(1, -20, 0, 20)
ColorTitle.Position = UDim2.new(0, 10, 0, 180)
ColorTitle.BackgroundTransparency = 1
ColorTitle.Font = Enum.Font.GothamMedium
ColorTitle.Text = "Цветовая тема меню:"
ColorTitle.TextColor3 = Color3.fromRGB(210, 200, 220)
ColorTitle.TextSize = 10
ColorTitle.TextXAlignment = Enum.TextXAlignment.Left
ColorTitle.ZIndex = 3
ColorTitle.Parent = SettingsTab

local colorsList = {
    {Name = "Темная ночь", Color = Color3.fromRGB(15, 12, 18)},
    {Name = "Киберпанк", Color = Color3.fromRGB(20, 10, 30)},
    {Name = "Неоновый синий", Color = Color3.fromRGB(10, 20, 35)},
    {Name = "Кровавый бордо", Color = Color3.fromRGB(35, 10, 15)},
    {Name = "Стильный графит", Color = Color3.fromRGB(25, 25, 30)}
}

for i, colInfo in ipairs(colorsList) do
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 90, 0, 26)
    colorBtn.Position = UDim2.new(0, 10 + ((i - 1) % 3) * 98, 0, 205 + (math.floor((i - 1) / 3) * 34))
    colorBtn.BackgroundColor3 = colInfo.Color
    colorBtn.Font = Enum.Font.GothamMedium
    colorBtn.Text = colInfo.Name
    colorBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
    colorBtn.TextSize = 9
    colorBtn.ZIndex = 3
    colorBtn.Parent = SettingsTab
    Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 80, 120)
    stroke.Thickness = 1
    stroke.Parent = colorBtn

    colorBtn.MouseButton1Click:Connect(function()
        currentMenuColor = colInfo.Color
        MainWindow.BackgroundColor3 = currentMenuColor
        saveConfig()
    end)
end


-- ================= РИСОВАНИЕ И ВИЗУАЛЬНЫЕ ЭФФЕКТЫ =================
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Visible = false; FOV_Circle.Filled = false; FOV_Circle.Thickness = 1.5; FOV_Circle.Color = Color3.fromRGB(255, 255, 255); FOV_Circle.NumSides = 64

local Crosshair_Dot = Drawing.new("Circle")
Crosshair_Dot.Visible = false; Crosshair_Dot.Filled = true; Crosshair_Dot.Radius = 2; Crosshair_Dot.NumSides = 12

local espObjects = {}
local currentRgbColor = Color3.new(1,1,1)
local trailPart = nil

local function setupESPForPlayer(p)
    if p == LocalPlayer then return end
    if not espObjects[p] then
        local box = Drawing.new("Square"); box.Visible = false; box.Filled = false; box.Thickness = 1.5
        local corners = {}
        for i = 1, 8 do local l = Drawing.new("Line"); l.Visible = false; l.Thickness = 1.5; table.insert(corners, l) end
        local text = Drawing.new("Text"); text.Visible = false; text.Size = 13; text.Center = true; text.Outline = true
        local healthBarBG = Drawing.new("Line"); healthBarBG.Visible = false; healthBarBG.Thickness = 2
        local healthBar = Drawing.new("Line"); healthBar.Visible = false; healthBar.Thickness = 2
        local headDot = Drawing.new("Circle"); headDot.Visible = false; headDot.Filled = true; headDot.Radius = 3
        local gazeLine = Drawing.new("Line"); gazeLine.Visible = false; gazeLine.Thickness = 1
        local oivArrow = Drawing.new("Triangle"); oivArrow.Visible = false; oivArrow.Filled = true; oivArrow.Thickness = 1
        local tracerLine = Drawing.new("Line"); tracerLine.Visible = false; tracerLine.Thickness = 1

        espObjects[p] = {
            Box = box, Corners = corners, Text = text, 
            HealthBarBG = healthBarBG, HealthBar = healthBar, 
            HeadDot = headDot, GazeLine = gazeLine, OIVArrow = oivArrow, TracerLine = tracerLine
        }
    end
end

for _, p in pairs(Players:GetPlayers()) do setupESPForPlayer(p) end
Players.PlayerAdded:Connect(setupESPForPlayer)
Players.PlayerRemoving:Connect(function(p)
    if espObjects[p] then
        pcall(function()
            espObjects[p].Box:Remove()
            for _, c in pairs(espObjects[p].Corners) do c:Remove() end
            espObjects[p].Text:Remove()
            espObjects[p].HealthBarBG:Remove()
            espObjects[p].HealthBar:Remove()
            espObjects[p].HeadDot:Remove()
            espObjects[p].GazeLine:Remove()
            espObjects[p].OIVArrow:Remove()
            espObjects[p].TracerLine:Remove()
        end)
        espObjects[p] = nil
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.spawn(function()
        task.wait(0.5)
        if ThirdPerson_Enabled then
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMinZoomDistance = 5
            LocalPlayer.CameraMaxZoomDistance = ThirdPerson_Dist
        end
    end)
end)

UserInputService.JumpRequest:Connect(function()
    if InfJump_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

RunService.Heartbeat:Connect(function()
    if BHop_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum:GetState() == Enum.HumanoidStateType.Running or hum:GetState() == Enum.HumanoidStateType.RunningNoPhysics then
            hum:ChangeState("Jumping")
        end
    end
end)

local function isVisible(targetPart)
    if not Aimbot_WallCheck then return true end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    local res = workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, rayParams)
    return res == nil
end

local function isTeammate(p)
    if not Aimbot_TeamCheck or p == LocalPlayer then return p == LocalPlayer end
    if p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then return true end
    return false
end

-- Функция тимчека для ESP
local function isEspTeammate(p)
    if not ESP_TeamCheck or p == LocalPlayer then return p == LocalPlayer and ESP_TeamCheck end
    if p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then return true end
    return false
end

local function getClosestPlayer()
    local closest, maxDist = nil, math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not isTeammate(p) and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local targetPart = p.Character:FindFirstChild(Aimbot_TargetPart) or p.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            
            local passesWallCheck = true
            if Aimbot_WallCheck then
                passesWallCheck = isVisible(targetPart)
            end

            if (onScreen or Aimbot_Mode == "360Rage") and passesWallCheck then
                local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                if (Aimbot_Mode == "360Rage" or dist <= FOV_Radius) and dist < maxDist then 
                    maxDist = dist 
                    closest = targetPart 
                end
            end
        end
    end
    return closest
end

local function hideAllESP()
    for _, obj in pairs(espObjects) do
        pcall(function()
            obj.Box.Visible = false
            for _, c in pairs(obj.Corners) do c.Visible = false end
            obj.Text.Visible = false
            obj.HealthBarBG.Visible = false
            obj.HealthBar.Visible = false
            obj.HeadDot.Visible = false
            obj.GazeLine.Visible = false
            obj.OIVArrow.Visible = false
            obj.TracerLine.Visible = false
        end)
    end
end

RunService.Stepped:Connect(function()
    currentRgbColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    local activeColor = RGB_World_Enabled and currentRgbColor or espCustomColor

    if Fog_Enabled then
        Lighting.FogEnd = 300; Lighting.FogColor = activeColor
    else
        Lighting.FogEnd = Original_FogEnd
    end

    if RGB_World_Enabled then
        Lighting.Ambient = currentRgbColor; Lighting.OutdoorAmbient = currentRgbColor
    else
        Lighting.Ambient = Color3.fromRGB(0,0,0)
    end

    if Noclip_Enabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end

    if Fly_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = true end
        local camCF = Camera.CFrame
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
        hrp.Velocity = moveDir * Fly_Speed
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not Noclip_Enabled then hum.PlatformStand = false end
    end

    if Unfreeze_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.PlatformStand = false
        if hum.WalkSpeed < 16 then hum.WalkSpeed = 16 end
    end

    if Spinbot_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Spinbot_Speed), 0)
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            if Hitbox_Enabled then
                hrp.Size = Vector3.new(Hitbox_Size, Hitbox_Size, Hitbox_Size)
                hrp.Transparency = 0.7
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            end
        end
    end

    if WalkTrail_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if not trailPart or not trailPart.Parent then
            local att0 = Instance.new("Attachment", hrp)
            local att1 = Instance.new("Attachment", hrp)
            att1.Position = Vector3.new(0, -2, 0)
            local t = Instance.new("Trail", hrp)
            t.Attachment0 = att0; t.Attachment1 = att1
            t.Color = ColorSequence.new(activeColor)
            t.Lifetime = 0.5; t.WidthScale = NumberSequence.new(0.5, 0)
            trailPart = t
        else
            trailPart.Color = ColorSequence.new(activeColor)
        end
    elseif not WalkTrail_Enabled and trailPart then
        trailPart:Destroy()
        trailPart = nil
    end

    FOV_Circle.Visible = FOV_Enabled and Aimbot_Enabled and (Aimbot_Mode == "Legit")
    FOV_Circle.Radius = FOV_Radius
    FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOV_Circle.Color = activeColor

    if Crosshair_Enabled then
        Crosshair_Dot.Visible = true
        Crosshair_Dot.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        Crosshair_Dot.Color = activeColor
    else
        Crosshair_Dot.Visible = false
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        hum.WalkSpeed = Speed_Enabled and Cheat_Speed or 16
        
        if Jump_Enabled then
            if hum.UseJumpPower then 
                hum.JumpPower = Cheat_Jump 
            else 
                hum.JumpHeight = Cheat_Jump / 2 
            end
        end
    end

    if Aimbot_Enabled then
        local targetPart = getClosestPlayer()
        if targetPart then
            if Aimbot_Mode == "360Rage" then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            else
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPart.Position), 1 / Aimbot_SmoothVal)
            end
        end
    end

    if not ESP_Enabled then
        hideAllESP()
        return
    end

    for player, obj in pairs(espObjects) do
        local character = player.Character
        -- Применяем ESP Team Check здесь
        local isTeamMember = isEspTeammate(player)
        
        if ESP_Enabled and not isTeamMember and character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            local rootPart = character.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

            if Chams_Enabled then
                local chams = character:FindFirstChild("CustomNeonChams") or Instance.new("Highlight", character)
                chams.Name = "CustomNeonChams"
                chams.FillTransparency = Chams_FillTransp
                chams.OutlineTransparency = Chams_OutlineTransp
                chams.FillColor = activeColor
                chams.OutlineColor = Color3.new(1, 1, 1)
            elseif character:FindFirstChild("CustomNeonChams") then
                character.CustomNeonChams:Destroy()
            end

            if Tracers_Enabled and onScreen then
                obj.TracerLine.Visible = true
                obj.TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                obj.TracerLine.To = Vector2.new(vector.X, vector.Y)
                obj.TracerLine.Color = activeColor
            else
                obj.TracerLine.Visible = false
            end

            if OutOfView_Enabled and not onScreen then
                local camCF = Camera.CFrame
                local relPos = camCF:PointToObjectSpace(rootPart.Position)
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local angle = math.atan2(relPos.Z, relPos.X)
                local radius = 160
                local arrowPos = screenCenter + Vector2.new(math.cos(angle), math.sin(angle)) * radius
                
                obj.OIVArrow.Visible = true; obj.OIVArrow.Color = activeColor
                obj.OIVArrow.PointA = arrowPos + Vector2.new(math.cos(angle), math.sin(angle)) * 12
                obj.OIVArrow.PointB = arrowPos + Vector2.new(math.cos(angle + 2.5), math.sin(angle + 2.5)) * 7
                obj.OIVArrow.PointC = arrowPos + Vector2.new(math.cos(angle - 2.5), math.sin(angle - 2.5)) * 7
            else
                obj.OIVArrow.Visible = false
            end

            if onScreen then
                local dist = (Camera.CFrame.Position - rootPart.Position).Magnitude
                local scale = 1000 / dist
                local boxW, boxH = scale * 1.5, scale * 2.5
                local boxX, boxY = vector.X - boxW / 2, vector.Y - boxH / 2

                if CornerBox_Enabled then
                    local lW, lH = boxW / 4, boxH / 4
                    local c = obj.Corners
                    c[1].From = Vector2.new(boxX, boxY); c[1].To = Vector2.new(boxX + lW, boxY); c[1].Color = activeColor; c[1].Visible = true
                    c[2].From = Vector2.new(boxX, boxY); c[2].To = Vector2.new(boxX, boxY + lH); c[2].Color = activeColor; c[2].Visible = true
                    c[3].From = Vector2.new(boxX + boxW, boxY); c[3].To = Vector2.new(boxX + boxW - lW, boxY); c[3].Color = activeColor; c[3].Visible = true
                    c[4].From = Vector2.new(boxX + boxW, boxY); c[4].To = Vector2.new(boxX + boxW, boxY + lH); c[4].Color = activeColor; c[4].Visible = true
                    c[5].From = Vector2.new(boxX, boxY + boxH); c[5].To = Vector2.new(boxX + lW, boxY + boxH); c[5].Color = activeColor; c[5].Visible = true
                    c[6].From = Vector2.new(boxX, boxY + boxH); c[6].To = Vector2.new(boxX, boxY + boxH - lH); c[6].Color = activeColor; c[6].Visible = true
                    c[7].From = Vector2.new(boxX + boxW, boxY + boxH); c[7].To = Vector2.new(boxX + boxW - lW, boxY + boxH); c[7].Color = activeColor; c[7].Visible = true
                    c[8].From = Vector2.new(boxX + boxW, boxY + boxH); c[8].To = Vector2.new(boxX + boxW, boxY + boxH - lH); c[8].Color = activeColor; c[8].Visible = true
                else
                    for _, line in pairs(obj.Corners) do line.Visible = false end
                end

                if HeadDot_Enabled and character:FindFirstChild("Head") then
                    local hp, hOn = Camera:WorldToViewportPoint(character.Head.Position)
                    if hOn then
                        obj.HeadDot.Visible = true; obj.HeadDot.Position = Vector2.new(hp.X, hp.Y); obj.HeadDot.Color = activeColor
                        if GazeLine_Enabled then
                            local lookTarget = character.Head.Position + (character.Head.CFrame.LookVector * 5)
                            local tpPos, tOn = Camera:WorldToViewportPoint(lookTarget)
                            if tOn then
                                obj.GazeLine.Visible = true; obj.GazeLine.From = Vector2.new(hp.X, hp.Y); obj.GazeLine.To = Vector2.new(tpPos.X, tpPos.Y); obj.GazeLine.Color = activeColor
                            else obj.GazeLine.Visible = false end
                        else obj.GazeLine.Visible = false end
                    else obj.HeadDot.Visible = false; obj.GazeLine.Visible = false end
                else obj.HeadDot.Visible = false; obj.GazeLine.Visible = false end

                if HealthBar_Enabled and character.Humanoid then
                    local hpPct = math.clamp(character.Humanoid.Health / character.Humanoid.MaxHealth, 0, 1)
                    obj.HealthBarBG.Visible = true
                    obj.HealthBarBG.From = Vector2.new(boxX - 6, boxY + boxH)
                    obj.HealthBarBG.To = Vector2.new(boxX - 6, boxY)
                    obj.HealthBarBG.Color = Color3.fromRGB(40, 40, 40)

                    obj.HealthBar.Visible = true
                    obj.HealthBar.From = Vector2.new(boxX - 6, boxY + boxH)
                    obj.HealthBar.To = Vector2.new(boxX - 6, boxY + (boxH * (1 - hpPct)))
                    obj.HealthBar.Color = Color3.fromRGB(0, 255, 100)
                else obj.HealthBarBG.Visible = false; obj.HealthBar.Visible = false end

                local textBuffer = ""
                if Show_Names then textBuffer = textBuffer .. player.Name end
                if MM2_Revealer then
                    local bp = player:FindFirstChild("Backpack")
                    if (bp and (bp:FindFirstChild("Knife") or bp:FindFirstChild("Dagger"))) or character:FindFirstChild("Knife") then 
                        textBuffer = textBuffer .. " [🔪 Убийца]"
                    elseif (bp and (bp:FindFirstChild("Gun") or bp:FindFirstChild("Revolver"))) or character:FindFirstChild("Gun") then 
                        textBuffer = textBuffer .. " [🔫 Шериф]" 
                    end
                end
                if Show_Dist then textBuffer = textBuffer .. " [" .. math.floor(dist)  .. "м]" end
                
                obj.Text.Text = textBuffer
                obj.Text.Position = Vector2.new(vector.X, boxY - 18)
                obj.Text.Color = activeColor
                obj.Text.Visible = true
            else
                for _, c in pairs(obj.Corners) do c.Visible = false end
                obj.Text.Visible = false; obj.HealthBarBG.Visible = false; obj.HealthBar.Visible = false
                obj.HeadDot.Visible = false; obj.GazeLine.Visible = false
            end
        else
            -- Если это союзник или игрок не подходит под условия ESP, скрываем всю его подсветку
            if character and character:FindFirstChild("CustomNeonChams") then
                character.CustomNeonChams:Destroy()
            end
            for _, c in pairs(obj.Corners) do c.Visible = false end
            obj.Text.Visible = false; obj.HealthBarBG.Visible = false; obj.HealthBar.Visible = false
            obj.HeadDot.Visible = false; obj.GazeLine.Visible = false; obj.OIVArrow.Visible = false; if obj.TracerLine then obj.TracerLine.Visible = false end
        end
    end
end)

print("Pulsar Hub v6.8 Final Edition Loaded Successfully! Created by c00lkidd214anzz")
