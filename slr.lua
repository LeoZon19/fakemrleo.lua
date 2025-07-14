-- Assuming you've already loaded the Linoria Library local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))() local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))() local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua"))()

local Window = Library:CreateWindow({ Title = 'fakemrleo | SLR Script', Center = true, AutoShow = true })

local Tabs = { Main = Window:AddTab('Main'), Aimbot = Window:AddTab('Aimbot'), Dupe = Window:AddTab('Dupe'), }

-- MAIN TAB Tabs.Main:AddSlider('Walkspeed', { Text = 'Walkspeed', Default = 16, Min = 16, Max = 100, Rounding = 0, Callback = function(Value) local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed = Value end end })

Tabs.Main:AddButton('Infinite Stamina', function() local player = game.Players.LocalPlayer local stamina = player:FindFirstChild("Stamina") or player.Character:FindFirstChild("Stamina") if stamina and stamina:IsA("NumberValue") then stamina:GetPropertyChangedSignal("Value"):Connect(function() stamina.Value = 100 end) stamina.Value = 100 end end)

Tabs.Main:AddButton('Show Usernames', function() for _, p in pairs(game.Players:GetPlayers()) do if p ~= game.Players.LocalPlayer and p.Character and not p.Character:FindFirstChild("UsernameTag") then local tag = Instance.new("BillboardGui", p.Character) tag.Name = "UsernameTag" tag.Size = UDim2.new(0, 200, 0, 50) tag.AlwaysOnTop = true tag.StudsOffset = Vector3.new(0, 3, 0) local label = Instance.new("TextLabel", tag) label.Size = UDim2.new(1, 0, 1, 0) label.Text = p.Name label.TextColor3 = Color3.new(1, 1, 1) label.BackgroundTransparency = 1 label.Font = Enum.Font.GothamBold label.TextSize = 14 end end end)

Tabs.Main:AddButton('Fly (Hold F)', function() local UIS = game:GetService("UserInputService") local flying = false UIS.InputBegan:Connect(function(input) if input.KeyCode == Enum.KeyCode.F then flying = true while flying do local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.Humanoid.Sit = true char.HumanoidRootPart.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60 + Vector3.new(0, 10, 0) end task.wait() end end end) UIS.InputEnded:Connect(function(input) if input.KeyCode == Enum.KeyCode.F then flying = false end end) end)

-- AIMBOT TAB Tabs.Aimbot:AddToggle('Enable Aimbot', {Text = 'Enable Aimbot', Default = false, Callback = function(state) print("Aimbot state:", state) end})

Tabs.Aimbot:AddToggle('Triggerbot', {Text = 'Enable Triggerbot', Default = false, Callback = function(state) print("Triggerbot state:", state) end})

Tabs.Aimbot:AddButton('Highlight Players', function() for _, p in pairs(game.Players:GetPlayers()) do if p ~= game.Players.LocalPlayer and p.Character and not p.Character:FindFirstChildOfClass("Highlight") then local hl = Instance.new("Highlight", p.Character) hl.FillColor = Color3.fromRGB(255, 0, 0) hl.OutlineColor = Color3.new(1, 1, 1) hl.FillTransparency = 0.25 hl.OutlineTransparency = 0 end end end)

-- DUPE TAB PLACEHOLDER Tabs.Dupe:AddButton('Attempt Dupe (Coming Soon)', function() print("Dupe logic goes here (future)") end)

-- Theme and Save ThemeManager:SetLibrary(Library) SaveManager:SetLibrary(Library) SaveManager:IgnoreThemeSettings() ThemeManager:LoadTheme() SaveManager:BuildConfigSection(Tabs.Main) SaveManager:LoadAutoloadConfig()

