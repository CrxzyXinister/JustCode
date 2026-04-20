local ESP_API_LIBRARY = {}

getgenv.esptypes = {
    health = true, --done
    name = true, --done
    distance = true, --done
    box = true, --done
    tracer = true, --done
    level = true, --done
    team = true, --done
    skeleton = true, --done
}

local levelpath = Players.Data.Level.Value

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- // Vars
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "BestESP"

-- // Functions
function ESP_API_LIBRARY:CreateESP(Target, Options)
    local ESP = Instance.new("BillboardGui", ESPFolder)
    ESP.Name = Target.Name .. "_ESP"
    ESP.Adornee = Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") or Target:FindFirstChild("HumanoidRootPart")
    ESP.Size = UDim
    ESP.AlwaysOnTop = true

local NameLabel = Instance.new("TextLabel", ESP)
NameLabel.Name = "Name"
NameLabel.Size = UDim2.new(1, 0, 0.3,)
NameLabel.BackgroundTransparency = 1
NameLabel.TextColor3 = Color3.new(1, 1, 1)
NameLabel.TextStrokeTransparency = 0
NameLabel.TextScaled = true
NameLabel.Font = Enum.Font.SourceSansBold
NameLabel.Text = Target.Name

local HealthLabel = Instance.new("TextLabel", ESP)
HealthLabel.Name = "Health"
HealthLabel.Size = UDim2.new(1, 0, 0.3, 0)
HealthLabel.BackgroundTransparency = 1
HealthLabel.TextColor3 = Color3.new(1, 1, 1)
HealthLabel.TextStrokeTransparency = 0
HealthLabel.TextScaled = true
HealthLabel.Font = Enum.Font.SourceSansBold
HealthLabel.Text = "Health: " .. Target.Character.Humanoid.Health

local DistanceLabel = Instance.new("TextLabel", ESP)
DistanceLabel.Name = "Distance"
DistanceLabel.Size = UDim2.new(1, 0, 0.3)
DistanceLabel.BackgroundTransparency = 1
DistanceLabel.TextColor3 = Color3.new(1, 1, 1)
DistanceLabel.TextStrokeTransparency = 0
DistanceLabel.TextScaled = true
DistanceLabel.Font = Enum.Font.SourceSansBold
DistanceLabel.Text = "Distance: " .. math.floor((Camera.CFrame.Position - Target.Character.HumanoidRootPart.Position).Magnitude)

local Box = Instance.new("Frame", ESP)
Box.Name = "Box"
Box.Size = UDim2.new(1, 0, 1, 0)
Box.BackgroundTransparency = 1
Box.BorderSizePixel = 2
Box.BorderColor3 = Color3.new(1, 0, 0)

local LevelLabel = Instance.new("TextLabel", ESP)
LevelLabel.Name = "Level"
LevelLabel.Size = UDim2.new(1, 0, 0.3, 0)
LevelLabel.BackgroundTransparency = 1
LevelLabel.TextColor3 = Color3.new(1, 1, 1)
LevelLabel.TextStrokeTransparency = 0
LevelLabel.TextScaled = true
LevelLabel.Font = Enum.Font.SourceSansBold
LevelLabel.Text = "Level: " .. levelpath

local Tracer = Instance.new("Frame", ESP)
Tracer.Name = "Tracer"
Tracer.Size = UDim2.new(0, 1, 1, 0)
Tracer.BackgroundTransparency = 1
Tracer.BorderSizePixel = 2
Tracer.BorderColor3 = Color3.new(1, 0, 0)

local Skeleton = Instance.new("Frame", ESP)
Skeleton.Name = "Skeleton"
Skeleton.Size = UDim2.new(1, 0, 1, 0)
Skeleton.BackgroundTransparency = 1
Skeleton.BorderSizePixel = 0
Skeleton.BorderColor3 = Color3.new(1, 0, 0)


local SkeletonJoints = {
    "Head",
    "UpperTorso",
    "LowerTorso",
    "LeftUpperArm",
    "LeftLowerArm",
    "LeftHand",
    "RightUpperArm",
    "RightLowerArm",
    "RightHand",
    "LeftUpperLeg",
    "LeftLowerLeg",
    "LeftFoot",
    "RightUpperLeg",
    "RightLowerLeg",
    "RightFoot"
}

local TracerLogic = RunService.Heartbeat:Connect(function()
    if Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
        local StartPos = Camera.CFramde.Position)
        local EndPos = Target.Character.HumanoidRootPart.Position

local TeamLogic = RunService.Heartbeat:Connect(function()
    if Target.TeamColor == LocalPlayer.TeamColor then
        Box.BorderColor3 = Color3.new(0, 1, 0)
        Tracer.BorderColor3 = Color3.new(0, 1, 0)
        Skeleton.BorderColor3 = Color3.new(0, 1, 0)
    else
        Box.BorderColor3 = Color3.new(1, 0, 0)
        Tracer.BorderColor3 = Color3.new(1, 0, 0)
        Skeleton.BorderColor3 = Color3.new(1, 0, 0)
    end
end)

if Team is = {
    "Pirate" then --Red ESP
        Box.BorderColor3 = Color3.new(255, 255, 255)
        Tracer.BorderColor3 = Color3.new(255, 255, 255)
        Skeleton.BorderColor3 = Color3.new(255, 255, 255)
    elseif Target.TeamColor == "Marine" then --Blue ESP
        Box.BorderColor3 = Color3.new(0, 0, 255)
        Tracer.BorderColor3 = Color3.new(0, 0, 255)
        Skeleton.BorderColor3 = Color3.new(0, 0, 255)
    }


    RunService.Heartbeat:Connect(function()
        if Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            ESP.Adornee = Target.Character.HumanoidRootPart
        end
    end)
end
