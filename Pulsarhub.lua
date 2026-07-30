-- c00lkidd214anzz Hub | Visuals Edition
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Выбери язык при запуске: "EN" (English) или "RU" (Русский)
local CurrentLang = "RU" 

local function L(enText, ruText)
    if CurrentLang == "RU" then
        return ruText
    else
        return enText
    end
end

local Window = Rayfield:CreateWindow({
    Name = L("Pulsar Hub | by c00lkidd214anzz", "Pulsar Hub | by c00lkidd214anzz"),
    LoadingTitle = L("Loading script...", "Загрузка скрипта..."),
    LoadingSubtitle = "by c00lkidd214anzz",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PulsarHubConfig",
        FileName = "VisualsConfig"
    },
    KeySystem = false,
})

-- Переменные состояний
local ESP_Enabled = false
local Show_Names = true   
local Show_Dist = true    
local Show_Weapon = true  
local Chams_Enabled = false
local RGB_Chams = true

local CornerBox_Enabled = true   
local Skeleton_Enabled = true
local HealthBar_Enabled = true
local HeadDot_Enabled = true
local GazeLine_Enabled = true    
local OutOfView_Enabled = true

local InfJump_Enabled = false
local BHop_Enabled = false -- Банихоп
local Aimbot_Enabled = false
local Aimbot_Mode = "Плавный (Smooth)" -- Режим аимбота
local Aimbot_TargetPart = "Head" -- Цель (Голова / Туловище)
local Aimbot_Smooth = 5
local Aimbot_TeamCheck = true
local Aimbot_WallCheck = true
local FOV_Enabled = true
local FOV_Radius = 150

local AutoParry_Enabled = false
local MM2_Revealer = true

-- Функции
local ThirdPerson_Enabled = false
local AntiAim_Mode = "Выключено"
local JumpCircle_Enabled = false
local WalkTrail_Enabled = false

local FOV_Changer_Enabled = false
local Custom_FOV = 70

local Tracer_Color_Mode = "Team"
local Cheat_Speed = 50
local Cheat_Jump = 120

local Original_Speed = 16
local Original_Jump = 50
local Original_FOV = Camera.FieldOfView

local function ApplyThirdPerson()
    if ThirdPerson_Enabled then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMinZoomDistance = 10
        LocalPlayer.CameraMaxZoomDistance = 400
    else
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 15.5
    end
end

local function OnCharacterAdded(character)
    local hum = character:WaitForChild("Humanoid", 5)
    if hum then
        Original_Speed = hum.WalkSpeed
        Original_Jump = hum.UseJumpPower and hum.JumpPower or hum.JumpHeight
        
        if ThirdPerson_Enabled then
            task.delay(0.3, function()
                ApplyThirdPerson()
            end)
        end

        hum.StateChanged:Connect(function(oldState, newState)
            if JumpCircle_Enabled and newState == Enum.HumanoidStateType.Jumping then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local part = Instance.new("Part")
                    part.Shape = Enum.PartType.Cylinder
                    part.Size = Vector3.new(0.2, 5, 5)
                    part.CFrame = rootPart.CFrame * CFrame.Angles(0, 0, math.rad(90)) - Vector3.new(0, 2.5, 0)
                    part.Anchored = true
                    part.CanCollide = false
                    part.Material = Enum.Material.Neon
                    part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    part.Parent = workspace

                    task.spawn(function()
                        for i = 1, 20 do
                            part.Size = part.Size + Vector3.new(0, 0.4, 0.4)
                            part.Transparency = i / 20
                            task.wait(0.03)
                        end
                        part:Destroy()
                    end)
                end
            end
        end)
    end
end

if LocalPlayer.Character then OnCharacterAdded(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)

local Speed_Enabled = false
local Jump_Enabled = false
local espObjects = {}
local currentRgbColor = Color3.new(1,1,1)

local trailSegments = {}
local lastTrailPos = Vector3.new(0,0,0)

