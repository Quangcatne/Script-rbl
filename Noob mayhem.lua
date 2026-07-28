-- [[ NOOB MAYHEM ADVANCED SYSTEM - BY QCAT ]] --
-- [BLOCK 1: CONFIGURATION & PROTECTION SYSTEM]

-- 1. Khởi tạo cấu hình trạng thái hệ thống
_G.WalkSpeedValue = 16
_G.JumpPowerValue = 50
_G.NoclipActive = false
_G.FlyActive = false
_G.FlySpeed = 50
_G.AutoCoin = false
_G.AdvancedFarm = false
_G.KillAura = false
_G.AuraRange = 15
_G.AttackSpeed = 0.2
_G.FarmMethod = "Phía Trên"
_G.StaffDetectionActive = false
_G.StaffAction = "Auto Hop (Đổi Server)"
_G.AntiAFK = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- CẤU HÌNH NHÓM ADMIN ĐỂ KIỂM THỬ (Thay đổi ID nhóm và Tên acc của bạn tại đây)
local TARGET_GROUP_ID = 12345678 
local MIN_STAFF_RANK = 200      
local SPECIAL_ADMINS = { ["Qcat"] = true }

-- 2. Vòng lặp Xuyên Tường (Noclip) qua Stepped Event
RunService.Stepped:Connect(function()
    if _G.NoclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- 3. Vòng lặp Chế Độ Bay (Fly Mode) tối ưu D-Pad Mobile
task.spawn(function()
    while true do
        task.wait(0.01)
        if _G.FlyActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                root.Velocity = Vector3.new(0, 0.1, 0)
                if humanoid.MoveDirection.Magnitude > 0 then
                    root.Velocity = humanoid.MoveDirection * _G.FlySpeed
                end
            end
        end
    end
end)

-- 4. Logic Xử lý Tự Động Đổi Máy Chủ (Auto Hop)
function _G.QcatAutoHop()
    local HttpService = game:GetService("HttpService")
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://roblox.com" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                return
            end
        end
    end
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

-- 5. Cơ chế kiểm tra và xử lý khi phát hiện Admin vào phòng
function _G.CheckAndActionStaff(player)
    if player == LocalPlayer or not _G.StaffDetectionActive then return end
    local isStaff = SPECIAL_ADMINS[player.Name]
    local success, roleRank = pcall(function() return player:GetRankInGroup(TARGET_GROUP_ID) end)
    if (success and roleRank >= MIN_STAFF_RANK) or isStaff then
        if _G.StaffAction == "Auto Hop (Đổi Server)" then _G.QcatAutoHop()
        elseif _G.StaffAction == "Tự Kick Bản Thân" then 
            LocalPlayer:Kick("\n[Qcat Protection]\nPhát hiện Staff: " .. player.Name) 
        end
    end
end
Players.PlayerAdded:Connect(function(p) _G.CheckAndActionStaff(p) end)

-- 6. Chống AFK bóp nghẹt kết nối sau 20 phút
Players.LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then game:GetService("VirtualUser"):CaptureController() game:GetService("VirtualUser"):ClickButton2(Vector2.new(0,0)) end
end)

-- [BLOCK 2: AUTOMATION FARM & COMBAT CORE ENGINE]

-- 1. Vòng lặp Auto Farm Coin (Dịch Chuyển Nhặt Xu)
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoCoin and LocalPlayer.Character then
            local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local coinsFolder = workspace:FindFirstChild("Coins") or workspace:FindFirstChild("Drops")
            if myRoot and coinsFolder then
                for _, coin in pairs(coinsFolder:GetChildren()) do
                    if _G.AutoCoin and coin:IsA("BasePart") and myRoot.Parent then
                        myRoot.CFrame = coin.CFrame
                        task.wait(0.3)
                    end
                end
            end
        end
    end
end)

