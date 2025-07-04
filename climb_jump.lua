-- ✅ CLIMB AND JUMP | Final Version | Tanpa Anti Clip Velocity

-- ⚠️ HWID Lock - pengecualian nama "supa_loi" & "Devrenzx"
local allowedUsers = {
    ["supa_loi"] = true,
    ["Devrenzx"] = true
}

local Players = game:GetService("Players")
local user = Players.LocalPlayer
local hwid = tostring(rconsoleprint or print)
local unique_id = tostring(hwid):match("function: (.+)") or "unknown"

local allowedHWIDs = {
    ["9A1234AB"] = true,
    ["BEEF1234"] = true
}

if not allowedUsers[user.Name] and not allowedHWIDs[unique_id] then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "HWID LOCK", Text = "Perangkat tidak terdaftar!", Duration = 5
    })
    wait(2)
    user:Kick("HWID tidak terdaftar")
    return
end

-- ✅ File I/O Fallback untuk Delta Mobile
if not (writefile and readfile and isfile) then
    getgenv().writefile = function() end
    getgenv().readfile = function() return "{}" end
    getgenv().isfile = function() return false end
end

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local filename = "teleport_points.json"
local teleportPoints = {point1 = nil, point2 = nil}
local autoTeleport = false
local delayTime = 8

-- ✅ Blacklist Staff
local blacklist = {
    ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
    ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
    ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
    ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
    ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
}

Players.PlayerAdded:Connect(function(p)
    if blacklist[p.Name] then
        StarterGui:SetCore("SendNotification", {
            Title = "Auto Leave", Text = "Staff terdeteksi. Keluar game.", Duration = 1
        })
        wait(2)
        user:Kick("Staff terdeteksi")
    end
end)

for _, p in pairs(Players:GetPlayers()) do
    if blacklist[p.Name] and p ~= user then
        user:Kick("Staff terdeteksi")
    end
end

-- ✅ Anti Cheat Sederhana
pcall(function()
    for _,v in pairs(getnilinstances()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            v:Destroy()
        end
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "Anti Cheat", Text = "Proteksi sederhana diaktifkan", Duration = 5
})

-- ✅ Utility
local function loadPoints()
    if isfile(filename) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(filename))
        end)
        if success and type(data) == "table" then
            teleportPoints = data
        end
    end
end

local function savePoints()
    pcall(function()
        writefile(filename, HttpService:JSONEncode(teleportPoints))
    end)
end

local function getHRP()
    local char = user.Character or user.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function teleportTo(point)
    if point then
        local char = user.Character or user.CharacterAdded:Wait()
        local hrp = getHRP()
        hrp.Anchored = true
        hrp.Velocity = Vector3.zero
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
        wait(0.05)
        char:PivotTo(CFrame.new(point.x, point.y + 3, point.z))
        wait(0.05)
        hrp.Anchored = false
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
    end
end

-- ✅ UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGUI"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 160, 0, 200)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 20)
title.Text = "CLIMB AND JUMP"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
title.BorderSizePixel = 0
title.Font = Enum.Font.SourceSansBold
title.TextSize = 15
title.Parent = MainFrame

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 18, 0, 18)
minimizeButton.Position = UDim2.new(1, -20, 0, 1)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
minimizeButton.BorderSizePixel = 0
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 14
minimizeButton.Parent = MainFrame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -20)
contentFrame.Position = UDim2.new(0, 0, 0, 20)
contentFrame.BackgroundTransparency = 1
contentFrame.Name = "ContentFrame"
contentFrame.Parent = MainFrame

local function createButton(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 20)
    b.Position = UDim2.new(0, 5, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(90, 60, 150)
    b.TextColor3 = Color3.fromRGB(220, 230, 255)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 13
    b.Text = text
    b.Parent = contentFrame
    b.MouseButton1Click:Connect(callback)
    return b
end

createButton("🚀 Teleport to Point 1", 5, function() teleportTo(teleportPoints.point1) end)
createButton("🚀 Teleport to Point 2", 28, function() teleportTo(teleportPoints.point2) end)
createButton("📌 Set Point 1", 51, function()
    local hrp = getHRP()
    teleportPoints.point1 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}
    savePoints()
end)
createButton("📌 Set Point 2", 74, function()
    local hrp = getHRP()
    teleportPoints.point2 = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}
    savePoints()
end)

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(1, -10, 0, 18)
delayBox.Position = UDim2.new(0, 5, 0, 97)
delayBox.PlaceholderText = "Delay detik"
delayBox.Text = tostring(delayTime)
delayBox.BackgroundColor3 = Color3.fromRGB(70, 50, 120)
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.BorderSizePixel = 0
delayBox.ClearTextOnFocus = false
delayBox.Parent = contentFrame

delayBox.FocusLost:Connect(function()
    local val = tonumber(delayBox.Text)
    if val and val > 0 then delayTime = val end
end)

local autoBtn = createButton("▶️ Start Auto Teleport", 120, function()
    autoTeleport = not autoTeleport
    autoBtn.Text = autoTeleport and "⏹ Stop Auto Teleport" or "▶️ Start Auto Teleport"
end)

createButton("❌ OFF Auto Teleport", 143, function()
    autoTeleport = false
    autoBtn.Text = "▶️ Start Auto Teleport"
end)

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 14)
credit.Position = UDim2.new(0, 0, 1, -14)
credit.BackgroundTransparency = 1
credit.TextColor3 = Color3.fromRGB(200, 180, 255)
credit.Font = Enum.Font.SourceSansItalic
credit.TextSize = 11
credit.Text = "By Ari"
credit.Parent = MainFrame

spawn(function()
    while true do wait(1)
        if autoTeleport and teleportPoints.point1 and teleportPoints.point2 then
            teleportTo(teleportPoints.point1)
            wait(delayTime)
            teleportTo(teleportPoints.point2)
        end
    end
end)

for _,v in pairs(getconnections(user.Idled)) do v:Disable() end

loadPoints()

-- ✅ Minimize Logic
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    contentFrame.Visible = not minimized
    minimizeButton.Text = minimized and "+" or "-"
    MainFrame.Size = minimized and UDim2.new(0, 160, 0, 22) or UDim2.new(0, 160, 0, 200)
end)

user.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end)