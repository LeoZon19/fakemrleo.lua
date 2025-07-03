local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Safe UI Reset
pcall(function() game.CoreGui:FindFirstChild("fakemrleo_SLR_UI"):Destroy() end)

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "fakemrleo_SLR_UI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

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

-- Button Creator
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

-- Walkspeed Controls
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
local flying = false
createButton("Fly (Hold F)", function()
	if not _G.FlyHooked then
		_G.FlyHooked = true
		UIS.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.F then
				flying = true
				while flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") do
					LocalPlayer.Character.Humanoid.Sit = true
					LocalPlayer.Character.Head.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60 + Vector3.new(0, 10, 0)
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
	end
end)

-- Enlarge Heads (Visual)
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

-- Anti-Ragdoll
createButton("Anti-Ragdoll", function()
	if not _G.AntiRagdollRunning then
		_G.AntiRagdollRunning = true
		task.spawn(function()
			while _G.AntiRagdollRunning do
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
	end
end)

-- Show Usernames
createButton("Show Usernames", function()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character and not p.Character:FindFirstChild("UsernameTag") then
			local tag = Instance.new("BillboardGui")
			tag.Name = "UsernameTag"
			tag.Adornee = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("UpperTorso")
			tag.Size = UDim2.new(0, 100, 0, 40)
			tag.StudsOffset = Vector3.new(0, 2, 0)
			tag.AlwaysOnTop = true
			tag.Parent = p.Character

			local label = Instance.new("TextLabel", tag)
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.new(1, 1, 1)
			label.TextStrokeTransparency = 0
			label.Font = Enum.Font.GothamBold
			label.TextSize = 14
			label.Text = p.Name
		end
	end
end)

-- Toggle UI
UIS.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.RightShift and not gpe then
		gui.Enabled = not gui.Enabled
	end
end)
