local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local FrameCorner = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local TopCorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local TabBar = Instance.new("Frame") 
local TabBarLayout = Instance.new("UIListLayout")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

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

MainFrame.Name = "NoobMayhemMain"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 290, 0, 240) 
MainFrame.Active = true
MainFrame.Draggable = true

FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = MainFrame

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

Title.Parent = TopBar
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Noob Mayhem Script | By Qcat"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseBtn.Parent = TopBar
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "—"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
CloseBtn.TextSize = 14

local menuVisible = true
local function toggleMenu()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end
CloseBtn.MouseButton1Click:Connect(toggleMenu)
ToggleButton.MouseButton1Click:Connect(toggleMenu)

TabBar.Name = "TabBar"
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
TabBar.Position = UDim2.new(0, 0, 0, 30)
TabBar.Size = UDim2.new(1, 0, 0, 28)

TabBarLayout.Parent = TabBar
TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabBarLayout.Padding = UDim.new(0, 2)

local Tabs = {}
_G.Toggles = {}

local function CreateTabSpace(tabName)
    local Container = Instance.new("ScrollingFrame")
    Container.Name = tabName .. "Page"
    Container.Parent = MainFrame
    Container.Position = UDim2.new(0, 8, 0, 64)
    Container.Size = UDim2.new(1, -16, 1, -72)
    Container.BackgroundTransparency = 1
    Container.CanvasSize = UDim2.new(0, 0, 0, 380)
    Container.ScrollBarThickness = 2
    Container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
    Container.Visible = false
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Container
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 6)
    
    return Container
end

local function AddTab(name)
    local TabBtn = Instance.new("TextButton")
    local Page = CreateTabSpace(name)
    
    TabBtn.Name = name .. "Tab"
    TabBtn.Parent = TabBar
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
    
    table.insert(Tabs, {Btn = TabBtn, Page = Page})
    return Page
end
local function AddToggle(parentPage, text, id, default)
    _G.Toggles[id] = default
    local TglFrame = Instance.new("Frame")
    local TglBtn = Instance.new("TextButton")
    local TglStatus = Instance.new("Frame")
    
    TglFrame.Size = UDim2.new(1, 0, 0, 32)
    TglFrame.BackgroundTransparency = 1
    TglFrame.Parent = parentPage
    
    TglBtn.Size = UDim2.new(1, 0, 1, 0)
    TglBtn.BackgroundTransparency = 1
    TglBtn.Text = "  " .. text
    TglBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
    TglBtn.Font = Enum.Font.SourceSans
    TglBtn.TextSize = 13
    TglBtn.TextXAlignment = Enum.TextXAlignment.Left
    TglBtn.Parent = TglFrame
    
    TglStatus.Size = UDim2.new(0, 26, 0, 14)
    TglStatus.Position = UDim2.new(1, -32, 0.5, -7)
    TglStatus.BackgroundColor3 = default and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(45, 45, 55)
    TglStatus.Parent = TglFrame
    Instance.new("UICorner", TglStatus).CornerRadius = UDim.new(0, 7)
    
    TglBtn.MouseButton1Click:Connect(function()
        _G.Toggles[id] = not _G.Toggles[id]
        TglStatus.BackgroundColor3 = _G.Toggles[id] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(45, 45, 55)
    end)
end

local function AddSlider(parentPage, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    local SliderTitle = Instance.new("TextLabel")
    local SliderMain = Instance.new("Frame")
    local SliderFill = Instance.new("Frame")
    local SliderBtn = Instance.new("TextButton")
    local SliderValLabel = Instance.new("TextLabel")
    
    SliderFrame.Size = UDim2.new(1, 0, 0, 42)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parentPage
    
    SliderTitle.Size = UDim2.new(0.7, 0, 0, 18)
    SliderTitle.Position = UDim2.new(0, 4, 0, 2)
    SliderTitle.BackgroundTransparency = 1
    SliderTitle.Text = text
    SliderTitle.TextColor3 = Color3.fromRGB(200, 200, 205)
    SliderTitle.Font = Enum.Font.SourceSans
    SliderTitle.TextSize = 13
    SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
    SliderTitle.Parent = SliderFrame
    
    SliderValLabel.Size = UDim2.new(0.25, 0, 0, 18)
    SliderValLabel.Position = UDim2.new(0.7, 0, 0, 2)
    SliderValLabel.BackgroundTransparency = 1
    SliderValLabel.Text = tostring(default)
    SliderValLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    SliderValLabel.Font = Enum.Font.SourceSansBold
    SliderValLabel.TextSize = 13
    SliderValLabel.TextXAlignment = Enum.TextXAlignment.Right
    SliderValLabel.Parent = SliderFrame
    
    SliderMain.Size = UDim2.new(1, -12, 0, 6)
    SliderMain.Position = UDim2.new(0, 6, 0, 26)
    SliderMain.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    SliderMain.Parent = SliderFrame
    Instance.new("UICorner", SliderMain).CornerRadius = UDim.new(0, 3)
    
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    SliderFill.Parent = SliderMain
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 3)
    
    SliderBtn.Size = UDim2.new(1, 0, 1, 0)
    SliderBtn.BackgroundTransparency = 1
    SliderBtn.Text = ""
    SliderBtn.Parent = SliderMain
    
    local function updateSlider(input)
        local inputX = input.Position.X
        local sliderX = SliderMain.AbsolutePosition.X
        local sliderWidth = SliderMain.AbsoluteSize.X
        local percentage = math.clamp((inputX - sliderX) / sliderWidth, 0, 1)
        
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        local value = math.floor(min + (percentage * (max - min)))
        SliderValLabel.Text = tostring(value)
        callback(value)
    end
    
    local dragging = false
    SliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

