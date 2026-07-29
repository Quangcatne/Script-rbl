local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("Qcat Hub", "Midnight")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

_G.KillAura = false
_G.AuraRange = 20
_G.NoCooldown = false
_G.SelectedTargetWeapon = "Tất cả"
_G.GodMode = false
_G.AntiLag = false
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.FlySpeed = 50
_G.Flying = false

local ScannedWeaponsList = {"Tất cả"}

-- [FIX ANTI-AFK]
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(0.5)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- [FIX QUÉT QUÁI THỜI GIAN THỰC]
local function getClosestEnemy()
    local closest, shortestDistance = nil, math.huge
    -- Quét diện rộng toàn bộ Workspace để tránh bỏ sót các Object quái ẩn
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("Humanoid") then
            if obj.Name ~= LocalPlayer.Name and obj.Humanoid.Health > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                if dist < shortestDistance then closest, shortestDistance = obj, dist end
            end
        end
    end
    return closest
end

local function updateInventoryList()
    ScannedWeaponsList = {"Tất cả"}
    local checkTable = {}
    if LocalPlayer.Character then
        for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
            if item:IsA("Tool") and not checkTable[item.Name] then table.insert(ScannedWeaponsList, item.Name) checkTable[item.Name] = true end
        end
    end
    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and not checkTable[item.Name] then table.insert(ScannedWeaponsList, item.Name) checkTable[item.Name] = true end
    end
end

-- ==========================================
-- TAB 1: COMBAT (FIX CẬP NHẬT THEO FRAME)
-- ==========================================
local Tab1 = Window:NewTab("Combat")
local Sec1 = Tab1:NewSection("Kill Aura")

Sec1:NewToggle("Bật Kill Aura", "Tự đánh quái gần nhất", function(v) _G.KillAura = v end)
Sec1:NewSlider("Tầm đánh", "Phạm vi mét (Studs)", 100, 5, function(v) _G.AuraRange = v end)

-- Sử dụng RenderStepped để ép đòn đánh chém liên tục theo tốc độ màn hình (Bypass Slider lag)
RunService.RenderStepped:Connect(function()
    if _G.KillAura and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            local target = getClosestEnemy()
            if target and target:FindFirstChild("HumanoidRootPart") then
                if (LocalPlayer.Character.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude <= _G.AuraRange then 
                    tool:Activate() 
                end
            end
        end
    end
end)

-- ==========================================
-- TAB 2: EXPLOIT (FIX BẺ GÃY COOLDOWN GIAO DIỆN)
-- ==========================================
local Tab2 = Window:NewTab("Exploit")
local Sec2 = Tab2:NewSection("Bẻ khóa Vũ Khí")

local WeaponDropdown = Sec2:NewDropdown("Chọn vật phẩm", "Vũ khí cần xóa CD", ScannedWeaponsList, function(v) _G.SelectedTargetWeapon = v end)

Sec2:NewButton("🔄 Quét túi đồ", "Cập nhật súng/máu mới", function()
    updateInventoryList()
    WeaponDropdown:Refresh(ScannedWeaponsList)
end)

Sec2:NewToggle("Bỏ Cooldown (No CD)", "Xóa sạch thời gian chờ", function(v) _G.NoCooldown = v end)

-- Luồng bẻ khóa sâu: Ép hủy trạng thái Reloading và Reset trạng thái đòn đánh
task.spawn(function()
    while true do
        if _G.NoCooldown then
            pcall(function()
                local allTools = {}
                if LocalPlayer.Character then for _, v in ipairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") then table.insert(allTools, v) end end end
                for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(allTools, v) end end
                
                for _, tool in ipairs(allTools) do
                    if _G.SelectedTargetWeapon == "Tất cả" or tool.Name == _G.SelectedTargetWeapon then
                        -- Tự cầm lên tay
                        if tool.Parent == LocalPlayer.Backpack and LocalPlayer.Character:FindFirstChild("Humanoid") then 
                            LocalPlayer.Character.Humanoid:EquipTool(tool) 
                        end
                        
                        -- Ép bắn vật lý liên tục
                        tool:Activate()
                        
                        -- FIX COOLDOWN: Ép sập toàn bộ các biến điều phối Logic ẩn
                        for _, child in ipairs(tool:GetDescendants()) do
                            if child:IsA("NumberValue") or child:IsA("IntValue") then
                                child.Value = 0
                            elseif child:IsA("BoolValue") then
                                -- Ép trạng thái súng luôn sẵn sàng bắn (Reloading = false, Shooting = true)
                                if child.Name:lower():match("reload") then child.Value = false end
                                if child.Name:lower():match("shoot") or child.Name:lower():match("active") then child.Value = true end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.01) -- Chu kỳ quét 10ms phá vỡ giới hạn Client Delay
    end
end)

-- ==========================================
-- TAB 3: MOVEMENT (FIX BAY THEO HƯỚNG CAMERA ĐIỆN THOẠI)
-- ==========================================
local Tab3 = Window:NewTab("Movement")
local Sec3 = Tab3:NewSection("Chỉ số di chuyển")

Sec3:NewSlider("Tốc độ chạy", "WalkSpeed", 300, 16, function(v) _G.WalkSpeed = v end)
Sec3:NewSlider("Lực nhảy cao", "JumpPower", 400, 50, function(v) _G.JumpPower = v end)

-- Đồng bộ chỉ số di chuyển liên tục qua luồng mạng tránh bị game rollback
RunService.Heartbeat:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeed
            LocalPlayer.Character.Humanoid.JumpPower = _G.JumpPower
        end
    end)