local function updateWalkTrail()
    if not WalkTrail_Enabled or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, p in pairs(trailSegments) do p:Destroy() end
        trailSegments = {}
        return
    end

    local hrp = LocalPlayer.Character.HumanoidRootPart
    local currentPos = hrp.Position - Vector3.new(0, 2.5, 0)

    if lastTrailPos == Vector3.new(0,0,0) then
        lastTrailPos = currentPos
    end

    if (currentPos - lastTrailPos).Magnitude > 1.2 then
        local distance = (currentPos - lastTrailPos).Magnitude
        local part = Instance.new("Part")
        part.Size = Vector3.new(0.4, 0.4, distance)
        part.Anchored = true
        part.CanCollide = false
        part.Material = Enum.Material.Neon
        part.Color = currentRgbColor
        part.CFrame = CFrame.new(lastTrailPos, currentPos) * CFrame.new(0, 0, -distance / 2)
        part.Parent = workspace

        lastTrailPos = currentPos
        table.insert(trailSegments, part)

        if #trailSegments > 50 then
            local oldPart = table.remove(trailSegments, 1)
            if oldPart then oldPart:Destroy() end
        end
    end
end

local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Visible = false
FOV_Circle.Filled = false
FOV_Circle.Thickness = 1.5
FOV_Circle.Color = Color3.fromRGB(255, 255, 255)
FOV_Circle.NumSides = 64

local function setupESPForPlayer(p)
    if p == LocalPlayer then return end
    if not espObjects[p] then
        local box = Drawing.new("Square")
        box.Visible = false; box.Filled = false; box.Thickness = 1.5

        local corners = {}
        for i = 1, 16 do
            local l = Drawing.new("Line")
            l.Visible = false; l.Thickness = 1.5
            table.insert(corners, l)
        end

        local tracer = Drawing.new("Line")
        tracer.Visible = false; tracer.Thickness = 1.5

        local text = Drawing.new("Text")
        text.Visible = false; text.Size = 13; text.Center = true; text.Outline = true

        local healthBarBG = Drawing.new("Line")
        healthBarBG.Visible = false; healthBarBG.Thickness = 2
        local healthBar = Drawing.new("Line")
        healthBar.Visible = false; healthBar.Thickness = 2

        local headDot = Drawing.new("Circle")
        headDot.Visible = false; headDot.Filled = true; headDot.Radius = 3

        local gazeLine = Drawing.new("Line")
        gazeLine.Visible = false; gazeLine.Thickness = 1

        local oivArrow = Drawing.new("Triangle")
        oivArrow.Visible = false; oivArrow.Filled = true; oivArrow.Thickness = 1

        local bones = {}
        local boneNames = {"Head_Neck", "Neck_Chest", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg"}
        for _, _ in pairs(boneNames) do
            local line = Drawing.new("Line")
            line.Visible = false; line.Thickness = 1.5
            table.insert(bones, line)
        end

        espObjects[p] = {
            Box = box, Corners = corners, Tracer = tracer, Text = text, 
            HealthBarBG = healthBarBG, HealthBar = healthBar, 
            HeadDot = headDot, GazeLine = gazeLine, OIVArrow = oivArrow, Bones = bones
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
            espObjects[p].Tracer:Remove()
            espObjects[p].Text:Remove()
            espObjects[p].HealthBarBG:Remove()
            espObjects[p].HealthBar:Remove()
            espObjects[p].HeadDot:Remove()
            espObjects[p].GazeLine:Remove()
            espObjects[p].OIVArrow:Remove()
            for _, bone in pairs(espObjects[p].Bones) do bone:Remove() end
        end)
        espObjects[p] = nil
    end
end)

