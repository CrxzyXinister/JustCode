-- Key System UI

local KeySystem = {}

instance.new("ScreenGui")
ScreenGui.Name = "Private"

instance.new("Frame", ScreenGui)
ScreenGui.Frame.Size = UDim2.new(0, 200, 0, 100)
ScreenGui.Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
ScreenGui.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

Frame.BackgroundTransparency = 0.35

-- Cosmetics/Designs

instance.new(UICorner, ScreenGui.Frame)
ScreenGui.Frame.UICorner.CornerRadius = 5

instance.new(UIStroke, ScreenGui.Frame)
ScreenGui.Frame.UIStroke.Thickness = 2
ScreenGui.Frame.UIStroke.Color = Color3.fromRGB(255, 255, 255)

-- Title
instance.new("TextLabel", ScreenGui.Frame)
ScreenGui.Frame.TextLabel.Size = UDim2.new(1, 0, 0.2, 0)
ScreenGui.Frame.TextLabel.Position = UDim2.new(0, 0, 0, 0)
ScreenGui.Frame.TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScreenGui.Frame.TextLabel.BackgroundTransparency = 0.5
ScreenGui.Frame.TextLabel.Text = "Key System"
ScreenGui.Frame.TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
ScreenGui.Frame.TextLabel.TextSize = 14

-- Key Input
instance.new("TextBox", ScreenGui.Frame)
ScreenGui.Frame.TextBox.Size = UDim2.new(1, 0, 0.8, 0)
ScreenGui.Frame.TextBox.Position = UDim2.new(0, 0, 0.2, 0)
ScreenGui.Frame.TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScreenGui.Frame.TextBox.BackgroundTransparency = 0.5
ScreenGui.Frame.TextBox.Text = ""
ScreenGui.Frame.TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
ScreenGui.Frame.TextBox.TextSize = 14

-- Key Validation 
instance.new("TextButton", ScreenGui.Frame)
ScreenGui.Frame.TextButton.Size = UDim2.new(0.5, 0, 0.2, 0)
ScreenGui.Frame.TextButton.Position = UDim2.new(0.25, 0, 0.8, 0)
ScreenGui.Frame.TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScreenGui.Frame.TextButton.BackgroundTransparency = 0.5
ScreenGui.Frame.TextButton.Text = "Validate Key"
ScreenGui.Frame.TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ScreenGui.Frame.TextButton.TextSize = 14

-- Key Validation Logic
local ValidKeys = {
    "DivineBeta",
    "DivineAlpha",
    "DivineRelease"
}

-- Function to validate the key
local function ValidateKey(key)
    for _, validkey in ipairs(ValidKeys) do
        if key == validkey then
            return true
        end
    end
    return false

-- Button Click Event
ScreenGui.Frame.TextButton.MouseButton1Click:Connect(function())
    local enteredKey = ScreenGui.Frame.TextBox.Text
    if ValidateKey(enteredKey) then
        print("Key is valid! Access granted.")
        -- you can add code here to grant access to the user
            ScreenGui.Frame.TextBox.Text = ""
            ScreenGui.Frame.TextBox.PlaceholderText = "Key Validated"
    else 
        print("Invalid Key! Access Denied.")
        -- Key Denied Logic
        ScreenGui.Frame.TextBox.Text = ""
        ScreenGui.Frame.TextBox.PlaceholderText = "Invalid Key"
    end
end)

if Key is Valid then
    -- Execute Loadstring 
    loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()
end
 
if Key is Invalid then
    -- Deny Access Logic
  game:GetService("LocalPlayer").Kick("Invalid Key Nigga, Get the key on our Discord Server!")
end


-- Destroy after Loadstring is Executed
if Key is Valid then
    -- Destroy the UI after successful key validation
    ScreenGui:Destroy()
end
