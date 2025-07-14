--// Rayfield Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "fakemrleo SLR Script",
	LoadingTitle = "Loading fakemrleo's UI",
	LoadingSubtitle = "by ChatGPT",
	ConfigurationSaving = {
		Enabled = false
	},
	KeySystem = false,
})

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local staminaLoop, godLoop, flying = false, false, false
local walkspeed = 16

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSlider({
	Name = "Walkspeed",
	Range = {16, 100},
	Increment = 2,
	CurrentValue = 16,
	Flag = "WalkspeedSlider",
	Callback = function(Value)
		walkspeed = Value
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed
		end
	end,
})

MainTab:CreateToggle({
	Name = "Infinite Stamina",
	CurrentValue = false,
	Callback = function(state)
		staminaLoop = state
		while staminaLoop do
			local stat = LocalPlayer:FindFirstChild("Values") or LocalPlayer:FindFirstChild("stats")
			if stat and stat:FindFirstChild("Stamina") then
				stat.Stamina.Value = 100
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
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChild("UsernameBillboard") then
				local tag = Instance.new("BillboardGui", plr.Character)
				tag.Name = "UsernameBillboard"
				tag.Size = UDim2.new(0, 200, 0, 50)
				tag.StudsOffset = Vector3.new(0, 3, 0)
				tag.AlwaysOnTop = true
				local txt = Instance.new("TextLabel", tag)
				txt.Size = UDim2.new(1, 0, 1, 0)
				txt.Text = plr.Name
				txt.BackgroundTransparency = 1
				txt.TextColor3 = Color3.new(1,1,1)
				txt.Font = Enum.Font.GothamBold
				txt.TextSize = 14
			end
		end
	end,
})

MainTab:CreateButton({
	Name = "Highlight Players",
	Callback = function()
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChild("Highlight") then
				local hl = Instance.new("Highlight", plr.Character)
				hl.FillColor = Color3.new(1, 0, 0)
				hl.OutlineColor = Color3.new(1, 1, 1)
				hl.FillTransparency = 0.25
				hl.OutlineTransparency = 0
			end
		end
	end,
})

-- Aimbot Tab
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

AimbotTab:CreateToggle({
	Name = "TriggerBot",
	CurrentValue = false,
	Callback = function(enabled)
		getgenv().TriggerBot = enabled
		while getgenv().TriggerBot do
			local mouse = LocalPlayer:GetMouse()
			local target = mouse.Target
			if target and target.Parent and Players:GetPlayerFromCharacter(target.Parent) then
				mouse1click()
			end
			task.wait()
		end
	end,
})

AimbotTab:CreateToggle({
	Name = "Enable Aimbot (head)",
	CurrentValue = false,
	Callback = function(state)
		getgenv().AimbotOn = state
		local RunService = game:GetService("RunService")
		local function getClosestPlayer()
			local closestPlayer = nil
			local shortestDistance = math.huge
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
					local screenPoint, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
					if onScreen then
						local mousePos = UIS:GetMouseLocation()
						local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
						if dist < shortestDistance then
							closestPlayer = player
							shortestDistance = dist
						end
					end
				end
			end
			return closestPlayer
		end
		RunService:BindToRenderStep("Aimbot", Enum.RenderPriority.Camera.Value + 1, function()
			if getgenv().AimbotOn then
				local target = getClosestPlayer()
				if target and target.Character and target.Character:FindFirstChild("Head") then
					Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
				end
			end
		end)
	end,
})

-- Godmode
MainTab:CreateButton({
	Name = "Enable Godmode",
	Callback = function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
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