-- Apple UI Library - Dark, Draggable, Apple-Inspired Floating Window

local Apple = {}

-- Color Scheme (Apple Dark Mode Inspired)
local Colors = {
    Background = Color3.fromRGB(28, 28, 30),
    Secondary = Color3.fromRGB(44, 44, 46),
    Tertiary = Color3.fromRGB(58, 58, 60),
    Accent = Color3.fromRGB(10, 132, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(142, 142, 147),
    Success = Color3.fromRGB(48, 209, 88),
    Warning = Color3.fromRGB(255, 204, 0),
    Error = Color3.fromRGB(255, 59, 48),
    Border = Color3.fromRGB(72, 72, 74)
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Utility Functions
local function CreateInstance(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function AddCorner(parent, radius)
    local corner = CreateInstance("UICorner", {CornerRadius = UDim.new(0, radius), Parent = parent})
    return corner
end

local function AddStroke(parent, color, thickness)
    local stroke = CreateInstance("UIStroke", {
        Color = color or Colors.Border,
        Thickness = thickness or 1,
        Parent = parent
    })
    return stroke
end

-- Main Window Creation
function Apple:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Apple UI"
    local size = config.Size or UDim2.new(0, 450, 0, 350)
    local position = config.Position or UDim2.new(0.5, -225, 0.5, -175)
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightShift

    -- ScreenGui
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "AppleUI",
        Parent = game.CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Main Frame
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Colors.Background,
        Size = size,
        Position = position,
        BorderSizePixel = 0
    })
    AddCorner(MainFrame, 12)
    AddStroke(MainFrame, Colors.Border, 1)

    -- Title Bar
    local TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = Colors.Secondary,
        Size = UDim2.new(1, 0, 0, 40),
        BorderSizePixel = 0
    })
    AddCorner(TitleBar, 12)

    -- Title Label
    local TitleLabel = CreateInstance("TextLabel", {
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Text = title,
        TextColor3 = Colors.Text,
        TextSize = 16,
        Font = Enum.Font.SourceSansSemibold,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Control Buttons
    local CloseButton = CreateInstance("TextButton", {
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        Text = "×",
        TextColor3 = Colors.Text,
        TextSize = 20,
        Font = Enum.Font.SourceSansBold
    })
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local MinimizeButton = CreateInstance("TextButton", {
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -70, 0, 5),
        Text = "−",
        TextColor3 = Colors.Text,
        TextSize = 20,
        Font = Enum.Font.SourceSansBold
    })
    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- Dragging Functionality
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function updateInput(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)

    -- Content Container
    local ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 50)
    })

    -- Tab System
    local Tabs = {}
    local CurrentTab = nil

    local TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Parent = ContentContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 0)
    })

    local TabContent = CreateInstance("Frame", {
        Name = "TabContent",
        Parent = ContentContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -35),
        Position = UDim2.new(0, 0, 0, 35)
    })

    local function SwitchTab(tab)
        if CurrentTab then
            CurrentTab.Button.BackgroundColor3 = Colors.Secondary
            CurrentTab.Frame.Visible = false
        end
        CurrentTab = tab
        tab.Button.BackgroundColor3 = Colors.Accent
        tab.Frame.Visible = true
    end

    -- Window Object
    local Window = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Tabs = Tabs,
        ToggleKey = toggleKey
    }

    function Window:AddTab(name)
        local TabButton = CreateInstance("TextButton", {
            Parent = TabContainer,
            BackgroundColor3 = Colors.Secondary,
            Size = UDim2.new(0, 100, 0, 30),
            Position = UDim2.new(0, (#Tabs) * 105, 0, 0),
            Text = name,
            TextColor3 = Colors.Text,
            TextSize = 14,
            Font = Enum.Font.SourceSansSemibold,
            BorderSizePixel = 0
        })
        AddCorner(TabButton, 6)

        local TabFrame = CreateInstance("ScrollingFrame", {
            Parent = TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Colors.Accent,
            Visible = false
        })

        local Tab = {
            Button = TabButton,
            Frame = TabFrame,
            Elements = {},
            YOffset = 0
        }

        TabButton.MouseButton1Click:Connect(function()
            SwitchTab(Tab)
        end)

        table.insert(Tabs, Tab)
        if #Tabs == 1 then
            SwitchTab(Tab)
        end

        -- Tab Methods
        function Tab:AddButton(config)
            config = config or {}
            local name = config.Name or "Button"
            local callback = config.Callback or function() end

            local Button = CreateInstance("TextButton", {
                Parent = self.Frame,
                BackgroundColor3 = Colors.Secondary,
                Size = UDim2.new(1, -10, 0, 35),
                Position = UDim2.new(0, 5, 0, self.YOffset),
                Text = name,
                TextColor3 = Colors.Text,
                TextSize = 14,
                Font = Enum.Font.SourceSans,
                BorderSizePixel = 0
            })
            AddCorner(Button, 6)

            Button.MouseButton1Click:Connect(function()
                callback()
            end)

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Tertiary}):Play()
            end)

            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Secondary}):Play()
            end)

            self.YOffset = self.YOffset + 40
            self.Frame.CanvasSize = UDim2.new(0, 0, 0, self.YOffset)
            table.insert(self.Elements, Button)
        end

        function Tab:AddToggle(config)
            config = config or {}
            local name = config.Name or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end

            local ToggleFrame = CreateInstance("Frame", {
                Parent = self.Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 35),
                Position = UDim2.new(0, 5, 0, self.YOffset)
            })

            local ToggleLabel = CreateInstance("TextLabel", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Text = name,
                TextColor3 = Colors.Text,
                TextSize = 14,
                Font = Enum.Font.SourceSans,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ToggleButton = CreateInstance("TextButton", {
                Parent = ToggleFrame,
                BackgroundColor3 = default and Colors.Success or Colors.Secondary,
                Size = UDim2.new(0, 35, 0, 35),
                Position = UDim2.new(1, -40, 0, 0),
                Text = default and "✓" or "",
                TextColor3 = Colors.Text,
                TextSize = 16,
                Font = Enum.Font.SourceSansBold,
                BorderSizePixel = 0
            })
            AddCorner(ToggleButton, 6)

            local toggled = default
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = toggled and Colors.Success or Colors.Secondary
                }):Play()
                ToggleButton.Text = toggled and "✓" or ""
                callback(toggled)
            end)

            self.YOffset = self.YOffset + 40
            self.Frame.CanvasSize = UDim2.new(0, 0, 0, self.YOffset)
            table.insert(self.Elements, ToggleFrame)
        end

        function Tab:AddSlider(config)
            config = config or {}
            local name = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or 50
            local callback = config.Callback or function() end

            local SliderFrame = CreateInstance("Frame", {
                Parent = self.Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 55),
                Position = UDim2.new(0, 5, 0, self.YOffset)
            })

            local SliderLabel = CreateInstance("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Position = UDim2.new(0, 0, 0, 0),
                Text = name .. ": " .. tostring(default),
                TextColor3 = Colors.Text,
                TextSize = 14,
                Font = Enum.Font.SourceSans,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local SliderBar = CreateInstance("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = Colors.Secondary,
                Size = UDim2.new(1, 0, 0, 8),
                Position = UDim2.new(0, 0, 0, 25),
                BorderSizePixel = 0
            })
            AddCorner(SliderBar, 4)

            local SliderFill = CreateInstance("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = Colors.Accent,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                BorderSizePixel = 0
            })
            AddCorner(SliderFill, 4)

            local SliderKnob = CreateInstance("TextButton", {
                Parent = SliderBar,
                BackgroundColor3 = Colors.Text,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new((default - min) / (max - min), -8, 0, -4),
                Text = "",
                BorderSizePixel = 0
            })
            AddCorner(SliderKnob, 8)

            local dragging = false
            local function updateSlider(input)
                local relativeX = input.Position.X - SliderBar.AbsolutePosition.X
                local percent = math.clamp(relativeX / SliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * percent + 0.5)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderKnob.Position = UDim2.new(percent, -8, 0, -4)
                SliderLabel.Text = name .. ": " .. tostring(value)
                callback(value)
            end

            SliderKnob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            SliderKnob.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)

            self.YOffset = self.YOffset + 60
            self.Frame.CanvasSize = UDim2.new(0, 0, 0, self.YOffset)
            table.insert(self.Elements, SliderFrame)
        end

        function Tab:AddDropdown(config)
            config = config or {}
            local name = config.Name or "Dropdown"
            local options = config.Options or {"Option 1", "Option 2"}
            local default = config.Default or options[1]
            local callback = config.Callback or function() end

            local DropdownFrame = CreateInstance("Frame", {
                Parent = self.Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 35),
                Position = UDim2.new(0, 5, 0, self.YOffset)
            })

            local DropdownButton = CreateInstance("TextButton", {
                Parent = DropdownFrame,
                BackgroundColor3 = Colors.Secondary,
                Size = UDim2.new(1, 0, 1, 0),
                Text = name .. ": " .. default,
                TextColor3 = Colors.Text,
                TextSize = 14,
                Font = Enum.Font.SourceSans,
                BorderSizePixel = 0
            })
            AddCorner(DropdownButton, 6)

            local DropdownList = CreateInstance("Frame", {
                Parent = DropdownFrame,
                BackgroundColor3 = Colors.Background,
                Size = UDim2.new(1, 0, 0, #options * 30),
                Position = UDim2.new(0, 0, 1, 2),
                Visible = false,
                BorderSizePixel = 0
            })
            AddCorner(DropdownList, 6)
            AddStroke(DropdownList, Colors.Border, 1)

            for i, option in ipairs(options) do
                local OptionButton = CreateInstance("TextButton", {
                    Parent = DropdownList,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    Position = UDim2.new(0, 0, 0, (i-1) * 30),
                    Text = option,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    Font = Enum.Font.SourceSans,
                    BorderSizePixel = 0
                })

                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = name .. ": " .. option
                    DropdownList.Visible = false
                    callback(option)
                end)

                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Tertiary}):Play()
                end)

                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
                end)
            end

            DropdownButton.MouseButton1Click:Connect(function()
                DropdownList.Visible = not DropdownList.Visible
            end)

            self.YOffset = self.YOffset + 40
            self.Frame.CanvasSize = UDim2.new(0, 0, 0, self.YOffset)
            table.insert(self.Elements, DropdownFrame)
        end

        function Tab:AddDivider()
            local Divider = CreateInstance("Frame", {
                Parent = self.Frame,
                BackgroundColor3 = Colors.Border,
                Size = UDim2.new(1, -10, 0, 1),
                Position = UDim2.new(0, 5, 0, self.YOffset + 5),
                BorderSizePixel = 0
            })

            self.YOffset = self.YOffset + 15
            self.Frame.CanvasSize = UDim2.new(0, 0, 0, self.YOffset)
            table.insert(self.Elements, Divider)
        end

        return Tab
    end

    function Window:Notify(config)
        config = config or {}
        local title = config.Title or "Notification"
        local content = config.Content or ""
        local type = config.Type or "Info"

        local NotifFrame = CreateInstance("Frame", {
            Parent = ScreenGui,
            BackgroundColor3 = Colors.Background,
            Size = UDim2.new(0, 320, 0, 80),
            Position = UDim2.new(1, 10, 1, -100 - (#ScreenGui:GetChildren() * 90)),
            BorderSizePixel = 0
        })
        AddCorner(NotifFrame, 8)
        AddStroke(NotifFrame, Colors.Border, 1)

        local NotifTitle = CreateInstance("TextLabel", {
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 25),
            Position = UDim2.new(0, 10, 0, 5),
            Text = title,
            TextColor3 = Colors.Text,
            TextSize = 16,
            Font = Enum.Font.SourceSansSemibold,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local NotifContent = CreateInstance("TextLabel", {
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 35),
            Position = UDim2.new(0, 10, 0, 30),
            Text = content,
            TextColor3 = Colors.TextSecondary,
            TextSize = 13,
            Font = Enum.Font.SourceSans,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })

        -- Type-based coloring
        if type == "Success" then
            NotifFrame.BackgroundColor3 = Colors.Success
            NotifTitle.TextColor3 = Color3.new(1, 1, 1)
            NotifContent.TextColor3 = Color3.new(1, 1, 1)
        elseif type == "Warning" then
            NotifFrame.BackgroundColor3 = Colors.Warning
            NotifTitle.TextColor3 = Color3.new(0, 0, 0)
            NotifContent.TextColor3 = Color3.new(0, 0, 0)
        elseif type == "Error" then
            NotifFrame.BackgroundColor3 = Colors.Error
            NotifTitle.TextColor3 = Color3.new(1, 1, 1)
            NotifContent.TextColor3 = Color3.new(1, 1, 1)
        end

        -- Animation
        NotifFrame.Position = UDim2.new(1, 330, 1, -100 - (#ScreenGui:GetChildren() * 90))
        TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
            Position = UDim2.new(1, -330, 1, -100 - (#ScreenGui:GetChildren() * 90))
        }):Play()

        task.delay(4, function()
            if NotifFrame and NotifFrame.Parent then
                TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                    Position = UDim2.new(1, 330, 1, -100 - (#ScreenGui:GetChildren() * 90))
                }):Play()
                task.wait(0.5)
                NotifFrame:Destroy()
            end
        end)
    end

    -- Key Toggle
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == toggleKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    return Window
end

return Apple
    Success = Color3.fromRGB(0, 255, 0),
    Warning = Color3.fromRGB(255, 255, 0),
    Error = Color3.fromRGB(255, 0, 0)
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- CreateWindow function
function AppleLibrary:CreateWindow(title, size, position)
    local Window = Instance.new("ScreenGui")
    Window.Name = "AppleLibrary"
    Window.Parent = game.CoreGui
    Window.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Window
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.Size = size or UDim2.new(0, 400, 0, 300)
    MainFrame.Position = position or UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BorderSizePixel = 0

    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Colors.Secondary
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BorderSizePixel = 0

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Text = title or "Apple Library"
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.SourceSansSemibold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)

    -- Minimize button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Parent = TitleBar
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Colors.Text
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- Dragging
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function updateInput(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)

    -- Content frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    ContentFrame.Position = UDim2.new(0, 0, 0, 30)

    -- Tab system
    local Tabs = {}
    local CurrentTab = nil

    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Parent = ContentFrame
    TabButtons.BackgroundTransparency = 1
    TabButtons.Size = UDim2.new(1, 0, 0, 30)
    TabButtons.Position = UDim2.new(0, 0, 0, 0)

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = ContentFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, 0, 1, -30)
    TabContainer.Position = UDim2.new(0, 0, 0, 30)

    local function SwitchTab(tab)
        if CurrentTab then
            CurrentTab.Frame.Visible = false
        end
        CurrentTab = tab
        tab.Frame.Visible = true
    end

    local WindowObject = {
        Tabs = Tabs,
        MainFrame = MainFrame,
        AddTab = function(self, name)
            local TabButton = Instance.new("TextButton")
            TabButton.Parent = TabButtons
            TabButton.BackgroundColor3 = Colors.Secondary
            TabButton.Size = UDim2.new(0, 80, 0, 25)
            TabButton.Position = UDim2.new(0, #Tabs * 85, 0, 0)
            TabButton.Text = name
            TabButton.TextColor3 = Colors.Text
            TabButton.TextSize = 12
            TabButton.Font = Enum.Font.SourceSans
            local TabCorner = Instance.new("UICorner")
            TabCorner.CornerRadius = UDim.new(0, 5)
            TabCorner.Parent = TabButton

            local TabFrame = Instance.new("ScrollingFrame")
            TabFrame.Parent = TabContainer
            TabFrame.BackgroundTransparency = 1
            TabFrame.Size = UDim2.new(1, 0, 1, 0)
            TabFrame.ScrollBarThickness = 5
            TabFrame.Visible = false

            local Tab = {
                Frame = TabFrame,
                Elements = {},
                YOffset = 0
            }

            TabButton.MouseButton1Click:Connect(function()
                SwitchTab(Tab)
            end)

            table.insert(Tabs, Tab)
            if #Tabs == 1 then
                SwitchTab(Tab)
            end

            return Tab
        end,
        Notify = function(self, title, content, type)
            -- Notification system
            local NotifFrame = Instance.new("Frame")
            NotifFrame.Parent = Window
            NotifFrame.BackgroundColor3 = Colors.Background
            NotifFrame.Size = UDim2.new(0, 300, 0, 80)
            NotifFrame.Position = UDim2.new(1, -320, 1, -100 - (#Window:GetChildren() - 1) * 90)
            NotifFrame.BorderSizePixel = 0
            local NotifCorner = Instance.new("UICorner")
            NotifCorner.CornerRadius = UDim.new(0, 10)
            NotifCorner.Parent = NotifFrame

            local NotifTitle = Instance.new("TextLabel")
            NotifTitle.Parent = NotifFrame
            NotifTitle.BackgroundTransparency = 1
            NotifTitle.Size = UDim2.new(1, -20, 0, 20)
            NotifTitle.Position = UDim2.new(0, 10, 0, 5)
            NotifTitle.Text = title
            NotifTitle.TextColor3 = Colors.Text
            NotifTitle.TextSize = 14
            NotifTitle.Font = Enum.Font.SourceSansSemibold
            NotifTitle.TextXAlignment = Enum.TextXAlignment.Left

            local NotifContent = Instance.new("TextLabel")
            NotifContent.Parent = NotifFrame
            NotifContent.BackgroundTransparency = 1
            NotifContent.Size = UDim2.new(1, -20, 0, 40)
            NotifContent.Position = UDim2.new(0, 10, 0, 25)
            NotifContent.Text = content
            NotifContent.TextColor3 = Colors.Text
            NotifContent.TextSize = 12
            NotifContent.Font = Enum.Font.SourceSans
            NotifContent.TextXAlignment = Enum.TextXAlignment.Left
            NotifContent.TextWrapped = true

            -- Color based on type
            if type == "Success" then
                NotifFrame.BackgroundColor3 = Colors.Success
            elseif type == "Warning" then
                NotifFrame.BackgroundColor3 = Colors.Warning
            elseif type == "Error" then
                NotifFrame.BackgroundColor3 = Colors.Error
            end

            -- Animate in
            NotifFrame.Position = UDim2.new(1, 20, 1, -100 - (#Window:GetChildren() - 1) * 90)
            local tween = TweenService:Create(NotifFrame, TweenInfo.new(0.5), {Position = UDim2.new(1, -320, 1, -100 - (#Window:GetChildren() - 1) * 90)})
            tween:Play()
            wait(3)
            local tweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.5), {Position = UDim2.new(1, 20, 1, -100 - (#Window:GetChildren() - 1) * 90)})
            tweenOut:Play()
            tweenOut.Completed:Wait()
            NotifFrame:Destroy()
        end
    }

    -- Add methods to Tab
    function WindowObject.AddTab:AddButton(name, callback)
        local Button = Instance.new("TextButton")
        Button.Parent = self.Frame
        Button.BackgroundColor3 = Colors.Secondary
        Button.Size = UDim2.new(1, -20, 0, 30)
        Button.Position = UDim2.new(0, 10, 0, self.YOffset)
        Button.Text = name
        Button.TextColor3 = Colors.Text
        Button.TextSize = 14
        Button.Font = Enum.Font.SourceSans
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 5)
        ButtonCorner.Parent = Button
        Button.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
        self.YOffset = self.YOffset + 35
        self.Frame.CanvasSize = UDim2.new(0, 0, 0, self.YOffset)
        table.insert(self.Elements, Button)
    end

    function WindowObject.AddTab:AddToggle(name, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Parent = self.Frame
        ToggleFrame.BackgroundTransparency = 1
        ToggleFrame.Size = UDim2.new(1, -20, 0, 30)
        ToggleFrame.Position = UDim2.new(0, 10, 0, self.YOffset)
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Parent = ToggleFrame
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Size = UDim2.new(1, -40, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Colors.Text
        ToggleLabel.TextSize = 14
        ToggleLabel.Font = Enum.Font.SourceSans
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Parent = ToggleFrame
        ToggleButton.BackgroundColor3 = default and Colors.Success or Colors.Secondary
        ToggleButton.Size = UDim2.new(0, 30, 0, 30)
        ToggleButton.Position = UDim2.new(1, -30, 0, 0)
        ToggleButton.Text = default and "✓" or ""
        ToggleButton.TextColor3 = Colors.Text
        ToggleButton.TextSize = 18
        ToggleButton.Font = Enum.Font.SourceSansBold
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 5)
        ToggleCorner.Parent = ToggleButton
        local toggled = default
        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            ToggleButton.BackgroundColor3 = toggled and Colors.Success or Colors.Secondary
            ToggleButton.Text = toggled and "✓" or ""
            if callback then callback(toggled) end
        end)
        self.YOffset = self.YOffset + 35
        self.Frame.CanvasSize = UDim2.new(0, 0, 0, self.YOffset)
        table.insert(self.Elements, ToggleFrame)
    end

    function WindowObject.AddTab:AddSlider(name, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Parent = self.Frame
        SliderFrame.BackgroundTransparency = 1
        SliderFrame.Size = UDim2.new(1, -20, 0, 50)
        SliderFrame.Position = UDim2.new(0, 10, 0, self.YOffset)
        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Parent = SliderFrame
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Size = UDim2.new(1, 0, 0, 20)
        SliderLabel.Position = UDim2.new(0, 0, 0, 0)
        SliderLabel.Text = name .. ": " .. tostring(default)
        SliderLabel.TextColor3 = Colors.Text
        SliderLabel.TextSize = 14
        SliderLabel.Font = Enum.Font.SourceSans
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        local SliderBar = Instance.new("Frame")
        SliderBar.Parent = SliderFrame
        SliderBar.BackgroundColor3 = Colors.Secondary
        SliderBar.Size = UDim2.new(1, 0, 0, 10)
        SliderBar.Position = UDim2.new(0, 0, 0, 25)
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 5)
        SliderCorner.Parent = SliderBar
        local SliderFill = Instance.new("Frame")
        SliderFill.Parent = SliderBar
        SliderFill.BackgroundColor3 = Colors.Accent
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        SliderFill.BorderSizePixel = 0
        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(0, 5)
        FillCorner.Parent = SliderFill
        local SliderButton = Instance.new("TextButton")
        SliderButton.Parent = SliderBar
        SliderButton.BackgroundColor3 = Colors.Text
        SliderButton.Size = UDim2.new(0, 15, 0, 15)
        SliderButton.Position = UDim2.new((default - min) / (max - min), -7.5, 0, -2.5)
        SliderButton.Text = ""
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(1, 0)
        ButtonCorner.Parent = SliderButton
        local dragging = false
        local function updateSlider(input)
            local relativeX = input.Position.X - SliderBar.AbsolutePosition.X
            local percent = math.clamp(relativeX / SliderBar.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * percent
            value = math.floor(value + 0.5)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderButton.Position = UDim2.new(percent, -7.5, 0, -2.5)
            SliderLabel.Text = name .. ": " .. tostring(value)
            if callback then callback(value) end
        end
        SliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        SliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        self.YOffset = self.YOffset + 55
        self.Frame.CanvasSize = UDim2.new(0, 0, 0, self.YOffset)
        table.insert(self.Elements, SliderFrame)
    end

    function WindowObject.AddTab:AddDropdown(name, options, default, callback)
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Parent = self.Frame
        DropdownFrame.BackgroundTransparency = 1
        DropdownFrame.Size = UDim2.new(1, -20, 0, 30)
        DropdownFrame.Position = UDim2.new(0, 10, 0, self.YOffset)
        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Parent = DropdownFrame
        DropdownButton.BackgroundColor3 = Colors.Secondary
        DropdownButton.Size = UDim2.new(1, 0, 1, 0)
        DropdownButton.Text = name .. ": " .. (default or options[1])
        DropdownButton.TextColor3 = Colors.Text
        DropdownButton.TextSize = 14
        DropdownButton.Font = Enum.Font.SourceSans
        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 5)
        DropdownCorner.Parent = DropdownButton
        local DropdownList = Instance.new("Frame")
        DropdownList.Parent = DropdownFrame
        DropdownList.BackgroundColor3 = Colors.Background
        DropdownList.Size = UDim2.new(1, 0, 0, #options * 25)
        DropdownList.Position = UDim2.new(0, 0, 1, 0)
        DropdownList.Visible = false
        local ListCorner = Instance.new("UICorner")
        ListCorner.CornerRadius = UDim.new(0, 5)
        ListCorner.Parent = DropdownList
        for i, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Parent = DropdownList
            OptionButton.BackgroundTransparency = 1
            OptionButton.Size = UDim2.new(1, 0, 0, 25)
            OptionButton.Position = UDim2.new(0, 0, 0, (i-1)*25)
            OptionButton.Text = option
            OptionButton.TextColor3 = Colors.Text
            OptionButton.TextSize = 12
            OptionButton.Font = Enum.Font.SourceSans
            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = name .. ": " .. option
                DropdownList.Visible = false
                if callback then callback(option) end
            end)
        end
        DropdownButton.MouseButton1Click:Connect(function()
            DropdownList.Visible = not DropdownList.Visible
        end)
        self.YOffset = self.YOffset + 35
        self.Frame.CanvasSize = UDim2.new(0, 0, 0, self.YOffset)
        table.insert(self.Elements, DropdownFrame)
    end

    function WindowObject.AddTab:AddDivider()
        local Divider = Instance.new("Frame")
        Divider.Parent = self.Frame
        Divider.BackgroundColor3 = Colors.Accent
        Divider.Size = UDim2.new(1, -20, 0, 1)
        Divider.Position = UDim2.new(0, 10, 0, self.YOffset + 5)
        self.YOffset = self.YOffset + 10
        self.Frame.CanvasSize = UDim2.new(0, 0, 0, self.YOffset)
        table.insert(self.Elements, Divider)
    end

    return WindowObject
end

-- Key system (simple toggle key)
local KeySystem = {
    ToggleKey = Enum.KeyCode.RightShift,
    Window = nil
}

function AppleLibrary:SetToggleKey(key)
    KeySystem.ToggleKey = key
end

function AppleLibrary:Init(window)
    KeySystem.Window = window
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == KeySystem.ToggleKey then
            window.MainFrame.Visible = not window.MainFrame.Visible
        end
    end)
end

return AppleLibrary