-- ==================== ВКЛАДКИ ИНТЕРФЕЙСА ====================
local AimTab = Window:CreateTab(L("Aimbot", "Аимбот"), 4483362458)
AimTab:CreateToggle({Name = L("Enable Aimbot", "Включить Аимбот"), CurrentValue = false, Callback = function(v) Aimbot_Enabled = v end})
AimTab:CreateDropdown({
    Name = L("Aimbot Mode", "Режим Аимбота"),
    Options = {"Плавный (Smooth / Legit)", "Рейдж (Rage / Snap Lock)"},
    CurrentOption = "Плавный (Smooth / Legit)",
    Callback = function(Opt) Aimbot_Mode = Opt[1] end
})
AimTab:CreateDropdown({
    Name = L("Target Part", "Цель на теле"),
    Options = {"Head", "HumanoidRootPart (Туловище)"},
    CurrentOption = "Head",
    Callback = function(Opt) 
        if string.find(Opt[1], "Head") then Aimbot_TargetPart = "Head" 
        else Aimbot_TargetPart = "HumanoidRootPart" end 
    end
})
AimTab:CreateSlider({Name = L("Aimbot Smoothness", "Плавность (для Smooth режима)"), Range = {1, 20}, Increment = 1, CurrentValue = 5, Flag = "Smooth", Callback = function(v) Aimbot_Smooth = v end})
AimTab:CreateToggle({Name = L("Team Check", "Team Check (Свои)"), CurrentValue = true, Callback = function(v) Aimbot_TeamCheck = v end})
AimTab:CreateToggle({Name = L("Wall Check", "Wall Check (Сквозь стены)"), CurrentValue = true, Callback = function(v) Aimbot_WallCheck = v end})
AimTab:CreateToggle({Name = L("Show FOV Circle", "Показывать круг FOV"), CurrentValue = true, Callback = function(v) FOV_Enabled = v end})
AimTab:CreateSlider({Name = L("FOV Radius", "Радиус FOV"), Range = {50, 500}, Increment = 5, CurrentValue = 150, Flag = "FOV", Callback = function(v) FOV_Radius = v end})

local TeleportTab = Window:CreateTab(L("Teleports", "Телепорты"), 4483362458)
local selectedPlayerToTP = nil
local playerDropdownOptions = {}
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(playerDropdownOptions, p.Name) end end
TeleportTab:CreateDropdown({Name = L("Select Player", "Выбрать игрока"), Options = playerDropdownOptions, CurrentOption = "", Callback = function(Opt) selectedPlayerToTP = Opt[1] end})
TeleportTab:CreateButton({Name = L("Teleport to Player", "Телепортироваться к игроку"), Callback = function()
    if selectedPlayerToTP then
        local tp = Players:FindFirstChild(selectedPlayerToTP)
        if tp and tp.Character and tp.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = tp.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end})

local BBTab = Window:CreateTab("Blade Ball", 4483362458)
BBTab:CreateToggle({Name = L("Auto Parry", "Авто-Блок (Auto Parry)"), CurrentValue = false, Callback = function(v) AutoParry_Enabled = v end})

local MM2Tab = Window:CreateTab("Murder Mystery 2", 4483362458)
MM2Tab:CreateToggle({Name = L("MM2 Roles (Revealer)", "MM2 Роли (Revealer)"), CurrentValue = true, Callback = function(v) MM2_Revealer = v end})

-- ==================== ВКЛАДКА ВИЗУАЛОВ ====================
local VisTab = Window:CreateTab(L("Visuals", "Визуалы"), 4483362458)
VisTab:CreateToggle({Name = L("Enable ESP Master", "Включить ESP Master"), CurrentValue = false, Callback = function(v) 
    ESP_Enabled = v 
    if not v then for _, o in pairs(espObjects) do pcall(function() o.Box.Visible = false; for _,c in pairs(o.Corners) do c.Visible = false end; o.Tracer.Visible = false; o.Text.Visible = false end) end end
end})

