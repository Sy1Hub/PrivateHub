local MainModule = {}

function MainModule.CreateUI()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = game:GetService("HttpService"):GenerateGUID(false)
	ScreenGui.Parent = game:GetService("CoreGui")
	return ScreenGui
end

function MainModule.CreateFrame(Name, parent, Size:Vector2, Position:Vector2, BackgroundColor:Color3, Transparency:number)
	local Frame = Instance.new("Frame")
	Frame.Name = Name
	Frame.Size = UDim2.new(0, Size.X, 0, Size.Y)
	Frame.Position = UDim2.new(0, Position.X, 0, Position.Y)
	Frame.BackgroundColor3 = BackgroundColor
	Frame.BackgroundTransparency = Transparency
	Frame.Parent = parent
	return Frame
end

function MainModule.CreateUICorner(parent, CornerRadius)
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = CornerRadius
	UICorner.Parent = parent
	return UICorner
end

function MainModule.CreateUIGradient(parent, Color, Offset, Rotation, Transparency)
	local UIGradient = Instance.new("UIGradient")
	UIGradient.Color = Color
	UIGradient.Offset = Offset
	UIGradient.Rotation = Rotation
	UIGradient.Transparency = Transparency
	UIGradient.Parent = parent
	return UIGradient
end

function MainModule.CreateUIStroke(parent, Color, Thickness, Transparency)
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color
	UIStroke.Thickness = Thickness
	UIStroke.Transparency = Transparency
	UIStroke.Parent = parent
	return UIStroke
end

function MainModule.CreateTextLabel(parent, BackgroundColor:Color3, Text, TextColor:Color3, TextSize, Font, TextTransparency)
	local TextLabel = Instance.new("TextLabel")
	TextLabel.BackgroundColor3 = BackgroundColor
	TextLabel.Text = Text
	TextLabel.TextColor3 = TextColor
	TextLabel.TextSize = TextSize
	TextLabel.Font = Font
	TextLabel.TextTransparency = TextTransparency
	TextLabel.Parent = parent
	return TextLabel
end

function MainModule.CreateTextButton(parent, BackgroundColor:Color3, Text, TextColor:Color3, TextSize, Font, TextTransparency, Callback)
	local TextButton = Instance.new("TextButton")
	TextButton.BackgroundColor3 = BackgroundColor
	TextButton.Text = Text
	TextButton.TextColor3 = TextColor
	TextButton.TextSize = TextSize
	TextButton.Font = Font
	TextButton.TextTransparency = TextTransparency
	TextButton.Parent = parent
	TextButton.MouseButton1Click:Connect(function()
		Callback()
	end)
	return TextButton
end

function MainModule.CreateTextBox(parent, BackgroundColor:Color3, PlaceholderTxt, Text, TextColor:Color3, TextSize, Font, TextTransparency, Callback)
	local TextBox = Instance.new("TextBox")
	TextBox.Parent = parent
	TextBox.BackgroundColor3 = BackgroundColor
	TextBox.PlaceholderText = PlaceholderTxt
	TextBox.Text = Text
	TextBox.TextColor3 = TextColor
	TextBox.TextSize = TextSize
	TextBox.Font = Font
	TextBox.TextTransparency = TextTransparency
	TextBox.FocusLost:Connect(function(enterPressed)
		if enterPressed and Callback then
			Callback(TextBox.Text)
		end
	end)
	return TextBox
end

function MainModule.CreateCheckbox(parent, Size:Vector2, Position:Vector2, BackgroundColor:Color3, CheckColor:Color3, Callback)
	local Checkbox = Instance.new("TextButton")
	Checkbox.Size = UDim2.new(0, Size.X, 0, Size.Y)
	Checkbox.Position = UDim2.new(0, Position.X, 0, Position.Y)
	Checkbox.BackgroundColor3 = BackgroundColor
	Checkbox.Text = ""
	Checkbox.Parent = parent

	local CheckMark = Instance.new("TextLabel")
	CheckMark.Size = UDim2.new(1, 0, 1, 0)
	CheckMark.BackgroundTransparency = 1
	CheckMark.Text = "✓"
	CheckMark.TextColor3 = CheckColor
	CheckMark.TextScaled = true
	CheckMark.Visible = false
	CheckMark.Parent = Checkbox

	Checkbox.MouseButton1Click:Connect(function()
		CheckMark.Visible = not CheckMark.Visible
		if Callback then
			Callback(CheckMark.Visible)
		end
	end)

	return Checkbox
end

function MainModule.CreateSlider(parent, Size:Vector2, Position:Vector2, BackgroundColor:Color3, FillColor:Color3, TextColor:Color3, min:number, max:number, initValue:number, showAsPercent:boolean, Callback)
	local Slider = Instance.new("Frame")
	Slider.Size = UDim2.new(0, Size.X, 0, Size.Y)
	Slider.Position = UDim2.new(0, Position.X, 0, Position.Y)
	Slider.BackgroundColor3 = BackgroundColor
	Slider.Parent = parent

	local Fill = Instance.new("Frame")
	Fill.BackgroundColor3 = FillColor
	Fill.Size = UDim2.new(0, 0, 1, 0)
	Fill.Parent = Slider

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Size = UDim2.new(1, 0, 1, 0)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.TextColor3 = TextColor
	ValueLabel.TextScaled = true
	ValueLabel.Parent = Slider

	local DragButton = Instance.new("TextButton")
	DragButton.Size = UDim2.new(1, 0, 1, 0)
	DragButton.BackgroundTransparency = 1
	DragButton.Text = ""
	DragButton.Parent = Slider

	local function clamp(n, lower, upper)
		return math.max(lower, math.min(n, upper))
	end

	local function valueToPercent(value)
		return (clamp(value, min, max) - min) / (max - min)
	end

	local function percentToValue(percent)
		return min + percent * (max - min)
	end

	local function updateSlider(x)
		local sliderWidth = Slider.AbsoluteSize.X
		local pos = clamp(x, 0, sliderWidth)
		local percent = pos / sliderWidth
		Fill.Size = UDim2.new(percent, 0, 1, 0)
		local value = percentToValue(percent)
		if showAsPercent then
			ValueLabel.Text = math.floor((value - min) / (max - min) * 100) .. "%"
		else
			ValueLabel.Text = tostring(math.floor(value))
		end
		if Callback then
			Callback(value)
		end
	end

	local initialPercent = valueToPercent(initValue)
	Fill.Size = UDim2.new(initialPercent, 0, 1, 0)
	if showAsPercent then
		ValueLabel.Text = math.floor(initialPercent * 100) .. "%"
	else
		ValueLabel.Text = tostring(math.floor(initValue))
	end

	local sliding = false

	DragButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sliding = true
			local relativeX = input.Position.X - Slider.AbsolutePosition.X
			updateSlider(relativeX)
		end
	end)

	DragButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sliding = false
		end
	end)

	DragButton.InputChanged:Connect(function(input)
		if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
			local relativeX = input.Position.X - Slider.AbsolutePosition.X
			updateSlider(relativeX)
		end
	end)

	return Slider, Fill, DragButton, ValueLabel
end

return MainModule
