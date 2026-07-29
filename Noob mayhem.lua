-- [[ PART 1: UI CONNECTION FOR NOOB MAYHEM ]] --
local RAW_UI_URL = "https://raw.githubusercontent.com/Quangcatne/Script-rbl/refs/heads/main/UILib.lua"
local Success, UiLibrary = pcall(function() return loadstring(game:HttpGet(RAW_UI_URL))() end)

if not Success or not UiLibrary then
    warn("Lỗi nghiêm trọng: Không thể kết nối tới tệp UILib.lua trên GitHub!")
    return
end

-- Dựng giao diện chính
local Engine = UiLibrary:Init("Noob Mayhem V2 | By Qcat")

-- Khởi tạo đúng 3 Trang danh mục như yêu cầu
local MovePage = Engine:AddTab("Movement")
local CombatPage = Engine:AddTab("Combat")
local AutoPage = Engine:AddTab("Automation")

-- Các biến môi trường dịch vụ của Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
