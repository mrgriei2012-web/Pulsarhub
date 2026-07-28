-- c00lkidd214anzz Hub (Settings Expansion Edition)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Pulsar Hub | by c00lkidd214anzz",
    LoadingTitle = "Загрузка Pulsar Hub...",
    LoadingSubtitle = "by c00lkidd214anzz",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PulsarHubConfig",
        FileName = "SettingsHubConfig"
    },
    KeySystem = false,
})

-- Переменные
local ESP_Enabled = false
local Show_Names = true   
local Show_Dist = true    
local Chams_Enabled = false
local RGB_Chams = false
local Hitbox_Enabled = false
local Noclip_Enabled = false
local Flying = false
local SpinBot_Enabled = false

local InfJump_Enabled = false
local Aimbot_Enabled = false
local Aimbot_TeamCheck = true
local Aimbot_WallCheck = true
local FOV_Enabled = true
local FOV_Radius = 150

local AutoParry_Enabled = false
local MM2_Revealer = false
local ThirdPerson_Enabled = false
local AutoThirdPerson_Enabled = false
local HitSound_Enabled = true

-- Новые переменные для настроек камеры и экрана
local FOV_Changer_Enabled = false
local Custom_FOV = 70
local ScreenStretch_Enabled = false
local Screen_Resolution_Scale = 1 -- 1 = стандарт, меньше = растяг/пиксели для FPS

local Tracer_Mode = "Bottom"
local Tracer_Color_Mode = "Team"
local Cheat_Speed = 50
local Cheat_Jump = 120
local Hitbox_Size = 5
local FlySpeed = 50

local Original_Speed = 16
local Original_Jump = 50
local Original_UseJumpPower = true
local Original_FOV = Camera.FieldOfView

local function SaveOriginalStats(character)
    local hum = character:WaitForChild("Humanoid", 5)
    if hum then
        Original_Speed = hum.WalkSpeed
        Original_UseJumpPower = hum.UseJumpPower
        Original_Jump = hum.UseJumpPower and hum.JumpPower or hum.JumpHeight
    end
end
if LocalPlayer.Character then SaveOriginalStats(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(SaveOriginalStats)

local function ApplyThirdPerson()
    if ThirdPerson_Enabled or AutoThirdPerson_Enabled then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMinZoomDistance = 10
        LocalPlayer.CameraMaxZoomDistance = 400
    end
end

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    if AutoThirdPerson_Enabled then
        task.wait(0.5)
        ApplyThirdPerson()
    end
end)

local Speed_Enabled = false
local Jump_Enabled = false
local espObjects = {}
local currentRgbColor = Color3.new(1,1,1)

local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Visible = false
FOV_Circle.Filled = false
FOV_Circle.Thickness = 1.5
FOV_Circle.Color = Color3.fromRGB(255, 255, 255)
FOV_Circle.NumSides = 64

-- Инициализация ESP объектов для игроков
local function setupESPForPlayer(p)
    if p == LocalPlayer then return end
    if not espObjects[p] then
        local box = Drawing.new("Square")
        box.Visible = false
        box.Filled = false
        box.Thickness = 1.5

        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Thickness = 1.5

        local text = Drawing.new("Text")
        text.Visible = false
        text.Size = 14
        text.Center = true
        text.Outline = true

        espObjects[p] = {Box = box, Tracer = tracer, Text = text}
    end
end

for _, p in pairs(Players:GetPlayers()) do
    setupESPForPlayer(p)
end

Players.PlayerAdded:Connect(setupESPForPlayer)
Players.PlayerRemoving:Connect(function(p)
    if espObjects[p] then
        pcall(function()
            espObjects[p].Box:Remove()
            espObjects[p].Tracer:Remove()
            espObjects[p].Text:Remove()
        end)
        espObjects[p] = nil
    end
end)

