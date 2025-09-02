--// ShattyHub GUI Library (Rayfield-style)
--// Made for exploits, supports notifications & configs

local ShattyHub = {}
ShattyHub.Theme = {
    Background = Color3.fromRGB(20,20,20),
    Topbar = Color3.fromRGB(30,30,30),
    Tab = Color3.fromRGB(40,40,40),
    Button = Color3.fromRGB(50,50,50),
    ToggleOn = Color3.fromRGB(0,170,127),
    ToggleOff = Color3.fromRGB(70,70,70),
    Text = Color3.fromRGB(255,255,255)
}
ShattyHub.Gui = nil
ShattyHub.Tabs = {}

--// Create Window
function ShattyHub:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "ShattyHub"
    local SubTitle = config.SubTitle or ""

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Name = "ShattyHub"

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = self.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = self.Theme.Topbar
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title .. " - " .. SubTitle
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar

    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(0, 120, 1, -40)
    TabBar.Position = UDim2.new(0, 0, 0, 40)
    TabBar.BackgroundColor3 = self.Theme.Tab
    TabBar.BorderSizePixel = 0
    TabBar.Parent = MainFrame

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -120, 1, -40)
    ContentFrame.Position = UDim2.new(0, 120, 0, 40)
    ContentFrame.BackgroundColor3 = self.Theme.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame

    self.Gui = ScreenGui
    self.MainFrame = MainFrame
    self.ContentFrame = ContentFrame
    self.TabBar = TabBar

    return self
end

--// Create Tab
function ShattyHub:CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 30)
    TabButton.BackgroundTransparency = 1
    TabButton.Text = name
    TabButton.TextColor3 = self.Theme.Text
    TabButton.TextSize = 14
    TabButton.Parent = self.TabBar

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 4
    TabContent.Visible = false
    TabContent.Parent = self.ContentFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.Parent = TabContent

    local Tab = {Button = TabButton, Content = TabContent}
    table.insert(self.Tabs, Tab)

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Content.Visible = false
        end
        TabContent.Visible = true
    end)

    if #self.Tabs == 1 then
        TabContent.Visible = true
    end

    return Tab
end

--// Add Button
function ShattyHub:AddButton(tab, config)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 30)
    Button.BackgroundColor3 = self.Theme.Button
    Button.BorderSizePixel = 0
    Button.Text = config.Name or "Button"
    Button.TextColor3 = self.Theme.Text
    Button.TextSize = 14
    Button.Parent = tab.Content

    Button.MouseButton1Click:Connect(function()
        if config.Callback then
            config.Callback()
        end
    end)
end

--// Add Toggle
function ShattyHub:AddToggle(tab, config)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -10, 0, 30)
    Toggle.BackgroundColor3 = self.Theme.ToggleOff
    Toggle.BorderSizePixel = 0
    Toggle.Text = (config.Name or "Toggle") .. " : OFF"
    Toggle.TextColor3 = self.Theme.Text
    Toggle.TextSize = 14
    Toggle.Parent = tab.Content

    local state = config.Default or false
    local function update()
        Toggle.BackgroundColor3 = state and self.Theme.ToggleOn or self.Theme.ToggleOff
        Toggle.Text = (config.Name or "Toggle") .. (state and " : ON" or " : OFF")
    end
    update()

    Toggle.MouseButton1Click:Connect(function()
        state = not state
        update()
        if config.Callback then
            config.Callback(state)
        end
    end)
end

--// Add Paragraph
function ShattyHub:AddParagraph(tab, config)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 60)
    Frame.BackgroundTransparency = 1
    Frame.Parent = tab.Content

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "Paragraph"
    Title.TextColor3 = self.Theme.Text
    Title.TextSize = 14
    Title.Font = Enum.Font.SourceSansBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Content = Instance.new("TextLabel")
    Content.Size = UDim2.new(1, 0, 1, -20)
    Content.Position = UDim2.new(0, 0, 0, 20)
    Content.BackgroundTransparency = 1
    Content.TextWrapped = true
    Content.TextYAlignment = Enum.TextYAlignment.Top
    Content.Text = config.Content or ""
    Content.TextColor3 = self.Theme.Text
    Content.TextSize = 13
    Content.Font = Enum.Font.SourceSans
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.Parent = Frame
end

--// Add Slider
function ShattyHub:AddSlider(tab, config)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.BackgroundTransparency = 1
    Frame.Parent = tab.Content

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = (config.Name or "Slider") .. ": " .. (config.Default or config.Min)
    Label.TextColor3 = self.Theme.Text
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, -10, 0, 10)
    SliderBack.Position = UDim2.new(0, 5, 0, 25)
    SliderBack.BackgroundColor3 = Color3.fromRGB(60,60,60)
    SliderBack.BorderSizePixel = 0
    SliderBack.Parent = Frame

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = self.Theme.ToggleOn
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBack

    local dragging = false
    local val = config.Default or config.Min

    local function update(inputX)
        local pct = math.clamp((inputX - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        val = math.floor(config.Min + (config.Max - config.Min) * pct)
        Fill.Size = UDim2.new(pct, 0, 1, 0)
        Label.Text = (config.Name or "Slider") .. ": " .. val
        if config.Callback then
            config.Callback(val)
        end
    end

    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input.Position.X)
        end
    end)
    SliderBack.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input.Position.X)
        end
    end)
end

--// Notifications + Save System
local HttpService = game:GetService("HttpService")

function ShattyHub:Notify(config)
    config = config or {}
    local text = config.Text or "Notification"
    local duration = config.Time or 3

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 50)
    Frame.Position = UDim2.new(1, -320, 1, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Frame.BorderSizePixel = 0
    Frame.ClipsDescendants = true
    Frame.Parent = self.Gui

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = self.Theme.Text
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    Frame.Position = Frame.Position + UDim2.new(0, 320, 0, 0)
    Frame:TweenPosition(UDim2.new(1, -320, 1, -100), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)

    task.delay(duration, function()
        if Frame and Frame.Parent then
            Frame:TweenPosition(Frame.Position + UDim2.new(0, 320, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
            task.delay(0.3, function()
                Frame:Destroy()
            end)
        end
    end)
end

ShattyHub.Flags = {}

function ShattyHub:SetFlag(name, value)
    self.Flags[name] = value
end

function ShattyHub:GetFlag(name)
    return self.Flags[name]
end

function ShattyHub:SaveConfig(fileName)
    fileName = fileName or "ShattyHubConfig.json"
    if writefile then
        local json = HttpService:JSONEncode(self.Flags)
        writefile(fileName, json)
        self:Notify({Text = "Config saved to "..fileName, Time = 2})
    else
        warn("writefile not supported in this exploit")
    end
end

function ShattyHub:LoadConfig(fileName)
    fileName = fileName or "ShattyHubConfig.json"
    if isfile and readfile and isfile(fileName) then
        local data = HttpService:JSONDecode(readfile(fileName))
        self.Flags = data
        self:Notify({Text = "Config loaded from "..fileName, Time = 2})
    else
        warn("Config file not found or readfile not supported")
    end
end

--// Finalizer
return ShattyHub
