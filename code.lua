-- Roblox ESP System API
-- Usage example:
-- local ESP = require(path.to.this.module)
-- local esp = ESP.new({
--     Enabled = true,
--     Boxes = true,
--     Tracers = true,
--     Names = true,
--     Distances = true,
--     Health = true,
--     ShowTeam = false,
--     ShowAllies = false,
--     ShowEnemies = true,
-- })
-- esp:AddPlayer(game.Players.SomePlayer)
-- esp:Destroy()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera or Workspace:WaitForChild("CurrentCamera")

assert(typeof(Drawing) == "table", "Drawing API is required for this ESP system")

local ESP = {}
ESP.__index = ESP

local DefaultConfig = {
    Enabled = true,
    Boxes = true,
    Tracers = true,
    Names = true,
    Distances = true,
    Health = true,
    Fill = false,
    ShowTeam = false,
    ShowAllies = false,
    ShowEnemies = true,
    TeamColor = true,
    EnemiesColor = Color3.fromRGB(255, 80, 80),
    AlliesColor = Color3.fromRGB(0, 175, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    Outline = true,
    OutlineColor = Color3.fromRGB(0, 0, 0),
    Transparency = 1,
    FillTransparency = 0.2,
    Thickness = 1,
    DistanceFrom = Vector2.new(0.5, 1),
    MaxDistance = 0,
    HideIfDead = true,
    ShowInvisibles = false,
}

local function mergeConfig(base, override)
    local config = {}
    for key, value in pairs(base) do
        config[key] = value
    end
    if override then
        for key, value in pairs(override) do
            config[key] = value
        end
    end
    return config
end

local function isAlive(humanoid)
    return humanoid and humanoid.Health > 0 and humanoid.Parent
end

local function getTargetColor(player, config)
    if config.TeamColor and player.TeamColor then
        return player.TeamColor.Color
    end
    local localPlayer = Players.LocalPlayer
    if localPlayer and localPlayer.Team and player.Team == localPlayer.Team then
        return config.AlliesColor
    end
    return config.EnemiesColor
end

local function isAlly(player)
    local localPlayer = Players.LocalPlayer
    if not localPlayer or not localPlayer.Team then
        return false
    end
    return player.Team == localPlayer.Team
end

local function createDrawing(typeName)
    local drawing = Drawing.new(typeName)
    drawing.Visible = false
    return drawing
end

local function findTargetPart(instance)
    if not instance or not instance.Parent then
        return nil
    end

    if instance:IsA("BasePart") then
        return instance
    end

    if instance:IsA("Model") then
        if instance.PrimaryPart and instance.PrimaryPart:IsA("BasePart") then
            return instance.PrimaryPart
        end
        local candidate = instance:FindFirstChild("HumanoidRootPart") or instance:FindFirstChild("LowerTorso") or instance:FindFirstChild("UpperTorso")
        if candidate and candidate:IsA("BasePart") then
            return candidate
        end
        for _, child in ipairs(instance:GetDescendants()) do
            if child:IsA("BasePart") then
                return child
            end
        end
    end

    return nil
end

local function getBoundingCorners(cframe, size)
    local half = size * 0.5
    local corners = {}
    for _, x in ipairs({-half.X, half.X}) do
        for _, y in ipairs({-half.Y, half.Y}) do
            for _, z in ipairs({-half.Z, half.Z}) do
                table.insert(corners, cframe * Vector3.new(x, y, z))
            end
        end
    end
    return corners
end

local function projectPoint(point)
    local screenPoint, onScreen = Camera:WorldToViewportPoint(point)
    return Vector2.new(screenPoint.X, screenPoint.Y), onScreen, screenPoint.Z
end

local function createTargetDrawings(config)
    local drawings = {}
    if config.Boxes then
        drawings.Box = createDrawing("Quad")
        drawings.Box.Filled = config.Fill
        drawings.Box.Transparency = config.Transparency
        drawings.Box.Thickness = config.Thickness
        drawings.Box.FillTransparency = config.Fill and config.FillTransparency or 1
    end
    if config.Tracers then
        drawings.Tracer = createDrawing("Line")
        drawings.Tracer.Thickness = config.Thickness
        drawings.Tracer.Transparency = config.Transparency
    end
    if config.Names then
        drawings.Name = createDrawing("Text")
        drawings.Name.Size = config.TextSize
        drawings.Name.Color = config.TextColor
        drawings.Name.Outline = config.Outline
        drawings.Name.OutlineColor = config.OutlineColor
        drawings.Name.Center = true
    end
    if config.Distances then
        drawings.Distance = createDrawing("Text")
        drawings.Distance.Size = config.TextSize
        drawings.Distance.Color = config.TextColor
        drawings.Distance.Outline = config.Outline
        drawings.Distance.OutlineColor = config.OutlineColor
        drawings.Distance.Center = true
    end
    if config.Health then
        drawings.Health = createDrawing("Text")
        drawings.Health.Size = config.TextSize
        drawings.Health.Color = config.TextColor
        drawings.Health.Outline = config.Outline
        drawings.Health.OutlineColor = config.OutlineColor
        drawings.Health.Center = true
    end
    return drawings
end

local function createTargetData(instance, config)
    local targetPart = findTargetPart(instance)
    if not targetPart then
        return nil
    end

    local target = {
        Instance = instance,
        TargetPart = targetPart,
        Config = mergeConfig(DefaultConfig, config),
        Drawings = createTargetDrawings(mergeConfig(DefaultConfig, config)),
    }
    return target
end

local function updateDrawingVisibility(drawings, visible)
    for _, drawing in pairs(drawings) do
        drawing.Visible = visible
    end
end

local function updateTargetData(target)
    local instance = target.Instance
    if not instance or not instance.Parent then
        return false
    end

    if target.Instance:IsA("Player") then
        local player = target.Instance
        if not player.Character or not player.Character.Parent then
            return false
        end
        local rootPart = findTargetPart(player.Character)
        if not rootPart then
            return false
        end
        target.TargetPart = rootPart
        target.Humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    else
        if not target.TargetPart or not target.TargetPart.Parent then
            local part = findTargetPart(target.Instance)
            if not part then
                return false
            end
            target.TargetPart = part
        end
    end

    return true
end

function ESP.new(config)
    local self = setmetatable({}, ESP)
    self.Config = mergeConfig(DefaultConfig, config)
    self.Targets = {}
    self._connections = {}
    self._running = false
    self:_start()
    return self
end

function ESP:SetConfig(config)
    self.Config = mergeConfig(self.Config, config)
    for target, data in pairs(self.Targets) do
        data.Config = mergeConfig(DefaultConfig, mergeConfig(self.Config, config))
        for name, drawing in pairs(data.Drawings) do
            if name == "Box" then
                drawing.Filled = data.Config.Fill
                drawing.FillTransparency = data.Config.Fill and data.Config.FillTransparency or 1
                drawing.Thickness = data.Config.Thickness
                drawing.Transparency = data.Config.Transparency
            elseif name == "Tracer" then
                drawing.Thickness = data.Config.Thickness
                drawing.Transparency = data.Config.Transparency
            else
                drawing.Size = data.Config.TextSize
                drawing.Color = data.Config.TextColor
                drawing.Outline = data.Config.Outline
                drawing.OutlineColor = data.Config.OutlineColor
            end
        end
    end
end

function ESP:_shouldRender(target, screenPos, onScreen, distance)
    local config = target.Config
    if not config.Enabled then
        return false
    end

    if config.MaxDistance > 0 and distance > config.MaxDistance then
        return false
    end

    if target.Instance:IsA("Player") then
        local player = target.Instance
        if player == Players.LocalPlayer then
            return false
        end
        if config.HideIfDead and target.Humanoid and not isAlive(target.Humanoid) then
            return false
        end
        if not config.ShowInvisibles and target.TargetPart.Transparency == 1 then
            return false
        end
        local ally = isAlly(player)
        if ally then
            return config.ShowAllies or config.ShowTeam
        end
        return config.ShowEnemies
    end

    return true
end

function ESP:_start()
    if self._running then
        return
    end

    self._running = true
    self._connections.RenderStepped = RunService.RenderStepped:Connect(function()
        for instance, target in pairs(self.Targets) do
            if not updateTargetData(target) then
                self:RemoveTarget(instance)
                continue
            end

            local part = target.TargetPart
            local size = part.Size
            local cframe = part.CFrame
            local corners = getBoundingCorners(cframe, size)
            local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
            local onScreen = false
            local farPlane = 0
            for _, corner in ipairs(corners) do
                local screenPos, visible, depth = projectPoint(corner)
                if visible then
                    onScreen = true
                    minX = math.min(minX, screenPos.X)
                    minY = math.min(minY, screenPos.Y)
                    maxX = math.max(maxX, screenPos.X)
                    maxY = math.max(maxY, screenPos.Y)
                end
                farPlane = math.max(farPlane, depth)
            end

            local center3D = cframe.Position
            local screenCenter, centerVisible, centerDepth = projectPoint(center3D)
            local distance = (Camera.CFrame.Position - center3D).Magnitude
            local shouldRender = self:_shouldRender(target, screenCenter, onScreen or centerVisible, distance)
            updateDrawingVisibility(target.Drawings, shouldRender)
            if not shouldRender then
                continue
            end

            local color = target.Instance:IsA("Player") and getTargetColor(target.Instance, target.Config) or target.Config.TextColor
            if target.Drawings.Box then
                target.Drawings.Box.Color = color
                target.Drawings.Box.PointA = Vector2.new(minX, minY)
                target.Drawings.Box.PointB = Vector2.new(maxX, minY)
                target.Drawings.Box.PointC = Vector2.new(maxX, maxY)
                target.Drawings.Box.PointD = Vector2.new(minX, maxY)
            end

            if target.Drawings.Tracer then
                target.Drawings.Tracer.Color = color
                local origin = Vector2.new(Camera.ViewportSize.X * target.Config.DistanceFrom.X, Camera.ViewportSize.Y * target.Config.DistanceFrom.Y)
                target.Drawings.Tracer.From = origin
                target.Drawings.Tracer.To = screenCenter
            end

            if target.Drawings.Name then
                target.Drawings.Name.Color = color
                target.Drawings.Name.Position = Vector2.new(screenCenter.X, minY - 18)
                target.Drawings.Name.Text = target.Instance:IsA("Player") and target.Instance.Name or target.Instance.Name
            end

            if target.Drawings.Distance then
                target.Drawings.Distance.Color = color
                target.Drawings.Distance.Position = Vector2.new(screenCenter.X, maxY + 2)
                target.Drawings.Distance.Text = string.format("%.0f studs", distance)
            end

            if target.Drawings.Health then
                local healthText = ""
                if target.Humanoid then
                    healthText = string.format("HP: %.0f", target.Humanoid.Health)
                elseif target.Instance:IsA("BasePart") then
                    healthText = target.Instance.Name
                end
                target.Drawings.Health.Color = Color3.fromRGB(255, 255, 255)
                target.Drawings.Health.Position = Vector2.new(screenCenter.X, maxY + 18)
                target.Drawings.Health.Text = healthText
            end
        end
    end)
end

function ESP:AddPlayer(player, config)
    if not player or not player:IsA("Player") or player == Players.LocalPlayer then
        return
    end

    if self.Targets[player] then
        return
    end

    local target = createTargetData(player, mergeConfig(self.Config, config))
    if not target then
        return
    end
    target.Instance = player
    self.Targets[player] = target

    self._connections[player] = player.CharacterAdded:Connect(function()
        updateTargetData(target)
    end)
end

function ESP:AddObject(instance, config)
    if not instance or not instance.Parent then
        return
    end
    if self.Targets[instance] then
        return
    end

    local target = createTargetData(instance, mergeConfig(self.Config, config))
    if not target then
        return
    end
    self.Targets[instance] = target
end

function ESP:RemoveTarget(instance)
    local target = self.Targets[instance]
    if not target then
        return
    end
    for _, drawing in pairs(target.Drawings) do
        drawing:Remove()
    end
    self.Targets[instance] = nil
    if self._connections[instance] then
        self._connections[instance]:Disconnect()
        self._connections[instance] = nil
    end
end

function ESP:Enable()
    self.Config.Enabled = true
end

function ESP:Disable()
    self.Config.Enabled = false
    for _, target in pairs(self.Targets) do
        updateDrawingVisibility(target.Drawings, false)
    end
end

function ESP:Destroy()
    for instance, target in pairs(self.Targets) do
        self:RemoveTarget(instance)
    end
    if self._connections.RenderStepped then
        self._connections.RenderStepped:Disconnect()
        self._connections.RenderStepped = nil
    end
    self._running = false
end

return ESP