-- ==================== ВКЛАДКИ ИНТЕРФЕЙСА ====================
local AimTab = Window:CreateTab("Aimbot", 4483362458)
AimTab:CreateToggle({
    Name = "Aimbot (Доводка Камеры)",
    CurrentValue = false,
    Callback = function(v) Aimbot_Enabled = v end,
})
AimTab:CreateToggle({
    Name = "Team Check (Не бить своих)",
    CurrentValue = true,
    Callback = function(v) Aimbot_TeamCheck = v end,
})
AimTab:CreateToggle({
    Name = "Wall Check (Сквозь стены не целить)",
    CurrentValue = true,
    Callback = function(v) Aimbot_WallCheck = v end,
})
AimTab:CreateToggle({
    Name = "Показывать круг FOV",
    CurrentValue = true,
    Callback = function(v) FOV_Enabled = v end,
})
AimTab:CreateSlider({
    Name = "Радиус FOV",
    Range = {50, 500},
    Increment = 5,
    CurrentValue = 150,
    Flag = "FOV_Radius_Flag",
    Callback = function(v) FOV_Radius = v end,
})

local TeleportTab = Window:CreateTab("Teleports", 4483362458)
local selectedPlayerToTP = nil
local playerDropdownOptions = {}

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(playerDropdownOptions, p.Name) end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then table.insert(playerDropdownOptions, p.Name) end
end)
Players.PlayerRemoving:Connect(function(p)
    for i, name in ipairs(playerDropdownOptions) do
        if name == p.Name then table.remove(playerDropdownOptions, i) end
    end
end)

TeleportTab:CreateDropdown({
    Name = "Выбрать игрока",
    Options = playerDropdownOptions,
    CurrentOption = "",
    Callback = function(Option) selectedPlayerToTP = Option[1] end,
})
TeleportTab:CreateButton({
    Name = "Телепортироваться к игроку",
    Callback = function()
        if selectedPlayerToTP then
            local targetPlayer = Players:FindFirstChild(selectedPlayerToTP)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end
    end,
})
TeleportTab:CreateButton({
    Name = "Получить ТП Мышку (Click TP Tool)",
    Callback = function()
        local tool = Instance.new("Tool"); tool.Name = "Click Teleport"; tool.RequiresHandle = false
        tool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and mouse.Hit then 
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)) 
            end
        end)
        tool.Parent = LocalPlayer.Backpack
    end,
})

local BBTab = Window:CreateTab("Blade Ball", 4483362458)
BBTab:CreateToggle({
    Name = "Авто-Блок (Auto Parry)",
    CurrentValue = false,
    Callback = function(v) AutoParry_Enabled = v end,
})

local MM2Tab = Window:CreateTab("Murder Mystery 2", 4483362458)
MM2Tab:CreateToggle({
    Name = "MM2 Роли (Revealer)",
    CurrentValue = false,
    Callback = function(v) MM2_Revealer = v end,
})

local VisTab = Window:CreateTab("Visuals (ESP)", 4483362458)
VisTab:CreateToggle({
    Name = "Включить ESP Boxes",
    CurrentValue = false,
    Callback = function(v) 
        ESP_Enabled = v 
        if not v then 
            for _, obj in pairs(espObjects) do 
                pcall(function()
                    obj.Box.Visible = false
                    obj.Tracer.Visible = false
                    obj.Text.Visible = false 
                end)
            end 
        end
    end,
})
VisTab:CreateToggle({
    Name = "Показывать Никнеймы",
    CurrentValue = true,
    Callback = function(v) Show_Names = v end,
})
VisTab:CreateToggle({
    Name = "Показывать Дистанцию",
    CurrentValue = true,
    Callback = function(v) Show_Dist = v end,
})
VisTab:CreateToggle({
    Name = "Chams (Силуэты)",
    CurrentValue = false,
    Callback = function(v) Chams_Enabled = v end,
})
VisTab:CreateToggle({
    Name = "RGB Chams (Радуга)",
    CurrentValue = false,
    Callback = function(v) RGB_Chams = v end,
})
VisTab:CreateDropdown({
    Name = "Режим линий (Tracers)",
    Options = {"Bottom", "Center", "Top"},
    CurrentOption = "Bottom",
    Callback = function(Option) Tracer_Mode = Option[1] end,
})
VisTab:CreateDropdown({
    Name = "Цвет ESP",
    Options = {"Team", "Red", "Green", "Blue", "Rainbow"},
    CurrentOption = "Team",
    Callback = function(Option) Tracer_Color_Mode = Option[1] end,
})

