-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Window = Rayfield:CreateWindow({
    Name = "fakemrleo SLR Script",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Thank you guys",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "fakemrleoSLR"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-----------------------
-- Main Tab
-----------------------
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Callback = function(Value)
        LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Fly Toggle
local flying = false
local function Fly()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1,1,1) * 1e9
    bv.Velocity = Vector3.zero
    bv.Name = "FlyVelocity"
    bv.Parent = hrp
    RunService.RenderStepped:Connect(function()
        if flying then
            bv.Velocity = hrp.CFrame.LookVector * 50
        else
            bv.Velocity = Vector3.zero
        end
    end)
end

MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        flying = Value
        if flying then
            Fly()
        else
            if LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("FlyVelocity") then
                LocalPlayer.Character.HumanoidRootPart.FlyVelocity:Destroy()
            end
        end
    end
})

-- NoClip Toggle
local noclip = false
MainTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(Value)
        noclip = Value
        RunService.Stepped:Connect(function()
            if noclip and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
})

-- Highlight Players
MainTab:CreateButton({
    Name = "Highlight Players",
    Callback = function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char and not char:FindFirstChild("Highlight") then
                    local hl = Instance.new("Highlight", char)
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
})

-- Show Usernames
MainTab:CreateButton({
    Name = "Show Usernames",
    Callback = function()
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and not player.Character:FindFirstChild("NameBillboard") then
                local billboard = Instance.new("BillboardGui", player.Character)
                billboard.Name = "NameBillboard"
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true

                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = player.Name
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextScaled = true
            end
        end
    end
})

-----------------------
-- Dupe Tab
-----------------------
local DupeTab = Window:CreateTab("Dupe", 4483362458)

DupeTab:CreateButton({
    Name = "Dupe Held Tool (Infinite)",
    Callback = function()
        local char = LocalPlayer.Character
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            for i = 1, 50 do
                local clone = tool:Clone()
                clone.Parent = Workspace
                clone.Handle.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 2 + i, 0)
            end
        else
            Rayfield:Notify({Title = "No Tool", Content = "You're not holding a tool."})
        end
    end
})

-----------------------
-- Combat Tab
-----------------------
local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateButton({
    Name = "Silent Aimbot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dvrkef/Scripts/main/SilentAim"))()
    end
})

CombatTab:CreateButton({
    Name = "Triggerbot",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/pHE7WbMv"))()
    end
})

-----------------------
-- Credits Tab
-----------------------
local CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsTab:CreateParagraph({Title = "Script by", Content = "fakemrleo"})

-----------------------
-- Done
-----------------------
Rayfield:Notify({
    Title = "SLR Script Loaded",
    Content = "All systems online!",
    Duration = 4
})