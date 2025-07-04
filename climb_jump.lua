-- ✅ CLIMB AND JUMP | Delta Executor Version | Tanpa CoreGui | Mobile Friendly UI | Auto Teleport 2 Titik

if game.PlaceId ~= 123921593837160 then
    return warn("[CLIMB AND JUMP] Script hanya berjalan di Climb and Jump Tower (Tokyo Tower).")
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local blacklist = {
    ["mach383"] = true, ["ixNazzz"] = true, ["Evgeniy444444"] = true,
    ["legendxlenn"] = true, ["VicSimon8"] = true, ["Woodrowlvan_8"] = true,
    ["Chase02771"] = true, ["Crystalst1402"] = true, ["CoryOdom_8"] = true,
    ["AubreyPigou"] = true, ["GlennOsborne"] = true, ["porcorossooo"] = true,
    ["AidenKaur"] = true, ["RBMAforMBTC"] = true, ["BlueBirdBarry"] = true
}

local filename = "Climb_point.json"
if not isfile(filename) then
    writefile(filename, HttpService:JSONEncode({point1 = nil, point2 = nil}))
end

local saved = HttpService:JSONDecode(readfile(filename))
local teleportEnabled = false
local minimized = false
local currentTarget = 1

-- UI
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "ClimbAndJumpUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 180, 0, 160)
Frame.Position = UDim2.new(0, 10, 0.6, -80)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0
Frame.BorderColor3 = Color3.fromRGB(80, 0, 160)

local Title = Instance.new("TextLabel", Frame)
Title.Text = "CLIMB AND JUMP"
Title.Size = UDim2.new(1, 0, 0, 26)
Title.BackgroundColor3 = Color3.fromRGB(70, 40, 120)
Title.TextColor3 = Color3.fromRGB(220, 220, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BorderSizePixel = 0

local MinBtn = Instance.new("TextButton", Frame)
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 28, 0, 26)
MinBtn.Position = UDim2.new(1, -30, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 180)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.Gotham
MinBtn.TextSize = 16

local TeleportBtn = Instance.new("TextButton", Frame)
TeleportBtn.Text = "🔁 Auto Teleport [OFF]"
TeleportBtn.Size = UDim2.new(1, -16, 0, 26)
TeleportBtn.Position = UDim2.new(0, 8, 0, 32)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(50, 90, 160)
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.Font = Enum.Font.Gotham
TeleportBtn.TextSize = 13

local SetPoint1Btn = Instance.new("TextButton", Frame)
SetPoint1Btn.Text = "📍 Set Point 1"
SetPoint1Btn.Size = UDim2.new(1, -16, 0, 26)
SetPoint1Btn.Position = UDim2.new(0, 8, 0, 62)
SetPoint1Btn.BackgroundColor3 = Color3.fromRGB(100, 60, 180)
SetPoint1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
SetPoint1Btn.Font = Enum.Font.Gotham
SetPoint1Btn.TextSize = 13

local SetPoint2Btn = Instance.new("TextButton", Frame)
SetPoint2Btn.Text = "📍 Set Point 2"
SetPoint2Btn.Size = UDim2.new(1, -16, 0, 26)
SetPoint2Btn.Position = UDim2.new(0, 8, 0, 92)
SetPoint2Btn.BackgroundColor3 = Color3.fromRGB(140, 60, 200)
SetPoint2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
SetPoint2Btn.Font = Enum.Font.Gotham
SetPoint2Btn.TextSize = 13

-- UI Functions
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, v in pairs(Frame:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextLabel") then
            if v ~= Title and v ~= MinBtn then
                v.Visible = not minimized
            end
        end
    end
    Frame.Size = minimized and UDim2.new(0, 140, 0, 26) or UDim2.new(0, 180, 0, 160)
end)

SetPoint1Btn.MouseButton1Click:Connect(function()
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        saved.point1 = {x = pos.X, y = pos.Y, z = pos.Z}
        writefile(filename, HttpService:JSONEncode(saved))
        SetPoint1Btn.Text = "✅ Point 1 Saved!"
        task.delay(2, function() SetPoint1Btn.Text = "📍 Set Point 1" end)
    end
end)

SetPoint2Btn.MouseButton1Click:Connect(function()
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        saved.point2 = {x = pos.X, y = pos.Y, z = pos.Z}
        writefile(filename, HttpService:JSONEncode(saved))
        SetPoint2Btn.Text = "✅ Point 2 Saved!"
        task.delay(2, function() SetPoint2Btn.Text = "📍 Set Point 2" end)
    end
end)

TeleportBtn.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    TeleportBtn.Text = teleportEnabled and "🔁 Auto Teleport [ON]" or "🔁 Auto Teleport [OFF]"
    TeleportBtn.BackgroundColor3 = teleportEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(50, 90, 160)
end)

-- Auto Teleport Logic
RunService.Heartbeat:Connect(function()
    if teleportEnabled and saved.point1 and saved.point2 then
        local char = LP.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local target = currentTarget == 1 and Vector3.new(saved.point1.x, saved.point1.y, saved.point1.z)
                or Vector3.new(saved.point2.x, saved.point2.y, saved.point2.z)
            if (root.Position - target).Magnitude > 5 then
                root.CFrame = root.CFrame:Lerp(CFrame.new(target), 0.1)
            else
                currentTarget = currentTarget == 1 and 2 or 1
                task.wait(1.5)
            end
        end
    end
end)
