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
    Notification:Create("Content")
    Notification:Create("Icon")
    Notification:Statuses("Type")
    NotificationStats = {
        Success = "Success",
        Warning = "Warning",
        Error = "Error"
    }
end

local function CreateWindow()
    local Window = Instance.new("ScreenGui")
    Window.Name = "AppleLibrary"
    Window.Parent = game.CoreGui
    Window.ZIndexBehavior = Enum.ZIndexBehavior.Siblinh
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Window
    MainFrame.BackgroundColo3