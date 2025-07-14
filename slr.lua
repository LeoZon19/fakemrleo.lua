-- // Load Linoria Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lnfiniteb0rn/linoria/main/library.lua"))()
local Window = Library:CreateWindow("fakemrleo SLR v1", Vector2.new(500, 600), Enum.KeyCode.RightControl)

-- // Tabs
local MainTab = Window:AddTab("Main")
local AimbotTab = Window:AddTab("Aimbot")
local DupeTab = Window:AddTab("Dupe")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- // Main Tab Functions
MainTab:AddSlider("Walkspeed", {
    min = 16;
    max = 100;
    default = 16;
    text = "Walkspeed";
    callback = function(value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end
    end;
})

MainTab:AddButton("Infinite Stamina", function()
    local function setStamina()
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("NumberValue") and v.Name:lower():find("stamina") then
                v.Value = 100
                v:GetPropertyChangedSignal("Value"):Connect(function()
                    v.Value = 100
                end)
            end
        end
    end
    setStamina()
    LocalPlayer.CharacterAdded:Connect(function()
        wait(1)
        setStamina()
    end)
end)

MainTab:AddButton("Fly (Hold F)", function()
    local flying = false
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F then
            flying = true
            while flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("UpperTorso") do
                LocalPlayer.Character.Humanoid.Sit = true
                LocalPlayer.Character.UpperTorso.Velocity = Camera.CFrame.LookVector * 60 + Vector3.new(0, 10, 0)
                task.wait()
            end
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F then
            flying = false
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Sit = false
            end
        end
    end)
end)

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

-- // Aimbot Tab Functions
local TriggerBot = false
local AimbotEnabled = false

AimbotTab:AddToggle("Enable Aimbot", {default = false}, function(state)
    AimbotEnabled = state
end)

AimbotTab:AddToggle("Trigger Bot", {default = false}, function(state)
    TriggerBot = state
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

-- // Dupe Tab Placeholder
DupeTab:AddLabel("Dupe system coming soon...")

-- // UI Ready
Library:Notify("Loaded fakemrleo SLR UI", 3)