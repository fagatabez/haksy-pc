local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

repeat wait() until character and character:FindFirstChild("Humanoid")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Lista trybów gry
local rareModes = {"BlackoutHour", "BloodNight", "CalamityStart", "CarnageHour", "ChaosHour", "DeepwaterPerdition", "FinalHour", "FrozenDeath", "GlitchHour", "InfernoHour", "LowtiergodHour", "CorruptedHour", "oldBN", "PureInsanity", "ShadowHour", "VoidHour", "VisionHour"}
local rareModesVal = {"BlackoutHourVal", "BloodNightVal", "CalamityHourVal", "CarnageHourVal", "ChaosHourVal", "DWPVal", "FinalHourVal", "FrozenDeathVal", "GlitchHourVal", "InfernoHourVal", "LowtierVal", "MikeHourVal", "OLDBNVal", "PureInsanityVal", "ShadowHourVal", "VoidHourVal", "VisionHourVal"}

-- Lista broni
local laserWeapons = {"LaserVision", "OverheatedLaserVision"}
local allWeapons = {"LightningStaff", "LightningStrikeTool", "VOLTBLADE", "UltraChain", "WinterCore", "TerrorBlade", "LaserVision", "OverheatedLaserVision", "Boom", "ReaperScythe", "ShadowBlade", "VenomScythe", "PrototypeStunStick", "StunStick", "SpectreOD", "Meteor", "Gasterblaster"}

local autoWeaponSwitch = false

-- Funkcje ekwipunku
local function equipTool(toolName)
    local backpack = player:FindFirstChild("Backpack")
    local tool = backpack and backpack:FindFirstChild(toolName)
    if tool then tool.Parent = character end
end

local function unequipAllTools()
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then tool.Parent = player.Backpack end
    end
end

local function activateTool(toolName)
    local tool = character:FindFirstChild(toolName)
    if tool then tool:Activate() end
end

-- Sprawdzenie trybu gry
local function checkGameMode()
    if not autoWeaponSwitch or not workspace:FindFirstChild("Rake") then return end
    
    local rake = workspace.Rake
    local currentMode, valModeActive = nil, false

    -- Sprawdzanie aktywnego trybu
    for _, script in ipairs(rake:GetChildren()) do
        if script:IsA("Script") and not script.Disabled then
            for _, mode in ipairs(rareModes) do
                if string.match(script.Name, mode) then
                    currentMode = mode
                    break
                end
            end
        end
    end

    -- Sprawdzanie wartości Val
    for _, valMode in ipairs(rareModesVal) do
        local val = rake:FindFirstChild(valMode)
        if val and val:IsA("BoolValue") and val.Value then
            valModeActive = true
            break
        end
    end

    if currentMode and not valModeActive then
        unequipAllTools()
        for _, weapon in ipairs(laserWeapons) do equipTool(weapon) end
    elseif valModeActive then
        unequipAllTools()
        for _, weapon in ipairs(allWeapons) do equipTool(weapon) end
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

-- Obsługa klawiszy
local function handleInput(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E and not autoWeaponSwitch then
        unequipAllTools()
        for _, weapon in ipairs(allWeapons) do equipTool(weapon) end
    elseif input.KeyCode == Enum.KeyCode.R and not autoWeaponSwitch then
        unequipAllTools()
        wait(0.1)
        for _, weapon in ipairs(laserWeapons) do equipTool(weapon) end
    elseif input.KeyCode == Enum.KeyCode.F then
        autoWeaponSwitch = true
        unequipAllTools()
        for _, weapon in ipairs(allWeapons) do equipTool(weapon) end
    elseif input.KeyCode == Enum.KeyCode.G then
        autoWeaponSwitch = false
        unequipAllTools()
    end
end

UserInputService.InputBegan:Connect(handleInput)

-- Aktywowanie broni po kliknięciu LMB
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    for _, weapon in ipairs(allWeapons) do activateTool(weapon) end
end)
