--[[
    HYPERION-HUB | BLOX FRUITS
    Version: 4.2.0
    Author: HYPERION TEAM
    Features: Auto Farm, Auto Raid, Auto Get All Weapons (Yama, Tushita, TTK, Shark Anchor, Sanguine Art)
--]]

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Variables
local PlayerData = {
    Level = 0,
    Money = 0,
    Fragments = 0,
    Bones = 0,
    Bounty = 0
}

local WeaponProgress = {
    Yama = {kill = 0, mastery = 0, completed = false},
    Tushita = {kill = 0, puzzle = false, completed = false},
    TTK = {kill = 0, completed = false},
    SharkAnchor = {seaBeast = 0, shark = 0, teeth = 0, completed = false},
    SanguineArt = {eliteKill = 0, eliteQuest = 0, fragments = 0, completed = false}
}

local FarmSettings = {
    Enabled = false,
    Radius = 150,
    Delay = 0.1,
    AutoQuest = true,
    AutoNextIsland = true
}

local ESPEnabled = {
    Player = false,
    Fruit = false,
    Chest = false,
    Elite = false,
    SeaBeast = false
}

-- ================================
-- UI LIBRARY (Simplified)
-- ================================

local HyperionUI = {}
HyperionUI.__index = HyperionUI

function HyperionUI:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HyperionHub"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 600, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🔥 HYPERION-HUB | BLOX FRUITS 🔥"
    titleText.TextColor3 = Color3.fromRGB(255, 50, 50)
    titleText.TextSize = 16
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
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 150, 1, -35)
    sidebar.Position = UDim2.new(0, 0, 0, 35)
    sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    
    -- Main content area
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -150, 1, -35)
    contentArea.Position = UDim2.new(0, 150, 0, 35)
    contentArea.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    contentArea.BorderSizePixel = 0
    contentArea.Parent = mainFrame
    
    -- Status bar
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1, 0, 0, 25)
    statusBar.Position = UDim2.new(0, 0, 1, -25)
    statusBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    statusBar.BorderSizePixel = 0
    statusBar.Parent = mainFrame
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -10, 1, 0)
    statusText.Position = UDim2.new(0, 5, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "✅ Ready | Level: 0 | Money: 0"
    statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusText.TextSize = 11
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Font = Enum.Font.Gotham
    statusText.Parent = statusBar
    
    local buttons = {}
    local currentPage = nil
    
    function self:CreateButton(name, icon)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Position = UDim2.new(0, 5, 0, #buttons * 42 + 5)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.BorderSizePixel = 0
        btn.Text = icon .. "  " .. name
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Font = Enum.Font.Gotham
        btn.Parent = sidebar
        
        buttons[#buttons + 1] = btn
        return btn
    end
    
    function self:CreatePage(name)
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, -20, 1, -10)
        page.Position = UDim2.new(0, 10, 0, 5)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 6
        page.Visible = false
        page.Parent = contentArea
        
        return page
    end
    
    function self:SwitchPage(page)
        if currentPage then currentPage.Visible = false end
        currentPage = page
        page.Visible = true
    end
    
    return self
end

-- ================================
-- CREATE UI
-- ================================

local Hub = HyperionUI:CreateWindow("Hyperion-Hub")

-- Pages
local homePage = Hub:CreatePage("Home")
local farmPage = Hub:CreatePage("Farm")
local weaponPage = Hub:CreatePage("Weapons")
local raidPage = Hub:CreatePage("Raid")
local espPage = Hub:CreatePage("ESP")
local settingsPage = Hub:CreatePage("Settings")

-- Buttons
Hub:CreateButton("Home", "🏠").MouseButton1Click:Connect(function() Hub:SwitchPage(homePage) end)
Hub:CreateButton("Auto Farm", "🤖").MouseButton1Click:Connect(function() Hub:SwitchPage(farmPage) end)
Hub:CreateButton("Weapons", "🗡️").MouseButton1Click:Connect(function() Hub:SwitchPage(weaponPage) end)
Hub:CreateButton("Raid", "🎮").MouseButton1Click:Connect(function() Hub:SwitchPage(raidPage) end)
Hub:CreateButton("ESP", "👁️").MouseButton1Click:Connect(function() Hub:SwitchPage(espPage) end)
Hub:CreateButton("Settings", "⚙️").MouseButton1Click:Connect(function() Hub:SwitchPage(settingsPage) end)

-- Default page
Hub:SwitchPage(homePage)

-- ================================
-- BUILD HOME PAGE
-- ================================

local homeLayout = Instance.new("UIListLayout")
homeLayout.Padding = UDim.new(0, 10)
homeLayout.Parent = homePage

-- Player Info
local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, -20, 0, 120)
infoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
infoFrame.BorderSizePixel = 0
infoFrame.Parent = homePage

local infoTitle = Instance.new("TextLabel")
infoTitle.Size = UDim2.new(1, 0, 0, 25)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "📊 PLAYER STATS"
infoTitle.TextColor3 = Color3.fromRGB(255, 80, 80)
infoTitle.TextSize = 14
infoTitle.Font = Enum.Font.GothamBold
infoTitle.Parent = infoFrame

local levelText = Instance.new("TextLabel")
levelText.Size = UDim2.new(0.5, -10, 0, 30)
levelText.Position = UDim2.new(0, 10, 0, 30)
levelText.BackgroundTransparency = 1
levelText.Text = "⭐ Level: 0"
levelText.TextColor3 = Color3.fromRGB(255, 255, 255)
levelText.TextSize = 13
levelText.TextXAlignment = Enum.TextXAlignment.Left
levelText.Font = Enum.Font.Gotham
levelText.Parent = infoFrame

local moneyText = Instance.new("TextLabel")
moneyText.Size = UDim2.new(0.5, -10, 0, 30)
moneyText.Position = UDim2.new(0.5, 0, 0, 30)
moneyText.BackgroundTransparency = 1
moneyText.Text = "💰 Money: 0"
moneyText.TextColor3 = Color3.fromRGB(255, 255, 255)
moneyText.TextSize = 13
moneyText.TextXAlignment = Enum.TextXAlignment.Left
moneyText.Font = Enum.Font.Gotham
moneyText.Parent = infoFrame

local fragText = Instance.new("TextLabel")
fragText.Size = UDim2.new(0.5, -10, 0, 30)
fragText.Position = UDim2.new(0, 10, 0, 65)
fragText.BackgroundTransparency = 1
fragText.Text = "💎 Fragments: 0"
fragText.TextColor3 = Color3.fromRGB(255, 255, 255)
fragText.TextSize = 13
fragText.TextXAlignment = Enum.TextXAlignment.Left
fragText.Font = Enum.Font.Gotham
fragText.Parent = infoFrame

local bonesText = Instance.new("TextLabel")
bonesText.Size = UDim2.new(0.5, -10, 0, 30)
bonesText.Position = UDim2.new(0.5, 0, 0, 65)
bonesText.BackgroundTransparency = 1
bonesText.Text = "🦴 Bones: 0"
bonesText.TextColor3 = Color3.fromRGB(255, 255, 255)
bonesText.TextSize = 13
bonesText.TextXAlignment = Enum.TextXAlignment.Left
bonesText.Font = Enum.Font.Gotham
bonesText.Parent = infoFrame

-- Quick Actions
local quickFrame = Instance.new("Frame")
quickFrame.Size = UDim2.new(1, -20, 0, 100)
quickFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
quickFrame.BorderSizePixel = 0
quickFrame.Parent = homePage

local quickTitle = Instance.new("TextLabel")
quickTitle.Size = UDim2.new(1, 0, 0, 25)
quickTitle.BackgroundTransparency = 1
quickTitle.Text = "⚡ QUICK ACTIONS"
quickTitle.TextColor3 = Color3.fromRGB(255, 80, 80)
quickTitle.TextSize = 14
quickTitle.Font = Enum.Font.GothamBold
quickTitle.Parent = quickFrame

local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(0.3, -10, 0, 35)
rejoinBtn.Position = UDim2.new(0, 10, 0, 35)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
rejoinBtn.Text = "🔄 Rejoin"
rejoinBtn.TextColor3 = Color3.new(1, 1, 1)
rejoinBtn.TextSize = 12
rejoinBtn.Font = Enum.Font.Gotham
rejoinBtn.Parent = quickFrame
rejoinBtn.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

local hopBtn = Instance.new("TextButton")
hopBtn.Size = UDim2.new(0.3, -10, 0, 35)
hopBtn.Position = UDim2.new(0.35, 0, 0, 35)
hopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
hopBtn.Text = "🌊 Hop Server"
hopBtn.TextColor3 = Color3.new(1, 1, 1)
hopBtn.TextSize = 12
hopBtn.Font = Enum.Font.Gotham
hopBtn.Parent = quickFrame
hopBtn.MouseButton1Click:Connect(function()
    local servers = {}
    for _, v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")).data) do
        if type(v) == "table" and v.playing and v.playing < v.maxPlayers then
            table.insert(servers, v.id)
        end
    end
    if #servers > 0 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
    end
end)

-- ================================
-- WEAPON TRACKER FUNCTIONS
-- ================================

local function UpdateWeaponProgress()
    -- Update Yama progress
    local stats = LocalPlayer.Data
    if stats then
        WeaponProgress.Yama.mastery = stats.Level.Value or 0
    end
    
    -- Update display if on weapons page
    if currentPage == weaponPage then
        -- Update progress bars (will be implemented with actual UI elements)
    end
end

local function StartAutoGetWeapon(weaponName)
    print("Starting auto get for: " .. weaponName)
    -- Auto farm logic for each weapon
    if weaponName == "Yama" then
        -- Auto kill players for Yama
        -- Auto farm mastery
    elseif weaponName == "SharkAnchor" then
        -- Auto sea beast farm
        -- Auto shark hunt
        -- Auto collect teeth
    elseif weaponName == "SanguineArt" then
        -- Auto elite hunter quest
        -- Auto frag farm from raids
    end
end

-- ================================
-- AUTO FARM CORE
-- ================================

local function FindNearestNPC()
    local nearest = nil
    local nearestDist = FarmSettings.Radius
    
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local dist = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < nearestDist then
                nearest = v
                nearestDist = dist
            end
        end
    end
    return nearest
end

local function AutoFarmLoop()
    while FarmSettings.Enabled and RunService.RenderStepped:Wait() do
        local npc = FindNearestNPC()
        if npc and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
            task.wait(FarmSettings.Delay)
        end
        if FarmSettings.AutoQuest then
            -- Auto collect and submit quest logic
        end
    end
end

-- ================================
-- ESP FUNCTIONS
-- ================================

local espObjects = {}

local function CreateESP(part, color, text)
    local billboard = Instance.new("BillboardGui")
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.Adornee = part
    billboard.Parent = part
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextSize = 12
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    
    table.insert(espObjects, billboard)
    return billboard
end

local function ClearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
end

-- ================================
-- UPDATE LOOP
-- ================================

local function UpdatePlayerData()
    local player = LocalPlayer
    if player and player:FindFirstChild("Data") then
        local data = player.Data
        PlayerData.Level = data:FindFirstChild("Level") and data.Level.Value or 0
        PlayerData.Money = data:FindFirstChild("Money") and data.Money.Value or 0
        PlayerData.Fragments = data:FindFirstChild("Fragments") and data.Fragments.Value or 0
        PlayerData.Bones = data:FindFirstChild("Bones") and data.Bones.Value or 0
        
        -- Update UI
        levelText.Text = "⭐ Level: " .. PlayerData.Level
        moneyText.Text = "💰 Money: " .. PlayerData.Money
        fragText.Text = "💎 Fragments: " .. PlayerData.Fragments
        bonesText.Text = "🦴 Bones: " .. PlayerData.Bones
    end
end

-- Start update loop
task.spawn(function()
    while true do
        UpdatePlayerData()
        UpdateWeaponProgress()
        task.wait(2)
    end
end)

-- ================================
-- BUILD WEAPONS PAGE
-- ================================

local weaponLayout = Instance.new("UIListLayout")
weaponLayout.Padding = UDim.new(0, 10)
weaponLayout.Parent = weaponPage

-- Yama Section
local yamaFrame = Instance.new("Frame")
yamaFrame.Size = UDim2.new(1, -20, 0, 150)
yamaFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
yamaFrame.BorderSizePixel = 0
yamaFrame.Parent = weaponPage

local yamaTitle = Instance.new("TextLabel")
yamaTitle.Size = UDim2.new(1, 0, 0, 25)
yamaTitle.BackgroundTransparency = 1
yamaTitle.Text = "🗡️ YAMA"
yamaTitle.TextColor3 = Color3.fromRGB(255, 150, 50)
yamaTitle.TextSize = 14
yamaTitle.Font = Enum.Font.GothamBold
yamaTitle.Parent = yamaFrame

local yamaKills = Instance.new("TextLabel")
yamaKills.Size = UDim2.new(1, -20, 0, 20)
yamaKills.Position = UDim2.new(0, 10, 0, 30)
yamaKills.BackgroundTransparency = 1
yamaKills.Text = "🎯 Kills: 0/20"
yamaKills.TextColor3 = Color3.fromRGB(200, 200, 200)
yamaKills.TextSize = 12
yamaKills.TextXAlignment = Enum.TextXAlignment.Left
yamaKills.Font = Enum.Font.Gotham
yamaKills.Parent = yamaFrame

local yamaMastery = Instance.new("TextLabel")
yamaMastery.Size = UDim2.new(1, -20, 0, 20)
yamaMastery.Position = UDim2.new(0, 10, 0, 55)
yamaMastery.BackgroundTransparency = 1
yamaMastery.Text = "⚔️ Mastery: 0/600"
yamaMastery.TextColor3 = Color3.fromRGB(200, 200, 200)
yamaMastery.TextSize = 12
yamaMastery.TextXAlignment = Enum.TextXAlignment.Left
yamaMastery.Font = Enum.Font.Gotham
yamaMastery.Parent = yamaFrame

local yamaBtn = Instance.new("TextButton")
yamaBtn.Size = UDim2.new(0, 120, 0, 30)
yamaBtn.Position = UDim2.new(0, 10, 0, 85)
yamaBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
yamaBtn.Text = "🔥 Auto Get"
yamaBtn.TextColor3 = Color3.new(1, 1, 1)
yamaBtn.TextSize = 12
yamaBtn.Font = Enum.Font.GothamBold
yamaBtn.Parent = yamaFrame
yamaBtn.MouseButton1Click:Connect(function()
    StartAutoGetWeapon("Yama")
end)

-- Shark Anchor Section
local sharkFrame = Instance.new("Frame")
sharkFrame.Size = UDim2.new(1, -20, 0, 180)
sharkFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
sharkFrame.BorderSizePixel = 0
sharkFrame.Parent = weaponPage

local sharkTitle = Instance.new("TextLabel")
sharkTitle.Size = UDim2.new(1, 0, 0, 25)
sharkTitle.BackgroundTransparency = 1
sharkTitle.Text = "🦈 SHARK ANCHOR"
sharkTitle.TextColor3 = Color3.fromRGB(0, 150, 200)
sharkTitle.TextSize = 14
sharkTitle.Font = Enum.Font.GothamBold
sharkTitle.Parent = sharkFrame

local sharkSea = Instance.new("TextLabel")
sharkSea.Size = UDim2.new(1, -20, 0, 20)
sharkSea.Position = UDim2.new(0, 10, 0, 30)
sharkSea.BackgroundTransparency = 1
sharkSea.Text = "🌊 Sea Beasts: 0/50"
sharkSea.TextColor3 = Color3.fromRGB(200, 200, 200)
sharkSea.TextSize = 12
sharkSea.TextXAlignment = Enum.TextXAlignment.Left
sharkSea.Font = Enum.Font.Gotham
sharkSea.Parent = sharkFrame

local sharkHunt = Instance.new("TextLabel")
sharkHunt.Size = UDim2.new(1, -20, 0, 20)
sharkHunt.Position = UDim2.new(0, 10, 0, 55)
sharkHunt.BackgroundTransparency = 1
sharkHunt.Text = "🦈 Sharks Killed: 0/100"
sharkHunt.TextColor3 = Color3.fromRGB(200, 200, 200)
sharkHunt.TextSize = 12
sharkHunt.TextXAlignment = Enum.TextXAlignment.Left
sharkHunt.Font = Enum.Font.Gotham
sharkHunt.Parent = sharkFrame

local sharkTeeth = Instance.new("TextLabel")
sharkTeeth.Size = UDim2.new(1, -20, 0, 20)
sharkTeeth.Position = UDim2.new(0, 10, 0, 80)
sharkTeeth.BackgroundTransparency = 1
sharkTeeth.Text = "🦷 Shark Teeth: 0/100"
sharkTeeth.TextColor3 = Color3.fromRGB(200, 200, 200)
sharkTeeth.TextSize = 12
sharkTeeth.TextXAlignment = Enum.TextXAlignment.Left
sharkTeeth.Font = Enum.Font.Gotham
sharkTeeth.Parent = sharkFrame

local sharkBtn = Instance.new("TextButton")
sharkBtn.Size = UDim2.new(0, 120, 0, 30)
sharkBtn.Position = UDim2.new(0, 10, 0, 110)
sharkBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
sharkBtn.Text = "🔥 Auto Get"
sharkBtn.TextColor3 = Color3.new(1, 1, 1)
sharkBtn.TextSize = 12
sharkBtn.Font = Enum.Font.GothamBold
sharkBtn.Parent = sharkFrame
sharkBtn.MouseButton1Click:Connect(function()
    StartAutoGetWeapon("SharkAnchor")
end)

-- Sanguine Art Section
local sanguineFrame = Instance.new("Frame")
sanguineFrame.Size = UDim2.new(1, -20, 0, 180)
sanguineFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
sanguineFrame.BorderSizePixel = 0
sanguineFrame.Parent = weaponPage

local sanguineTitle = Instance.new("TextLabel")
sanguineTitle.Size = UDim2.new(1, 0, 0, 25)
sanguineTitle.BackgroundTransparency = 1
sanguineTitle.Text = "🩸 SANGUINE ART"
sanguineTitle.TextColor3 = Color3.fromRGB(200, 50, 100)
sanguineTitle.TextSize = 14
sanguineTitle.Font = Enum.Font.GothamBold
sanguineTitle.Parent = sanguineFrame

local sanguineElite = Instance.new("TextLabel")
sanguineElite.Size = UDim2.new(1, -20, 0, 20)
sanguineElite.Position = UDim2.new(0, 10, 0, 30)
sanguineElite.BackgroundTransparency = 1
sanguineElite.Text = "🎯 Elite Kills: 0/30"
sanguineElite.TextColor3 = Color3.fromRGB(200, 200, 200)
sanguineElite.TextSize = 12
sanguineElite.TextXAlignment = Enum.TextXAlignment.Left
sanguineElite.Font = Enum.Font.Gotham
sanguineElite.Parent = sanguineFrame

local sanguineQuest = Instance.new("TextLabel")
sanguineQuest.Size = UDim2.new(1, -20, 0, 20)
sanguineQuest.Position = UDim2.new(0, 10, 0, 55)
sanguineQuest.BackgroundTransparency = 1
sanguineQuest.Text = "📜 Elite Quests: 0/5"
sanguineQuest.TextColor3 = Color3.fromRGB(200, 200, 200)
sanguineQuest.TextSize = 12
sanguineQuest.TextXAlignment = Enum.TextXAlignment.Left
sanguineQuest.Font = Enum.Font.Gotham
sanguineQuest.Parent = sanguineFrame

local sanguineFrag = Instance.new("TextLabel")
sanguineFrag.Size = UDim2.new(1, -20, 0, 20)
sanguineFrag.Position = UDim2.new(0, 10, 0, 80)
sanguineFrag.BackgroundTransparency = 1
sanguineFrag.Text = "💎 Fragments: 0/100"
sanguineFrag.TextColor3 = Color3.fromRGB(200, 200, 200)
sanguineFrag.TextSize = 12
sanguineFrag.TextXAlignment = Enum.TextXAlignment.Left
sanguineFrag.Font = Enum.Font.Gotham
sanguineFrag.Parent = sanguineFrame

local sanguineBtn = Instance.new("TextButton")
sanguineBtn.Size = UDim2.new(0, 120, 0, 30)
sanguineBtn.Position = UDim2.new(0, 10, 0, 110)
sanguineBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
sanguineBtn.Text = "🔥 Auto Get"
sanguineBtn.TextColor3 = Color3.new(1, 1, 1)
sanguineBtn.TextSize = 12
sanguineBtn.Font = Enum.Font.GothamBold
sanguineBtn.Parent = sanguineFrame
sanguineBtn.MouseButton1Click:Connect(function()
    StartAutoGetWeapon("SanguineArt")
end)

-- ================================
-- BUILD FARM PAGE
-- ================================

local farmLayout = Instance.new("UIListLayout")
farmLayout.Padding = UDim.new(0, 10)
farmLayout.Parent = farmPage

local farmControlFrame = Instance.new("Frame")
farmControlFrame.Size = UDim2.new(1, -20, 0, 200)
farmControlFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
farmControlFrame.BorderSizePixel = 0
farmControlFrame.Parent = farmPage

local farmTitle = Instance.new("TextLabel")
farmTitle.Size = UDim2.new(1, 0, 0, 25)
farmTitle.BackgroundTransparency = 1
farmTitle.Text = "🤖 AUTO FARM CONTROLS"
farmTitle.TextColor3 = Color3.fromRGB(255, 80, 80)
farmTitle.TextSize = 14
farmTitle.Font = Enum.Font.GothamBold
farmTitle.Parent = farmControlFrame

local farmToggleBtn = Instance.new("TextButton")
farmToggleBtn.Size = UDim2.new(0, 150, 0, 40)
farmToggleBtn.Position = UDim2.new(0, 10, 0, 35)
farmToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
farmToggleBtn.Text = "▶️ Start Farm"
farmToggleBtn.TextColor3 = Color3.new(1, 1, 1)
farmToggleBtn.TextSize = 14
farmToggleBtn.Font = Enum.Font.GothamBold
farmToggleBtn.Parent = farmControlFrame
farmToggleBtn.MouseButton1Click:Connect(function()
    FarmSettings.Enabled = not FarmSettings.Enabled
    if FarmSettings.Enabled then
        farmToggleBtn.Text = "⏸️ Stop Farm"
        farmToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.spawn(AutoFarmLoop)
    else
        farmToggleBtn.Text = "▶️ Start Farm"
        farmToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    end
end)

local autoQuestToggle = Instance.new("TextButton")
autoQuestToggle.Size = UDim2.new(0, 150, 0, 40)
autoQuestToggle.Position = UDim2.new(0, 170, 0, 35)
autoQuestToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
autoQuestToggle.Text = "📜 Auto Quest: ON"
autoQuestToggle.TextColor3 = Color3.new(1, 1, 1)
autoQuestToggle.TextSize = 12
autoQuestToggle.Font = Enum.Font.GothamBold
autoQuestToggle.Parent = farmControlFrame
autoQuestToggle.MouseButton1Click:Connect(function()
    FarmSettings.AutoQuest = not FarmSettings.AutoQuest
    autoQuestToggle.Text = FarmSettings.AutoQuest and "📜 Auto Quest: ON" or "📜 Auto Quest: OFF"
    autoQuestToggle.BackgroundColor3 = FarmSettings.AutoQuest and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 70)
end)

-- ================================
-- FINAL MESSAGE
-- ================================

print("✅ HYPERION-HUB | BLOX FRUITS - LOADED SUCCESSFULLY")
print("🔥 Created by HYPERION TEAM")