-- 2. Vòng lặp Auto Farm Quái Vật (Giữ khoảng cách an toàn)
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AdvancedFarm and LocalPlayer.Character then
            local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local enemies = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("NPCs")
            if myRoot and enemies and myRoot.Parent then
                for _, enemy in pairs(enemies:GetChildren()) do
                    local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                    local enemyHumanoid = enemy:FindFirstChildOfClass("Humanoid")
                    while _G.AdvancedFarm and enemyRoot and enemyHumanoid and enemyHumanoid.Health > 0 and myRoot.Parent do
                        local targetCFrame
                        if _G.FarmMethod == "Phía Trên" then targetCFrame = enemyRoot.CFrame * CFrame.new(0, 7, 0)
                        elseif _G.FarmMethod == "Phía Dưới" then targetCFrame = enemyRoot.CFrame * CFrame.new(0, -7, 0)
                        else targetCFrame = enemyRoot.CFrame * CFrame.new(0, 0, 5) end
                        myRoot.CFrame = targetCFrame
                        task.wait(0.1)
                    end
                end
            end
        end
    end
end)

-- 3. Vòng lặp Kill Aura (Quét mục tiêu diện rộng xung quanh Client)
task.spawn(function()
    while true do
        task.wait(_G.AttackSpeed or 0.2)
        if _G.KillAura and LocalPlayer.Character then
            local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local enemies = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("NPCs")
            if myRoot and enemies then
                for _, enemy in pairs(enemies:GetChildren()) do
                    local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                    local enemyHumanoid = enemy:FindFirstChildOfClass("Humanoid")
                    if enemyRoot and enemyHumanoid and enemyHumanoid.Health > 0 and myRoot.Parent then
                        if (myRoot.Position - enemyRoot.Position).Magnitude <= _G.AuraRange then
                            local remote = game.ReplicatedStorage:FindFirstChild("DealDamageRemote")
                            if remote and remote:IsA("RemoteEvent") then
                                remote:FireServer(enemy, 10)
                            end
                        end
                    end
                end
            end
        end
    end
end)
-- [BLOCK 3: RAYFIELD GRAPHICAL USER INTERFACE)

