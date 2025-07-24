--// Rayfield UI Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local flyEnabled = false
local noclipEnabled = false
local triggerBotEnabled = false
local lockOnAimbotEnabled = false
local staminaEnabled = false

local targetPart = "UpperTorso"
local walkspeed = 16

local Window = Rayfield:CreateWindow({
   Name = "fakemrleo UI",
   LoadingTitle = "fakemrleo",
   LoadingSubtitle = "by fakemrleo",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- WalkSpeed Slider
MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
       walkspeed = Value
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed
       end
   end,
})

-- Fly Toggle
MainTab:CreateToggle({
   Name = "Fly (Hold F)",
   CurrentValue = false,
   Callback = function(Value)
       flyEnabled = Value
   end,
})

-- Noclip Toggle
MainTab:CreateToggle({
   Name = "NoClip (Hold G)",
   CurrentValue = false,
   Callback = function(Value)
       noclipEnabled = Value
   end,
})

-- Highlight Players
MainTab:CreateToggle({
   Name = "Highlight Players",
   CurrentValue = false,
   Callback = function(Value)
       for _, player in pairs(Players:GetPlayers()) do
           if player ~= LocalPlayer and player.Character then
               if Value then
                   local highlight = Instance.new("Highlight", player.Character)
                   highlight.Name = "HighlightESP"
                   highlight.FillColor = Color3.new(1, 0, 0)
                   highlight.OutlineColor = Color3.new(1, 1, 1)
               else
                   if player.Character:FindFirstChild("HighlightESP") then
                       player.Character.HighlightESP:Destroy()
                   end
               end
           end
       end
   end,
})

-- Show Usernames
MainTab:CreateToggle({
   Name = "Show Usernames",
   CurrentValue = false,
   Callback = function(Value)
       for _, player in pairs(Players:GetPlayers()) do
           if player ~= LocalPlayer and player.Character then
               if Value then
                   if not player.Character:FindFirstChild("NameTag") then
                       local billboard = Instance.new("BillboardGui", player.Character)
                       billboard.Name = "NameTag"
                       billboard.Size = UDim2.new(0, 100, 0, 40)
                       billboard.StudsOffset = Vector3.new(0, 3, 0)
                       billboard.AlwaysOnTop = true

                       local label = Instance.new("TextLabel", billboard)
                       label.Size = UDim2.new(1, 0, 1, 0)
                       label.Text = player.Name
                       label.BackgroundTransparency = 1
                       label.TextColor3 = Color3.new(1, 1, 1)
                       label.TextStrokeTransparency = 0
                   end
               else
                   if player.Character:FindFirstChild("NameTag") then
                       player.Character.NameTag:Destroy()
                   end
               end
           end
       end
   end,
})

-- Infinite Stamina
MainTab:CreateToggle({
   Name = "Infinite Stamina",
   CurrentValue = false,
   Callback = function(Value)
       staminaEnabled = Value
   end,
})

-- Trigger Bot
MainTab:CreateToggle({
   Name = "Trigger Bot",
   CurrentValue = false,
   Callback = function(Value)
       triggerBotEnabled = Value
   end,
})

-- Lock-On Aimbot
MainTab:CreateToggle({
   Name = "Lock-On Aimbot",
   CurrentValue = false,
   Callback = function(Value)
       lockOnAimbotEnabled = Value
   end,
})

--// Fly + NoClip
RunService.RenderStepped:Connect(function()
   if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
       local root = LocalPlayer.Character.HumanoidRootPart
       if flyEnabled and UserInputService:IsKeyDown(Enum.KeyCode.F) then
           root.Velocity = Vector3.new(0, 50, 0)
       end
       if noclipEnabled and UserInputService:IsKeyDown(Enum.KeyCode.G) then
           for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
               if part:IsA("BasePart") then
                   part.CanCollide = false
               end
           end
       end
   end
end)

--// Infinite Stamina loop
task.spawn(function()
   while true do
       if staminaEnabled and LocalPlayer.Character then
           for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
               if v:IsA("NumberValue") and string.lower(v.Name):find("stamina") then
                   v.Value = 100
               end
           end
       end
       wait(0.1)
   end
end)

--// Trigger Bot + Lock-On Aimbot
RunService.RenderStepped:Connect(function()
   if Camera and triggerBotEnabled then
       local target = nil
       local closestDist = math.huge
       for _, player in pairs(Players:GetPlayers()) do
           if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild(targetPart) then
               local part = player.Character[targetPart]
               local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
               if onScreen then
                   local mouse = UserInputService:GetMouseLocation()
                   local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - mouse).Magnitude
                   if dist < 30 and dist < closestDist then
                       closestDist = dist
                       target = part
                   end
               end
           end
       end
       if target then
           mouse1click()
       end
   end

   if lockOnAimbotEnabled then
       local target = nil
       local shortest = math.huge
       for _, player in pairs(Players:GetPlayers()) do
           if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(targetPart) then
               local part = player.Character[targetPart]
               local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
               if onScreen then
                   local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - UserInputService:GetMouseLocation()).Magnitude
                   if dist < shortest then
                       shortest = dist
                       target = part
                   end
               end
           end
       end
       if target then
           Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
       end
   end
end)