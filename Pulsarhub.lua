-- c00lkidd214anzz Hub | Ultimate ESP Edition (Skeleton, Health, HeadDot, OIV)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Pulsar Hub | by c00lkidd214anzz",
    LoadingTitle = "Загрузка Pulsar Hub Pro...",
    LoadingSubtitle = "by c00lkidd214anzz",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PulsarHubConfig",
        FileName = "ProESPConfig"
    },
    KeySystem = false,
})

-- Переменные состояний
local ESP_Enabled = false
local Show_Names = true   
local Show_Dist = true    
local Chams_Enabled = false
local RGB_Chams = false

-- Новые визуалы (Skeleton, HealthBar, HeadDot, OutOfView)
local Skeleton_Enabled = false
local HealthBar_Enabled = false
local HeadDot_Enabled = false
local OutOfView_Enabled = false

local VisualAura_Enabled = false
local Aura_RGB = true
local Aura_Color = Color3.fromRGB(0, 255, 255)

local Hitbox_Enabled = false
local Noclip_Enabled = false
local Flying = false

local AntiAim_Mode = "Выключено"
local AntiAim_Speed = 50

local InfJump_Enabled = false
local Aimbot_Enabled = false
local Aimbot_Smooth = 5
local Aimbot_TeamCheck = true
local Aimbot_WallCheck = true
local FOV_Enabled = true
local FOV_Radius = 150

local AutoParry_Enabled = false
local MM2_Revealer = false
local ThirdPerson_Enabled = false
local AutoThirdPerson_Enabled = false
local HitSound_Enabled = true

local FOV_Changer_Enabled = false
local Custom_FOV = 70

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

