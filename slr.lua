-- Rayfield Setup
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Window
local Window = Rayfield:CreateWindow({
    Name = "fakemrleo SLR UI",
    LoadingTitle = "South London Remastered",
    LoadingSubtitle = "by fakemrleo",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

local flying = false
MainTab:CreateToggle({
    Name = "Fly (Hold F)",
    CurrentValue = false,
    Callback = function(Value)
        flying = Value
        if flying then
            local UIS = game:GetService("UserInputService")
            local BP = Instance.new("BodyPosition")
            BP.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            BP.P = 10000
            BP.D = 1000
            BP.Position = LocalPlayer.Character.HumanoidRootPart.Position
            BP.Parent = LocalPlayer.Character.HumanoidRootPart

            local conn
            conn = UIS.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.F and flying then
                    BP.Position = BP.Position + Vector3.new(0, 50, 0)
                end
            end)

            while flying and BP.Parent do
                task.wait()
                BP.Position = LocalPlayer.Character.HumanoidRootPart.Position
            end

            conn:Disconnect()
            BP:Destroy()
        end
    end
})

MainTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Callback = function(Value)
        _G.InfiniteStamina = Value
        while _G.InfiniteStamina do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Stamina") then
                char.Stamina.Value = char.Stamina.MaxValue
            end
            task.wait(0.1)
        end
    end
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateToggle({
    Name = "Big Head (Enemy Only)",
    CurrentValue = false,
    Callback = function(Value)
        _G.BigHead = Value
        while _G.BigHead do
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local head = player.Character.Head
                    if head and head.Size ~= Vector3.new(5, 5, 5) then
                        head.Size = Vector3.new(5, 5, 5)
                        head.CanCollide = false
                        if not head:FindFirstChild("Mesh") then
                            local mesh = Instance.new("SpecialMesh", head)
                            mesh.MeshType = Enum.MeshType.Head
                            mesh.Scale = Vector3.new(1.25, 1.25, 1.25)
                        end
                    end
                end
            end
            task.wait(1)
        end
        -- Reset head size
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                head.Size = Vector3.new(2, 1, 1)
                if head:FindFirstChild("Mesh") then
                    head.Mesh:Destroy()
                end
            end
        end
    end
})

CombatTab:CreateToggle({
    Name = "Trigger Bot",
    CurrentValue = false,
    Callback = function(Value)
        _G.TriggerBot = Value
        while _G.TriggerBot do
            local target = Mouse.Target
            if target and target.Parent and Players:GetPlayerFromCharacter(target.Parent) then
                mouse1press()
                wait(0.1)
                mouse1release()
            end
            wait(0.1)
        end
    end
})

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

VisualsTab:CreateToggle({
    Name = "Highlight Players",
    CurrentValue = false,
    Callback = function(Value)
        _G.Highlight = Value
        while _G.Highlight do
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("Highlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "Highlight"
                    highlight.FillColor = Color3.fromRGB(255, 255, 0)
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = player.Character
                    highlight.Adornee = player.Character
                end
            end
            task.wait(1)
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Highlight") then
                player.Character.Highlight:Destroy()
            end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Show Usernames",
    CurrentValue = false,
    Callback = function(Value)
        _G.NameESP = Value
        while _G.NameESP do
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("NameBillboard") then
                    local billboard = Instance.new("BillboardGui", player.Character)
                    billboard.Name = "NameBillboard"
                    billboard.Adornee = player.Character:WaitForChild("Head")
                    billboard.Size = UDim2.new(0, 100, 0, 40)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true

                    local text = Instance.new("TextLabel", billboard)
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.Text = player.Name
                    text.TextColor3 = Color3.new(1, 1, 1)
                    text.BackgroundTransparency = 1
                    text.TextScaled = true
                end
            end
            task.wait(1)
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("NameBillboard") then
                player.Character.NameBillboard:Destroy()
            end
        end
    end
})