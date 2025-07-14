-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "fakemrleo SLR Script",
	LoadingTitle = "Loading...",
	LoadingSubtitle = "Thank you guys",
	ConfigurationSaving = {
		Enabled = false
	},
	KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

-- Variables
local walkspeed = 16
local flying = false
local infStamina = false
local aimbotEnabled = false
local triggerBot = false

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)

-- MAIN TAB BUTTONS

MainTab:CreateSlider({
	Name = "Walkspeed",
	Range = {16, 100},
	Increment = 2,
	CurrentValue = 16,
	Flag = "WalkspeedSlider",
	Callback = function(Value)
		walkspeed = Value
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			LocalPlayer.Character.Humanoid.WalkSpeed = Value
		end
	end,
})

MainTab:CreateToggle({
	Name = "Infinite Stamina",
	CurrentValue = false,
	Callback = function(state)
		infStamina = state
		while infStamina do
			local values = LocalPlayer:FindFirstChild("Values") or LocalPlayer:FindFirstChild("stats")
			if values and values:FindFirstChild("Stamina") then
				values.Stamina.Value = 100
			end
			task.wait(0.1)
		end
	end,
})

MainTab:CreateButton({
	Name = "Fly (Hold F)",
	Callback = function()
		UIS.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.F then
				flying = true
				while flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
					LocalPlayer.Character.HumanoidRootPart.Velocity = Camera.CFrame.LookVector * 60
					task.wait()
				end
			end
		end)
		UIS.InputEnded:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.F then
				flying = false
			end
		end)
	end,
})

MainTab:CreateButton({
	Name = "Show Usernames",
	Callback = function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("NameTag") then
				local tag = Instance.new("BillboardGui", p.Character)
				tag.Name = "NameTag"
				tag.Size = UDim2.new(0, 200, 0, 50)
				tag.StudsOffset = Vector3.new(0, 3, 0)
				tag.AlwaysOnTop = true

				local label = Instance.new("TextLabel", tag)
				label.Size = UDim2.new(1, 0, 1, 0)
				label.Text = p.Name
				label.TextColor3 = Color3.new(1, 1, 1)
				label.BackgroundTransparency = 1
				label.Font = Enum.Font.GothamBold
				label.TextSize = 14
			end
		end
	end,
})

MainTab:CreateButton({
	Name = "Highlight Players",
	Callback = function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChildOfClass("Highlight") then
				local hl = Instance.new("Highlight", p.Character)
				hl.FillColor = Color3.fromRGB(255, 0, 0)
				hl.OutlineColor = Color3.new(1, 1, 1)
				hl.FillTransparency = 0.25
				hl.OutlineTransparency = 0
			end
		end
	end,
})

MainTab:CreateButton({
	Name = "Enable Godmode",
	Callback = function()
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.Name = "GodHumanoid"
			hum.MaxHealth = math.huge
			hum.Health = math.huge
			hum:GetPropertyChangedSignal("Health"):Connect(function()
				if hum.Health < hum.MaxHealth then
					hum.Health = hum.MaxHealth
				end
			end)
		end
	end,
})

-- COMBAT TAB (Aimbot/TriggerBot)

CombatTab:CreateToggle({
	Name = "TriggerBot",
	CurrentValue = false,
	Callback = function(state)
		triggerBot = state
		while triggerBot do
			local mouse = LocalPlayer:GetMouse()
			local target = mouse.Target
			if target and target.Parent and Players:GetPlayerFromCharacter(target.Parent) then
				mouse1click()
			end
			task.wait(0.1)
		end
	end,
})

CombatTab:CreateToggle({
	Name = "Enable Aimbot",
	CurrentValue = false,
	Callback = function(state)
		aimbotEnabled = state
		local RunService = game:GetService("RunService")

		local function getClosestPlayer()
			local closest, shortest = nil, math.huge
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
					local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
					if onScreen then
						local dist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
						if dist < shortest then
							shortest = dist
							closest = p
						end
					end
				end
			end
			return closest
		end

		RunService:BindToRenderStep("Aimbot", Enum.RenderPriority.Camera.Value + 1, function()
			if aimbotEnabled then
				local target = getClosestPlayer()
				if target and target.Character and target.Character:FindFirstChild("Head") then
					Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
				end
			end
		end)
	end,
})