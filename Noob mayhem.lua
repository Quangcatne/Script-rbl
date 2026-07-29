-- [[ MAINSCRIPT.LUA - PART 4: INITIALIZE & MOVE PAGE ]] --
local UI_URL = "https://raw.githubusercontent.com/Quangcatne/Script-rbl/refs/heads/main/UILib.lua"
local Success, UiLibrary = pcall(function() return loadstring(game:HttpGet(UI_URL))() end)
if not Success or not UiLibrary then warn("Lỗi: Không tải được UI!"); return end

local Engine = UiLibrary:Init("Noob Mayhem V2 | By Qcat")
local MovePage = Engine:AddTab("Move")
local CombatPage = Engine:AddTab("Combat")
local AutoPage = Engine:AddTab("Auto")
local VisualPage = Engine:AddTab("Visual")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

_G.FlySpeed, _G.Flying = 50, false
_G.GodMode, _G.KillAura, _G.HitboxSize = false, false, 2
_G.AutoGold, _G.AutoMiniGame, _G.AutoClicker = false, false, false
_G.AntiFreeze, _G.AutoCollectChests, _G.AutoSpinWheel = false, false, false
_G.SelectedMap, _G.AutoFarmMap, _G.SafeHeight = "Arena", false, 15
local FlyConn, NoclipConn

Engine:AddToggle(MovePage, "Kích hoạt Bay (Fly)", "flymode", false, function(state)
    _G.Flying = state; local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    if _G.Flying then
        local Hum = Char:FindFirstChildOfClass("Humanoid"); local Root = Char.HumanoidRootPart
        local BG = Instance.new("BodyGyro", Root)
        BG.P = 9e4; BG.maxTorque = Vector3.new(9e9, 9e9, 9e9); BG.cframe = Root.CFrame
        local BV = Instance.new("BodyVelocity", Root)
        BV.velocity = Vector3.new(0, 0.1, 0); BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        FlyConn = RunService.RenderStepped:Connect(function()
            if not _G.Flying or not Char:Parent() then BG:Destroy(); BV:Destroy(); if FlyConn then FlyConn:Disconnect() end; return end
            local Dir = Hum.MoveDirection; BV.velocity = Dir * _G.FlySpeed; BG.cframe = workspace.CurrentCamera.CFrame
            if Dir.Magnitude == 0 then BV.velocity = Vector3.new(0,0,0) end
        end)
    else if FlyConn then FlyConn:Disconnect() end end
end)
Engine:AddSlider(MovePage, "Tốc độ Bay (Fly)", 10, 250, 50, function(v) _G.FlySpeed = v end)
Engine:AddSlider(MovePage, "Tốc độ Chạy (Speed)", 16, 300, 16, function(v)
    task.spawn(function()
        while task.wait(0.1) do
            if _G.SliderValues["Tốc độ Chạy (Speed)"] ~= v then break end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v end
        end
    end)
end)
Engine:AddSlider(MovePage, "Độ cao Nhảy (Jump)", 50, 500, 50, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); Hum.UseJumpPower = true; Hum.JumpPower = v
    end
end)
-- [[ MAINSCRIPT.LUA - PART 5: COMBAT PAGE FUNCTIONS ]] --
Engine:AddToggle(CombatPage, "Bất tử (God Mode)", "godmode", false, function(state)
    _G.GodMode = state
    task.spawn(function()
        while _G.GodMode do
            pcall(function()
                local Hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if Hum and Hum.Health > 0 and Hum.Health < Hum.MaxHealth then Hum.Health = Hum.MaxHealth end
            end)
            task.wait(0.1)
        end
    end)
end)