-- Менеджер ESP с поддержкой скелетов и элементов
local function setupESPForPlayer(p)
    if p == LocalPlayer then return end
    if not espObjects[p] then
        local box = Drawing.new("Square")
        box.Visible = false; box.Filled = false; box.Thickness = 1.5

        local tracer = Drawing.new("Line")
        tracer.Visible = false; tracer.Thickness = 1.5

        local text = Drawing.new("Text")
        text.Visible = false; text.Size = 14; text.Center = true; text.Outline = true

        -- Здоровье
        local healthBarBG = Drawing.new("Line")
        healthBarBG.Visible = false; healthBarBG.Thickness = 2
        local healthBar = Drawing.new("Line")
        healthBar.Visible = false; healthBar.Thickness = 2

        -- Точка на голове
        local headDot = Drawing.new("Circle")
        headDot.Visible = false; headDot.Filled = true; headDot.Radius = 3

        -- Индикатор вне экрана (стрелка)
        local oivArrow = Drawing.new("Triangle")
        oivArrow.Visible = false; oivArrow.Filled = true; oivArrow.Thickness = 1

        -- Скелет (основные суставы: голова-шея, плечи, торс, руки, ноги)
        local bones = {}
        local boneNames = {"Head_Neck", "Neck_Chest", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg"}
        for _, _ in pairs(boneNames) do
            local line = Drawing.new("Line")
            line.Visible = false
            line.Thickness = 1.5
            table.insert(bones, line)
        end

        espObjects[p] = {
            Box = box, Tracer = tracer, Text = text, 
            HealthBarBG = healthBarBG, HealthBar = healthBar, 
            HeadDot = headDot, OIVArrow = oivArrow, Bones = bones
        }
    end
end

for _, p in pairs(Players:GetPlayers()) do setupESPForPlayer(p) end
Players.PlayerAdded:Connect(setupESPForPlayer)
Players.PlayerRemoving:Connect(function(p)
    if espObjects[p] then
        pcall(function()
            espObjects[p].Box:Remove()
            espObjects[p].Tracer:Remove()
            espObjects[p].Text:Remove()
            espObjects[p].HealthBarBG:Remove()
            espObjects[p].HealthBar:Remove()
            espObjects[p].HeadDot:Remove()
            espObjects[p].OIVArrow:Remove()
            for _, bone in pairs(espObjects[p].Bones) do bone:Remove() end
        end)
        espObjects[p] = nil
    end
end)

-- ==================== ВКЛАДКИ ИНТЕРФЕЙСА ====================
local AimTab = Window:CreateTab("Aimbot", 4483362458)
AimTab:CreateToggle({Name = "Aimbot (Плавная доводка)", CurrentValue = false, Callback = function(v) Aimbot_Enabled = v end})
AimTab:CreateSlider({Name = "Плавность Aimbot", Range = {1, 20}, Increment = 1, CurrentValue = 5, Flag = "Smooth", Callback = function(v) Aimbot_Smooth = v end})
AimTab:CreateToggle({Name = "Team Check (Свои)", CurrentValue = true, Callback = function(v) Aimbot_TeamCheck = v end})
AimTab:CreateToggle({Name = "Wall Check (Сквозь стены)", CurrentValue = true, Callback = function(v) Aimbot_WallCheck = v end})
AimTab:CreateToggle({Name = "Показывать круг FOV", CurrentValue = true, Callback = function(v) FOV_Enabled = v end})
AimTab:CreateSlider({Name = "Радиус FOV", Range = {50, 500}, Increment = 5, CurrentValue = 150, Flag = "FOV", Callback = function(v) FOV_Radius = v end})

local TeleportTab = Window:CreateTab("Teleports", 4483362458)
local selectedPlayerToTP = nil
local playerDropdownOptions = {}
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(playerDropdownOptions, p.Name) end end
TeleportTab:CreateDropdown({Name = "Выбрать игрока", Options = playerDropdownOptions, CurrentOption = "", Callback = function(Opt) selectedPlayerToTP = Opt[1] end})
TeleportTab:CreateButton({Name = "Телепортироваться к игроку", Callback = function()
    if selectedPlayerToTP then
        local tp = Players:FindFirstChild(selectedPlayerToTP)
        if tp and tp.Character and tp.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = tp.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end})
TeleportTab:CreateButton({Name = "Выдать Click TP Tool", Callback = function()
    local t = Instance.new("Tool"); t.Name = "Click Teleport"; t.RequiresHandle = false
    t.Activated:Connect(function()
        local m = LocalPlayer:GetMouse()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and m.Hit then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(m.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)
    t.Parent = LocalPlayer.Backpack
end})

local BBTab = Window:CreateTab("Blade Ball", 4483362458)
BBTab:CreateToggle({Name = "Авто-Блок (Auto Parry)", CurrentValue = false, Callback = function(v) AutoParry_Enabled = v end})

local MM2Tab = Window:CreateTab("Murder Mystery 2", 4483362458)
MM2Tab:CreateToggle({Name = "MM2 Роли (Revealer)", CurrentValue = false, Callback = function(v) MM2_Revealer = v end})

-- ==================== ВКЛАДКА ВИЗУАЛОВ (СУПЕР-ПАК) ====================
local VisTab = Window:CreateTab("Visuals (ESP)", 4483362458)
VisTab:CreateToggle({Name = "Включить ESP Boxes", CurrentValue = false, Callback = function(v) 
    ESP_Enabled = v 
    if not v then for _, o in pairs(espObjects) do pcall(function() o.Box.Visible = false; o.Tracer.Visible = false; o.Text.Visible = false end) end end
end})

VisTab:CreateToggle({Name = "Skeleton ESP (Скелет)", CurrentValue = false, Callback = function(v) Skeleton_Enabled = v end})
VisTab:CreateToggle({Name = "Health Bar (Полоска HP)", CurrentValue = false, Callback = function(v) HealthBar_Enabled = v end})
VisTab:CreateToggle({Name = "Head Dot (Точка на голове)", CurrentValue = false, Callback = function(v) HeadDot_Enabled = v end})
VisTab:CreateToggle({Name = "Out-of-View (Стрелки за экраном)", CurrentValue = false, Callback = function(v) OutOfView_Enabled = v end})

VisTab:CreateToggle({Name = "Визуальная Аура (Glow)", CurrentValue = false, Callback = function(v) 
    VisualAura_Enabled = v 
    if not v then for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("PulsarAuraGlow") then p.Character.PulsarAuraGlow:Destroy() end end end
end})
VisTab:CreateToggle({Name = "RGB Радужная аура / Чамс", CurrentValue = true, Callback = function(v) Aura_RGB = v end})

VisTab:CreateToggle({Name = "Показывать Никнеймы", CurrentValue = true, Callback = function(v) Show_Names = v end})
VisTab:CreateToggle({Name = "Показывать Дистанцию", CurrentValue = true, Callback = function(v) Show_Dist = v end})
VisTab:CreateToggle({Name = "Chams (Подсветка тел)", CurrentValue = false, Callback = function(v) Chams_Enabled = v end})
VisTab:CreateDropdown({Name = "Линии (Tracers)", Options = {"Bottom", "Center", "Top"}, CurrentOption = "Bottom", Callback = function(Opt) Tracer_Mode = Opt[1] end})
VisTab:CreateDropdown({Name = "Цвет ESP", Options = {"Team", "Red", "Green", "Blue", "Rainbow"}, CurrentOption = "Team", Callback = function(Opt) Tracer_Color_Mode = Opt[1] end})

local PlayerTab = Window:CreateTab("Main / Player", 4483362458)
PlayerTab:CreateToggle({Name = "Бесконечный Прыжок", CurrentValue = false, Callback = function(v) InfJump_Enabled = v end})
PlayerTab:CreateToggle({Name = "Быстрый бег (Speed)", CurrentValue = false, Callback = function(v) Speed_Enabled = v end})
PlayerTab:CreateToggle({Name = "Высокий прыжок (Jump)", CurrentValue = false, Callback = function(v) Jump_Enabled = v end})
PlayerTab:CreateToggle({Name = "Ноклип (Сквозь стены)", CurrentValue = false, Callback = function(v) Noclip_Enabled = v end})
PlayerTab:CreateToggle({Name = "Полет (Fly)", CurrentValue = false, Callback = function(v) Flying = v end})
PlayerTab:CreateDropdown({Name = "Режим Анти-Аим", Options = {"Выключено", "Spinbot", "Jitter (Дерганый)"}, CurrentOption = "Выключено", Callback = function(Opt) AntiAim_Mode = Opt[1] end})
PlayerTab:CreateSlider({Name = "Скорость Анти-Аим", Range = {10, 200}, Increment = 5, CurrentValue = 50, Flag = "AA", Callback = function(v) AntiAim_Speed = v end})
PlayerTab:CreateToggle({Name = "Увеличить Хитбоксы", CurrentValue = false, Callback = function(v) Hitbox_Enabled = v end})

local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateToggle({Name = "Звук попадания (HitSound)", CurrentValue = true, Callback = function(v) HitSound_Enabled = v end})
SettingsTab:CreateToggle({Name = "Включить FOV Changer", CurrentValue = false, Callback = function(v) FOV_Changer_Enabled = v if not v then Camera.FieldOfView = Original_FOV end end})
SettingsTab:CreateSlider({Name = "Угол обзора камеры (FOV)", Range = {50, 120}, Increment = 1, CurrentValue = 70, Flag = "CamFOV", Callback = function(v) Custom_FOV = v end})

local SkinTab = Window:CreateTab("Skins", 4483362458)
SkinTab:CreateButton({Name = "Применить скин: сахур", Callback = function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then local d = Instance.new("HumanoidDescription") pcall(function() d.BundleId = 77146269098974 end) hum:RemoveAccessories() hum:ApplyDescription(d) end
end})
SkinTab:CreateButton({Name = "Сбросить скин", Callback = function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum:RemoveAccessories() local s, d = pcall(function() return game.Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId) end) if s and d then hum:ApplyDescription(d) end end
end})

local CameraTab = Window:CreateTab("Camera", 4483362458)
CameraTab:CreateToggle({Name = "Вид от 3-го лица", CurrentValue = false, Callback = function(v) ThirdPerson_Enabled = v if v then ApplyThirdPerson() else LocalPlayer.CameraMinZoomDistance = 0.5 end end})
CameraTab:CreateToggle({Name = "Авто-вкл 3 лица после смерти", CurrentValue = false, Callback = function(v) AutoThirdPerson_Enabled = v if v then ApplyThirdPerson() end end})

-- === ОСНОВНОЙ ЦИКЛ ОБРАБОТКИ ===

UserInputService.JumpRequest:Connect(function()
    if InfJump_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
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

local function getClosestPlayer()
    local closest, maxDist = nil, FOV_Radius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local isTeam = Aimbot_TeamCheck and ((p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team) or (p.TeamColor == LocalPlayer.TeamColor))
            if not isTeam and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local head = p.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    if dist <= maxDist and isVisible(head) then maxDist = dist; closest = head end
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

    if FOV_Changer_Enabled then Camera.FieldOfView = Custom_FOV end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        hum.WalkSpeed = Speed_Enabled and Cheat_Speed or Original_Speed
        if hum.UseJumpPower then hum.JumpPower = Jump_Enabled and Cheat_Jump or Original_Jump else hum.JumpHeight = Jump_Enabled and (Cheat_Jump / 3) or Original_Jump end
    end

    if Noclip_Enabled and LocalPlayer.Character then 
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end 
    end
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if AntiAim_Mode == "Spinbot" then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(AntiAim_Speed), 0)
        elseif AntiAim_Mode == "Jitter (Дерганый)" then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(math.random(-AntiAim_Speed, AntiAim_Speed)), 0)
        end
    end
    
    if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hrp = LocalPlayer.Character.HumanoidRootPart 
        local hum = LocalPlayer.Character.Humanoid 
        hrp.Velocity = Vector3.new(0, 0.1, 0)
        if hum.MoveDirection.Magnitude > 0 then hrp.Velocity = hum.MoveDirection * FlySpeed end
    end

    if Aimbot_Enabled then
        local targetHead = getClosestPlayer()
        if targetHead then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetHead.Position), 1 / Aimbot_Smooth) end
    end

    if AutoParry_Enabled then
        local balls = workspace:FindFirstChild("Balls") or workspace:FindFirstChild("BallFolder")
        if balls then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            for _, ball in pairs(balls:GetChildren()) do
                if ball:IsA("BasePart") and ball:GetAttribute("Target") == LocalPlayer.Name then
                    local distance = hrp and (ball.Position - hrp.Position).Magnitude or 999
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

    -- Отрисовка ESP, Скелетов, Здоровья и Индикаторов
    for player, obj in pairs(espObjects) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            local rootPart = character.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

            local displayColor = Color3.fromRGB(255, 255, 255)
            local mm2Role = nil
            if MM2_Revealer then
                local bp = player:FindFirstChild("Backpack")
                if (bp and bp:FindFirstChild("Knife")) or character:FindFirstChild("Knife") then mm2Role = "Murder"
                elseif (bp and bp:FindFirstChild("Gun")) or character:FindFirstChild("Gun") then mm2Role = "Sheriff" end
            end

            if Tracer_Color_Mode == "Team" and player.Team then displayColor = player.TeamColor.Color
            elseif Tracer_Color_Mode == "Red" then displayColor = Color3.fromRGB(255, 50, 50)
            elseif Tracer_Color_Mode == "Green" then displayColor = Color3.fromRGB(50, 255, 50)
            elseif Tracer_Color_Mode == "Blue" then displayColor = Color3.fromRGB(50, 50, 255)
            elseif Tracer_Color_Mode == "Rainbow" or Aura_RGB then displayColor = currentRgbColor end

            -- 1. Визуальная Аура (Glow)
            if VisualAura_Enabled then
                local glow = character:FindFirstChild("PulsarAuraGlow") or Instance.new("Highlight", character)
                glow.Name = "PulsarAuraGlow"
                glow.FillTransparency = 0.7; glow.OutlineTransparency = 0.1
                glow.FillColor = Aura_RGB and currentRgbColor or Aura_Color
                glow.OutlineColor = Aura_RGB and currentRgbColor or Aura_Color
            elseif character:FindFirstChild("PulsarAuraGlow") then
                character.PulsarAuraGlow:Destroy()
            end

            -- 2. Индикатор вне экрана (Out-of-View Arrows)
            if OutOfView_Enabled and not onScreen then
                local camCF = Camera.CFrame
                local relPos = camCF:PointToObjectSpace(rootPart.Position)
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local angle = math.atan2(relPos.Z, relPos.X)
                local radius = 150
                local arrowPos = screenCenter + Vector2.new(math.cos(angle), math.sin(angle)) * radius
                
                obj.OIVArrow.Visible = true
                obj.OIVArrow.Color = displayColor
                obj.OIVArrow.PointA = arrowPos + Vector2.new(math.cos(angle), math.sin(angle)) * 10
                obj.OIVArrow.PointB = arrowPos + Vector2.new(math.cos(angle + 2.5), math.sin(angle + 2.5)) * 6
                obj.OIVArrow.PointC = arrowPos + Vector2.new(math.cos(angle - 2.5), math.sin(angle - 2.5)) * 6
            else
                obj.OIVArrow.Visible = false
            end

            if onScreen then
                local dist = (Camera.CFrame.Position - rootPart.Position).Magnitude
                local scale = 1000 / dist

                -- 3. Skeleton ESP (Скелет)
                if Skeleton_Enabled and character:FindFirstChild("Head") and character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") then
                    local getPartPos = function(name)
                        local p = character:FindFirstChild(name)
                        if p then local v, s = Camera:WorldToViewportPoint(p.Position) if s then return Vector2.new(v.X, v.Y) end end
                        return nil
                    end
                    local head = getPartPos("Head")
                    local neck = getPartPos("UpperTorso") or getPartPos("Torso")
                    local lShoulder = getPartPos("LeftUpperArm")
                    local rShoulder = getPartPos("RightUpperArm")
                    local lHand = getPartPos("LeftLowerArm")
                    local rHand = getPartPos("RightLowerArm")
                    local lLeg = getPartPos("LeftUpperLeg")
                    local rLeg = getPartPos("RightUpperLeg")
                    local lFoot = getPartPos("LeftLowerLeg")
                    local rFoot = getPartPos("RightLowerLeg")

                    local connections = {{head, neck}, {neck, lShoulder}, {neck, rShoulder}, {lShoulder, lHand}, {rShoulder, rHand}, {neck, lLeg}, {neck, rLeg}, {lLeg, lFoot}, {rLeg, rFoot}}
                    for i, conn in ipairs(connections) do
                        if conn[1] and conn[2] and obj.Bones[i] then
                            obj.Bones[i].Visible = true
                            obj.Bones[i].From = conn[1]
                            obj.Bones[i].To = conn[2]
                            obj.Bones[i].Color = displayColor
                        else
                            if obj.Bones[i] then obj.Bones[i].Visible = false end
                        end
                    end
                else
                    for _, b in pairs(obj.Bones) do b.Visible = false end
                end

                -- 4. Head Dot (Точка на голове)
                if HeadDot_Enabled and character:FindFirstChild("Head") then
                    local hp, hOn = Camera:WorldToViewportPoint(character.Head.Position)
                    if hOn then
                        obj.HeadDot.Visible = true
                        obj.HeadDot.Position = Vector2.new(hp.X, hp.Y)
                        obj.HeadDot.Color = displayColor
                    else
                        obj.HeadDot.Visible = false
                    end
                else
                    obj.HeadDot.Visible = false
                end

                -- Основной Box ESP
                obj.Box.Color = displayColor
                obj.Box.Size = Vector2.new(scale * 1.5, scale * 2.5)
                obj.Box.Position = Vector2.new(vector.X - obj.Box.Size.X / 2, vector.Y - obj.Box.Size.Y / 2)
                obj.Box.Visible = ESP_Enabled

                -- 5. Health Bar (Полоска здоровья)
                if HealthBar_Enabled and character.Humanoid then
                    local hpPct = math.clamp(character.Humanoid.Health / character.Humanoid.MaxHealth, 0, 1)
                    local boxPos = obj.Box.Position
                    local boxSize = obj.Box.Size
                    obj.HealthBarBG.Visible = ESP_Enabled
                    obj.HealthBarBG.From = Vector2.new(boxPos.X - 6, boxPos.Y + boxSize.Y)
                    obj.HealthBarBG.To = Vector2.new(boxPos.X - 6, boxPos.Y)
                    obj.HealthBarBG.Color = Color3.fromRGB(50, 50, 50)

                    obj.HealthBar.Visible = ESP_Enabled
                    obj.HealthBar.From = Vector2.new(boxPos.X - 6, boxPos.Y + boxSize.Y)
                    obj.HealthBar.To = Vector2.new(boxPos.X - 6, boxPos.Y + (boxSize.Y * (1 - hpPct)))
                    obj.HealthBar.Color = Color3.fromRGB(0, 255, 0)
                else
                    obj.HealthBarBG.Visible = false
                    obj.HealthBar.Visible = false
                end

                -- Текст (Ник, роль, дистанция)
                local textBuffer = ""
                if Show_Names then textBuffer = textBuffer .. player.Name end
                if mm2Role then textBuffer = textBuffer .. " [" .. mm2Role .. "]" end
                if Show_Dist then textBuffer = textBuffer .. " [" .. math.floor(dist) .. "m]" end
                
                obj.Text.Text = textBuffer
                obj.Text.Position = Vector2.new(vector.X, vector.Y - (obj.Box.Size.Y / 2) - 20)
                obj.Text.Color = displayColor
                obj.Text.Visible = ESP_Enabled and (Show_Names or Show_Dist or MM2_Revealer)
            else
                obj.Box.Visible = false
                obj.Tracer.Visible = false
                obj.Text.Visible = false
                obj.HealthBarBG.Visible = false
                obj.HealthBar.Visible = false
                obj.HeadDot.Visible = false
                for _, b in pairs(obj.Bones) do b.Visible = false end
            end
        else
            obj.Box.Visible = false
            obj.Tracer.Visible = false
            obj.Text.Visible = false
            obj.HealthBarBG.Visible = false
            obj.HealthBar.Visible = false
            obj.HeadDot.Visible = false
            obj.OIVArrow.Visible = false
            for _, b in pairs(obj.Bones) do b.Visible = false end
        end
    end
end)

Rayfield:Notify({
    Title = "Pulsar Hub: Pro Visuals",
    Content = "Внедрены Skeleton ESP, Health Bar, Head Dot и Out-of-View индикаторы!",
    Duration = 6.5,
    Image = 4483362458,
})
