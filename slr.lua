local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "fakemrleo SLR Script",
	LoadingTitle = "Loading fakemrleo SLR Script",
	LoadingSubtitle = "by Leonard",
	ConfigurationSaving = {
		Enabled = false,
		FolderName = nil,
		FileName = "fakemrleoSLR"
	},
	KeySystem = false
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TriggerBotEnabled = false
local AimbotEnabled = false

-- Functions

local function InfiniteStamina()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local stats = char:FindFirstChild("BodyEffects")
	if stats and stats:FindFirstChild("Stamina") then
		stats.Stamina.Changed:Connect(function()
			stats.Stamina.Value = 100
		end)
		stats.Stamina.Value = 100
	end
end

local function FlyToggle()
	local flying = false
	local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	UIS.InputBegan:Connect(function(key, gpe)
		if key.KeyCode == Enum.KeyCode.F and not gpe then
			flying = true
			while flying do
				hrp.Velocity = Camera.CFrame.LookVector * 100
				RunService.RenderStepped:Wait()
			end
		end
	end)
	UIS.InputEnded:Connect(function(key)
		if key.KeyCode == Enum.KeyCode.F then
			flying = false
		end
	end)
end

local function ShowUsernames()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("NameTag") then
			local tag = Instance.new("BillboardGui", player.Character)
			tag.Name = "NameTag"
			tag.Size = UDim2.new(0, 200, 0, 50)
			tag.StudsOffset = Vector3.new(0, 3, 0)
			tag.AlwaysOnTop = true
			local name = Instance.new("TextLabel", tag)
			name.Size = UDim2.new(1, 0, 1, 0)
			name.BackgroundTransparency = 1
			name.Text = player.Name
			name.TextColor3 = Color3.new(1, 1, 1)
			name.TextScaled = true
		end
	end
end

local function HighlightPlayers()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChildOfClass("Highlight") then
			local hl = Instance.new("Highlight", p.Character)
			hl.FillColor = Color3.fromRGB(255, 0, 0)
			hl.OutlineColor = Color3.new(1, 1, 1)
			hl.FillTransparency = 0.25
			hl.OutlineTransparency = 0
		end
	end
end

local function RunAimbot()
	RunService.RenderStepped:Connect(function()
		if not AimbotEnabled then return end
		local closest = nil
		local shortest = math.huge
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("UpperTorso") then
				local pos = Camera:WorldToViewportPoint(player.Character.UpperTorso.Position)
				local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
				if mag < shortest then
					shortest = mag
					closest = player
				end
			end
		end
		if closest and closest.Character and closest.Character:FindFirstChild("UpperTorso") then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Character.UpperTorso.Position)
		end
	end)
end

local function RunTriggerBot()
	RunService.RenderStepped:Connect(function()
		if not TriggerBotEnabled then return end
		local mouse = LocalPlayer:GetMouse()
		local target = mouse.Target
		if target and target.Parent:FindFirstChild("Humanoid") then
			mouse1click()
		end
	end)
end

-- MAIN TAB
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSlider({
	Name = "Walkspeed",
	Range = {16, 100},
	Increment = 1,
	Default = 16,
	Callback = function(Value)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
		end
	end,
})

MainTab:CreateButton({
	Name = "Enable Infinite Stamina",
	Callback = InfiniteStamina,
})

MainTab:CreateButton({
	Name = "Fly (Hold F)",
	Callback = FlyToggle,
})

MainTab:CreateButton({
	Name = "Show Usernames",
	Callback = ShowUsernames,
})

-- AIMBOT TAB
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

AimbotTab:CreateToggle({
	Name = "Enable Aimbot",
	CurrentValue = false,
	Callback = function(Value)
		AimbotEnabled = Value
	end,
})

AimbotTab:CreateToggle({
	Name = "Enable TriggerBot",
	CurrentValue = false,
	Callback = function(Value)
		TriggerBotEnabled = Value
	end,
})

AimbotTab:CreateButton({
	Name = "Highlight Players",
	Callback = HighlightPlayers,
})

-- Start logic loops
RunAimbot()
RunTriggerBot()