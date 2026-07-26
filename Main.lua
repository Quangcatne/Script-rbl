-- ====================================================================
-- SCRIPT NAME: rbl cmd | CREATOR: Qcatne
-- PHẦN 1: KHỞI TẠO KHUNG GIAO DIỆN VÀ HỆ THỐNG TABS MỚI
-- ====================================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("rbl_cmd_Qcatne") then
    CoreGui.rbl_cmd_Qcatne:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "rbl_cmd_Qcatne"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- CÁC BIẾN CẤU HÌNH TRẠNG THÁI
local noclipEnabled, infJumpEnabled, godModeEnabled, espEnabled, autoClickEnabled = false, false, false, false, false

-- NÚT TOGGLE TRÊN MOBILE
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
ToggleBtn.Text = "RC"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 20
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)

-- KHUNG MENU CHÍNH
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 320)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "rbl cmd | Created by Qcatne"
Title.TextColor3 = Color3.fromRGB(255, 0, 100)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Sidebar.Parent = MainFrame
local uiList = Instance.new("UIListLayout")
uiList.Parent = Sidebar
uiList.Padding = UDim.new(0, 5)
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -115, 1, -45)
ContentFrame.Position = UDim2.new(0, 115, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- ====================================================================
-- PHẦN 2: CÁC HÀM XỬ LÝ (TABS, INPUT, TOGGLE)
-- ====================================================================
local tabContainers = {}

local function CreateTab(tabName)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    tabBtn.Text = tabName:upper()
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 13
    tabBtn.Parent = Sidebar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 400)
    page.ScrollBarThickness = 3
    page.Visible = false
    page.Parent = ContentFrame
    
    tabContainers[tabName] = page

    tabBtn.MouseButton1Click:Connect(function()
        for name, p in pairs(tabContainers) do p.Visible = false end
        for _, btn in pairs(Sidebar:GetChildren()) do
            if btn:IsA("TextButton") then btn.TextColor3 = Color3.fromRGB(180, 180, 180) end
        end
        page.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 0, 100)
    end)
    return page
end

local function addInput(parentPage, placeholder, btnText, yPos, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.55, -5, 0, 35)
    box.Position = UDim2.new(0.025, 0, 0, yPos)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 12
    box.Parent = parentPage
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.35, 0, 0, 35)
    btn.Position = UDim2.new(0.6, 0, 0, yPos)
    btn.Text = btnText
    btn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = parentPage
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() callback(box.Text) end)
end

local function addToggle(parentPage, text, yPos, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.Position = UDim2.new(0.025, 0, 0, yPos)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(35, 35, 45)
    btn.Text = text .. (default and " [ON]" or " [OFF]")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = parentPage
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        local status = callback()
        btn.BackgroundColor3 = status and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(35, 35, 45)
        btn.Text = text .. (status and " [ON]" or " [OFF]")
    end)
end

local farmPage = CreateTab("farm")
local supportPage = CreateTab("support")
local vulnPage = CreateTab("vulnerability")
local themePage = CreateTab("theme tool")
farmPage.Visible = true
-- ====================================================================
-- PHẦN 3: CÀI ĐẶT CHI TIẾT TÍNH NĂNG CHO TỪNG DANH MỤC
-- ====================================================================

-- 1. MỤC FARM
addToggle(farmPage, "TỰ ĐỘNG CLICK (AUTO CLICK)", 10, autoClickEnabled, function()
    autoClickEnabled = not autoClickEnabled
    return autoClickEnabled
end)
task.spawn(function()
    while true do
        task.wait(0.1)
        if autoClickEnabled then
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        end
    end
end)

-- 2. MỤC SUPPORT
addInput(supportPage, "Nhập tốc độ chạy...", "SET SPEED", 10, function(t)
    local s = tonumber(t)
    if s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = s end
end)
addInput(supportPage, "Nhập lực nhảy cao...", "SET JUMP", 50, function(t)
    local j = tonumber(t)
    if j and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = j end
end)
addInput(supportPage, "Tên người chơi...", "TELEPORT", 90, function(t)
    if t ~= "" then
        for _, p in pairs(Players:GetPlayers()) do
            if string.lower(p.Name):sub(1, #t) == string.lower(t) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
                break
            end
        end
    end
end)
addToggle(supportPage, "NHÌN XUYÊN TƯỜNG (ESP)", 135, espEnabled, function()
    espEnabled = not espEnabled
    if not espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("rblCmdESP") then p.Character.rblCmdESP:Destroy() end
        end
    end
    return espEnabled
end)
RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("rblCmdESP") then
                local hl = Instance.new("Highlight")
                hl.Name = "rblCmdESP"
                hl.FillColor = Color3.fromRGB(255, 0, 100)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillOpacity = 0.4
                hl.Parent = p.Character
            end
        end
    end
end)

-- 3. MỤC VULNERABILITY
addToggle(vulnPage, "CHẾ ĐỘ BẤT TỬ (GOD)", 10, godModeEnabled, function()
    godModeEnabled = not godModeEnabled
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Dead, not godModeEnabled)
    end
    return godModeEnabled
end)
RunService.Heartbeat:Connect(function()
    if godModeEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end
end)
addToggle(vulnPage, "ĐI XUYÊN TƯỜNG (NOCLIP)", 50, noclipEnabled, function()
    noclipEnabled = not noclipEnabled
    return noclipEnabled
end)
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)
addToggle(vulnPage, "NHẢY VÔ HẠN (INF JUMP)", 90, infJumpEnabled, function()
    infJumpEnabled = not infJumpEnabled
    return infJumpEnabled
end)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- 4. MỤC THEME TOOL
addInput(themePage, "Mã màu RGB (VD: 0,255,0)...", "SET COLOR", 10, function(text)
    local colors = string.split(text, ",")
    local r, g, b = tonumber(colors[1]), tonumber(colors[2]), tonumber(colors[3])
    if r and g and b then
        local nc = Color3.fromRGB(r, g, b)
        Title.TextColor3 = nc
        ToggleBtn.BackgroundColor3 = nc
        for _, page in pairs(tabContainers) do
            for _, obj in pairs(page:GetChildren()) do
                if obj:IsA("TextButton") and obj.BackgroundColor3 ~= Color3.fromRGB(35, 35, 45) and obj.BackgroundColor3 ~= Color3.fromRGB(0, 200, 100) then
                    obj.BackgroundColor3 = nc
                end
            end
        end
    end
end)

local DelBtn = Instance.new("TextButton")
DelBtn.Size = UDim2.new(0.95, 0, 0, 35)
DelBtn.Position = UDim2.new(0.025, 0, 0, 150)
DelBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
DelBtn.Text = "UNLOAD SCRIPT"
DelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DelBtn.Font = Enum.Font.SourceSansBold
DelBtn.TextSize = 13
DelBtn.Parent = themePage
DelBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