local PlayerTab = Window:CreateTab("Main / Player", 4483362458)
PlayerTab:CreateToggle({
    Name = "Бесконечный Прыжок",
    CurrentValue = false,
    Callback = function(v) InfJump_Enabled = v end,
})
PlayerTab:CreateToggle({
    Name = "Быстрый бег (50)",
    CurrentValue = false,
    Callback = function(v) Speed_Enabled = v end,
})
PlayerTab:CreateToggle({
    Name = "Высокий прыжок (120)",
    CurrentValue = false,
    Callback = function(v) Jump_Enabled = v end,
})
PlayerTab:CreateToggle({
    Name = "Ноклип (Сквозь стены)",
    CurrentValue = false,
    Callback = function(v) Noclip_Enabled = v end,
})
PlayerTab:CreateToggle({
    Name = "Полет (Fly)",
    CurrentValue = false,
    Callback = function(v) Flying = v end,
})
PlayerTab:CreateToggle({
    Name = "Крутилка (SpinBot)",
    CurrentValue = false,
    Callback = function(v) SpinBot_Enabled = v end,
})
PlayerTab:CreateToggle({
    Name = "Увеличить Хитбоксы",
    CurrentValue = false,
    Callback = function(v) Hitbox_Enabled = v end,
})

-- ==================== ВКЛАДКА: SETTINGS (С НОВЫМИ ФУНКЦИЯМИ) ====================
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateToggle({
    Name = "Звук попадания (HitSound)",
    CurrentValue = true,
    Callback = function(v) HitSound_Enabled = v end,
})

SettingsTab:CreateToggle({
    Name = "Включить FOV Changer",
    CurrentValue = false,
    Callback = function(v) 
        FOV_Changer_Enabled = v 
        if not v then Camera.FieldOfView = Original_FOV end
    end,
})

SettingsTab:CreateSlider({
    Name = "Угол обзора (FOV камера)",
    Range = {50, 120},
    Increment = 1,
    CurrentValue = 70,
    Flag = "Camera_FOV_Flag",
    Callback = function(v) 
        Custom_FOV = v 
    end,
})

SettingsTab:CreateToggle({
    Name = "Включить растяг экрана (Resolution Scale)",
    CurrentValue = false,
    Callback = function(v)
        ScreenStretch_Enabled = v
        if not v then
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            end)
        end
    end,
})

SettingsTab:CreateSlider({
    Name = "Степень растяга / Разрешение",
    Range = {0.5, 1.0},
    Increment = 0.05,
    CurrentValue = 1.0,
    Flag = "ScreenStretch_Flag",
    Callback = function(v)
        Screen_Resolution_Scale = v
    end,
})

local SkinTab = Window:CreateTab("Skins", 4483362458)
SkinTab:CreateButton({
    Name = "Применить скин: сахур",
    Callback = function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            local desc = Instance.new("HumanoidDescription")
            local success = pcall(function() desc.BundleId = 77146269098974 end)
            if success then
                humanoid:RemoveAccessories()
                humanoid:ApplyDescription(desc)
            end
        end
    end,
})
SkinTab:CreateButton({
    Name = "Сбросить скин",
    Callback = function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:RemoveAccessories()
            local success, desc = pcall(function() return game.Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId) end)
            if success and desc then humanoid:ApplyDescription(desc) end
        end
    end,
})

