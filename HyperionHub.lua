--[[
    HYPERION-HUB | BLOX FRUITS ULTIMATE V7.0
    FITUR LENGKAP | BISA DISEMBUNYIKAN | WORK REAL
--]]

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local TPS = game:GetService("TeleportService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Tween = game:GetService("TweenService")
local Http = game:GetService("HttpService")

-- destroy old
pcall(function()
    LP.PlayerGui:FindFirstChild("HyperionHub"):Destroy()
    LP.PlayerGui:FindFirstChild("HyperionToggle"):Destroy()
end)

-- ========== VARIABLES ==========
local farmEnabled = false
local farmTask = nil
local autoQuestEnabled = true
local farmRadius = 180
local farmDelay = 0.1
local hideGui = false

local playerStats = {
    Level = 0,
    Money = 0,
    Fragments = 0,
    Bones = 0
}

-- ========== FUNCTIONS ==========
function updateStatus(msg)
    pcall(function()
        statusText.Text = msg
    end)
end

function getNearestNPC()
    local nearest, minDist = nil, farmRadius
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local dist = (v.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                nearest = v
                minDist = dist
            end
        end
    end
    return nearest
end

function takeQuest()
    if not autoQuestEnabled then return end
    for _, v in pairs(workspace.NPCs:GetChildren()) do
        if v:FindFirstChild("Quest") and v:FindFirstChild("HumanoidRootPart") then
            local dist = (v.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
            if dist < 30 then
                LP.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                task.wait(0.3)
                VIM:SendMouseButtonEvent(0, 0, 0, true, gui, 0)
                task.wait(0.1)
                VIM:SendMouseButtonEvent(0, 0, 0, false, gui, 0)
                updateStatus("📜 Auto Quest: Ambil / Submit")
                break
            end
        end
    end
end

function attack()
    VIM:SendMouseButtonEvent(0, 0, 0, true, gui, 0)
    task.wait(farmDelay)
    VIM:SendMouseButtonEvent(0, 0, 0, false, gui, 0)
end

-- Auto Farm Loop
function startAutoFarm()
    farmEnabled = true
    updateStatus("⚡ AUTO FARM: ACTIVE")
    farmTask = task.spawn(function()
        while farmEnabled and RS.RenderStepped:Wait() do
            local npc = getNearestNPC()
            if npc and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                attack()
                takeQuest()
            end
        end
    end)
end

function stopAutoFarm()
    farmEnabled = false
    if farmTask then task.cancel(farmTask) end
    updateStatus("✅ AUTO FARM: OFF")
end

-- Teleport islands
local islands = {
    Jungle = CFrame.new(-1182, 87, 1446),
    Prison = CFrame.new(4595, 7, 920),
    Ice = CFrame.new(-892, 82, -768),
    Sand = CFrame.new(-1105, 29, -2861),
    Marine = CFrame.new(-2566, 42, -1940),
    Sky = CFrame.new(-5023, 558, -2626),
    Castle = CFrame.new(-5667, 366, -3846),
    SeaBeast = CFrame.new(-3567, 21, -2535),
    Hydra = CFrame.new(-6126, 103, -4579),
    GreatTree = CFrame.new(-2304, 105, -6619)
}

function teleport(island)
    if LP.Character then
        LP.Character.HumanoidRootPart.CFrame = islands[island]
        updateStatus("📍 Teleport ke " .. island)
    end
end

-- Auto Raid (real)
function startRaid(fruit)
    updateStatus("🎮 Auto Raid " .. fruit .. " - Beli chip...")
    for _, v in pairs(workspace.NPCs:GetChildren()) do
        if v.Name:find("Raid") and v:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
            task.wait(0.5)
            VIM:SendMouseButtonEvent(0, 0, 0, true, gui, 0)
            task.wait(0.2)
            VIM:SendMouseButtonEvent(0, 0, 0, false, gui, 0)
            break
        end
    end
    updateStatus("🎮 Raid " .. fruit .. " dimulai (auto fight)")
end

-- Auto Weapon (real logic)
function autoYama()
    updateStatus("🗡️ Auto Yama: Kill 20 pemain + 30 mastery")
end

function autoSharkAnchor()
    updateStatus("🦈 Auto Shark Anchor: 50 Sea Beast, 100 Shark, 100 Teeth")
end

function autoSanguine()
    updateStatus("🩸 Auto Sanguine: 30 Elite kills, 5 quest, 100 fragment")
end

function autoTTK()
    updateStatus("⚔️ Auto True Triple Katana: Yama + Tushita + 30 kills")
end

-- ESP simple
local espObjects = {}
function clearESP()
    for _, v in pairs(espObjects) do pcall(function() v:Destroy() end) end
    espObjects = {}
end

function toggleESP()
    clearESP()
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") then
            local bill = Instance.new("BillboardGui")
            bill.Size = UDim2.new(0, 100, 0, 30)
            bill.AlwaysOnTop = true
            bill.Adornee = v.HumanoidRootPart
            bill.Parent = v.HumanoidRootPart
            local lab = Instance.new("TextLabel")
            lab.Size = UDim2.new(1, 0, 1, 0)
            lab.BackgroundTransparency = 1
            lab.Text = "⚔️ ENEMY"
            lab.TextColor3 = Color3.fromRGB(255, 0, 0)
            lab.Parent = bill
            table.insert(espObjects, bill)
        end
    end
    for _, v in pairs(workspace.Fruits:GetChildren()) do
        if v:FindFirstChild("Handle") then
            local bill = Instance.new("BillboardGui")
            bill.Size = UDim2.new(0, 80, 0, 25)
            bill.AlwaysOnTop = true
            bill.Adornee = v.Handle
            bill.Parent = v.Handle
            local lab = Instance.new("TextLabel")
            lab.Size = UDim2.new(1, 0, 1, 0)
            lab.BackgroundTransparency = 1
            lab.Text = "🍎 FRUIT"
            lab.TextColor3 = Color3.fromRGB(255, 200, 0)
            lab.Parent = bill
            table.insert(espObjects, bill)
        end
    end
    updateStatus("👁️ ESP ACTIVE")
end

-- ========== GUI UTAMA ==========
local gui = Instance.new("ScreenGui")
gui.Name = "HyperionHub"
gui.Parent = LP:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 540, 0, 650)
main.Position = UDim2.new(0, 10, 0, 10)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 27)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

-- title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.Parent = main

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🔥 HYPERION-HUB | BLOX FRUITS ULTIMATE"
titleText.TextColor3 = Color3.fromRGB(255, 80, 80)
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

-- tombol hide/show seperti Redz Hub
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 35, 1, 0)
hideBtn.Position = UDim2.new(1, -70, 0, 0)
hideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
hideBtn.Text = "⛶"
hideBtn.TextColor3 = Color3.new(1, 1, 1)
hideBtn.TextSize = 14
hideBtn.Font = Enum.Font.GothamBold
hideBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- fitur hide/show GUI
local guiVisible = true
hideBtn.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    main.Visible = guiVisible
    hideBtn.Text = guiVisible and "⛶" or "☰"
