-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local VirtualInput = game:GetService("VirtualInputManager")

-- VARIABLES
local walkspeed = 20
local TriggerBotEnabled = false
local CameraAimbot = false
local KillConfirmed = false
local AimPart = "UpperTorso"

-- GUI SETUP
local gui = Instance.new("ScreenGui")
gui.Name = "fakemrleo_v1"
gui.Enabled = true
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Text = "fakemrleo v1 Script"

local buttonSide = Instance.new("Frame", mainFrame)
buttonSide.Size = UDim2.new(0, 150, 0, 260)
buttonSide.Position = UDim2.new(0, 0, 0, 40)
buttonSide.BackgroundColor3 = Color3.fromRGB(90, 0, 0)

local layout = Instance.new("UIListLayout", buttonSide)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local centerPanel = Instance.new("Frame", mainFrame)
centerPanel.Size = UDim2.new(0, 330, 0, 260)
centerPanel.Position = UDim2.new(0, 160, 0, 40)
centerPanel.BackgroundColor3 = Color3.fromRGB(100, 0, 0)

local killLabel = Instance.new("TextLabel", centerPanel)
killLabel.Size = UDim2.new(1, 0, 0, 25)
killLabel.Position = UDim2.new(0, 0, 0, 0)
killLabel.Text = "Kill Confirm: None"
killLabel.BackgroundTransparency = 1
killLabel.TextColor3 = Color3.new(1, 1, 1)
killLabel.Font = Enum.Font.GothamBold
killLabel.TextSize = 16

local aimbotLabel = Instance.new("TextLabel", centerPanel)
aimbotLabel.Size = UDim2.new(1, 0, 0, 25)
aimbotLabel.Position = UDim2.new(0, 0, 0, 25)
aimbotLabel.Text = "Aimbot: OFF"
aimbotLabel.BackgroundTransparency = 1
aimbotLabel.TextColor3 = Color3.new(1, 1, 1)
aimbotLabel.Font = Enum.Font.Gotham
aimbotLabel.TextSize = 16

local triggerLabel = Instance.new("TextLabel", centerPanel)
triggerLabel.Size = UDim2.new(1, 0, 0, 25)
triggerLabel.Position = UDim2.new(0, 0, 0, 50)
triggerLabel.Text = "TriggerBot: OFF"
triggerLabel.BackgroundTransparency = 1
triggerLabel.TextColor3 = Color3.new(1, 1, 1)
triggerLabel.Font = Enum.Font.Gotham
triggerLabel.TextSize = 16

-- BUTTON CREATOR
local function createButton(text, callback)
	local btn = Instance.new("TextButton", buttonSide)
	btn.Size = UDim2.new(1, -10, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(function()
		callback(btn)
	end)
end

-- BUTTONS ADDED
createButton("Increase Walkspeed", function()
	walkspeed += 5
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkspeed
	end
end)

createButton("Decrease Walkspeed", function()
	walkspeed = math.max(5, walkspeed - 5)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkspeed
	end
end)

createButton("Fly (Hold F)", function()
	local flying = false
	UIS.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.F then
			flying = true
			while flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("UpperTorso") do
				LocalPlayer.Character.Humanoid.Sit = true
				LocalPlayer.Character.UpperTorso.Velocity = Camera.CFrame.LookVector * 60 + Vector3.new(0, 10, 0)
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

createButton("Highlight Players", function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChildOfClass("Highlight") then
			local hl = Instance.new("Highlight", p.Character)
			hl.FillColor = Color3.fromRGB(255, 0, 0)
			hl.OutlineColor = Color3.new(1, 1, 1)
			hl.FillTransparency = 0.25
			hl.OutlineTransparency = 0
		end
	end
end)

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

createButton("Toggle Aimbot", function(btn)
	CameraAimbot = not CameraAimbot
	aimbotLabel.Text = "Aimbot: " .. (CameraAimbot and "ON" or "OFF")
end)

createButton("Toggle TriggerBot", function(btn)
	TriggerBotEnabled = not TriggerBotEnabled
	triggerLabel.Text = "TriggerBot: " .. (TriggerBotEnabled and "ON" or "OFF")
end)

-- NEW BUTTON ➕ ENABLE GODMODE
createButton("Enable Godmode", function()
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
end)

-- TOGGLE UI
UIS.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.RightShift and not gpe then
		gui.Enabled = not gui.Enabled
	end
end)