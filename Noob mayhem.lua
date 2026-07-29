local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua
        "))()
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

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

local function getClosestEnemy()
    local closest, shortestDistance = nil, math.huge
    local container = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("Mobs") or workspace
    for _, obj in ipairs(container:GetChildren()) do
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

-- TAB COMBAT
local Tab1 = Window:NewTab("Combat")
local Sec1 = Tab1:NewSection("Kill Aura")
Sec1:NewToggle("Bật Kill Aura", "Tự đánh quái", function(v) _G.KillAura = v end)
Sec1:NewSlider("Tầm đánh", "Phạm vi quét quái", 100, 5, function(v) _G.AuraRange = v end)

task.spawn(function()
    while true do
        if _G.KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    local target = getClosestEnemy()
                    if target and target:FindFirstChild("HumanoidRootPart") then
                        if (LocalPlayer.Character.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude <= _G.AuraRange then tool:Activate() end
                    end
                end
            end)
        end
        task.wait(0.02)
    end
end)

-- TAB EXPLOIT
local Tab2 = Window:NewTab("Exploit")
local Sec2 = Tab2:NewSection("No Cooldown")
local WeaponDropdown = Sec2:NewDropdown("Chọn vật phẩm", "Vũ khí cần bẻ CD", ScannedWeaponsList, function(v) _G.SelectedTargetWeapon = v end)
Sec2:NewButton("🔄 Quét túi đồ", "Cập nhật danh sách", function()
    updateInventoryList()
    WeaponDropdown:Refresh(ScannedWeaponsList)
end)
Sec2:NewToggle("Bỏ Cooldown (No CD)", "Xóa thời gian chờ", function(v) _G.NoCooldown = v end)

task.spawn(function()
    while true do
        if _G.NoCooldown then
            pcall(function()
                local allTools = {}
                if LocalPlayer.Character then for _, v in ipairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") then table.insert(allTools, v) end end end
                for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(allTools, v) end end
                for _, tool in ipairs(allTools) do
                    if _G.SelectedTargetWeapon == "Tất cả" or tool.Name == _G.SelectedTargetWeapon then
                        if tool.Parent == LocalPlayer.Backpack and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid:EquipTool(tool) end
                        tool:Activate()
                        for _, child in ipairs(tool:GetDescendants()) do
                            if child:IsA("NumberValue") or child:IsA("IntValue") then
                                if child.Name:lower():match("cooldown") or child.Name:lower():match("delay") or child.Name:lower():match("time") then child.Value = 0 end
                            elseif child:IsA("BoolValue") then
                                if child.Name:lower():match("reload") or child.Name:lower():match("shoot") or child.Name:match("active") then child.Value = false end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.01)
    end
end)

-- TAB MOVEMENT
local Tab3 = Window:NewTab("Movement")
local Sec3 = Tab3:NewSection("Di chuyển")
Sec3:NewSlider("Tốc độ chạy", "WalkSpeed", 300, 16, function(v) _G.WalkSpeed = v end)
Sec3:NewSlider("Lực nhảy cao", "JumpPower", 400, 50, function(v) _G.JumpPower = v end)

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

task.spawn(function()
    while true do
        if _G.Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local hrp = LocalPlayer.Character.HumanoidRootPart
                local bv = hrp:FindFirstChild("QcatFlyBV") or Instance.new("BodyVelocity", hrp)
                bv.Name = "QcatFlyBV" bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                local bg = hrp:FindFirstChild("QcatFlyBG") or Instance.new("BodyGyro", hrp)
                bg.Name = "QcatFlyBG" bg.maxForce = Vector3.new(9e9, 9e9, 9e9) bg.cframe = workspace.CurrentCamera.CFrame
                local moveDir = LocalPlayer.Character.Humanoid.MoveDirection
                if moveDir.Magnitude > 0 then bv.velocity = moveDir * _G.FlySpeed else bv.velocity = Vector3.new(0, 0.1, 0) end
            end)
        end
        task.wait()
    end
end)

-- TAB UTILS
local Tab4 = Window:NewTab("Utils")
local Sec4 = Tab4:NewSection("Tiện ích")
Sec4:NewToggle("Bật Bất tử (God)", "God Mode Alpha", function(v) _G.GodMode = v end)

task.spawn(function()
    while true do
        if _G.GodMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            pcall(function()
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
                LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end)
        end
        task.wait(0.1)
    end
end)

Sec4:NewToggle("Giảm Lag (FPS)", "Smooth Graphics", function(v)
    _G.AntiLag = v
    if v then
        settings().Rendering.QualityLevel = 1
        for _, obj in ipairs(workspace:GetDescendants()) do if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic obj.CastShadow = false end end
    end
end)
