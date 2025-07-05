local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local VirtualInput = game:GetService("VirtualInputManager")

-- Core Variables
local walkspeed = 20
local TriggerBotEnabled = false
local CameraAimbot = false
local KillConfirmed = false
local AimPart = "UpperTorso"
local flying = false

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "fakemrleo_v1"
gui.Enabled = true

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Text = "fakemrleo v1 Script"

-- Side Panel
local buttonSide = Instance.new("Frame", mainFrame)
buttonSide.Size = UDim2.new(0, 150, 0, 260)
buttonSide.Position = UDim2.new(0, 0, 0, 40)
buttonSide.BackgroundColor3 = Color3.fromRGB(90, 0, 0)

local layout = Instance.new("UIListLayout", buttonSide)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Center Panel
local centerPanel = Instance.new("Frame", mainFrame)
centerPanel.Size = UDim2.new(0, 330, 0, 260)
centerPanel.Position = UDim2.new(0, 160, 0, 40)
centerPanel.BackgroundColor3 = Color3.fromRGB(100, 0, 0)

-- Kill Confirm Label
local killLabel = Instance.new("TextLabel", centerPanel)
killLabel.Size = UDim2.new(1, 0, 0, 25)
killLabel.Position = UDim2.new(0, 0, 0, 0)
killLabel.Text = "Kill Confirm: None"
killLabel.BackgroundTransparency = 1
killLabel.TextColor3 = Color3.new(1, 1, 1)
killLabel.Font = Enum.Font.GothamBold
killLabel.TextSize = 16

-- Aimbot Label
local aimbotLabel = Instance.new("TextLabel", centerPanel)
aimbotLabel.Size = UDim2.new(1, 0, 0, 25)
aimbotLabel.Position = UDim2.new(0, 0, 0, 25)
aimbotLabel.Text = "Aimbot: OFF"
aimbotLabel.BackgroundTransparency = 1
aimbotLabel.TextColor3 = Color3.new(1, 1, 1)
aimbotLabel.Font = Enum.Font.Gotham
aimbotLabel.TextSize = 16

-- TriggerBot Label
local triggerLabel = Instance.new("TextLabel", centerPanel)
triggerLabel.Size = UDim2.new(1, 0, 0, 25)
triggerLabel.Position = UDim2.new(0, 0, 0, 50)
triggerLabel.Text = "TriggerBot: OFF"
triggerLabel.BackgroundTransparency = 1
triggerLabel.TextColor3 = Color3.new(1, 1, 1)
triggerLabel.Font = Enum.Font.Gotham
triggerLabel.TextSize = 16

-- Button Creator
local function createButton(text, callback)
    local btn = Instance.new("TextButton", buttonSide)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = text
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

-- Walkspeed Buttons
createButton("Increase Walkspeed", function()
    walkspeed = walkspeed + 5
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = walkspeed
        end
    end
end)

createButton("Decrease Walkspeed", function()
    walkspeed = math.max(5, walkspeed - 5)
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = walkspeed
        end
    end
end)

-- Fly toggle
local flyConnectionBegan
local flyConnectionEnded

createButton("Fly (Hold F)", function()
    if flyConnectionBegan or flyConnectionEnded then return end -- Prevent duplicate connections

    flying = false

    flyConnectionBegan = UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F then
            flying = true
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("UpperTorso")
            while flying and hrp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") do
                LocalPlayer.Character.Humanoid.Sit = true
                hrp.Velocity = Camera.CFrame.LookVector * 60 + Vector3.new(0, 10, 0)
                task.wait()
            end
        end
    end)

    flyConnectionEnded = UIS.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F then
            flying = false
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Sit = false
                end
            end
        end
    end)
end)

-- Highlight Players
createButton("Highlight Players", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChildOfClass("Highlight") then
            local hl = Instance.new("Highlight", p.Character)
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.OutlineColor = Color3.new(1, 1, 1)
            hl.FillTransparency = 0.25
            hl.OutlineTransparency = 0
        end
    end
end)

-- Aimbot Toggle Button
createButton("Toggle Aimbot", function(btn)
    CameraAimbot = not CameraAimbot
    aimbotLabel.Text = "Aimbot: " .. (CameraAimbot and "ON" or "OFF")
end)

-- TriggerBot Toggle Button
createButton("Toggle TriggerBot", function(btn)
    TriggerBotEnabled = not TriggerBotEnabled
    triggerLabel.Text = "TriggerBot: " .. (TriggerBotEnabled and "ON" or "OFF")
end)

-- TriggerBot + Kill Confirm logic
local function onPlayerDied(player)
    if KillConfirmed then return end
    KillConfirmed = true
    killLabel.Text = "Kill Confirm: " .. player.Name
    task.delay(2.5, function()
        KillConfirmed = false
        killLabel.Text = "Kill Confirm: None"
    end)
end

-- TriggerBot Logic
RunService.RenderStepped:Connect(function()
    if TriggerBotEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(AimPart) then
                local part = p.Character[AimPart]
                local mousePos = UIS:GetMouseLocation()
                local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude

                if onScreen and distance < 50 then
                    -- Fire mouse click down and up events at that position
                    VirtualInput:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 0)
                    VirtualInput:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 0)

                    -- Check if humanoid is dead
                    local humanoid = p.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health <= 0 then
                        onPlayerDied(p)
                    end
                end
            end
        end
    end
end)

-- Aimbot Loop Helper
local function GetClosestPlayer()
    local closest, dist = nil, math.huge
    local mousePos = UIS:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(AimPart) then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character[AimPart].Position)
            if onScreen then
                local d = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if d < dist then
                    dist = d
                    closest = p
                end
            end
        end
    end
    return closest
end

-- Aimbot Logic
RunService.RenderStepped:Connect(function()
    if CameraAimbot then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(AimPart) then
            local part = target.Character[AimPart]
            local dir = (part.Position - Camera.CFrame.Position).Unit

            -- Rotate camera towards target smoothly
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + dir)

            -- Optionally rotate character's HumanoidRootPart to face target's XZ position
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(part.Position.X, hrp.Position.Y, part.Position.Z))
            end
        end
    end
end)

-- RightShift to Toggle UI
UIS.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.RightShift and not gpe then
        gui.Enabled = not gui.Enabled
    end
end)