_G.SelectedWeapon = "Tất cả"
local function AddWeaponDropdown(parentPage)
    local DropFrame = Instance.new("Frame")
    local DropBtn = Instance.new("TextButton")
    
    DropFrame.Size = UDim2.new(1, 0, 0, 35)
    DropFrame.BackgroundTransparency = 1
    DropFrame.Parent = parentPage
    
    DropBtn.Size = UDim2.new(1, 0, 1, 0)
    DropBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    DropBtn.Text = " Vũ khí: " .. _G.SelectedWeapon
    DropBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
    DropBtn.Font = Enum.Font.SourceSansBold
    DropBtn.TextSize = 13
    DropBtn.TextXAlignment = Enum.TextXAlignment.Left
    DropBtn.Parent = DropFrame
    Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)
    
    local DropList = Instance.new("Frame")
    DropList.Size = UDim2.new(1, 0, 0, 100)
    DropList.Position = UDim2.new(0, 0, 1, 2)
    DropList.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    DropList.Visible = false
    DropList.ZIndex = 5
    DropList.Parent = DropFrame
    Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 6)
    
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, 0, 1, 0)
    Scroll.BackgroundTransparency = 1
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 200)
    Scroll.ScrollBarThickness = 2
    Scroll.ZIndex = 5
    Scroll.Parent = DropList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = Scroll
    ListLayout.Padding = UDim.new(0, 2)
    
    local function refreshItems()
        for _, c in ipairs(Scroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        
        local wpList = {"Tất cả"}
        local added = {}
        local p = game:GetService("Players").LocalPlayer
        if p.Character then
            for _, i in ipairs(p.Character:GetChildren()) do
                if i:IsA("Tool") and not added[i.Name] then table.insert(wpList, i.Name) added[i.Name] = true end
            end
        end
        if p:FindFirstChild("Backpack") then
            for _, i in ipairs(p.Backpack:GetChildren()) do
                if i:IsA("Tool") and not added[i.Name] then table.insert(wpList, i.Name) added[i.Name] = true end
            end
        end
        
        for _, name in ipairs(wpList) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 25)
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            b.Text = " " .. name
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Font = Enum.Font.SourceSans
            b.TextSize = 12
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.ZIndex = 6
            b.Parent = Scroll
            
            b.MouseButton1Click:Connect(function()
                _G.SelectedWeapon = name
                DropBtn.Text = " Vũ khí: " .. name
                DropList.Visible = false
            end)
        end
    end
    
    DropBtn.MouseButton1Click:Connect(function()
        DropList.Visible = not DropList.Visible
        if DropList.Visible then refreshItems() end
    end)
end

local PageCombat = AddTab("Combat")
local PageExploit = AddTab("Exploit")
local PageMovement = AddTab("Movement")

AddToggle(PageCombat, "Killaura Đánh Quái (Tầm Gần)", "KillAura", false)
AddToggle(PageCombat, "Bất Tử (God Mode / Anti-Die)", "GodMode", false)
AddToggle(PageCombat, "Tự Động Đánh (Auto Clicker)", "AutoClick", false)
AddToggle(PageCombat, "Gom Quái Lại Gần (Bring Mobs)", "BringMobs", false)

