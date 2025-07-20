-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "fakemrleo SLR Script",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Thank you guys",
    ConfigurationSaving = { Enabled = true, FolderName = "fakemrleo", FileName = "SLRScript" },
    Discord = { Enabled = false },
    KeySystem = false
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- === MAIN TAB ===
local MainTab = Window:CreateTab("Main", 4483362458)

-- WalkSpeed Slider
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end,
})

-- Fly Toggle
do
    local flying = false
    local bodyVelocity

    MainTab:CreateToggle({
        Name = "Fly",
        CurrentValue = false,
        Callback = function(state)
            flying = state
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            if flying then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
                bodyVelocity.Parent = hrp

                spawn(function()
                    while flying do
                        RunService.Heartbeat:Wait()
                        local moveDirection = Vector3.new()
                        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection += Camera.CFrame.LookVector end
                        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection -= Camera.CFrame.LookVector end
                        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection -= Camera.CFrame.RightVector end
                        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection += Camera.CFrame.RightVector end

                        if moveDirection.Magnitude > 0 then
                            bodyVelocity.Velocity = moveDirection.Unit * 50
                        else
                            bodyVelocity.Velocity = Vector3.new(0,0,0)
                        end
                    end
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                        bodyVelocity = nil
                    end
                end)
            else
                if bodyVelocity then
                    bodyVelocity:Destroy()
                    bodyVelocity = nil
                end
            end
        end,
    })
end

-- Noclip Toggle
do
    local noclip = false
    local function setNoclip(state)
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end

    MainTab:CreateToggle({
        Name = "Noclip",
        CurrentValue = false,
        Callback = function(state)
            noclip = state
            setNoclip(noclip)
        end,
    })
end

-- Highlight Players
MainTab:CreateButton({
    Name = "Highlight Players",
    Callback = function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChildOfClass("Highlight") then
                local hl = Instance.new("Highlight")
                hl.Adornee = plr.Character
                hl.FillColor = Color3.fromRGB(255,0,0)
                hl.OutlineColor = Color3.fromRGB(0,0,0)
                hl.FillTransparency = 0.3
                hl.OutlineTransparency = 0
                hl.Parent = plr.Character
            end
        end
    end,
})

-- Show Usernames
MainTab:CreateButton({
    Name = "Show Usernames",
    Callback = function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and not plr.Character:FindFirstChild("NameTag") then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "NameTag"
                    billboard.Adornee = head
                    billboard.Size = UDim2.new(0, 150, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = plr.Character

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextColor3 = Color3.new(1, 1, 1)
                    textLabel.TextStrokeTransparency = 0
                    textLabel.Text = plr.Name
                    textLabel.TextScaled = true
                    textLabel.Font = Enum.Font.GothamBold
                    textLabel.Parent = billboard
                end
            end
        end
    end,
})

-- === COMBAT TAB ===
local CombatTab = Window:CreateTab("Combat", 4483362458)

-- TriggerBot Toggle
CombatTab:CreateToggle({
    Name = "TriggerBot",
    CurrentValue = false,
    Flag = "TriggerBotToggle",
    Callback = function(state)
        getgenv().TriggerBotEnabled = state
        spawn(function()
            while getgenv().TriggerBotEnabled do
                local mouse = LocalPlayer:GetMouse()
                local target = mouse.Target
                if target and target.Parent then
                    local targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
                    if targetPlayer and targetPlayer ~= LocalPlayer then
                        mouse1click()
                    end
                end
                task.wait(0.1)
            end
        end)
    end,
})

-- === DUPE TAB ===
local DupeTab = Window:CreateTab("Dupe", 4483362458)

DupeTab:CreateButton({
    Name = "Duplicate Equipped Tool",
    Callback = function()
        local character = LocalPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        -- Get equipped tool from character (not backpack)
        local tool = nil
        for _, child in pairs(character:GetChildren()) do
            if child:IsA("Tool") then
                tool = child
                break
            end
        end

        if not tool then
            warn("No tool equipped to duplicate!")
            return
        end

        local clone = tool:Clone()
        clone.Parent = LocalPlayer.Backpack
        print("Duplicated tool: "..clone.Name)
    end,
})

-- === CREDITS TAB ===
local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateParagraph({
    Title = "fakemrleo",
    Content = "Script made for SLR by fakemrleo."
})