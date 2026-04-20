instance.new(ScreenGui)
instance.new(Frame, ScreenGui)
instance.new(UICorner, Frame)
local UICorner = Frame.UICorner
UICorner.CornerRadius = UDim.new(0, 5)
instance.new(UIStroke, Frame)
local UIStroke = Frame.UIStroke
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(135, 206, 235)
UIStroke.Transparency = 0.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
instance.new(TextLabel, Frame)