VisTab:CreateToggle({Name = L("Corner Box", "Corner Box (Стильные уголки)"), CurrentValue = true, Callback = function(v) CornerBox_Enabled = v end})
VisTab:CreateToggle({Name = L("Skeleton ESP", "Skeleton ESP (Скелет)"), CurrentValue = true, Callback = function(v) Skeleton_Enabled = v end})
VisTab:CreateToggle({Name = L("Health Bar", "Health Bar (Полоска HP)"), CurrentValue = true, Callback = function(v) HealthBar_Enabled = v end})
VisTab:CreateToggle({Name = L("Head Dot", "Head Dot (Точка на голове)"), CurrentValue = true, Callback = function(v) HeadDot_Enabled = v end})
VisTab:CreateToggle({Name = L("Gaze Line", "Gaze Line (Направление взгляда)"), CurrentValue = true, Callback = function(v) GazeLine_Enabled = v end})
VisTab:CreateToggle({Name = L("Out-of-View Arrows", "Out-of-View (Стрелки за экраном)"), CurrentValue = true, Callback = function(v) OutOfView_Enabled = v end})

VisTab:CreateToggle({Name = L("Neon Chams", "Neon Chams (Неоновая подсветка тел)"), CurrentValue = false, Callback = function(v) 
    Chams_Enabled = v 
    if not v then for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("CustomNeonChams") then p.Character.CustomNeonChams:Destroy() end end end
end})
VisTab:CreateToggle({Name = L("RGB Rainbow Colors", "RGB Радужные цвета"), CurrentValue = true, Callback = function(v) RGB_Chams = v end})

VisTab:CreateToggle({Name = L("Neon Jump Circle", "Неоновый круг при прыжке"), CurrentValue = false, Callback = function(v) JumpCircle_Enabled = v end})
VisTab:CreateToggle({Name = L("Neon Walk Trail", "Неоновый след траектории"), CurrentValue = false, Callback = function(v) 
    WalkTrail_Enabled = v 
    if not v then for _, p in pairs(trailSegments) do p:Destroy() end; trailSegments = {} end 
end})

VisTab:CreateToggle({Name = L("Show Names", "Показывать Никнеймы"), CurrentValue = true, Callback = function(v) Show_Names = v end})
VisTab:CreateToggle({Name = "Show Distance", "Показывать Дистанцию", CurrentValue = true, Callback = function(v) Show_Dist = v end})
VisTab:CreateToggle({Name = L("Show Weapons", "Показывать Оружие в руках"), CurrentValue = true, Callback = function(v) Show_Weapon = v end})
VisTab:CreateDropdown({Name = L("Visual Color", "Цвет визуала"), Options = {"Rainbow", "Team", "Red", "Green", "Blue"}, CurrentOption = "Rainbow", Callback = function(Opt) Tracer_Color_Mode = Opt[1] end})

-- ==================== ВКЛАДКА ИГРОКА ====================
local PlayerTab = Window:CreateTab(L("Main / Player", "Игрок / Главное"), 4483362458)
PlayerTab:CreateToggle({Name = L("Infinite Jump", "Бесконечный Прыжок"), CurrentValue = false, Callback = function(v) InfJump_Enabled = v end})
PlayerTab:CreateToggle({Name = L("Auto Bunny Hop (BHop)", "Авто-Прыжок (BHop)"), CurrentValue = false, Callback = function(v) BHop_Enabled = v end})
PlayerTab:CreateToggle({Name = L("Speed Hack", "Быстрый бег (Speed)"), CurrentValue = false, Callback = function(v) Speed_Enabled = v end})
PlayerTab:CreateToggle({Name = L("High Jump", "Высокий прыжок (Jump)"), CurrentValue = false, Callback = function(v) Jump_Enabled = v end})
PlayerTab:CreateToggle({Name = L("Third Person", "Вид от 3-го лица (Third Person)"), CurrentValue = false, Callback = function(v) 
    ThirdPerson_Enabled = v 
    ApplyThirdPerson()
end})
PlayerTab:CreateDropdown({Name = L("Anti-Aim Mode", "Режим Анти-Аим"), Options = {"Выключено / Off", "Spinbot", "Jitter"}, CurrentOption = "Выключено / Off", Callback = function(Opt) AntiAim_Mode = Opt[1] end})

