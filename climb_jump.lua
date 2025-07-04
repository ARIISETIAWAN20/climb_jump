-- ✅ CLIMB AND JUMP | Final Version | All Features Unlocked | Delta Mobile Safe

if game.PlaceId ~= 123921593837160 then
    return warn("[CLIMB AND JUMP] Script hanya berjalan di Climb and Jump Tower (Tokyo Tower).")
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- 🔐 HWID LOCK (bypass untuk supa_loi dan Devrenzx)
local allowedHWID = {
    ["ABC123DEF456"] = true -- ❗ Ganti ini dengan HWID kamu
}
local bypassName = {
    ["supa_loi"] = true,
    ["Devrenzx"] = true
}
local function getHWID()
    if gethwid then return gethwid()
    elseif syn and syn.request then return syn.request({Url="http://httpbin.org/get"}).Headers["Syn-Fingerprint"]
    elseif identifyexecutor then return identifyexecutor()
    elseif rconsoleprint then return tostring(rconsoleprint)
    else return "unknown_"..tostring(game.JobId):sub(1, 8)
    end
end
if not bypassName[LP.Name] then
    local hwid = getHWID()
    if not allowedHWID[hwid] then
        return LP:Kick("HWID tidak terdaftar. Hubungi pembuat script.")
    end
end

-- 🔍 DEEP SCAN SEDERHANA
local suspicious = {"admin","mod","staff","dev","helper"}
for _, plr in pairs(Players:GetPlayers()) do
    for _, word in pairs(suspicious) do
        if plr.Name:lower():find(word) then
            return LP:Kick("Admin/Staff terdeteksi dalam server.\n("..plr.Name..")")
        end
    end
end

-- 🚫 BLACKLIST
local blacklist = {
    ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
    ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
    ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
    ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
    ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
}
if blacklist[LP.Name] then
    return LP:Kick("Script tidak tersedia untuk staff/admin.")
end

-- 🛡️ ANTI KICK
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    if tostring(self) == "Kick" or getnamecallmethod() == "Kick" then
        return warn("[AntiKick] Diblok.")
    end
    return old(self, ...)
end)

-- 💤 ANTI AFK
for _,v in ipairs(getconnections(LP.Idled)) do v:Disable() end
task.spawn(function()
    while task.wait(300) do
        VIM:SendKeyEvent(true, "W", false, game)
        task.wait(0.2)
        VIM:SendKeyEvent(false, "W", false, game)
    end
end)

-- 💾 LOAD POINT & DELAY
local filename = "Climb_point.json"
if not isfile(filename) then
    writefile(filename, HttpService:JSONEncode({point1 = nil, point2 = nil, delay = 8}))
end
local saved = HttpService:JSONDecode(readfile(filename))
if typeof(saved.delay) ~= "number" or saved.delay < 1 or saved.delay > 10 then
    saved.delay = 8
    writefile(filename, HttpService:JSONEncode(saved))
end

local teleportEnabled = false
local minimized = false
local currentTarget = 1

-- 📦 UI
local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "ClimbAndJumpUI"
Gui.ResetOnSpawn = false

local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0, 180, 0, 190)
Frame.Position = UDim2.new(0, 10, 0.6, -95)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Text = "CLIMB AND JUMP"
Title.Size = UDim2.new(1, 0, 0, 26)
Title.BackgroundColor3 = Color3.fromRGB(70, 40, 120)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13

local MinBtn = Instance.new("TextButton", Frame)
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 28, 0, 26)
MinBtn.Position = UDim2.new(1, -30, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 180)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local TeleportBtn = Instance.new("TextButton", Frame)
TeleportBtn.Text = "🔁 Auto Teleport [OFF]"
TeleportBtn.Size = UDim2.new(1, -16, 0, 26)
TeleportBtn.Position = UDim2.new(0, 8, 0, 32)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(50, 90, 160)
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local SetPoint1Btn = Instance.new("TextButton", Frame)
SetPoint1Btn.Text = "📍 Set Point 1"
SetPoint1Btn.Size = UDim2.new(1, -16, 0, 26)
SetPoint1Btn.Position = UDim2.new(0, 8, 0, 62)
SetPoint1Btn.BackgroundColor3 = Color3.fromRGB(100, 60, 180)
SetPoint1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)

local SetPoint2Btn = Instance.new("TextButton", Frame)
SetPoint2Btn.Text = "📍 Set Point 2"
SetPoint2Btn.Size = UDim2.new(1, -16, 0, 26)
SetPoint2Btn.Position = UDim2.new(0, 8, 0, 92)
SetPoint2Btn.BackgroundColor3 = Color3.fromRGB(140, 60, 200)
SetPoint2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)

local DelayBox = Instance.new("TextBox", Frame)
DelayBox.PlaceholderText = "⏱ Delay (1-10)"
DelayBox.Text = tostring(saved.delay)
DelayBox.Size = UDim2.new(1, -16, 0, 26)
DelayBox.Position = UDim2.new(0, 8, 0, 122)
DelayBox.BackgroundColor3 = Color3.fromRGB(70, 70, 120)
DelayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayBox.ClearTextOnFocus = false

-- 📦 UI Logic
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in pairs(Frame:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextBox") then
            if v ~= MinBtn then v.Visible = not minimized end
        end
    end
    Frame.Size = minimized and UDim2.new(0, 140, 0, 26) or UDim2.new(0, 180, 0, 190)
end)

SetPoint1Btn.MouseButton1Click:Connect(function()
    local pos = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character.HumanoidRootPart.Position
    if pos then
        saved.point1 = {x=pos.X, y=pos.Y, z=pos.Z}
        writefile(filename, HttpService:JSONEncode(saved))
        SetPoint1Btn.Text = "✅ Point 1 Saved!"
        task.delay(2, function() SetPoint1Btn.Text = "📍 Set Point 1" end)
    end
end)

SetPoint2Btn.MouseButton1Click:Connect(function()
    local pos = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character.HumanoidRootPart.Position
    if pos then
        saved.point2 = {x=pos.X, y=pos.Y, z=pos.Z}
        writefile(filename, HttpService:JSONEncode(saved))
        SetPoint2Btn.Text = "✅ Point 2 Saved!"
        task.delay(2, function() SetPoint2Btn.Text = "📍 Set Point 2" end)
    end
end)

TeleportBtn.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    TeleportBtn.Text = teleportEnabled and "🔁 Auto Teleport [ON]" or "🔁 Auto Teleport [OFF]"
    TeleportBtn.BackgroundColor3 = teleportEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,90,160)
end)

DelayBox.FocusLost:Connect(function()
    local val = tonumber(DelayBox.Text)
    if val and val >= 1 and val <= 10 then
        saved.delay = val
        writefile(filename, HttpService:JSONEncode(saved))
    else
        DelayBox.Text = tostring(saved.delay)
    end
end)

-- 🔁 AUTO TELEPORT
RunService.Heartbeat:Connect(function()
    if teleportEnabled and saved.point1 and saved.point2 then
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local targetPos = currentTarget == 1 and saved.point1 or saved.point2
            local target = Vector3.new(targetPos.x, targetPos.y, targetPos.z)
            if (root.Position - target).Magnitude > 5 then
                root.CFrame = root.CFrame:Lerp(CFrame.new(target), 0.1)
            else
                currentTarget = currentTarget == 1 and 2 or 1
                task.wait(saved.delay)
            end
        end
    end
end)