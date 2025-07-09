-- SERVICES local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local UIS = game:GetService("UserInputService") local RunService = game:GetService("RunService") local Camera = workspace.CurrentCamera local VirtualInput = game:GetService("VirtualInputManager")

-- VARIABLES local walkspeed = 20 local TriggerBotEnabled = false local CameraAimbot = false local KillConfirmed = false local AimPart = "UpperTorso" local GodmodeEnabled = false local InfiniteStaminaEnabled = false

-- GUI SETUP local gui = Instance.new("ScreenGui", game.CoreGui) gui.Name = "fakemrleo_v1" local mainFrame = Instance.new("Frame", gui) mainFrame.Size = UDim2.new(0, 500, 0, 400) mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200) mainFrame.BackgroundColor3 = Color3.fromRGB(120, 0, 0) mainFrame.BorderSizePixel = 0 mainFrame.Active = true mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame) title.Size = UDim2.new(1, 0, 0, 40) title.Position = UDim2.new(0, 0, 0, 0) title.BackgroundColor3 = Color3.fromRGB(180, 0, 0) title.TextColor3 = Color3.new(1, 1, 1) title.Font = Enum.Font.GothamBold title.TextSize = 22 title.Text = "fakemrleo v1 Script"

local buttonSide = Instance.new("Frame", mainFrame) buttonSide.Size = UDim2.new(0, 150, 0, 360) buttonSide.Position = UDim2.new(0, 0, 0, 40) buttonSide.BackgroundColor3 = Color3.fromRGB(90, 0, 0) local layout = Instance.new("UIListLayout", buttonSide) layout.Padding = UDim.new(0, 5) layout.SortOrder = Enum.SortOrder.LayoutOrder

local centerPanel = Instance.new("Frame", mainFrame) centerPanel.Size = UDim2.new(0, 330, 0, 360) centerPanel.Position = UDim2.new(0, 160, 0, 40) centerPanel.BackgroundColor3 = Color3.fromRGB(100, 0, 0)

-- LABELS local killLabel = Instance.new("TextLabel", centerPanel) killLabel.Size = UDim2.new(1, 0, 0, 25) killLabel.Text = "Kill Confirm: None" killLabel.BackgroundTransparency = 1 killLabel.TextColor3 = Color3.new(1, 1, 1) killLabel.Font = Enum.Font.GothamBold killLabel.TextSize = 16

local aimbotLabel = killLabel:Clone() aimbotLabel.Parent = centerPanel aimbotLabel.Position = UDim2.new(0, 0, 0, 25) aimbotLabel.Text = "Aimbot: OFF"

local triggerLabel = killLabel:Clone() triggerLabel.Parent = centerPanel triggerLabel.Position = UDim2.new(0, 0, 0, 50) triggerLabel.Text = "TriggerBot: OFF"

local godLabel = killLabel:Clone() godLabel.Parent = centerPanel godLabel.Position = UDim2.new(0, 0, 0, 75) godLabel.Text = "Godmode: OFF"

local staminaLabel = killLabel:Clone() staminaLabel.Parent = centerPanel staminaLabel.Position = UDim2.new(0, 0, 0, 100) staminaLabel.Text = "Infinite Stamina: OFF"

-- BUTTON FUNCTION local function createButton(text, callback) local btn = Instance.new("TextButton", buttonSide) btn.Size = UDim2.new(1, -10, 0, 35) btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) btn.TextColor3 = Color3.new(1, 1, 1) btn.Font = Enum.Font.GothamBold btn.TextSize = 14 btn.Text = text btn.MouseButton1Click:Connect(function() callback(btn) end) end

-- BASIC TOGGLES createButton("Toggle Aimbot", function() CameraAimbot = not CameraAimbot aimbotLabel.Text = "Aimbot: " .. (CameraAimbot and "ON" or "OFF") end)

createButton("Toggle TriggerBot", function() TriggerBotEnabled = not TriggerBotEnabled triggerLabel.Text = "TriggerBot: " .. (TriggerBotEnabled and "ON" or "OFF") end)

createButton("Toggle Godmode", function() GodmodeEnabled = not GodmodeEnabled godLabel.Text = "Godmode: " .. (GodmodeEnabled and "ON" or "OFF") end)

createButton("Toggle Infinite Stamina", function() InfiniteStaminaEnabled = not InfiniteStaminaEnabled staminaLabel.Text = "Infinite Stamina: " .. (InfiniteStaminaEnabled and "ON" or "OFF") end)

-- Stamina + Godmode Loop RunService.Heartbeat:Connect(function() if GodmodeEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth end if InfiniteStaminaEnabled then for _, obj in pairs(LocalPlayer.Character:GetDescendants()) do if obj:IsA("NumberValue") and obj.Name:lower():find("stamina") then obj.Value = 100 end end end end)

-- Toggle UI UIS.InputBegan:Connect(function(input, gpe) if input.KeyCode == Enum.KeyCode.RightShift and not gpe then gui.Enabled = not gui.Enabled end end)