PlayerTab:CreateToggle({Name = L("Enable FOV Changer", "Включить FOV Changer"), CurrentValue = false, Callback = function(v) FOV_Changer_Enabled = v if not v then Camera.FieldOfView = Original_FOV end end})
PlayerTab:CreateSlider({Name = L("Camera FOV", "Угол обзора камеры (FOV)"), Range = {50, 120}, Increment = 1, CurrentValue = 70, Flag = "CamFOV", Callback = function(v) Custom_FOV = v end})

-- ==================== ВКЛАДКА НАСТРОЕК ====================
local SettingsTab = Window:CreateTab(L("Settings", "Настройки"), 4483362458)
SettingsTab:CreateParagraph({Title = L("Language Info", "Информация о языке"), Content = L("To change language, please restart script and change 'CurrentLang' at the top of code ('RU' or 'EN').", "Чтобы сменить язык, перезапустите скрипт, изменив переменную 'CurrentLang' в самом начале кода на 'RU' or 'EN'.")})

-- === ОСНОВНОЙ ЦИКЛ ОБРАБОТКИ ===

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

local function getClosestPlayer()
    local closest, maxDist = nil, FOV_Radius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local isTeam = Aimbot_TeamCheck and ((p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team) or (p.TeamColor == LocalPlayer.TeamColor))
            if not isTeam and p.Character and p.Character:FindFirstChild(Aimbot_TargetPart) and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local targetPart = p.Character[Aimbot_TargetPart]
                local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    if dist <= maxDist and isVisible(targetPart) then maxDist = dist; closest = targetPart end
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

    updateWalkTrail()

    if AntiAim_Mode ~= "Выключено" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if string.find(AntiAim_Mode, "Spinbot") then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(35), 0)
        elseif string.find(AntiAim_Mode, "Jitter") then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(math.random(-90, 90)), 0)
        end
    end

    if Aimbot_Enabled then
        local targetPart = getClosestPlayer()
        if targetPart then
            if string.find(Aimbot_Mode, "Плавный") then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPart.Position), 1 / Aimbot_Smooth)
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            end
        end
    end

    for player, obj in pairs(espObjects) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            local rootPart = character.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

            local displayColor = currentRgbColor
            if Tracer_Color_Mode == "Team" and player.Team then displayColor = player.TeamColor.Color
            elseif Tracer_Color_Mode == "Red" then displayColor = Color3.fromRGB(255, 50, 50)
            elseif Tracer_Color_Mode == "Green" then displayColor = Color3.fromRGB(50, 255, 50)
            elseif Tracer_Color_Mode == "Blue" then displayColor = Color3.fromRGB(50, 50, 255) end

            if Chams_Enabled then
                local chams = character:FindFirstChild("CustomNeonChams") or Instance.new("Highlight", character)
                chams.Name = "CustomNeonChams"
                chams.FillTransparency = 0.5; chams.OutlineTransparency = 0.1
                chams.FillColor = RGB_Chams and currentRgbColor or displayColor
                chams.OutlineColor = Color3.new(1, 1, 1)
            elseif character:FindFirstChild("CustomNeonChams") then
                character.CustomNeonChams:Destroy()
            end

            if OutOfView_Enabled and not onScreen then
                local camCF = Camera.CFrame
                local relPos = camCF:PointToObjectSpace(rootPart.Position)
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local angle = math.atan2(relPos.Z, relPos.X)
                local radius = 160
                local arrowPos = screenCenter + Vector2.new(math.cos(angle), math.sin(angle)) * radius
                
                obj.OIVArrow.Visible = true
                obj.OIVArrow.Color = displayColor
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

                if CornerBox_Enabled and ESP_Enabled then
                    obj.Box.Visible = false
                    local lW, lH = boxW / 4, boxH / 4
                    local c = obj.Corners
                    c[1].From = Vector2.new(boxX, boxY); c[1].To = Vector2.new(boxX + lW, boxY); c[1].Color = displayColor; c[1].Visible = true
                    c[2].From = Vector2.new(boxX, boxY); c[2].To = Vector2.new(boxX, boxY + lH); c[2].Color = displayColor; c[2].Visible = true
                    c[3].From = Vector2.new(boxX + boxW, boxY); c[3].To = Vector2.new(boxX + boxW - lW, boxY); c[3].Color = displayColor; c[3].Visible = true
                    c[4].From = Vector2.new(boxX + boxW, boxY); c[4].To = Vector2.new(boxX + boxW, boxY + lH); c[4].Color = displayColor; c[4].Visible = true
                    c[5].From = Vector2.new(boxX, boxY + boxH); c[5].To = Vector2.new(boxX + lW, boxY + boxH); c[5].Color = displayColor; c[5].Visible = true
                    c[6].From = Vector2.new(boxX, boxY + boxH); c[6].To = Vector2.new(boxX, boxY + boxH - lH); c[6].Color = displayColor; c[6].Visible = true
                    c[7].From = Vector2.new(boxX + boxW, boxY + boxH); c[7].To = Vector2.new(boxX + boxW - lW, boxY + boxH); c[7].Color = displayColor; c[7].Visible = true
                    c[8].From = Vector2.new(boxX + boxW, boxY + boxH); c[8].To = Vector2.new(boxX + boxW, boxY + boxH - lH); c[8].Color = displayColor; c[8].Visible = true
                    for i = 9, #c do c[i].Visible = false end
                else
                    for _, line in pairs(obj.Corners) do line.Visible = false end
                    obj.Box.Color = displayColor
                    obj.Box.Size = Vector2.new(boxW, boxH)
                    obj.Box.Position = Vector2.new(boxX, boxY)
                    obj.Box.Visible = ESP_Enabled
                end

                if Skeleton_Enabled and ESP_Enabled and (character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")) then
                    local getPartPos = function(name)
                        local pt = character:FindFirstChild(name)
                        if pt then local v, s = Camera:WorldToViewportPoint(pt.Position) if s then return Vector2.new(v.X, v.Y) end end
                        return nil
                    end
                    local head = getPartPos("Head")
                    local neck = getPartPos("UpperTorso") or getPartPos("Torso")
                    local lSh, rSh = getPartPos("LeftUpperArm"), getPartPos("RightUpperArm")
                    local lHnd, rHnd = getPartPos("LeftLowerArm"), getPartPos("RightLowerArm")
                    local lLeg, rLeg = getPartPos("LeftUpperLeg"), getPartPos("RightUpperLeg")
                    local lFoot, rFoot = getPartPos("LeftLowerLeg"), getPartPos("RightLowerLeg")

                    local conns = {{head, neck}, {neck, lSh}, {neck, rSh}, {lSh, lHnd}, {rSh, rHnd}, {neck, lLeg}, {neck, rLeg}, {lLeg, lFoot}, {rLeg, rFoot}}
                    for i, conn in ipairs(conns) do
                        if conn[1] and conn[2] and obj.Bones[i] then
                            obj.Bones[i].Visible = true; obj.Bones[i].From = conn[1]; obj.Bones[i].To = conn[2]; obj.Bones[i].Color = displayColor
                        elseif obj.Bones[i] then obj.Bones[i].Visible = false end
                    end
                else
                    for _, b in pairs(obj.Bones) do b.Visible = false end
                end

                if HeadDot_Enabled and ESP_Enabled and character:FindFirstChild("Head") then
                    local hp, hOn = Camera:WorldToViewportPoint(character.Head.Position)
                    if hOn then
                        obj.HeadDot.Visible = true; obj.HeadDot.Position = Vector2.new(hp.X, hp.Y); obj.HeadDot.Color = displayColor
                        
                        if GazeLine_Enabled then
                            local lookVector = character.Head.CFrame.LookVector
                            local lookTarget = character.Head.Position + (lookVector * 5)
                            local tpPos, tOn = Camera:WorldToViewportPoint(lookTarget)
                            if tOn then
                                obj.GazeLine.Visible = true; obj.GazeLine.From = Vector2.new(hp.X, hp.Y); obj.GazeLine.To = Vector2.new(tpPos.X, tpPos.Y); obj.GazeLine.Color = displayColor
                            else
                                obj.GazeLine.Visible = false
                            end
                        else
                            obj.GazeLine.Visible = false
                        end
                    else
                        obj.HeadDot.Visible = false; obj.GazeLine.Visible = false
                    end
                else
                    obj.HeadDot.Visible = false; obj.GazeLine.Visible = false
                end

                if HealthBar_Enabled and ESP_Enabled and character.Humanoid then
                    local hpPct = math.clamp(character.Humanoid.Health / character.Humanoid.MaxHealth, 0, 1)
                    obj.HealthBarBG.Visible = true
                    obj.HealthBarBG.From = Vector2.new(boxX - 6, boxY + boxH)
                    obj.HealthBarBG.To = Vector2.new(boxX - 6, boxY)
                    obj.HealthBarBG.Color = Color3.fromRGB(40, 40, 40)

                    obj.HealthBar.Visible = true
                    obj.HealthBar.From = Vector2.new(boxX - 6, boxY + boxH)
                    obj.HealthBar.To = Vector2.new(boxX - 6, boxY + (boxH * (1 - hpPct)))
                    obj.HealthBar.Color = Color3.fromRGB(0, 255, 100)
                else
                    obj.HealthBarBG.Visible = false; obj.HealthBar.Visible = false
                end

                local textBuffer = ""
                if Show_Names then textBuffer = textBuffer .. player.Name end
                
                if MM2_Revealer then
                    local bp = player:FindFirstChild("Backpack")
                    if (bp and bp:FindFirstChild("Knife")) or character:FindFirstChild("Knife") then textBuffer = textBuffer .. " [🔪 Murder]"
                    elseif (bp and bp:FindFirstChild("Gun")) or character:FindFirstChild("Gun") then textBuffer = textBuffer .. " [🔫 Sheriff]" end
                end

                if Show_Weapon then
                    local tool = character:FindFirstChildOfClass("Tool")
                    if tool then textBuffer = textBuffer .. " (" .. tool.Name .. ")" end
                end

                if Show_Dist then textBuffer = textBuffer .. " [" .. math.floor(dist)  .. "m]" end
                
                obj.Text.Text = textBuffer
                obj.Text.Position = Vector2.new(vector.X, boxY - 18)
                obj.Text.Color = displayColor
                obj.Text.Visible = ESP_Enabled
            else
                obj.Box.Visible = false
                for _, c in pairs(obj.Corners) do c.Visible = false end
                obj.Tracer.Visible = false
                obj.Text.Visible = false
                obj.HealthBarBG.Visible = false
                obj.HealthBar.Visible = false
                obj.HeadDot.Visible = false
                obj.GazeLine.Visible = false
                for _, b in pairs(obj.Bones) do b.Visible = false end
            end
        else
            obj.Box.Visible = false
            for _, c in pairs(obj.Corners) do c.Visible = false end
            obj.Tracer.Visible = false
            obj.Text.Visible = false
            obj.HealthBarBG.Visible = false
            obj.HealthBar.Visible = false
            obj.HeadDot.Visible = false
            obj.GazeLine.Visible = false
            obj.OIVArrow.Visible = false
            for _, b in pairs(obj.Bones) do b.Visible = false end
        end
    end
end)

Rayfield:Notify({
    Title = "Pulsar Hub | by c00lkidd214anzz",
    Content = "Скрипт успешно запущен / Script loaded!",
    Duration = 5,
    Image = 4483362458,
})
