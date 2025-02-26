local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

repeat wait() until character and character:FindFirstChild("Humanoid")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local rareModes = {
    "BlackoutHour", "BloodNight", "CalamityStart", "CarnageHour", "ChaosHour",
    "DeepwaterPerdition", "FinalHour", "FrozenDeath", "GlitchHour", "InfernoHour",
    "LowtiergodHour", "CorruptedHour", "oldBN", "PureInsanity", "ShadowHour", "VoidHour", "VisionHour"
}

local rareModesVal = {
    "BlackoutHourVal", "BloodNightVal", "CalamityHourVal", "CarnageHourVal", "ChaosHourVal",
    "DWPVal", "FinalHourVal", "FrozenDeathVal", "GlitchHourVal", "InfernoHourVal",
    "LowtierVal", "MikeHourVal", "OLDBNVal", "PureInsanityVal", "ShadowHourVal", "VoidHourVal", "VisionHourVal"
}

local laserWeapons = { "LaserVision", "OverheatedLaserVision" }

local allWeapons = {
    "LightningStaff", "LightningStrikeTool", "VOLTBLADE", "UltraChain", "WinterCore",
    "TerrorBlade", "LaserVision", "OverheatedLaserVision", "Boom",
    "ReaperScythe", "ShadowBlade", "VenomScythe", "PrototypeStunStick",
    "StunStick", "SpectreOD", "Meteor", "Gasterblaster"
}

local autoWeaponSwitch = false
local lastValState = false -- Zapamiętuje poprzedni stan Val, by nie powtarzać operacji

local function equipTool(toolName)
    local backpack = player:FindFirstChild("Backpack")
    local tool = backpack and backpack:FindFirstChild(toolName)

    if tool then
        tool.Parent = character
    end
end

local function unequipAllTools()
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = player.Backpack
        end
    end
end

local function activateTool(toolName)
    local tool = character:FindFirstChild(toolName)
    if tool then
        tool:Activate()
    end
end

local function checkGameMode()
    if not workspace:FindFirstChild("Rake") then return end

    local rake = workspace.Rake
    local valModeActive = false

    for _, valMode in ipairs(rareModesVal) do
        local val = rake:FindFirstChild(valMode)
        if val and val:IsA("BoolValue") and val.Value == true then
            valModeActive = true
            break
        end
    end

    if valModeActive and lastValState == false then
        -- Jeśli Val został włączony, a wcześniej był wyłączony → załóż bronie
        unequipAllTools()
        for _, weapon in ipairs(allWeapons) do
            equipTool(weapon)
        end
        lastValState = true -- Zapamiętujemy, że Val jest aktywny

    elseif not valModeActive and lastValState == true then
        -- Jeśli Val został wyłączony, a wcześniej był włączony → załóż lasery
        unequipAllTools()
        for _, weapon in ipairs(laserWeapons) do
            equipTool(weapon)
        end
        lastValState = false -- Zapamiętujemy, że Val jest wyłączony
    end
end

RunService.Heartbeat:Connect(checkGameMode)

if workspace:FindFirstChild("Rake") then
    local rake = workspace.Rake
    for _, valMode in ipairs(rareModesVal) do
        local val = rake:FindFirstChild(valMode)
        if val and val:IsA("BoolValue") then
            val:GetPropertyChangedSignal("Value"):Connect(checkGameMode)
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or autoWeaponSwitch then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        unequipAllTools()
        for _, weapon in ipairs(allWeapons) do
            equipTool(weapon)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or autoWeaponSwitch then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        unequipAllTools()
        wait(0.1)
        for _, weapon in ipairs(laserWeapons) do
            equipTool(weapon)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        autoWeaponSwitch = true
        unequipAllTools()
        for _, weapon in ipairs(allWeapons) do
            equipTool(weapon)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        autoWeaponSwitch = false
        unequipAllTools()
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        for _, weapon in ipairs(allWeapons) do
            activateTool(weapon)
        end
    end
end)
