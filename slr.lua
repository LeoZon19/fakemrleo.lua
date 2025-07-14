--// Simbot SXRIOT Full Build - SCRIPT
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lnfiniteb0rn/linoria/main/library.lua"))()
local Window = Library:CreateWindow("script", Vector2.new(520, 620), Enum.KeyCode.RightControl)

local MainTab = Window:AddTab("Main")
local AimbotTab = Window:AddTab("Aimbot")
local DupeTab = Window:AddTab("Dupe")

--// Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

--// Walkspeed Slider
local walkSpeed = 16
MainTab:AddSlider("Walkspeed", {
    min = 16;
    max = 100;
    default = 16;
    text = "Walkspeed";
    callback = function(val)
        walkSpeed = val
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = val end
    end;
})

LocalPlayer.CharacterAdded:Connect(function(char)
    repeat task.wait() until char:FindFirstChildOfClass("Humanoid")
    char:FindFirstChildOfClass("Humanoid").WalkSpeed = walkSpeed
end)

--// Infinite Stamina Toggle
local staminaLocked = false
MainTab:AddToggle("Infinite Stamina", {default = false}, function(state)
    staminaLocked = state
    local function maintainStamina()
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("NumberValue") and v.Name:lower():find("stamina") then
                v.Value = 100
                v:GetPropertyChangedSignal("Value"):Connect(function()
                    if staminaLocked then v.Value = 100 end
                end)
            end
        end
    end
    maintainStamina()
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        maintainStamina()
    end)
end)

--// Show Usernames Button
MainTab:AddButton("Show Usernames", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("UsernameTag") then
            local tag = Instance.new("BillboardGui", p.Character)
            tag.Name = "UsernameTag"
            tag.Size = UDim2.new(0, 200, 0, 50)
            tag.AlwaysOnTop = true
            tag.StudsOffset = Vector3.new(0, 3, 0)
            local label = Instance.new("TextLabel", tag)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = p.Name
            label.TextColor3 = Color3.new(1, 1, 1)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextSize = 14
        end
    end
end)

--// Aimbot Logic
local AimbotEnabled = false
local TriggerBotEnabled = false
local AimbotFOV = 100
local AimbotTargetPart = "Head"

local function getClosest()
    local closest, shortest = nil, AimbotFOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimbotTargetPart) then
            local part = player.Character[AimbotTargetPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - UIS:GetMouseLocation()).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = part
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = getClosest()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
    if TriggerBotEnabled then
        local target = getClosest()
        if target then
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Activate") then
                tool:Activate()
            end
        end
    end
end)

--// Aimbot Controls
AimbotTab:AddToggle("Enable Aimbot", {default = false}, function(state)
    AimbotEnabled = state
end)

AimbotTab:AddToggle("Enable Trigger Bot", {default = false}, function(state)
    TriggerBotEnabled = state
end)

AimbotTab:AddSlider("Aimbot FOV", {
    min = 50;
    max = 300;
    default = 100;
    text = "FOV Range";
    callback = function(val)
        AimbotFOV = val
    end;
})

AimbotTab:AddDropdown("Target Part", {"Head", "Torso", "UpperTorso"}, function(part)
    AimbotTargetPart = part
end)

AimbotTab:AddButton("Highlight Players", function()
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

--// Dupe System
DupeTab:AddButton("Dupe Backpack Items", function()
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            local clone = item:Clone()
            clone.Parent = bp
        end
        Library:Notify("Items duplicated!", 3)
    else
        Library:Notify("Backpack missing", 3)
    end
end)

--// Final Notification
Library:Notify("Loaded script UI with full utilities ⚙️", 3)