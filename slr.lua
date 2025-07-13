local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'fakemrleo UI - SLR & Dupe Tools',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'),
    Aimbot = Window:AddTab('Aimbot'),
    Dupe = Window:AddTab('Dupe'),
    ['UI Settings'] = Window:AddTab('UI Settings')
}

local Local = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- 🧠 Main Tab
local MainBox = Tabs.Main:AddLeftGroupbox('Main Features')

MainBox:AddToggle('InfiniteStamina', {
    Text = 'Infinite Stamina',
    Default = false,
    Callback = function(val)
        if val then
            RunService.RenderStepped:Connect(function()
                local char = Local.Character
                if char then
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("NumberValue") and string.find(string.lower(v.Name), "stamina") then
                            v.Value = v.MaxValue or 100
                        end
                    end
                end
            end)
        end
    end
})

MainBox:AddSlider('WalkSpeed', {
    Text = 'WalkSpeed',
    Default = 16,
    Min = 5,
    Max = 100,
    Suffix = 'Speed',
    Callback = function(v)
        local hum = Local.Character and Local.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
})

MainBox:AddToggle('FlyToggle', {
    Text = 'Fly (Hold F)',
    Default = false,
    Callback = function(val)
        if val then
            local flying = false
            UIS.InputBegan:Connect(function(i, e)
                if not e and i.KeyCode == Enum.KeyCode.F then flying = true end
            end)
            UIS.InputEnded:Connect(function(i, e)
                if i.KeyCode == Enum.KeyCode.F then flying = false end
            end)
            RunService.RenderStepped:Connect(function()
                if flying and Local.Character and Local.Character:FindFirstChild("HumanoidRootPart") then
                    Local.Character.HumanoidRootPart.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
                end
            end)
        end
    end
})

MainBox:AddButton('ShowUsernames', {
    Text = 'Show Usernames',
    Func = function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Local and p.Character and not p.Character:FindFirstChild("NameTagGui") then
                local tag = Instance.new("BillboardGui", p.Character)
                tag.Name = "NameTagGui"
                tag.Size = UDim2.new(0,100,0,50)
                tag.StudsOffset = Vector3.new(0,3,0)
                tag.AlwaysOnTop = true
                local lbl = Instance.new("TextLabel", tag)
                lbl.Size = UDim2.new(1,0,1,0)
                lbl.Text = p.Name
                lbl.Font = Enum.Font.GothamBold
                lbl.TextColor3 = Color3.new(1,1,1)
                lbl.BackgroundTransparency = 1
            end
        end
    end
})

-- 🎯 Aimbot Tab
local AimbotBox = Tabs.Aimbot:AddLeftGroupbox('Aimbot Tools')

AimbotBox:AddToggle('EnableAimbot', {
    Text = 'Enable Aimbot',
    Default = false,
    Callback = function(enabled)
        if enabled then
            RunService.RenderStepped:Connect(function()
                local closest, dist = nil, math.huge
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= Local and p.Character then
                        local part = p.Character:FindFirstChild("UpperTorso")
                        if part then
                            local sp = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                            local md = (Vector2.new(sp.X, sp.Y) - UIS:GetMouseLocation()).Magnitude
                            if md < dist then dist, closest = md, p end
                        end
                    end
                end
                if closest and closest.Character then
                    local pos = closest.Character.UpperTorso.Position
                    workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, pos)
                end
            end)
        end
    end
})

AimbotBox:AddToggle('TriggerBot', {
    Text = 'Trigger Bot',
    Default = false,
    Callback = function(val)
        if val then
            RunService.RenderStepped:Connect(function()
                -- Add shooting logic here if game has tools
            end)
        end
    end
})

AimbotBox:AddButton('HighlightPlayers', {
    Text = 'Highlight Players',
    Func = function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Local and p.Character and not p.Character:FindFirstChildOfClass("Highlight") then
                local hl = Instance.new("Highlight", p.Character)
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.new(1, 1, 1)
                hl.FillTransparency = 0.25
            end
        end
    end
})

-- 📦 Dupe Tab
local DupeBox = Tabs.Dupe:AddLeftGroupbox('Dupe Tools')

DupeBox:AddButton('AttemptDupe', {
    Text = 'Attempt Dupe',
    Func = function()
        local rs = game:GetService("ReplicatedStorage")
        local evt = rs:FindFirstChild("DupeEvent") or rs:FindFirstChild("Duplicate")
        if evt and evt:IsA("RemoteEvent") then
            evt:FireServer()
        else
            warn("No dupe event found.")
        end
    end
})

-- 🎨 Theme & Save
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder('fakemrleoSLR')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyTheme('Default')

Library:Notify('Linoria UI Loaded', 3)