Engine:AddToggle(CombatPage, "Kích hoạt Kill Aura", "killaura", false, function(state)
    _G.KillAura = state
    task.spawn(function()
        while _G.KillAura do
            pcall(function()
                local MyRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not MyRoot then return end
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and obj ~= LocalPlayer.Character and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("Humanoid") then
                        if (MyRoot.Position - obj.HumanoidRootPart.Position).Magnitude < 30 and obj.Humanoid.Health > 0 then
                            local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool"); if Tool then Tool:Activate() end
                        end
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end)

Engine:AddSlider(CombatPage, "Phóng to Hitbox Địch", 2, 50, 2, function(v)
    _G.HitboxSize = v
    task.spawn(function()
        pcall(function()
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Model") and obj ~= LocalPlayer.Character and obj:FindFirstChild("HumanoidRootPart") then
                    obj.HumanoidRootPart.Size = Vector3.new(v, v, v); obj.HumanoidRootPart.Transparency = 0.7; obj.HumanoidRootPart.CanCollide = false
                end
            end
        end)
    end)
end)
-- [[ MAINSCRIPT.LUA - PART 6: AUTO, VISUAL & ANTI-AFK ]] --
Engine:AddToggle(AutoPage, "Auto Nhặt Vàng", "autogold", false, function(state)
    _G.AutoGold = state
    task.spawn(function() while _G.AutoGold do pcall(function()
        local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if Root then for _, part in pairs(workspace:GetDescendants()) do if part:IsA("BasePart") and (part.Name:lower():find("coin") or part.Name:lower():find("gold")) then part.CFrame = Root.CFrame end end end
    end) task.wait(0.3) end end)
end)

Engine:AddToggle(AutoPage, "Auto Nhặt Rương Báu", "autochests", false, function(state)
    _G.AutoCollectChests = state
    task.spawn(function() while _G.AutoCollectChests do pcall(function()
        local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if Root then for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("BasePart") and (obj.Name:lower():find("chest") or obj.Name:lower():find("treasure")) then obj.CFrame = Root.CFrame end end end
    end) task.wait(0.5) end end)
end)

Engine:AddToggle(AutoPage, "Tự Động Nhập Mã Code", "autocode", false, function(state)
    if state then local Codes = {"ALPHA", "MAYHEM", "RELEASE", "FREECOINS", "SHEDLETSKY"}
        for _, code in pairs(Codes) do pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RedeemCode"):FireServer(code) end) task.wait(0.5) end
    end
end)

Engine:AddToggle(AutoPage, "Auto Clicker Chuột", "autoclick", false, function(state)
    _G.AutoClicker = state
    task.spawn(function() while _G.AutoClicker do local Tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool"); if Tool then Tool:Activate() end task.wait(0.01) end end)
end)

local MapList = {"Arena", "Lobby Stage", "Boss Raid Zone", "Event Map", "Snowy Mountain"}
Engine:AddDropdown(AutoPage, "Chọn Map Muốn Farm", MapList, function(selected) _G.SelectedMap = selected end)

Engine:AddToggle(AutoPage, "Auto Farm Mini Game / Map", "farmmap", false, function(state)
    _G.AutoFarmMap = state
    task.spawn(function()
        while _G.AutoFarmMap do pcall(function()
            local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if Root then local TargetStage = workspace:FindFirstChild(_G.SelectedMap) or workspace.Maps:FindFirstChild(_G.SelectedMap)
                if TargetStage then local Pos = TargetStage:IsA("BasePart") and TargetStage.CFrame or TargetStage:FindFirstChildOfClass("BasePart").CFrame
                    Root.CFrame = Pos * CFrame.new(0, _G.SafeHeight, 0)
                    if not Root:FindFirstChild("GameVelocity") then local BV = Instance.new("BodyVelocity"); BV.Name = "GameVelocity"; BV.Velocity = Vector3.new(0,0,0); BV.MaxForce = Vector3.new(9e9,9e9,9e9); BV.Parent = Root end
                end
            end
        end) task.wait(0.5) end
        pcall(function() local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if Root and Root:FindFirstChild("GameVelocity") then Root.GameVelocity:Destroy() end end)
    end)
end)
Engine:AddSlider(AutoPage, "Độ cao Treo Không", 0, 100, 15, function(v) _G.SafeHeight = v end)

Engine:AddToggle(VisualPage, "Bật ESP Nhìn Xuyên Tường", "esp", false, function(state)
    _G.ESP_Enabled = state
    for _, obj in pairs(workspace:GetChildren()) do if obj:IsA("Model") and obj ~= LocalPlayer.Character and obj:FindFirstChild("HumanoidRootPart") then
        if _G.ESP_Enabled then if not obj.HumanoidRootPart:FindFirstChild("Highlight") then local Hl = Instance.new("Highlight", obj.HumanoidRootPart); Hl.FillColor = Color3.fromRGB(255, 0, 0); Hl.OutlineColor = Color3.fromRGB(255, 255, 255) end
        else if obj.HumanoidRootPart:FindFirstChild("Highlight") then obj.HumanoidRootPart.Highlight:Destroy() end end
    end end
end)

Engine:AddToggle(VisualPage, "Chống Đông Cứng (Anti-Freeze)", "antifreeze", false, function(state)
    _G.AntiFreeze = state
    task.spawn(function() while _G.AntiFreeze do pcall(function() local Hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if Hum and (Hum.PlatformStand or Hum.WalkSpeed == 0) then Hum.PlatformStand = false; Hum.WalkSpeed = _G.SliderValues["Tốc độ Chạy (Speed)"] or 16 end end) task.wait(0.1) end end)
end)

Engine:AddToggle(VisualPage, "Auto Quay Vòng Quay", "autowheel", false, function(state)
    _G.AutoSpinWheel = state
    task.spawn(function() while _G.AutoSpinWheel do pcall(function() local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 3); local Spin = Remotes and (Remotes:FindFirstChild("ClaimDaily") or Remotes:FindFirstChild("SpinWheel")); if Spin then Spin:FireServer() end end) task.wait(10) end end)
end)

LocalPlayer.Idled:Connect(function() pcall(function() VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame); task.wait(1); VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end) end)