AddWeaponDropdown(PageExploit)
AddToggle(PageExploit, "Bỏ Cooldown Đích Danh (No CD)", "NoCooldown", false)
AddToggle(PageExploit, "Tự Động Gom Xu (Auto Coin)", "AutoCoin", false)
AddToggle(PageExploit, "Tự Động Quay Vòng (Daily Wheel)", "AutoWheel", false)
AddToggle(PageExploit, "Nạp Code Nhận 25K Xu (Redeem Codes)", "AutoCodes", false)
AddToggle(PageExploit, "Mẹo Hồi Máu Đồng Đội Tăng Xu", "ArenaBonus", false)
AddToggle(PageExploit, "Bật Định Vị Người (Player ESP)", "PlayerESP", false)
AddToggle(PageExploit, "Tối Ưu Giảm Lag (Anti-Lag VIP)", "AntiLag", false)

AddToggle(PageMovement, "Chế Độ Bay Mobile (Fly Mode)", "Flying", false)
AddSlider(PageMovement, "Mức Tốc Độ Chạy", 16, 300, 16, function(value) _G.WalkSpeedValue = value end)
AddSlider(PageMovement, "Mức Lực Nhảy Cao", 50, 400, 50, function(value) _G.JumpPowerValue = value end)
AddSlider(PageMovement, "Mức Tốc Độ Bay", 10, 300, 50, function(value) _G.FlySpeedValue = value end)

if Tabs then
    Tabs.Page.Visible = true
    Tabs.Btn.TextColor3 = Color3.fromRGB(0, 255, 150)
end
_G.WalkSpeedValue = 16
_G.JumpPowerValue = 50
_G.FlySpeedValue = 50

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local function getClosestEnemy()
    local closest, shortestDistance = nil, math.huge
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position

    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= char and obj:FindFirstChild("HumanoidRootPart") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local dist = (myPos - obj.HumanoidRootPart.Position).Magnitude
                if dist < shortestDistance then closest, shortestDistance = obj, dist end
            end
        end
    end
    return closest
end

task.spawn(function()
    while true do
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                if _G.Toggles["KillAura"] then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        local target = getClosestEnemy()
                        if target and target:FindFirstChild("HumanoidRootPart") then
                            if (char.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude <= 22 then 
                                tool:Activate() 
                            end
                        end
                    end
                end
                
                if _G.Toggles["NoCooldown"] then
                    local tool = char:FindFirstChildOfClass("Tool")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not tool and _G.SelectedWeapon ~= "Tất cả" then
                        tool = LocalPlayer.Backpack:FindFirstChild(_G.SelectedWeapon)
                        if tool and hum then hum:EquipTool(tool) end
                    end
                    if tool and (_G.SelectedWeapon == "Tất cả" or tool.Name == _G.SelectedWeapon) and hum then
                        tool:Activate()
                        for _, child in ipairs(tool:GetDescendants()) do
                            if child:IsA("NumberValue") or child:IsA("IntValue") then
                                child.Value = 0
                            elseif child:IsA("BoolValue") then
                                if child.Name:lower():match("reload") then child.Value = false end
                                if child.Name:lower():match("shoot") or child.Name:lower():match("active") then child.Value = true end
                            end
                        end
                        tool.Parent = LocalPlayer.Backpack
                        task.wait(0.01)
                        hum:EquipTool(tool)
                    end
                end
            end
        end)
        task.wait(0.03)
    end
end)

task.spawn(function()
    while true do
        if _G.Toggles["GodMode"] then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                end
            end)
        else
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.MaxHealth == math.huge then
                    hum.MaxHealth = 100
                    hum.Health = 100
                end
            end)
        end
        task.wait(0.3)
    end
end)
task.spawn(function()
    while true do
        if _G.Toggles["AutoCoin"] then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local target = nil
                    local dist = math.huge
                    local function check(v)
                        if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("Model") then
                            local n = v.Name:lower()
                            if n:match("coin") or n:match("gold") or n:match("money") or v:FindFirstChild("Coin") then
                                local p = v:IsA("Model") and (v.PrimaryPart and v.PrimaryPart.Position) or v.Position
                                if p then
                                    local d = (hrp.Position - p).Magnitude
                                    if d < dist then dist = d target = v end
                                end
                            end
                        end
                    end
                    for _, v in ipairs(workspace:GetChildren()) do check(v) end
                    if workspace:FindFirstChild("Coins") then for _, v in ipairs(workspace.Coins:GetChildren()) do check(v) end end
                    if workspace:FindFirstChild("Drops") then for _, v in ipairs(workspace.Drops:GetChildren()) do check(v) end end
                    if target then
                        local cf = target:IsA("Model") and (target:GetPrimaryPartCFrame() or target:FindFirstChildOfClass("Part").CFrame) or target.CFrame
                        if cf then hrp.CFrame = cf end
                    end
                end
            end)
        end
        task.wait(0.05)
    end
