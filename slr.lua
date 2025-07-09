--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// VARIABLES
local walkspeed = 20
local TriggerBotEnabled = false
local CameraAimbot = false
local KillConfirmed = false
local AimPart = "UpperTorso"
local InfiniteStamina = false
local GodMode = false

--// GUI SETUP
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "fakemrleo_v1"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
mainFrame.Active = true
mainFrame.Draggable = true

-- TAB BUTTONS
local tabButtons = Instance.new("Frame", mainFrame)
tabButtons.Size = UDim2.new(0, 100, 1, 0)
tabButtons.Position = UDim2.new(0, 0, 0, 0)
tabButtons.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
local tabLayout = Instance.new("UIListLayout", tabButtons)
tabLayout.FillDirection = Enum.FillDirection.Vertical
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 5)

local function createTab(name)
	local tab = Instance.new("TextButton")
	tab.Size = UDim2.new(1, 0, 0, 30)
	tab.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
	tab.TextColor3 = Color3.new(1, 1, 1)
	tab.Font = Enum.Font.GothamBold
	tab.TextSize = 14
	tab.Text = name
	tab.Parent = tabButtons
	return tab
end

-- TAB FRAMES
local tabFrames = {}
local function makeTabFrame()
	local frame = Instance.new("Frame", mainFrame)
	frame.Size = UDim2.new(0, 490, 1, 0)
	frame.Position = UDim2.new(0, 110, 0, 0)
	frame.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
	frame.Visible = false
	return frame
end

local function clearTabs()
	for _, tab in pairs(tabFrames) do
		tab.Visible = false
	end
end

--// MAIN TAB
local mainTab = makeTabFrame()
tabFrames["Main"] = mainTab

local function createMainButton(text, callback)
	local btn = Instance.new("TextButton", mainTab)
	btn.Size = UDim2.new(0, 470, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, (#mainTab:GetChildren() - 1) * 45 + 10)
	btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

createMainButton("Fly (Hold F)", function()
	local flying = false
	UIS.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.F then
			flying = true
			while flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("UpperTorso") do
				LocalPlayer.Character.Humanoid.Sit = true
				LocalPlayer.Character.UpperTorso.Velocity = Camera.CFrame.LookVector * 60 + Vector3.new(0, 10, 0)
				RunService.RenderStepped:Wait()
			end
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.F then
			flying = false
			LocalPlayer.Character.Humanoid.Sit = false
		end
	end)
end)

createMainButton("Highlight Players", function()
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

createMainButton("Show Usernames", function()
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

createMainButton("Toggle Infinite Stamina", function()
	InfiniteStamina = not InfiniteStamina
end)

createMainButton("Toggle Godmode", function()
	GodMode = not GodMode
end)

--// AIMBOT TAB
local aimbotTab = makeTabFrame()
tabFrames["Aimbot"] = aimbotTab

local aimbotLabel = Instance.new("TextLabel", aimbotTab)
aimbotLabel.Size = UDim2.new(0, 470, 0, 30)
aimbotLabel.Position = UDim2.new(0, 10, 0, 10)
aimbotLabel.Text = "Aimbot: OFF (Q)"
aimbotLabel.TextColor3 = Color3.new(1, 1, 1)
aimbotLabel.BackgroundTransparency = 1
aimbotLabel.Font = Enum.Font.GothamBold
aimbotLabel.TextSize = 16

local triggerLabel = Instance.new("TextLabel", aimbotTab)
triggerLabel.Size = UDim2.new(0, 470, 0, 30)
triggerLabel.Position = UDim2.new(0, 10, 0, 45)
triggerLabel.Text = "TriggerBot: OFF"
triggerLabel.TextColor3 = Color3.new(1, 1, 1)
triggerLabel.BackgroundTransparency = 1
triggerLabel.Font = Enum.Font.Gotham
triggerLabel.TextSize = 16

UIS.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.Q then
		CameraAimbot = not CameraAimbot
		aimbotLabel.Text = "Aimbot: " .. (CameraAimbot and "ON" or "OFF") .. " (Q)"
	end
end)

createMainButton("Toggle TriggerBot", function()
	TriggerBotEnabled = not TriggerBotEnabled
	triggerLabel.Text = "TriggerBot: " .. (TriggerBotEnabled and "ON" or "OFF")
end)

--// GUI TAB
local guiTab = makeTabFrame()
tabFrames["GUI"] = guiTab

local function createGuiButton(text, callback)
	local btn = Instance.new("TextButton", guiTab)
	btn.Size = UDim2.new(0, 470, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, (#guiTab:GetChildren() - 1) * 40 + 10)
	btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

createGuiButton("Set Weather: Sunny", function()
	Lighting.TimeOfDay = "14:00:00"
	Lighting.FogEnd = 100000
	Lighting.Brightness = 2
end)

createGuiButton("Set Weather: Foggy", function()
	Lighting.FogEnd = 50
end)

createGuiButton("Set Weather: Dark", function()
	Lighting.TimeOfDay = "00:00:00"
end)

--// TAB TOGGLE BEHAVIOR
local tabs = {
	Main = createTab("Main"),
	Aimbot = createTab("Aimbot"),
	GUI = createTab("GUI")
}

for name, btn in pairs(tabs) do
	btn.MouseButton1Click:Connect(function()
		clearTabs()
		tabFrames[name].Visible = true
	end)
end

tabFrames["Main"].Visible = true

--// TRIGGERBOT + KILL CONFIRM
local function onPlayerDied(player)
	if KillConfirmed then return end
	KillConfirmed = true
	print("Kill Confirmed: " .. player.Name)
	task.delay(2.5, function()
		KillConfirmed = false
	end)
end

RunService.RenderStepped:Connect(function()
	-- TriggerBot
	if TriggerBotEnabled then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(AimPart) then
				local part = p.Character[AimPart]
				local mousePos = UIS:GetMouseLocation()
				local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
				local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
				if onScreen and distance < 50 then
					VirtualInput:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 0)
					VirtualInput:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 0)
					if p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health <= 0 then
						onPlayerDied(p)
					end
				end
			end
		end
	end

	-- Aimbot
	if CameraAimbot then
		local closest, dist = nil, math.huge
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("UpperTorso") then
				local pos, onScreen = Camera:WorldToViewportPoint(p.Character.UpperTorso.Position)
				local d = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
				if onScreen and d < dist then
					dist = d
					closest = p
				end
			end
		end

		if closest and closest.Character and closest.Character:FindFirstChild("UpperTorso") then
			local part = closest.Character.UpperTorso
			local dir = (part.Position - Camera.CFrame.Position).Unit
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + dir)

			local char = LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position, Vector3.new(part.Position.X, char.HumanoidRootPart.Position.Y, part.Position.Z))
			end
		end
	end

	-- Godmode + Stamina
	if LocalPlayer.Character then
		if GodMode then
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = hum.MaxHealth end
		end

		if InfiniteStamina then
			local values = LocalPlayer.Character:GetDescendants()
			for _, v in pairs(values) do
				if v.Name:lower():find("stamina") and v:IsA("NumberValue") then
					v.Value = 100
				end
			end
		end
	end
end)

-- Toggle UI
UIS.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.RightShift and not gpe then
		gui.Enabled = not gui.Enabled
	end
end)