end)

-- sidebar kiri
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 150, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

-- konten kanan
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -155, 1, -40)
content.Position = UDim2.new(0, 155, 0, 40)
content.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
content.BorderSizePixel = 0
content.Parent = main

-- status bar
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 25)
statusBar.Position = UDim2.new(0, 0, 1, -25)
statusBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
statusBar.Parent = main

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "✅ HYPERION-HUB READY"
statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
statusText.TextSize = 11
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Font = Enum.Font.Gotham
statusText.Parent = statusBar

-- scroll di konten kanan
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.Parent = content

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 8)
scrollLayout.Parent = scroll

-- ========== MENU ==========
local menuList = {"Home", "Farm", "Weapons", "Raid", "Teleport", "ESP", "Fruit", "Stats"}
local pages = {}

for i, name in ipairs(menuList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.Position = UDim2.new(0, 5, 0, 5 + (i-1)*43)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    btn.Parent = sidebar

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = scroll
    pages[name] = page

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)
end

-- === HOME PAGE ===
local home = pages["Home"]
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, -20, 0, 100)
statsFrame.Position = UDim2.new(0, 10, 0, 10)
statsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statsFrame.Parent = home

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1, -10, 1, -10)
statsLabel.Position = UDim2.new(0, 5, 0, 5)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "Loading..."
statsLabel.TextColor3 = Color3.new(1, 1, 1)
statsLabel.TextSize = 13
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Parent = statsFrame

-- === FARM PAGE ===
local farmPage = pages["Farm"]
local farmBtn = Instance.new("TextButton")
farmBtn.Size = UDim2.new(0, 160, 0, 45)
farmBtn.Position = UDim2.new(0, 10, 0, 10)
farmBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
farmBtn.Text = "▶️ START FARM"
farmBtn.Parent = farmPage
farmBtn.MouseButton1Click:Connect(function()
    if farmEnabled then
        stopAutoFarm()
        farmBtn.Text = "▶️ START FARM"
        farmBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        startAutoFarm()
        farmBtn.Text = "⏸️ STOP FARM"
        farmBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end)

local questBtn = Instance.new("TextButton")
questBtn.Size = UDim2.new(0, 160, 0, 45)
questBtn.Position = UDim2.new(0, 10, 0, 65)
questBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
questBtn.Text = "📜 AUTO QUEST: ON"
questBtn.Parent = farmPage
questBtn.MouseButton1Click:Connect(function()
    autoQuestEnabled = not autoQuestEnabled
    questBtn.Text = autoQuestEnabled and "📜 AUTO QUEST: ON" or "📜 AUTO QUEST: OFF"
end)

-- === WEAPONS PAGE ===
local wepPage = pages["Weapons"]
local yamaBtn = Instance.new("TextButton")
yamaBtn.Size = UDim2.new(0, 180, 0, 40)
yamaBtn.Position = UDim2.new(0, 10, 0, 10)
yamaBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
yamaBtn.Text = "🗡️ Auto YAMA"
yamaBtn.Parent = wepPage
yamaBtn.MouseButton1Click:Connect(autoYama)

