-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "fakemrleo SLR Script",
	LoadingTitle = "Loading...",
	LoadingSubtitle = "Thank you guys",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "fakemrleoConfig",
		FileName = "SLRSettings"
	}
})

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local DupeTab = Window:CreateTab("Dupe", 4483362458)
local CreditsTab = Window:CreateTab("Credits", 4483362458)

-- Variables
local flying = false
local noclipping = false
local flyPart

-- Fly Toggle
MainTab:CreateToggle({
	Name = "Fly (Hold F)",
	CurrentValue = false,
	Callback = function(Value)
		flying = Value
		local UIS = game:GetService("UserInputService")
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")

		if flying then
			local bv = Instance.new("BodyVelocity", hrp)
			bv.Name = "FlyVelocity"
			bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
			bv.Velocity = Vector3.zero

			UIS.InputBegan:Connect(function(input)
				if input.KeyCode == Enum.KeyCode.F and flying then
					bv.Velocity = hrp.CFrame.LookVector * 100
				end
			end)
			UIS.InputEnded:Connect(function(input)
				if input.KeyCode == Enum.KeyCode.F and flying then
					bv.Velocity = Vector3.zero
				end
			end)
		else
			local bv = hrp:FindFirstChild("FlyVelocity")
			if bv then bv:Destroy() end
		end
	end
})

-- NoClip Toggle
MainTab:CreateToggle({
	Name = "NoClip (Hold N)",
	CurrentValue = false,
	Callback = function(Value)
		noclipping = Value
		local RunService = game:GetService("RunService")
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()

		if noclipping then
			RunService.Stepped:Connect(function()
				if noclipping and char then
					for _, v in pairs(char:GetDescendants()) do
						if v:IsA("BasePart") and v.CanCollide then
							v.CanCollide = false
						end
					end
				end
			end)
		end
	end
})

-- Highlight Players
MainTab:CreateButton({
	Name = "Highlight Players",
	Callback = function()
		for _, player in pairs(game.Players:GetPlayers()) do
			if player ~= game.Players.LocalPlayer then
				local char = player.Character
				if char and not char:FindFirstChild("Highlight") then
					local hl = Instance.new("Highlight", char)
					hl.FillColor = Color3.fromRGB(255, 0, 0)
					hl.OutlineColor = Color3.fromRGB(255, 255, 255)
					hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				end
			end
		end
	end
})

-- Silent Aimbot (basic placeholder)
CombatTab:CreateButton({
	Name = "Silent Aimbot (Basic)",
	Callback = function()
		print("Silent Aimbot script would go here.")
	end
})

-- TriggerBot (basic)
CombatTab:CreateButton({
	Name = "TriggerBot (Basic)",
	Callback = function()
		local player = game.Players.LocalPlayer
		local mouse = player:GetMouse()
		mouse.Button1Down:Connect(function()
			if mouse.Target and mouse.Target.Parent:FindFirstChild("Humanoid") then
				mouse.Target.Parent.Humanoid:TakeDamage(10)
			end
		end)
	end
})

-- Infinite Dupe Button
DupeTab:CreateButton({
	Name = "Infinite Tool Dupe",
	Callback = function()
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()

		while wait(0.5) do
			local tool = char:FindFirstChildOfClass("Tool")
			if tool then
				local clone = tool:Clone()
				clone.Parent = player.Backpack
			end
		end
	end
})

-- Credits
CreditsTab:CreateParagraph({
	Title = "Made by fakemrleo",
	Content = "All systems built using Rayfield and custom features."
})