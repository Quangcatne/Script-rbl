-- [[ NOOB MAYHEM - DYNAMIC ITEM SCANNER BY QCAT ]]
-- Auto-scans inventory tools and dynamically injects them into the Orion Dropdown

-- Cú pháp chuẩn hóa để nạp thư viện Orion UI
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Khởi tạo giao diện Qcat Hub
local Window = OrionLib:MakeWindow({
    Name = "Qcat Hub | Noob Mayhem [DYNAMIC SCAN]", 
    HidePremium = true, 
    SaveConfig = true, 
    ConfigFolder = "QcatHub_DynamicScan",
    IntroText = "Qcat Dynamic Engine..."
})

-- Quản lý trạng thái toàn cục
_G.KillAura = false
_G.AuraRange = 20
_G.NoCooldownActive = false
_G.SelectedTargetWeapon = "Tất cả vật phẩm" -- Mặc định là bẻ khóa toàn bộ

-- Danh sách lưu trữ tên vũ khí quét được thực tế trong game
local ScannedWeaponsList = {"Tất cả vật phẩm"}

-- Hàm tiện ích quét tìm quái gần nhất (Dùng cho Kill Aura)
local function getClosestEnemy()
    local closest = nil
    local shortestDistance = math.huge
    local container = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("Mobs") or workspace
    for _, obj in ipairs(container:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("Humanoid") then
            if obj.Name ~= LocalPlayer.Name and obj.Humanoid.Health > 0 then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                    if dist < shortestDistance then
                        closest = obj
                        shortestDistance = dist
                    end
                end
            end
        end
    end
    return closest
end

-- Hàm quét động túi đồ để tìm tất cả các Object là "Tool" (Vũ khí/Item)
local function updateInventoryList()
    -- Đặt lại danh sách về mặc định ban đầu
    ScannedWeaponsList = {"Tất cả vật phẩm"}
    local checkTable = {} -- Tránh trùng lặp tên hiển thị trên UI

    -- 1. Quét các Tool đang cầm trên tay
    if LocalPlayer.Character then
        for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
            if item:IsA("Tool") and not checkTable[item.Name] then
                table.insert(ScannedWeaponsList, item.Name)
                checkTable[item.Name] = true
            end
        end
    end

    -- 2. Quét các Tool đang cất trong túi đồ (Backpack)
    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and not checkTable[item.Name] then
            table.insert(ScannedWeaponsList, item.Name)
            checkTable[item.Name] = true
        end
    end
end

-- ==========================================
-- TAB 1: COMBAT & AURA
-- ==========================================
local CombatTab = Window:MakeTab({
    Name = "Combat & Aura",
    Icon = "rbxassetid://4483345998"
})

CombatTab:AddToggle({
    Name = "Enable Kill Aura",
    Default = false,
    Callback = function(Value)
        _G.KillAura = Value
    end    
})

CombatTab:AddSlider({
    Name = "Aura Range (Tầm đánh)",
    Min = 5,
    Max = 100,
    Default = 20,
    Color = Color3.fromRGB(255, 85, 85),
    Increment = 1,
    ValueName = "Studs",
    Callback = function(Value)
        _G.AuraRange = Value
    end    
})

task.spawn(function()
    while true do
        if _G.KillAura then
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local equippedTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if equippedTool then
                        local target = getClosestEnemy()
                        if target and target:FindFirstChild("HumanoidRootPart") then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude
                            if dist <= _G.AuraRange then
                                equippedTool:Activate()
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.02)
    end
end)

-- ==========================================
-- TAB 2: DYNAMIC EXPLOIT (Quét & Chọn Vũ Khí)
-- ==========================================
local ExploitTab = Window:MakeTab({
    Name = "Weapon Exploits",
    Icon = "rbxassetid://4483362458"
})

-- Khởi tạo danh sách thả xuống trước (Ban đầu chỉ có chữ "Tất cả vật phẩm")
local WeaponDropdown = ExploitTab:AddDropdown({
    Name = "Select Weapon (Chọn súng/vật phẩm)",
    Default = "Tất cả vật phẩm",
    Options = ScannedWeaponsList,
    Callback = function(Value)
        _G.SelectedTargetWeapon = Value
        print("Qcat Hub: Đã chọn mục tiêu bẻ khóa Cooldown -> " .. Value)
    end
})

-- Nút bấm thực hiện hành động quét đồ thời gian thực
ExploitTab:AddButton({
    Name = "🔄 Scan Inventory (Cập nhật túi đồ)",
    Callback = function()
        updateInventoryList() -- Chạy hàm quét
        -- Ép Orion UI cập nhật lại danh sách lựa chọn mới vừa quét được lên màn hình
        WeaponDropdown:Refresh(ScannedWeaponsList, true)
        
        OrionLib:MakeNotification({
            Name = "Qcat Dynamic Scanner",
            Content = "Đã quét xong! Hãy mở Dropdown để chọn vật phẩm thực tế.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- Bật/Tắt chế độ bẻ khóa Cooldown
ExploitTab:AddToggle({
    Name = "Enable No Cooldown Mode",
    Default = false,
    Callback = function(Value)
        _G.NoCooldownActive = Value
    end    
})

-- [LUỒNG XỬ LÝ ÉP BỎ COOLDOWN THEO LỰA CHỌN]
task.spawn(function()
    while true do
        if _G.NoCooldownActive then
            pcall(function()
                -- Tạo một danh sách gom các món đồ cần bẻ khóa trong luồng này
                local itemsToBypass = {}

                -- Thu thập toàn bộ Tool hiện có
                local allTools = {}
                if LocalPlayer.Character then
                    for _, v in ipairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") then table.insert(allTools, v) end end
                end
                for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(allTools, v) end end

                -- Lọc vật phẩm dựa trên cài đặt UI người dùng chọn
                for _, tool in ipairs(allTools) do
                    if _G.SelectedTargetWeapon == "Tất cả vật phẩm" then
                        table.insert(itemsToBypass, tool)
                    elseif tool.Name == _G.SelectedTargetWeapon then
                        table.insert(itemsToBypass, tool)
                    end
                end

                -- Thực hiện bẻ khóa Cooldown và ép bắn siêu tốc cho các mục tiêu đã lọc
                for _, tool in ipairs(itemsToBypass) do
                    -- Nếu món đồ đang cất trong balo, tự động lôi ra tay để kích hoạt
                    if tool.Parent == LocalPlayer.Backpack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:EquipTool(tool)
                    end

                    -- Ép hành động bắn/sử dụng liên tục
                    tool:Activate()

                    -- Bẻ gãy các biến Cooldown/Reloading ẩn bên trong Tool (nếu có)
                    if tool:FindFirstChild("Cooldown") then tool.Cooldown.Value = 0 end
                    if tool:FindFirstChild("Reloading") then tool.Reloading.Value = false end
                end
            end)
        end
        task.wait(0.01) -- Độ trễ 10ms biến mọi khẩu súng đơn thanh được chọn thành súng sấy liên thanh
    end
end)

OrionLib:Init()