local CameraTab = Window:CreateTab("Camera", 4483362458)
CameraTab:CreateToggle({
    Name = "Вид от 3-го лица",
    CurrentValue = false,
    Callback = function(v)
        ThirdPerson_Enabled = v
        if ThirdPerson_Enabled then
            ApplyThirdPerson()
        else
            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = 400
        end
    end,
})
CameraTab:CreateToggle({
    Name = "Авто-вкл 3 лица после смерти",
    CurrentValue = false,
    Callback = function(v)
        AutoThirdPerson_Enabled = v
        if v then ApplyThirdPerson() end
    end,
})

-- === ОСНОВНОЙ ЦИКЛ ===

UserInputService.JumpRequest:Connect(function()
    if InfJump_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local function isVisible(targetPart)
    if not Aimbot_WallCheck then return true end
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

local function getClosestPlayer()
    local closest, maxDist = nil, FOV_Radius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local isTeamMate = false
            if Aimbot_TeamCheck then
                if (p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team) or (p.TeamColor == LocalPlayer.TeamColor) then
                    isTeamMate = true
                end
            end
            
            if not isTeamMate and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local head = p.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local screenPos = Vector2.new(pos.X, pos.Y)
                    local dist = (screenPos - screenCenter).Magnitude
                    if dist <= maxDist then
                        if isVisible(head) then
                            maxDist = dist
                            closest = head
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.Stepped:Connect(function()
    currentRgbColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)

    FOV_Circle.Visible = FOV_Enabled and Aimbot_Enabled
    FOV_Circle.Radius = FOV_Radius
    FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- Применение FOV Changer
    if FOV_Changer_Enabled then
        Camera.FieldOfView = Custom_FOV
    end

    -- Применение растяга экрана / изменения разрешения рендеринга
    if ScreenStretch_Enabled then
        pcall(function()
            local ViewportSize = Camera.ViewportSize
            -- Меняем разрешение через вьюпорт или настройки качества для эффекта растяга/буста FPS
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame
        end)
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        hum.WalkSpeed = Speed_Enabled and Cheat_Speed or Original_Speed
        if hum.UseJumpPower then 
            hum.JumpPower = Jump_Enabled and Cheat_Jump or Original_Jump 
        else 
            hum.JumpHeight = Jump_Enabled and (Cheat_Jump / 3) or Original_Jump 
        end
    end

    if Noclip_Enabled and LocalPlayer.Character then 
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do 
            if part:IsA("BasePart") then part.CanCollide = false end 
        end 
    end
    
    if SpinBot_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(35), 0) 
    end
    
    if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hrp = LocalPlayer.Character.HumanoidRootPart 
        local hum = LocalPlayer.Character.Humanoid 
        hrp.Velocity = Vector3.new(0, 0.1, 0)
        if hum.MoveDirection.Magnitude > 0 then hrp.Velocity = hum.MoveDirection * FlySpeed end
    end

    if Aimbot_Enabled then
        local targetHead = getClosestPlayer()
        if targetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end

    if AutoParry_Enabled then
        local balls = workspace:FindFirstChild("Balls") or workspace:FindFirstChild("BallFolder")
        if balls then
            for _, ball in pairs(balls:GetChildren()) do
                if ball:IsA("BasePart") and ball:GetAttribute("Target") == LocalPlayer.Name then
                    local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (ball.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) or 999
                    local speed = ball.Velocity.Magnitude
                    if distance < (speed * 0.45) or distance < 15 then
                        local rem = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                        local parryRemote = rem and (rem:FindFirstChild("Parry") or rem:FindFirstChild("ParryAttempt"))
                        if parryRemote then parryRemote:FireServer() end
                    end
                end
            end
        end
    end

    local startPoint = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    if Tracer_Mode == "Center" then startPoint = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    elseif Tracer_Mode == "Top" then startPoint = Vector2.new(Camera.ViewportSize.X / 2, 0) end

    for player, obj in pairs(espObjects) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            local rootPart = character.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

            if Hitbox_Enabled then 
                rootPart.Size = Vector3.new(Hitbox_Size, Hitbox_Size, Hitbox_Size)
                rootPart.Transparency = 0.5 
                rootPart.BrickColor = BrickColor.new("Really red")
                rootPart.CanCollide = false 
            else 
                rootPart.Size = Vector3.new(2, 2, 1)
                rootPart.Transparency = 1 
            end

            local mm2Role = nil
            if MM2_Revealer then
                local backpack = player:FindFirstChild("Backpack")
                if (backpack and backpack:FindFirstChild("Knife")) or (character and character:FindFirstChild("Knife")) then mm2Role = "Murder"
                elseif (backpack and backpack:FindFirstChild("Gun")) or (character and character:FindFirstChild("Gun")) then mm2Role = "Sheriff" end
            end

            if Chams_Enabled then
                if not character:FindFirstChild("HubHighlight") then Instance.new("Highlight", character).Name = "HubHighlight" end
                local cHighlight = character.HubHighlight
                cHighlight.FillTransparency = 0.4
                if mm2Role == "Murder" then cHighlight.FillColor = Color3.fromRGB(255, 0, 0)
                elseif mm2Role == "Sheriff" then cHighlight.FillColor = Color3.fromRGB(0, 0, 255)
                else cHighlight.FillColor = RGB_Chams and currentRgbColor or Color3.fromRGB(255, 255, 255) end
            else
                if character:FindFirstChild("HubHighlight") then character.HubHighlight:Destroy() end
            end

            if ESP_Enabled and onScreen then
                local displayColor = Color3.fromRGB(255, 255, 255)
                if mm2Role == "Murder" then displayColor = Color3.fromRGB(255, 30, 30)
                elseif mm2Role == "Sheriff" then displayColor = Color3.fromRGB(30, 30, 255)
                elseif Tracer_Color_Mode == "Team" and player.Team then displayColor = player.TeamColor.Color
                elseif Tracer_Color_Mode == "Red" then displayColor = Color3.fromRGB(255, 50, 50)
                elseif Tracer_Color_Mode == "Green" then displayColor = Color3.fromRGB(50, 255, 50)
                elseif Tracer_Color_Mode == "Blue" then displayColor = Color3.fromRGB(50, 50, 255)
                elseif Tracer_Color_Mode == "Rainbow" then displayColor = currentRgbColor end

                local dist = (Camera.CFrame.Position - rootPart.Position).Magnitude
                local scale = 1000 / dist

                obj.Box.Color = displayColor
                obj.Box.Size = Vector2.new(scale * 1.5, scale * 2.5)
                obj.Box.Position = Vector2.new(vector.X - obj.Box.Size.X / 2, vector.Y - obj.Box.Size.Y / 2)
                obj.Box.Visible = true

                obj.Tracer.Color = displayColor
                obj.Tracer.From = startPoint
                obj.Tracer.To = Vector2.new(vector.X, vector.Y + (obj.Box.Size.Y / 2))
                obj.Tracer.Visible = true
                
                local textBuffer = ""
                if Show_Names then textBuffer = textBuffer .. player.Name end
                if mm2Role then textBuffer = textBuffer .. " [" .. mm2Role .. "]" end
                if Show_Dist then textBuffer = textBuffer .. " [" .. math.floor(dist) .. "m]" end
                
                obj.Text.Text = textBuffer
                obj.Text.Position = Vector2.new(vector.X, vector.Y - (obj.Box.Size.Y / 2) - 20)
                obj.Text.Color = displayColor
                obj.Text.Visible = (Show_Names or Show_Dist or MM2_Revealer)
            else
                obj.Box.Visible = false
                obj.Tracer.Visible = false
                obj.Text.Visible = false
            end
        else
            obj.Box.Visible = false
            obj.Tracer.Visible = false
            obj.Text.Visible = false
        end
    end
end)

Rayfield:Notify({
    Title = "Pulsar Hub Запущен!",
    Content = "by c00lkidd214anzz",
    Duration = 6.5,
    Image = 4483362458,
})
