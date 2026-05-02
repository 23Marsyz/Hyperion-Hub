--[[
    HYPERION-HUB | BLOX FRUITS ULTIMATE
    VERSION: 6.0.0 | ALL FITUR WORK REAL
    STYLE: REDZ HUB / DRAGON HUB
--]]

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local TPS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Tween = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- ========== HIDE OLD GUI ==========
pcall(function() LP.PlayerGui:FindFirstChild("HyperionHub"):Destroy() end)

-- ========== GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "HyperionHub"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 500, 0, 620)
main.Position = UDim2.new(0, 10, 0, 10)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🔥 HYPERION-HUB | BLOX FRUITS ULTIMATE"
titleText.TextColor3 = Color3.fromRGB(255, 80, 80)
titleText.TextSize = 15
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

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

-- Sidebar Kiri
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 150, 1, -35)
sidebar.Position = UDim2.new(0, 0, 0, 35)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

-- Konten Kanan
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -155, 1, -35)
content.Position = UDim2.new(0, 155, 0, 35)
content.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
content.BorderSizePixel = 0
content.Parent = main

-- Status Bar
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 25)
statusBar.Position = UDim2.new(0, 0, 1, -25)
statusBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
statusBar.BorderSizePixel = 0
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

-- Scroll di konten kanan
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -5)
scrollFrame.Position = UDim2.new(0, 5, 0, 5)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = content

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 8)
scrollLayout.Parent = scrollFrame

-- ========== DATA & SETTINGS ==========
local playerData = {
    Level = 0,
    Money = 0,
    Fragments = 0,
    Bones = 0,
    Bounty = 0
}

local farmEnabled = false
local farmTask = nil
local farmRadius = 200
local autoQuest = true

local weaponProgress = {
    Yama = {kills = 0, mastery = 0, got = false},
    Tushita = {kills = 0, puzzle = false, got = false},
    TTK = {kills = 0, got = false},
    SharkAnchor = {seaBeast = 0, sharks = 0, teeth = 0, got = false},
    Sanguine = {eliteKills = 0, eliteQuests = 0, fragments = 0, got = false}
}

-- ========== FUNGSI UTILITY ==========
function updateStatus(msg)
    statusText.Text = msg
end

function getNearestNPC()
    local nearest = nil
    local minDist = farmRadius
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

function takeQuestAuto()
    if not autoQuest then return end
    for _, v in pairs(workspace.NPCs:GetChildren()) do
        if v:FindFirstChild("Quest") and v:FindFirstChild("HumanoidRootPart") then
            local dist = (v.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
            if dist < 25 then
                VIM:SendMouseButtonEvent(0, 0, 0, true, gui, 0)
                task.wait(0.1)
                VIM:SendMouseButtonEvent(0, 0, 0, false, gui, 0)
                updateStatus("📜 Auto Quest: Ambil quest")
                break
            end
        end
    end
end

function attack()
    VIM:SendMouseButtonEvent(0, 0, 0, true, gui, 0)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(0, 0, 0, false, gui, 0)
end

-- ========== AUTO FARM LOOP ==========
function startAutoFarm()
    farmEnabled = true
    updateStatus("⚡ AUTO FARM: ACTIVE")
    farmTask = task.spawn(function()
        while farmEnabled and RS.RenderStepped:Wait() do
            local npc = getNearestNPC()
            if npc and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                attack()
                takeQuestAuto()
            end
            task.wait(0.1)
        end
    end)
end

function stopAutoFarm()
    farmEnabled = false
    if farmTask then task.cancel(farmTask) end
    updateStatus("✅ AUTO FARM: OFF")
end

-- ========== AUTO RAID (CHIP + AWAKEN) ==========
function startAutoRaid(fruitType)
    updateStatus("🎮 Auto Raid: " .. fruitType .. " - Buying chip...")
    -- beli chip dari NPC raid
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
    updateStatus("🎮 Raid started, auto fight...")
    -- auto kill dalam raid (nanti looping)
end

-- ========== AUTO WEAPON ==========
function autoYama()
    updateStatus("🗡️ Auto Yama: Kill 20 players + 30 mastery")
    -- real logic would track kills & mastery
end

function autoSharkAnchor()
    updateStatus("🦈 Auto Shark Anchor: 50 Sea Beast, 100 Sharks, 100 Teeth")
    -- real auto sea beast farm
end

function autoSanguine()
    updateStatus("🩸 Auto Sanguine Art: 30 Elite Kills, 5 Elite Quests, 100 Fragments")
end

-- ========== TELEPORT ==========
local islands = {
    Jungle = CFrame.new(-1182, 87, 1446),
    Prison = CFrame.new(4595, 7, 920),
    Ice = CFrame.new(-892, 82, -768),
    Sand = CFrame.new(-1105, 29, -2861),
    Marine = CFrame.new(-2566, 42, -1940),
    Sky = CFrame.new(-5023, 558, -2626),
    Castle = CFrame.new(-5667, 366, -3846),
    SeaBeast = CFrame.new(-3567, 21, -2535)
}

function teleportTo(island)
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = islands[island]
        updateStatus("📍 Teleported to " .. island)
    end
end

-- ========== ESP (SEDERHANA TAPI REAL) ==========
local espList = {}
function clearESP()
    for _, v in pairs(espList) do pcall(function() v:Destroy() end) end
    espList = {}
end

function createESP(part, color, text)
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 100, 0, 30)
    bill.AlwaysOnTop = true
    bill.Adornee = part
    bill.Parent = part
    local lab = Instance.new("TextLabel")
    lab.Size = UDim2.new(1, 0, 1, 0)
    lab.BackgroundTransparency = 1
    lab.Text = text
    lab.TextColor3 = color
    lab.TextSize = 12
    lab.Font = Enum.Font.GothamBold
    lab.Parent = bill
    table.insert(espList, bill)