end)

Sec3:NewToggle("Bật chế độ Bay", "Fly Mode", function(v)
    _G.Flying = v
    local char = LocalPlayer.Character
    if not v and char and char:FindFirstChild("HumanoidRootPart") then
        if char.HumanoidRootPart:FindFirstChild("QcatFlyBV") then char.HumanoidRootPart.QcatFlyBV:Destroy() end
        if char.HumanoidRootPart:FindFirstChild("QcatFlyBG") then char.HumanoidRootPart.QcatFlyBG:Destroy() end
    end
end)

Sec3:NewSlider("Tốc độ bay", "Fly Speed", 300, 10, function(v) _G.FlySpeed = v end)

-- Luồng xử lý bay thông minh: Di chuyển dựa theo hướng vuốt màn hình di động
RunService.Stepped:Connect(function()
    if _G.Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local camera = workspace.CurrentCamera
            
            local bv = hrp:FindFirstChild("QcatFlyBV") or Instance.new("BodyVelocity", hrp)
            bv.Name = "QcatFlyBV" bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            
            local bg = hrp:FindFirstChild("QcatFlyBG") or Instance.new("BodyGyro", hrp)
            bg.Name = "QcatFlyBG" bg.maxForce = Vector3.new(9e9, 9e9, 9e9) bg.cframe = camera.CFrame
            
            local moveDir = LocalPlayer.Character.Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then 
                -- Nhân vật sẽ bay thẳng về hướng Camera đang nhìn (Nhìn lên trời bay lên, nhìn xuống đất bay xuống)
                bv.velocity = camera.CFrame.LookVector * _G.FlySpeed 
            else 
                bv.velocity = Vector3.new(0, 0, 0) -- Đứng im khóa vị trí trên không
            end
        end)
    end
end)

-- ==========================================
-- TAB 4: UTILS (FIX BẤT TỬ & ANTI-LAG CHUYÊN SÂU)
-- ==========================================
local Tab4 = Window:NewTab("Utils")
local Sec4 = Tab4:NewSection("Hỗ trợ hệ thống")

Sec4:NewToggle("Bật Bất tử (God)", "Khóa thanh máu vô hạn", function(v) _G.GodMode = v end)

RunService.Heartbeat:Connect(function()
    if _G.GodMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        pcall(function()
            -- Ép thanh máu vượt ngưỡng giới hạn vật lý để chống sốc sát thương từ Bazooka Boss
            LocalPlayer.Character.Humanoid.MaxHealth = 999999
            LocalPlayer.Character.Humanoid.Health = 999999
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end)
    end
end)

Sec4:NewToggle("Siêu Giảm Lag (FPS+)", "Xóa hiệu ứng khói nổ, vật liệu nhựa", function(v)
    _G.AntiLag = v
    if v then
        settings().Rendering.QualityLevel = 1
        -- Quét và xóa sạch các hiệu ứng khói lựu đạn, vụ nổ bazooka gây đứng hình điện thoại
        for _, obj in ipairs(workspace:GetDescendants()) do 
            if obj:IsA("BasePart") then 
                obj.Material = Enum.Material.SmoothPlastic 
                obj.CastShadow = false 
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end 
        end
    end
end)
