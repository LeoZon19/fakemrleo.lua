local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "fakemrleo_SLR_UI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 500)
frame.Position = UDim2.new(0.5, -200, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
frame.BorderSizePixel = 5
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "fakemrleo's SLR Script"
title.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 24

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
title.LayoutOrder = 0

-- Button creator
local function createButton(text, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 360, 0, 40)
	button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	button.TextColor3 = Color3.fromRGB(0, 0, 0)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.Text = text
	button.Parent = frame
	button.MouseButton1Click:Connect(callback)
	return button
end

-- Walkspeed Control
local walkspeed = 20
local wsLabel = Instance.new("TextLabel", frame)
wsLabel.Size = UDim2.new(0, 360, 0, 20)
wsLabel.BackgroundTransparency = 1
wsLabel.TextColor3 = Color3.new(1, 1, 1)
wsLabel.Font = Enum.Font.Gotham
wsLabel.TextSize = 14
wsLabel.Text = "Walkspeed: " .. walkspeed

createButton("Increase Walkspeed", function()
	walkspeed = math.min(walkspeed + 5, 200)
	wsLabel.Text = "Walkspeed: " .. walkspeed
	local char = LocalPlayer.Character
	if char and char:FindFirstChildOfClass("Humanoid") then
		char:FindFirstChildOfClass("Humanoid").WalkSpeed = walkspeed
	end
end)

createButton("Decrease Walkspeed", function()
	walkspeed = math.max(walkspeed - 5, 5)
	wsLabel.Text = "Walkspeed: " .. walkspeed
	local char = LocalPlayer.Character
	if char and char:FindFirstChildOfClass("Humanoid") then
		char:FindFirstChildOfClass("Humanoid").WalkSpeed = walkspeed
	end
end)

-- Fly (Hold F)
createButton("Fly (Hold F)", function()
	local flying = false
	UIS.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.F then
			flying = true
			while flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") do
				LocalPlayer.Character.Humanoid.Sit = true
				LocalPlayer.Character.Head.Velocity = Camera.CFrame.LookVector * 60 + Vector3.new(0, 10, 0)
				task.wait()
			end
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.F then
			flying = false
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid.Sit = false
			end
		end
	end)
end)

-- Enlarge Heads (Visual only)
createButton("Enlarge Heads", function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
			local head = p.Character.Head
			head.Size = Vector3.new(5, 5, 5)
			head.Transparency = 0.3
			head.Material = Enum.Material.Neon
			head.Color = Color3.fromRGB(255, 0, 0)
		end
	end
end)

-- Highlight Players
createButton("Highlight Players", function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChildOfClass("Highlight") then
			local hl = Instance.new("Highlight", p.Character)
			hl.FillColor = Color3.fromRGB(0, 255, 0)
			hl.OutlineColor = Color3.fromRGB(0, 0, 0)
			hl.FillTransparency = 0.25
			hl.OutlineTransparency = 0
		end
	end
end)

-- Show Usernames
createButton("Show Usernames", function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("UsernameTag") then
			local tag = Instance.new("BillboardGui", p.Character)
			tag.Name = "UsernameTag"
			tag.Size = UDim2.new(0, 200, 0, 50)
			tag.AlwaysOnTop = true
			tag.StudsOffset = Vector3.new(0, 3, 0)
			local label = Instance.new("TextLabel", tag)
			label.Size = UDim2.new(1, 0, 1, 0)
			label.Text = p.Name
			label.TextColor3 = Color3.new(1, 1, 1)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.GothamBold
			label.TextSize = 14
		end
	end
end)

-- Anti-Ragdoll
createButton("Anti-Ragdoll", function()
	_G.AntiRagdoll = true
	task.spawn(function()
		while _G.AntiRagdoll do
			local char = LocalPlayer.Character
			if char then
				for _, v in pairs(char:GetDescendants()) do
					if v:IsA("BallSocketConstraint") or v.Name:lower():find("ragdoll") then
						v:Destroy()
					end
				end
			end
			task.wait(0.1)
		end
	end)
end)

-- SAFE Aimbot (Camera rotation)
createButton("Enable Aimbot", function()
	_G.Aimbot = true
	local function getClosestTarget()
		local closest, shortest = nil, math.huge
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
				local screenPoint, visible = Camera:WorldToViewportPoint(p.Character.Head.Position)
				local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - UIS:GetMouseLocation()).Magnitude
				if distance < shortest and visible then
					closest = p
					shortest = distance
				end
			end
		end
		return closest
	end

	RunService.RenderStepped:Connect(function()
		if _G.Aimbot then
			local target = getClosestTarget()
			if target and target.Character and target.Character:FindFirstChild("Head") then
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
			end
		end
	end)
end)

-- Toggle UI with RightShift
UIS.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.RightShift and not gpe then
		gui.Enabled = not gui.Enabled
	end
end)
