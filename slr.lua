-- fakemrleo v1 Script
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local VirtualInput = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")

-- Core Variables
local walkspeed = 20
local TriggerBotEnabled = false
local CameraAimbot = false
local KillConfirmed = false
local AimPart = "UpperTorso"
local InfiniteStamina = false
local GodmodeEnabled = false

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "fakemrleo_v1"

local tabHolder = Instance.new("Frame", gui)
tabHolder.Size = UDim2.new(0, 550, 0, 350)
tabHolder.Position = UDim2.new(0.5, -275, 0.5, -175)
tabHolder.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
tabHolder.Active = true
tabHolder.Draggable = true

-- Tab Buttons
local tabButtons = Instance.new("Frame", tabHolder)
tabButtons.Size = UDim2.new(0, 550, 0, 40)
tabButtons.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

local mainTabBtn = Instance.new("TextButton", tabButtons)
mainTabBtn.Size = UDim2.new(0, 180, 1, 0)
mainTabBtn.Position = UDim2.new(0, 0, 0, 0)
mainTabBtn.Text = "Main"
mainTabBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
mainTabBtn.TextColor3 = Color3.new(1, 1, 1)

local aimbotTabBtn = Instance.new("TextButton", tabButtons)
aimbotTabBtn.Size = UDim2.new(0, 180, 1, 0)
aimbotTabBtn.Position = UDim2.new(0, 180, 0, 0)
aimbotTabBtn.Text = "Aimbot"
aimbotTabBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
aimbotTabBtn.TextColor3 = Color3.new(1, 1, 1)

local guiTabBtn = Instance.new("TextButton", tabButtons)
guiTabBtn.Size = UDim2.new(0, 190, 1, 0)
guiTabBtn.Position = UDim2.new(0, 360, 0, 0)
guiTabBtn.Text = "GUI"
guiTabBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
guiTabBtn.TextColor3 = Color3.new(1, 1, 1)

-- Panels
local tabs = {
	Main = Instance.new("Frame", tabHolder),
	Aimbot = Instance.new("Frame", tabHolder),
	GUI = Instance.new("Frame", tabHolder)
}

for name, frame in pairs(tabs) do
	frame.Size = UDim2.new(1, 0, 1, -40)
	frame.Position = UDim2.new(0, 0, 0, 40)
	frame.Visible = false
	frame.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
end

tabs.Main.Visible = true

mainTabBtn.MouseButton1Click:Connect(function()
	tabs.Main.Visible = true
	tabs.Aimbot.Visible = false
	tabs.GUI.Visible = false
end)
aimbotTabBtn.MouseButton1Click:Connect(function()
	tabs.Main.Visible = false
	tabs.Aimbot.Visible = true
	tabs.GUI.Visible = false
end)
guiTabBtn.MouseButton1Click:Connect(function()
	tabs.Main.Visible = false
	tabs.Aimbot.Visible = false
	tabs.GUI.Visible = true
end)

-- Button Maker
local function createButton(text, parent, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0, 500, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- MAIN TAB
createButton("Infinite Stamina", tabs.Main, function()
	InfiniteStamina = not InfiniteStamina
	print("Infinite Stamina:", InfiniteStamina)
end)

createButton("Godmode", tabs.Main, function()
	GodmodeEnabled = not GodmodeEnabled
	print("Godmode:", GodmodeEnabled)
end)

createButton("Fly (Hold F)", tabs.Main, function()
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

createButton("Highlight Players", tabs.Main, function()
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

createButton("Show Usernames", tabs.Main, function()
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

-- AIMBOT TAB
createButton("Toggle Aimbot (Q)", tabs.Aimbot, function()
	CameraAimbot = not CameraAimbot
	print("Aimbot:", CameraAimbot)
end)

createButton("Toggle TriggerBot", tabs.Aimbot, function()
	TriggerBotEnabled = not TriggerBotEnabled
	print("TriggerBot:", TriggerBotEnabled)
end)

-- GUI TAB
createButton("Set Weather: Sunny", tabs.GUI, function()
	Lighting.TimeOfDay = "14:00:00"
	Lighting.FogEnd = 100000
	Lighting.Brightness = 2
	Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end)

createButton("Set Weather: Foggy", tabs.GUI, function()
	Lighting.FogEnd = 150
	Lighting.OutdoorAmbient = Color3.fromRGB(80, 80, 80)
	Lighting.Brightness = 1
end)

createButton("Set Weather: Dark", tabs.GUI, function()
	Lighting.TimeOfDay = "00:00:00"
	Lighting.FogEnd = 500
	Lighting.Brightness = 0.3
	Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
end)

-- INF STAMINA + GODMODE LOOP
RunService.RenderStepped:Connect(function()
	if InfiniteStamina and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Stamina") then
		LocalPlayer.Character.Stamina.Value = 100
	end
	if GodmodeEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
	end
end)

-- Aimbot Lock
RunService.RenderStepped:Connect(function()
	if CameraAimbot then
		local closest = nil
		local dist = math.huge
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("UpperTorso") then
				local pos, onScreen = Camera:WorldToViewportPoint(p.Character.UpperTorso.Position)
				if onScreen then
					local d = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
					if d < dist then
						dist = d
						closest = p
					end
				end
			end
		end
		if closest then
			local dir = (closest.Character.UpperTorso.Position - Camera.CFrame.Position).Unit
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + dir)
		end
	end
end)

-- UI TOGGLE
UIS.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.RightShift and not gpe then
		gui.Enabled = not gui.Enabled
	end
end)