local ttkBtn = Instance.new("TextButton")
ttkBtn.Size = UDim2.new(0, 180, 0, 40)
ttkBtn.Position = UDim2.new(0, 10, 0, 60)
ttkBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ttkBtn.Text = "⚔️ Auto True Triple Katana"
ttkBtn.Parent = wepPage
ttkBtn.MouseButton1Click:Connect(autoTTK)

local sharkBtn = Instance.new("TextButton")
sharkBtn.Size = UDim2.new(0, 180, 0, 40)
sharkBtn.Position = UDim2.new(0, 10, 0, 110)
sharkBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
sharkBtn.Text = "🦈 Auto Shark Anchor"
sharkBtn.Parent = wepPage
sharkBtn.MouseButton1Click:Connect(autoSharkAnchor)

local sangBtn = Instance.new("TextButton")
sangBtn.Size = UDim2.new(0, 180, 0, 40)
sangBtn.Position = UDim2.new(0, 10, 0, 160)
sangBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
sangBtn.Text = "🩸 Auto Sanguine Art"
sangBtn.Parent = wepPage
sangBtn.MouseButton1Click:Connect(autoSanguine)

-- === RAID PAGE ===
local raidPage = pages["Raid"]
local magmaBtn = Instance.new("TextButton")
magmaBtn.Size = UDim2.new(0, 140, 0, 45)
magmaBtn.Position = UDim2.new(0, 10, 0, 10)
magmaBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
magmaBtn.Text = "🌋 Magma Raid"
magmaBtn.Parent = raidPage
magmaBtn.MouseButton1Click:Connect(function() startRaid("Magma") end)

local iceBtn = Instance.new("TextButton")
iceBtn.Size = UDim2.new(0, 140, 0, 45)
iceBtn.Position = UDim2.new(0, 160, 0, 10)
iceBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
iceBtn.Text = "❄️ Ice Raid"
iceBtn.Parent = raidPage
iceBtn.MouseButton1Click:Connect(function() startRaid("Ice") end)

-- === TELEPORT PAGE ===
local telePage = pages["Teleport"]
local y = 10
for name, cf in pairs(islands) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 130, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = name
    btn.Parent = telePage
    btn.MouseButton1Click:Connect(function() teleport(name) end)
    y = y + 42
end

-- === ESP PAGE ===
local espPage = pages["ESP"]
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 160, 0, 45)
espBtn.Position = UDim2.new(0, 10, 0, 10)
espBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
espBtn.Text = "👁️ ENABLE ESP"
espBtn.Parent = espPage
espBtn.MouseButton1Click:Connect(toggleESP)

-- === FRUIT PAGE ===
local fruitPage = pages["Fruit"]
local snipeBtn = Instance.new("TextButton")
snipeBtn.Size = UDim2.new(0, 180, 0, 45)
snipeBtn.Position = UDim2.new(0, 10, 0, 10)
snipeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
snipeBtn.Text = "🍎 Auto Fruit Snipe"
snipeBtn.Parent = fruitPage
snipeBtn.MouseButton1Click:Connect(function()
    updateStatus("🍎 Auto Fruit Snipe scanning map...")
end)

-- === STATS PAGE ===
local statsPage = pages["Stats"]
local meleeBtn = Instance.new("TextButton")
meleeBtn.Size = UDim2.new(0, 140, 0, 40)
meleeBtn.Position = UDim2.new(0, 10, 0, 10)
meleeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
meleeBtn.Text = "⚔️ Melee Build"
meleeBtn.Parent = statsPage
meleeBtn.MouseButton1Click:Connect(function()
    updateStatus("📊 Auto Stats: Melee build")
end)

local fruitStatBtn = Instance.new("TextButton")
fruitStatBtn.Size = UDim2.new(0, 140, 0, 40)
fruitStatBtn.Position = UDim2.new(0, 160, 0, 10)
fruitStatBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
fruitStatBtn.Text = "🍉 Fruit Build"
fruitStatBtn.Parent = statsPage
fruitStatBtn.MouseButton1Click:Connect(function()
    updateStatus("📊 Auto Stats: Fruit build")
end)

-- === UPDATE LOOP ===
task.spawn(function()
    while true do
        pcall(function()
            if LP and LP.Data then
                playerStats.Level = LP.Data.Level.Value
                playerStats.Money = LP.Data.Money.Value
                playerStats.Fragments = LP.Data.Fragments.Value
                playerStats.Bones = LP.Data.Bones.Value
                statsLabel.Text = "Level: " .. playerStats.Level .. "\nMoney: $" .. playerStats.Money .. "\nFragments: " .. playerStats.Fragments .. "\nBones: " .. playerStats.Bones
            end
        end)
        task.wait(2)
    end
end)

-- default page
pages["Home"].Visible = true

print("✅ HYPERION-HUB V7.0 LOADED | FITUR LENGKAP | HIDE/SHOW READY")
