local ESP_API_LIBRARY = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Vars
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "BestESP"

-- Function
function ESP_API_LIBRARY:CreateESP(Target)
    if not Target or not Target.Character then return end

    local ESP = Instance.new("BillboardGui", ESPFolder)
    ESP.Name = Target.Name .. "_ESP"
    ESP.Adornee = Target.Character:FindFirstChild("HumanoidRootPart")
    ESP.Size = UDim2.new(0, 200, 0, 150)
    ESP.AlwaysOnTop = true
    ESP.StudsOffset = Vector3.new(0, 2, 0)

    -- Name
    local NameLabel = Instance.new("TextLabel", ESP)
    NameLabel.Size = UDim2.new(1, 0, 0.2, 0)
    NameLabel.Position = UDim2.new(0, 0, 0, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextColor3 = Color3.new(1, 1, 1)
    NameLabel.TextStrokeTransparency = 0
    NameLabel.TextScaled = true
    NameLabel.Font = Enum.Font.SourceSansBold

    -- Health
    local HealthLabel = Instance.new("TextLabel", ESP)
    HealthLabel.Size = UDim2.new(1, 0, 0.2, 0)
    HealthLabel.Position = UDim2.new(0, 0, 0.2, 0)
    HealthLabel.BackgroundTransparency = 1
    HealthLabel.TextColor3 = Color3.new(0, 1, 0)
    HealthLabel.TextStrokeTransparency = 0
    HealthLabel.TextScaled = true
    HealthLabel.Font = Enum.Font.SourceSansBold

    -- Distance
    local DistanceLabel = Instance.new("TextLabel", ESP)
    DistanceLabel.Size = UDim2.new(1, 0, 0.2, 0)
    DistanceLabel.Position = UDim2.new(0, 0, 0.4, 0)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.TextColor3 = Color3.new(1, 1, 0)
    DistanceLabel.TextStrokeTransparency = 0
    DistanceLabel.TextScaled = true
    DistanceLabel.Font = Enum.Font.SourceSansBold

    -- Level
    local LevelLabel = Instance.new("TextLabel", ESP)
    LevelLabel.Size = UDim2.new(1, 0, 0.2, 0)
    LevelLabel.Position = UDim2.new(0, 0, 0.6, 0)
    LevelLabel.BackgroundTransparency = 1
    LevelLabel.TextColor3 = Color3.new(0, 1, 1)
    LevelLabel.TextStrokeTransparency = 0
    LevelLabel.TextScaled = true
    LevelLabel.Font = Enum.Font.SourceSansBold

    -- Box (simple frame around)
    local Box = Instance.new("Frame", ESP)
    Box.Size = UDim2.new(1, 0, 1, 0)
    Box.BackgroundTransparency = 1
    Box.BorderSizePixel = 2
    Box.BorderColor3 = Color3.new(1, 0, 0)

    -- Update function
    local function Update()
        if not Target or not Target.Character or not Target.Character:FindFirstChild("Humanoid") or not Target.Character:FindFirstChild("HumanoidRootPart") then
            ESP:Destroy()
            return
        end

        local Humanoid = Target.Character.Humanoid
        local RootPart = Target.Character.HumanoidRootPart

        NameLabel.Text = Target.Name
        HealthLabel.Text = "HP: " .. math.floor(Humanoid.Health) .. "/" .. math.floor(Humanoid.MaxHealth)
        local Dist = (Camera.CFrame.Position - RootPart.Position).Magnitude
        DistanceLabel.Text = "Dist: " .. math.floor(Dist) .. " studs"
        local Level = Target:FindFirstChild("Data") and Target.Data:FindFirstChild("Level") and Target.Data.Level.Value or "N/A"
        LevelLabel.Text = "Level: " .. tostring(Level)

        -- Team color
        local Color = Color3.new(1, 0, 0) -- default red
        if Target.Team then
            if Target.Team.Name == "Pirate" then
                Color = Color3.new(1, 1, 1)
            elseif Target.Team.Name == "Marine" then
                Color = Color3.new(0, 0, 1)
            end
        end
        if Target == LocalPlayer then
            Color = Color3.new(0, 1, 0)
        end
        Box.BorderColor3 = Color
    end

    -- Connect to heartbeat
    local Connection = RunService.Heartbeat:Connect(Update)

    -- Initial update
    Update()

    return ESP
end

return ESP_API_LIBRARY
