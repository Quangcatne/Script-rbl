-- [[ PART 1: SYSTEM INITIALIZATION ]] --
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Library = {}
local Tabs = {}
_G.Toggles = {}
_G.SliderValues = {}
local menuVisible = true
-- [[ PART 2: CORE INTERFACE & DRAG ]] --
function Library:Init(scriptTitle)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NoobMayhem_Engine"
    ScreenGui.Parent = CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "NoobMayhemToggle"
    ToggleButton.Parent = ScreenGui
    ToggleButton.Size = UDim2.new(0, 45, 0, 45)
    ToggleButton.Position = UDim2.new(0.03, 0, 0.15, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    ToggleButton.Text = "⚡"
    ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 150)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.TextSize = 22
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 22)

    local ToggleStroke = Instance.new("UIStroke", ToggleButton)
    ToggleStroke.Color = Color3.fromRGB(0, 255, 150)
    ToggleStroke.Thickness = 1.5

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "NoobMayhemMain"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
    MainFrame.Size = UDim2.new(0, 290, 0, 240) 
    MainFrame.Active = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = scriptTitle or "Noob Mayhem Script"
    Title.TextColor3 = Color3.fromRGB(0, 255, 150)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopBar
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -30, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "—"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
    CloseBtn.TextSize = 14

    -- Xử lý Kéo Thả
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Ẩn/Hiện Menu
    local function toggleMenu()
        menuVisible = not menuVisible
        if menuVisible then MainFrame.Visible = true end
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = menuVisible and 0 or 1
        }):Play()
        if not menuVisible then task.wait(0.2) MainFrame.Visible = false end
    end
    CloseBtn.MouseButton1Click:Connect(toggleMenu)
    ToggleButton.MouseButton1Click:Connect(toggleMenu)

    local TabBar = Instance.new("Frame") 
    TabBar.Name = "TabBar"
    TabBar.Parent = MainFrame
    TabBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    TabBar.Position = UDim2.new(0, 0, 0, 30)
    TabBar.Size = UDim2.new(1, 0, 0, 28)

    local TabBarLayout = Instance.new("UIListLayout")
    TabBarLayout.Parent = TabBar
    TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
    TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabBarLayout.Padding = UDim.new(0, 2)

    self.MainFrame = MainFrame
    self.TabBar = TabBar
    return self
end
-- [[ PART 3: PAGES & TABS MANAGEMENT ]] --
function Library:CreateTabSpace(tabName)
    local Container = Instance.new("ScrollingFrame")
    Container.Name = tabName .. "Page"
    Container.Parent = self.MainFrame
    Container.Position = UDim2.new(0, 8, 0, 64)
    Container.Size = UDim2.new(1, -16, 1, -72)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2
    Container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
    Container.Visible = false
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Container
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 6)
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)
    return Container
end

function Library:AddTab(name)
    local TabBtn = Instance.new("TextButton")
    local Page = self:CreateTabSpace(name)
    
    TabBtn.Name = name .. "Tab"
    TabBtn.Parent = self.TabBar
    TabBtn.Size = UDim2.new(0, 94, 1, 0) 
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.TextSize = 13
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
    end)
    
    if #Tabs == 0 then
        Page.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
    end
    
    table.insert(Tabs, {Btn = TabBtn, Page = Page})
    return Page
end
-- [[ PART 4: INTERACTION ELEMENTS & RETURN ]] --
function Library:AddToggle(parentPage, text, id, default, callback)
    _G.Toggles[id] = default
    callback = callback or function() end
    
    local TglFrame = Instance.new("Frame")
    TglFrame.Size = UDim2.new(1, 0, 0, 32)
    TglFrame.BackgroundTransparency = 1
    TglFrame.Parent = parentPage
    
    local TglBtn = Instance.new("TextButton")
    TglBtn.Size = UDim2.new(1, 0, 1, 0)
    TglBtn.BackgroundTransparency = 1
    TglBtn.Text = "  " .. text
    TglBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
    TglBtn.Font = Enum.Font.SourceSans
    TglBtn.TextSize = 13
    TglBtn.TextXAlignment = Enum.TextXAlignment.Left
    TglBtn.Parent = TglFrame
    
    local TglStatus = Instance.new("Frame")
    TglStatus.Size = UDim2.new(0, 26, 0, 14)
    TglStatus.Position = UDim2.new(1, -32, 0.5, -7)
    TglStatus.BackgroundColor3 = default and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(45, 45, 55)
    TglStatus.Parent = TglFrame
    Instance.new("UICorner", TglStatus).CornerRadius = UDim.new(0, 7)
    
    TglBtn.MouseButton1Click:Connect(function()
        _G.Toggles[id] = not _G.Toggles[id]
        local isEnabled = _G.Toggles[id]
        TweenService:Create(TglStatus, TweenInfo.new(0.15), {
            BackgroundColor3 = isEnabled and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(45, 45, 55)
        }):Play()
        task.spawn(callback, isEnabled)
    end)
end

function Library:AddSlider(parentPage, text, min, max, default, callback)
    callback = callback or function() end
    _G.SliderValues[text] = default

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 42)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parentPage
    
    local SliderTitle = Instance.new("TextLabel")
    SliderTitle.Size = UDim2.new(0.7, 0, 0, 18)
    SliderTitle.Position = UDim2.new(0, 4, 0, 2)
    SliderTitle.BackgroundTransparency = 1
    SliderTitle.Text = text
    SliderTitle.TextColor3 = Color3.fromRGB(200, 200, 205)
    SliderTitle.Font = Enum.Font.SourceSans
    SliderTitle.TextSize = 13
    SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
    SliderTitle.Parent = SliderFrame
    
    local SliderValLabel = Instance.new("TextLabel")
    SliderValLabel.Size = UDim2.new(0.25, 0, 0, 18)
    SliderValLabel.Position = UDim2.new(0.7, 0, 0, 2)
    SliderValLabel.BackgroundTransparency = 1
    SliderValLabel.Text = tostring(default)
    SliderValLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    SliderValLabel.Font = Enum.Font.SourceSansBold
    SliderValLabel.TextSize = 13
    SliderValLabel.TextXAlignment = Enum.TextXAlignment.Right
    SliderValLabel.Parent = SliderFrame
    
    local SliderMain = Instance.new("Frame")
    SliderMain.Size = UDim2.new(1, -12, 0, 6)
    SliderMain.Position = UDim2.new(0, 6, 0, 26)
    SliderMain.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    SliderMain.Parent = SliderFrame
    Instance.new("UICorner", SliderMain).CornerRadius = UDim.new(0, 3)
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    SliderFill.Parent = SliderMain
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 3)
    
    local SliderBtn = Instance.new("TextButton")
    SliderBtn.Size = UDim2.new(1, 0, 1, 0)
    SliderBtn.BackgroundTransparency = 1
    SliderBtn.Text = ""
    SliderBtn.Parent = SliderMain
    
    local isDragging = false
    local function updateSlider(input)
        local percentage = math.clamp((input.Position.X - SliderMain.AbsolutePosition.X) / SliderMain.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        local finalValue = math.floor(min + (percentage * (max - min)))
        SliderValLabel.Text = tostring(finalValue)
        _G.SliderValues[text] = finalValue
        task.spawn(callback, finalValue)
    end
    
    SliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true updateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
end

return Library