-- Tải thư viện Rayfield UI chính thức
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()
local Window = Rayfield:CreateWindow({
   Name = "Noob Mayhem Script | Created by Qcat",
   LoadingTitle = "Noob Mayhem Security Hub",
   LoadingSubtitle = "by Qcat",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Thiết lập các tab chức năng không dùng icon để chống crash Mobile
local LocalTab = Window:CreateTab("🏃 Local Player", nil)
local FarmTab = Window:CreateTab("🌾 Farm Nâng Cao", nil)
local CombatTab = Window:CreateTab("⚔️ Combat / Đấu", nil)
local ProtectionTab = Window:CreateTab("🛡️ Phòng Thủ", nil)
local VulnTab = Window:CreateTab("⚠️ Lỗ Hổng", nil)

-- --- DANH MỤC: LOCAL PLAYER ---
LocalTab:CreateSection("--- Chỉ Số Vật Lý ---")
LocalTab:CreateSlider({Name = "Tốc Độ Di Chuyển (WalkSpeed)", Min = 16, Max = 150, CurrentValue = 16, Callback = function(v) _G.WalkSpeedValue = v; if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v end end})
LocalTab:CreateSlider({Name = "Độ Cao Nhảy (JumpPower)", Min = 50, Max = 300, CurrentValue = 50, Callback = function(v) _G.JumpPowerValue = v; local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower = true h.JumpPower = v end end})
LocalTab:CreateSection("--- Trạng Thái Đặc Biệt ---")
LocalTab:CreateToggle({Name = "Kích Hoạt Noclip (Xuyên Tường)", CurrentValue = false, Callback = function(v) _G.NoclipActive = v end})
LocalTab:CreateToggle({Name = "Kích Hoạt Chế Độ Bay (Fly)", CurrentValue = false, Callback = function(v) _G.FlyActive = v end})
LocalTab:CreateSlider({Name = "Tốc Độ Bay (Fly Speed)", Min = 20, Max = 250, CurrentValue = 50, Callback = function(v) _G.FlySpeed = v end})

-- --- DANH MỤC: FARM ADVANCED ---
FarmTab:CreateSection("--- Cày Cuốc Tự Động ---")
FarmTab:CreateToggle({Name = "Auto Farm Coin (Dịch Chuyển Nhặt)", CurrentValue = false, Callback = function(v) _G.AutoCoin = v end})
FarmTab:CreateDropdown({Name = "Vị Trí Đứng Farm Quái", Options = {"Phía Trên", "Phía Dưới", "Phía Sau"}, CurrentOption = {"Phía Trên"}, Callback = function(o) _G.FarmMethod = type(o) == "table" and o or o end})
FarmTab:CreateToggle({Name = "Kích Hoạt Auto Farm Quái", CurrentValue = false, Callback = function(v) _G.AdvancedFarm = v end})
FarmTab:CreateSection("--- Tối Ưu Đồ Họa ---")
FarmTab:CreateButton({Name = "Bật Chế Độ Siêu Mượt (Anti-Lag Mobile)", Callback = function() for _, o in pairs(workspace:GetDescendants()) do if o:IsA("ParticleEmitter") or o:IsA("Trail") then o.Enabled = false end end local t = workspace:FindFirstChildOfClass("Terrain") if t then t.WaterWaveSize = 0 t.WaterWaveSpeed = 0 end game:GetService("Lighting").GlobalShadows = false end})

-- --- DANH MỤC: COMBAT ---
CombatTab:CreateSection("--- Hỗ Trợ Đấu ---")
CombatTab:CreateToggle({Name = "Kích Hoạt Kill Aura (Auto Đánh)", CurrentValue = false, Callback = function(v) _G.KillAura = v end})
CombatTab:CreateSlider({Name = "Phạm Vi Quét Sát Thương (Studs)", Min = 5, Max = 60, CurrentValue = 15, Callback = function(v) _G.AuraRange = v end})
CombatTab:CreateSlider({Name = "Tốc Độ Đánh (Delay Giây)", Min = 1, Max = 10, CurrentValue = 2, Callback = function(v) _G.AttackSpeed = v/10 end})

-- --- DANH MỤC: PROTECTION ---
ProtectionTab:CreateSection("--- Phát Hiện Quản Trị Viên (Staff) ---")
ProtectionTab:CreateToggle({Name = "Kích Hoạt Quét Admin", CurrentValue = false, Callback = function(v) _G.StaffDetectionActive = v if v then for _, p in pairs(game.Players:GetPlayers()) do _G.CheckAndActionStaff(p) end end end})
ProtectionTab:CreateDropdown({Name = "Hành Động Khi Phát Hiện", Options = {"Auto Hop (Đổi Server)", "Tự Kick Bản Thân"}, CurrentOption = {"Auto Hop (Đổi Server)"}, Callback = function(o) _G.StaffAction = type(o) == "table" and o or o end})
ProtectionTab:CreateToggle({Name = "Bật Cơ Chế Treo Máy Chống AFK", CurrentValue = false, Callback = function(v) _G.AntiAFK = v end})

-- --- DANH MỤC: VULNERABILITY ---
VulnTab:CreateSection("--- Kiểm Lỗi Sức Chịu Đựng ---")
VulnTab:CreateToggle({Name = "Spam Request Remote (Stress Test Server)", CurrentValue = false, Callback = function(v) _G.SpamRemote = v if v then task.spawn(function() while _G.SpamRemote do local r = game.ReplicatedStorage:FindFirstChildOfClass("RemoteEvent") if r then r:FireServer("Qcat Test") end task.wait(0.05) end end) end end})
VulnTab:CreateButton({Name = "Bypass Thử Nghiệm Hàm Kick (Anti-Kick Hook)", Callback = function() local g = getrawmetatable(game) setreadonly(g, false) local old = g.__namecall g.__namecall = newcclosure(function(self, ...) if string.lower(getnamecallmethod()) == "kick" then print("[Qcat Blocked] Server tried to kick client!") return nil end return old(self, ...) end) setreadonly(g, true) end})

Rayfield:Init()
