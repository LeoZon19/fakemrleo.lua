--// Rayfield UI Loader
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "fakemrleo SLR Script",
   LoadingTitle = "SLR Loader",
   LoadingSubtitle = "By fakemrleo",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

--// Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

--// Walkspeed Slider
MainTab:CreateSlider({
   Name = "Walkspeed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

--// Infinite Stamina (Moved to Main Tab)
MainTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Flag = "InfiniteStamina",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()

        if Value then
            while Rayfield.Flags["InfiniteStamina"].CurrentValue do
                local stats = char:FindFirstChild("Stamina") or player:FindFirstChild("Stamina")
                if stats and stats:IsA("NumberValue") then
                    stats.Value = 100
                end
                task.wait(0.1)
            end
        end
    end,
})

--// Fly (Hold F)
MainTab:CreateToggle({
   Name = "Fly (Hold F)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
       local UIS = game:GetService("UserInputService")
       local player = game.Players.LocalPlayer
       local char = player.Character or player.CharacterAdded:Wait()
       local hum = char:WaitForChild("HumanoidRootPart")

       local flying = false
       local bodyVel

       local function onInput(input)
           if input.KeyCode == Enum.KeyCode.F then
               if not flying then
                   bodyVel = Instance.new("BodyVelocity")
                   bodyVel.Velocity = Vector3.new(0, 0, 0)
                   bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                   bodyVel.Parent = hum
                   flying = true

                   while flying do
                       bodyVel.Velocity = Vector3.new(0, 50, 0)
                       wait()
                   end
               else
                   flying = false
                   if bodyVel then bodyVel:Destroy() end
               end
           end
       end

       if Value then
           UIS.InputBegan:Connect(onInput)
       end
   end,
})

--// Legit Trigger Bot
CombatTab:CreateToggle({
    Name = "Trigger Bot",
    CurrentValue = false,
    Flag = "TriggerBot",
    Callback = function(Value)
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local mouse = LocalPlayer:GetMouse()

        local connection

        if Value then
            connection = RunService.RenderStepped:Connect(function()
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
                local target = mouse.Target
                if target and target.Parent then
                    local targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
                    if targetPlayer and targetPlayer ~= LocalPlayer then
                        -- Simulate mouse click
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("Handle") then
                            if tool:FindFirstChild("RemoteEvent") then
                                tool.RemoteEvent:FireServer()
                            else
                                tool:Activate()
                            end
                        end
                    end
                end
            end)
        else
            if connection then
                connection:Disconnect()
            end
        end
    end,
})

--// Legit Big Head (Moved to Combat Tab)
CombatTab:CreateToggle({
    Name = "Big Head (Legit)",
    CurrentValue = false,
    Flag = "BigHead",
    Callback = function(Value)
        local Players = game:GetService("Players")
        local function setBigHead(character, enabled)
            local head = character:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                if enabled then
                    head.Size = Vector3.new(10, 10, 10)
                    head.CanCollide = false
                    local mesh = head:FindFirstChildWhichIsA("SpecialMesh")
                    if mesh then mesh:Destroy() end
                else
                    head.Size = Vector3.new(2, 1, 1)
                end
            end
        end

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character then
                setBigHead(player.Character, Value)
            end

            player.CharacterAdded:Connect(function(char)
                if player ~= Players.LocalPlayer then
                    wait(1)
                    setBigHead(char, Value)
                end
            end)
        end

        Players.PlayerAdded:Connect(function(player)
            if player ~= Players.LocalPlayer then
                player.CharacterAdded:Connect(function(char)
                    wait(1)
                    setBigHead(char, Value)
                end)
            end
        end)
    end,
})

--// Highlight Players
VisualsTab:CreateToggle({
   Name = "Highlight Players",
   CurrentValue = false,
   Flag = "HighlightPlayers",
   Callback = function(Value)
       for _, v in pairs(game.Players:GetPlayers()) do
           if v ~= game.Players.LocalPlayer and v.Character then
               if Value then
                   local highlight = Instance.new("Highlight")
                   highlight.FillColor = Color3.new(1, 1, 0)
                   highlight.OutlineColor = Color3.new(1, 1, 1)
                   highlight.Parent = v.Character
                   highlight.Name = "Highlight"
               else
                   if v.Character:FindFirstChild("Highlight") then
                       v.Character.Highlight:Destroy()
                   end
               end
           end
       end
   end,
})

--// Show Usernames Above Players
VisualsTab:CreateToggle({
    Name = "Show Usernames",
    CurrentValue = false,
    Flag = "ShowUsernames",
    Callback = function(Value)
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character then
                if Value then
                    local tag = Instance.new("BillboardGui", plr.Character:WaitForChild("Head"))
                    tag.Size = UDim2.new(0, 100, 0, 40)
                    tag.StudsOffset = Vector3.new(0, 2, 0)
                    tag.Name = "NameDisplay"
                    tag.AlwaysOnTop = true

                    local text = Instance.new("TextLabel", tag)
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.Text = plr.Name
                    text.TextColor3 = Color3.new(1, 1, 1)
                    text.BackgroundTransparency = 1
                    text.TextScaled = true
                else
                    if plr.Character:FindFirstChild("Head") and plr.Character.Head:FindFirstChild("NameDisplay") then
                        plr.Character.Head.NameDisplay:Destroy()
                    end
                end
            end
        end
    end,
})