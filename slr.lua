-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "fakemrleo SLR Script",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Thank you guys",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "fakemrleoConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
})

-- MAIN TAB
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

MainTab:CreateButton({
    Name = "Fly (Hold F)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxScriptsX/FlyScript/main/Fly.lua"))()
    end,
})

MainTab:CreateButton({
    Name = "Highlight Players",
    Callback = function()
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = player.Character
            end
        end
    end,
})

MainTab:CreateButton({
    Name = "Show Usernames",
    Callback = function()
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Character and not player.Character:FindFirstChild("UsernameBillboard") then
                local billboard = Instance.new("BillboardGui", player.Character)
                billboard.Name = "UsernameBillboard"
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                local textLabel = Instance.new("TextLabel", billboard)
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.Text = player.Name
                textLabel.TextColor3 = Color3.new(1, 1, 1)
                textLabel.BackgroundTransparency = 1
            end
        end
    end,
})

-- COMBAT TAB
local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateButton({
    Name = "Silent Aimbot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NighterEpic/RobloxScripts/main/SilentAim.lua"))()
    end,
})

CombatTab:CreateButton({
    Name = "TriggerBot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NighterEpic/RobloxScripts/main/TriggerBot.lua"))()
    end,
})

-- MISC TAB
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateButton({
    Name = "Anti Ragdoll",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char:FindFirstChild("RagdollConstraint") then
            char:FindFirstChild("RagdollConstraint"):Destroy()
        end
        if char:FindFirstChild("Ragdoll") then
            char:FindFirstChild("Ragdoll"):Destroy()
        end
        if char:FindFirstChild("Ragdolled") then
            char:FindFirstChild("Ragdolled"):Destroy()
        end
    end,
})

-- DUPE TAB
local DupeTab = Window:CreateTab("Dupe", 4483362458)

DupeTab:CreateButton({
    Name = "Duplicate Equipped Tool",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then return end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local tool = humanoid:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
        if not tool then
            warn("No tool equipped or in backpack to duplicate!")
            return
        end

        local clone = tool:Clone()
        clone.Parent = player.Backpack
        print("Duplicated tool: " .. clone.Name)
    end,
})

-- CREDITS TAB
local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateParagraph({
    Title = "fakemrleo",
    Content = "Made by fakemrleo for SLR."
})