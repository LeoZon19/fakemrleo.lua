-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "fakemrleo SLR Script",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Thank you guys",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "fakemrleo",
        FileName = "SLRScript"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- MAIN TAB
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateButton({
    Name = "Fly (Hold F)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/WzS6bYpS"))()
    end
})

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

MainTab:CreateButton({
    Name = "Noclip (Hold E)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/2n2v3yqZ"))()
    end
})

-- COMBAT TAB
local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateButton({
    Name = "Silent Aimbot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/Trident/master/Scripts/SilentAim.lua"))()
    end
})

CombatTab:CreateButton({
    Name = "Triggerbot",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/VH2j7W6p"))()
    end
})

-- ESP TAB
local ESPTab = Window:CreateTab("ESP", 4483362458)

ESPTab:CreateButton({
    Name = "Highlight Players",
    Callback = function()
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local highlight = Instance.new("Highlight", player.Character)
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.OutlineColor = Color3.new(0, 0, 0)
            end
        end
    end
})

ESPTab:CreateButton({
    Name = "Show Usernames",
    Callback = function()
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and not player.Character:FindFirstChild("NameTag") then
                local tag = Instance.new("BillboardGui", player.Character)
                tag.Name = "NameTag"
                tag.Size = UDim2.new(0, 100, 0, 40)
                tag.StudsOffset = Vector3.new(0, 3, 0)
                tag.AlwaysOnTop = true
                local label = Instance.new("TextLabel", tag)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = player.Name
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextStrokeTransparency = 0
                label.TextScaled = true
            end
        end
    end
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
    end
})

-- CREDITS TAB
local CreditsTab = Window:CreateTab("Credits", 4483362458)

CreditsTab:CreateParagraph({
    Title = "fakemrleo",
    Content = "Script made for SLR, all UI and systems built by fakemrleo."
})