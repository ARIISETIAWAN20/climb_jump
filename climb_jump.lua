-- ✅ CLIMB AND JUMP | ARII FUSION VERSION | Delta Mobile Safe

if game.PlaceId ~= 123921593837160 then
    return warn("[CLIMB AND JUMP] Hanya untuk Tokyo Tower.")
end

-- 🔧 Service
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- 🔐 HWID LOCK (bypass untuk supa_loi dan Devrenzx)
local allowedHWID = {
    ["ABC123DEF456"] = true -- Ganti HWID kamu di sini
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
        return LP:Kick("HWID tidak terdaftar.")
    end
end

-- 🔍 Deep Scan
local suspicious = {"admin","mod","staff","dev","helper"}
for _, p in pairs(Players:GetPlayers()) do
    for _, w in pairs(suspicious) do
        if p.Name:lower():find(w) then
            return LP:Kick("Staff terdeteksi: "..p.Name)
        end
    end
end

-- 🚫 Blacklist Staff
local blacklist = {
    ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
    ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
    ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
    ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
    ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
}
if blacklist[LP.Name] then
    return LP:Kick("Script tidak tersedia untuk staff.")
end

-- 🛡️ Anti Kick
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    if tostring(self) == "Kick" or getnamecallmethod() == "Kick" then
        return warn("[AntiKick] Diblokir.")
    end
    return old(self, ...)
end)

-- 💤 Anti AFK
for _,v in ipairs(getconnections(LP.Idled)) do v:Disable() end
task.spawn(function()
    while task.wait(300) do
        VIM:SendKeyEvent(true, "W", false, game)
        task.wait(0.2)
        VIM:SendKeyEvent(false, "W", false, game)
    end
end)

-- 💾 File Save
local filename = "Climb_point.json"
if not isfile(filename) then
    writefile(filename, HttpService:JSONEncode({point1=nil, point2=nil, delay=8}))
end
local saved = HttpService:JSONDecode(readfile(filename))
if typeof(saved.delay) ~= "number" or saved.delay < 1 or saved.delay > 10 then
    saved.delay = 8
    writefile(filename, HttpService:JSONEncode(saved))
end

-- 📦 UI
local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "CLIMB_JUMP_UI"
Gui.ResetOnSpawn = false

local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0, 170, 0, 170)
Frame.Position = UDim2.new(0, 10, 0.5, -85)
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

local function makeBtn(txt, y, color)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -16, 0, 26)
    btn.Position = UDim2.new(0, 8, 0, y)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Text = txt
    return btn
end

local AutoBtn = makeBtn("🔁 Auto Teleport [OFF]", 32, Color3.fromRGB(50, 90, 160))
local Point1Btn = makeBtn("📍 Set Point 1", 62, Color3.fromRGB(100, 60, 180))
local Point2Btn = makeBtn("📍 Set Point 2", 92, Color3.fromRGB(140, 60, 200))
local DelayBox = Instance.new("TextBox", Frame)
DelayBox.Size = UDim2.new(1, -16, 0, 26)
DelayBox.Position = UDim2.new(0, 8, 0, 122)
DelayBox.PlaceholderText = "⏱ Delay (1-10)"
DelayBox.Text = tostring(saved.delay)
DelayBox.ClearTextOnFocus = false
DelayBox.BackgroundColor3 = Color3.fromRGB(70, 70, 120)
DelayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayBox.Parent = Frame

-- 🧠 Teleport Logic
local teleporting = false
local currentTarget = 1
local function teleportTo(point)
    if point then
        local char = LP.Character or LP.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        hrp.Anchored = true
        hrp.Velocity = Vector3.zero
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end
        task.wait(0.05)
        char:PivotTo(CFrame.new(point.x, point.y + 3, point.z))
        task.wait(0.05)
        hrp.Anchored = false
        if hum then hum:ChangeState(Enum.HumanoidStateType.Running) end
    end
end

-- 🔘 Button Events
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in pairs(Frame:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextBox") then
            if v ~= MinBtn then v.Visible = not minimized end
        end
    end
    Frame.Size = minimized and UDim2.new(0, 140, 0, 26) or UDim2.new(0, 170, 0, 170)
end)

AutoBtn.MouseButton1Click:Connect(function()
    teleporting = not teleporting
    AutoBtn.Text = teleporting and "🔁 Auto Teleport [ON]" or "🔁 Auto Teleport [OFF]"
    AutoBtn.BackgroundColor3 = teleporting and Color3.fromRGB(0,200,0) or Color3.fromRGB(50,90,160)
end)

Point1Btn.MouseButton1Click:Connect(function()
    local pos = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character.HumanoidRootPart.Position
    if pos then
        saved.point1 = {x=pos.X, y=pos.Y, z=pos.Z}
        writefile(filename, HttpService:JSONEncode(saved))
        Point1Btn.Text = "✅ Point 1 Saved!"
        task.delay(2, function() Point1Btn.Text = "📍 Set Point 1" end)
    end
end)

Point2Btn.MouseButton1Click:Connect(function()
    local pos = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character.HumanoidRootPart.Position
    if pos then
        saved.point2 = {x=pos.X, y=pos.Y, z=pos.Z}
        writefile(filename, HttpService:JSONEncode(saved))
        Point2Btn.Text = "✅ Point 2 Saved!"
        task.delay(2, function() Point2Btn.Text = "📍 Set Point 2" end)
    end
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

-- ⏱️ Auto Teleport Loop
task.spawn(function()
    while task.wait(1) do
        if teleporting and saved.point1 and saved.point2 then
            teleportTo(currentTarget == 1 and saved.point1 or saved.point2)
            currentTarget = currentTarget == 1 and 2 or 1
            task.wait(saved.delay)
        end
    end
end)