end)

task.spawn(function()
    while true do
        if _G.Toggles["AutoClick"] then
            pcall(function()
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end)
        end
        task.wait(0.01)
    end
end)

task.spawn(function()
    while true do
        if _G.Toggles["BringMobs"] then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, obj in ipairs(workspace:GetChildren()) do
                        if obj:IsA("Model") and obj ~= char and obj:FindFirstChild("HumanoidRootPart") then
                            local hum = obj:FindFirstChildOfClass("Humanoid")
                            if hum and hum.Health > 0 and not game:GetService("Players"):GetPlayerFromCharacter(obj) then
                                obj.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 0, -4)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

task.spawn(function()
    while true do
        if _G.Toggles["AutoWheel"] then
            pcall(function()
                local r = game:GetService("ReplicatedStorage")
                if r:FindFirstChild("RemoteEvent") then
                    r.RemoteEvent:FireServer("ClaimDailyWheel")
                    r.RemoteEvent:FireServer("SpinDailyWheel")
                elseif r:FindFirstChild("Remotes") then
                    for _, v in ipairs(r.Remotes:GetChildren()) do
                        if v.Name:lower():match("wheel") or v.Name:lower():match("spin") or v.Name:lower():match("daily") then v:FireServer() end
                    end
                end
            end)
        end
        task.wait(5)
    end
end)

task.spawn(function()
    while true do
        if _G.Toggles["AutoCodes"] then
            _G.Toggles["AutoCodes"] = false
            pcall(function()
                local r = game:GetService("ReplicatedStorage")
                local codes = {"268Troops", "AwesomeBirthday2", "4000000", "Mechs", "Release"}
                for _, v in ipairs(r:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():match("code") or v.Name:lower():match("redeem")) then
                        for _, c in ipairs(codes) do v:FireServer(c) task.wait(0.5) end
                    end
                end
            end)
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        if _G.Toggles["ArenaBonus"] then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChild("Builderman") or char:FindFirstChildOfClass("Tool")
                    if tool and tool.Name:lower():match("heal") or tool.Name:lower():match("builder") then
                        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
                                if p.Character.Humanoid.Health < p.Character.Humanoid.MaxHealth then tool:Activate() end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

local espObjects = {}
task.spawn(function()
    while true do
        if _G.Toggles["PlayerESP"] then
            pcall(function()
                for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local char = p.Character
                        if not espObjects[p.Name] then
                            local box = Instance.new("BoxHandleAdornment")
                            box.Name = p.Name .. "ESP"
                            box.Size = Vector3.new(4, 5, 1)
                            box.Color3 = Color3.fromRGB(0, 255, 150)
                            box.AlwaysOnTop = true
                            box.ZIndex = 5
                            box.Transparency = 0.5
                            box.Adornee = char.HumanoidRootPart
                            box.Parent = char.HumanoidRootPart
                            espObjects[p.Name] = box
                        end
                    end
                end
            end)
        else
            pcall(function()
                for name, obj in pairs(espObjects) do
                    if obj then obj:Destroy() end
                    espObjects[name] = nil
                end
            end)
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        if _G.Toggles["AntiLag"] then
            _G.Toggles["AntiLag"] = false
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.CastShadow = false
                    elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
                end
            end)
        end
        task.wait(2)
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = _G.WalkSpeedValue hum.JumpPower = _G.JumpPowerValue end
    end)
end)

RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local camera = workspace.CurrentCamera
        if _G.Toggles["Flying"] and hrp and camera and hum then
            local bv = hrp:FindFirstChild("SpeedFlyBV") or Instance.new("BodyVelocity", hrp)
            bv.Name = "SpeedFlyBV" bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            local bg = hrp:FindFirstChild("SpeedFlyBG") or Instance.new("BodyGyro", hrp)
            bg.Name = "SpeedFlyBG" bg.maxForce = Vector3.new(9e9, 9e9, 9e9) bg.cframe = camera.CFrame
            if hum.MoveDirection.Magnitude > 0 then bv.velocity = camera.CFrame.LookVector * _G.FlySpeedValue
            else bv.velocity = Vector3.new(0, 0, 0) end
        else
            if hrp then
                if hrp:FindFirstChild("SpeedFlyBV") then hrp.SpeedFlyBV:Destroy() end
                if hrp:FindFirstChild("SpeedFlyBG") then hrp.SpeedFlyBG:Destroy() end
            end
        end
    end)
end)

LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(0.5)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)