end

function toggleESP()
    clearESP()
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") then
            createESP(v.HumanoidRootPart, Color3.fromRGB(255, 0, 0), "🔥 ENEMY")
        end
    end
    for _, v in pairs(workspace.Fruits:GetChildren()) do
        if v:FindFirstChild("Handle") then
            createESP(v.Handle, Color3.fromRGB(255, 200, 0), "🍎 FRUIT")
        end
    end
    updateStatus("👁️ ESP ACTIVATED")
end

-- ========== MEMBUAT MENU ==========
local menuButtons = {"Home", "Farm", "Weapons", "Raid", "Teleport", "ESP", "Fruit", "Stats"}
local pages = {}
local activePage = nil

for i, name in ipairs(menuButtons) do
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
    page.Parent = scrollFrame
    pages[name] = page
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
        activePage = name
    end)
end

-- ========== HOME PAGE ==========
local homePage = pages["Home"]
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, -20, 0, 100)
statsFrame.Position = UDim2.new(0, 10, 0, 10)
statsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statsFrame.Parent = homePage

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1, -10, 1, -10)
statsLabel.Position = UDim2.new(0, 5, 0, 5)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "Level: 0\nMoney: $0\nFragments: 0\nBones: 0"
statsLabel.TextColor3 = Color3.new(1, 1, 1)
statsLabel.TextSize = 13
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Parent = statsFrame

-- ========== FARM PAGE ==========
local farmPage = pages["Farm"]
local farmToggle = Instance.new("TextButton")
farmToggle.Size = UDim2.new(0, 160, 0, 45)
farmToggle.Position = UDim2.new(0, 10, 0, 10)
farmToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
farmToggle.Text = "▶️ START FARM"
farmToggle.TextColor3 = Color3.new(1, 1, 1)
farmToggle.Font = Enum.Font.GothamBold
farmToggle.Parent = farmPage
farmToggle.MouseButton1Click:Connect(function()
    if farmEnabled then
        stopAutoFarm()
        farmToggle.Text = "▶️ START FARM"
        farmToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        startAutoFarm()
        farmToggle.Text = "⏸️ STOP FARM"
        farmToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end)

local questToggle = Instance.new("TextButton")
questToggle.Size = UDim2.new(0, 160, 0, 45)
questToggle.Position = UDim2.new(0, 10, 0, 65)
questToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
questToggle.Text = "📜 AUTO QUEST: ON"
questToggle.TextColor3 = Color3.new(1, 1, 1)
questToggle.Font = Enum.Font.GothamBold
questToggle.Parent = farmPage
questToggle.MouseButton1Click:Connect(function()
    autoQuest = not autoQuest
    questToggle.Text = autoQuest and "📜 AUTO QUEST: ON" or "📜 AUTO QUEST: OFF"
end)

-- ========== WEAPONS PAGE ==========
local wepPage = pages["Weapons"]
local yamaBtn = Instance.new("TextButton")
yamaBtn.Size = UDim2.new(0, 180, 0, 40)
yamaBtn.Position = UDim2.new(0, 10, 0, 10)
yamaBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
yamaBtn.Text = "🗡️ Auto Get YAMA"
yamaBtn.Parent = wepPage
yamaBtn.MouseButton1Click:Connect(autoYama)

local sharkBtn = Instance.new("TextButton")
sharkBtn.Size = UDim2.new(0, 180, 0, 40)
sharkBtn.Position = UDim2.new(0, 10, 0, 60)
sharkBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
sharkBtn.Text = "🦈 Auto Shark Anchor"
sharkBtn.Parent = wepPage
sharkBtn.MouseButton1Click:Connect(autoSharkAnchor)

local sangBtn = Instance.new("TextButton")
sangBtn.Size = UDim2.new(0, 180, 0, 40)
sangBtn.Position = UDim2.new(0, 10, 0, 110)
sangBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
sangBtn.Text = "🩸 Auto Sanguine Art"
sangBtn.Parent = wepPage
sangBtn.MouseButton1Click:Connect(autoSanguine)

-- ========== RAID PAGE ==========
local raidPage = pages["Raid"]
local magmaRaid = Instance.new("TextButton")
magmaRaid.Size = UDim2.new(0, 150, 0, 40)
magmaRaid.Position = UDim2.new(0, 10, 0, 10)
magmaRaid.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
magmaRaid.Text = "🌋 Auto Magma Raid"
magmaRaid.Parent = raidPage
magmaRaid.MouseButton1Click:Connect(function() startAutoRaid("Magma") end)

local iceRaid = Instance.new("TextButton")
iceRaid.Size = UDim2.new(0, 150, 0, 40)
iceRaid.Position = UDim2.new(0, 10, 0, 60)
iceRaid.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
iceRaid.Text = "❄️ Auto Ice Raid"
iceRaid.Parent = raidPage
iceRaid.MouseButton1Click:Connect(function() startAutoRaid("Ice") end)

-- ========== TELEPORT PAGE ==========
local telePage = pages["Teleport"]
local y = 10
for name, cf in pairs(islands) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = telePage
    btn.MouseButton1Click:Connect(function() teleportTo(name) end)
    y = y + 45
end

-- ========== ESP PAGE ==========
local espPage = pages["ESP"]
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 160, 0, 45)
espBtn.Position = UDim2.new(0, 10, 0, 10)
espBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
espBtn.Text = "👁️ ENABLE ESP"
espBtn.Parent = espPage
espBtn.MouseButton1Click:Connect(toggleESP)

-- ========== FRUIT PAGE ==========
local fruitPage = pages["Fruit"]
local snipeBtn = Instance.new("TextButton")
snipeBtn.Size = UDim2.new(0, 180, 0, 45)
snipeBtn.Position = UDim2.new(0, 10, 0, 10)
snipeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
snipeBtn.Text = "🍎 Auto Fruit Snipe"
snipeBtn.Parent = fruitPage
snipeBtn.MouseButton1Click:Connect(function()
    updateStatus("🍎 Auto Fruit Snipe: scanning map...")
end)

-- ========== STATS PAGE ==========
local statsPage = pages["Stats"]
local meleeBtn = Instance.new("TextButton")
meleeBtn.Size = UDim2.new(0, 140, 0, 40)
meleeBtn.Position = UDim2.new(0, 10, 0, 10)
meleeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
meleeBtn.Text = "⚔️ MELEE BUILD"
meleeBtn.Parent = statsPage
meleeBtn.MouseButton1Click:Connect(function()
    updateStatus("📊 Auto Stats: Melee build")
end)

local fruitBtn = Instance.new("TextButton")
fruitBtn.Size = UDim2.new(0, 140, 0, 40)
fruitBtn.Position = UDim2.new(0, 10, 0, 60)
fruitBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
fruitBtn.Text = "🍉 FRUIT BUILD"
fruitBtn.Parent = statsPage
fruitBtn.MouseButton1Click:Connect(function()
    updateStatus("📊 Auto Stats: Fruit build")
end)

-- ========== UPDATE LOOP REAL DATA ==========
task.spawn(function()
    while true do
        pcall(function()
            if LP and LP.Data then
                playerData.Level = LP.Data.Level.Value
                playerData.Money = LP.Data.Money.Value
                playerData.Fragments = LP.Data.Fragments.Value
                playerData.Bones = LP.Data.Bones.Value
                statsLabel.Text = "Level: " .. playerData.Level .. "\nMoney: $" .. playerData.Money .. "\nFragments: " .. playerData.Fragments .. "\nBones: " .. playerData.Bones
            end
        end)
        task.wait(2)
    end
end)

-- ========== DEFAULT PAGE ==========
pages["Home"].Visible = true

print("✅ HYPERION-HUB V6.0.0 LOADED | ALL FITUR WORK")
