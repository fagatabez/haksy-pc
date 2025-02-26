local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

repeat wait() until character and character:FindFirstChild("Humanoid")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 🔹 Lista rzadkich trybów
local rareModes = {
    "BlackoutHour", "BloodNight", "CalamityHour", "CarnageHour", "ChaosHour",
    "DWP", "FinalHour", "FrozenDeath", "GlitchHour", "InfernoHour",
    "LowtiergodHour", "MikeHour", "OLDBN", "PureInsanity", "ShadowHour", "VisionHour"
}

-- 🔹 Lista rzadkich trybów z "Val"
local rareModesVal = {
    "BlackoutHourVal", "BloodNightVal", "CalamityHourVal", "CarnageHourVal", "ChaosHourVal",
    "DWPVal", "FinalHourVal", "FrozenDeathVal", "GlitchHourVal", "InfernoHourVal",
    "LowtierVal", "MikeHourVal", "OLDBNVal", "PureInsanityVal", "ShadowHourVal", "VisionHourVal"
}

-- 🔹 Lista broni laserowych
local laserWeapons = { "LaserVision", "OverheatedLaserVision" }

-- 🔹 Lista wszystkich broni
local allWeapons = {
    "LightningStaff", "LightningStrikeTool", "VOLTBLADE", "UltraChain", "WinterCore",
    "TerrorBlade", "LaserVision", "OverheatedLaserVision", "Boom",
    "ReaperScythe", "ShadowBlade", "VenomScythe", "PrototypeStunStick",
    "StunStick", "SpectreOD", "Meteor", "Gasterblaster"
}

-- 🔹 Zmienna do śledzenia trybu inteligentnej zmiany broni
local autoWeaponSwitch = false

-- 🔹 Funkcja do zakładania narzędzi
local function equipTool(toolName)
    local backpack = player:FindFirstChild("Backpack")
    local tool = backpack and backpack:FindFirstChild(toolName)

    if tool then
        tool.Parent = character
    end
end

-- 🔹 Funkcja do zdejmowania wszystkich narzędzi
local function unequipAllTools()
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = player.Backpack
        end
    end
end

-- 🔹 Funkcja do aktywowania narzędzi
local function activateTool(toolName)
    local tool = character:FindFirstChild(toolName)
    if tool then
        tool:Activate()
    end
end

-- 🔹 Funkcja do sprawdzania trybu gry
local function checkGameMode()
    if not autoWeaponSwitch then return end -- Jeśli inteligentne zmienianie jest wyłączone, to nie sprawdzamy trybu

    if not workspace:FindFirstChild("Rake") then return end

    local currentMode = nil
    local valModeActive = false

    -- Sprawdza tryb w skryptach Rake
    for _, v in ipairs(workspace.Rake:GetChildren()) do
        if v:IsA("Script") and not v.Disabled then
            for _, mode in ipairs(rareModes) do
                if string.match(v.Name, mode) then
                    currentMode = mode
                    break
                end
            end
            for _, valMode in ipairs(rareModesVal) do
                if string.match(v.Name, valMode) then
                    valModeActive = true
                    break
                end
            end
        end
    end

    -- 🔹 Jeśli wykryto rzadki tryb -> Zdejmuje bronie i zakłada lasery
    if currentMode and not valModeActive then
        unequipAllTools()
        for _, weapon in ipairs(laserWeapons) do
            equipTool(weapon)
        end
        print("🔴 Rzadki tryb wykryty: " .. currentMode .. " - Zakładam lasery!")

    -- 🔹 Jeśli tryb Val został włączony -> Zdejmuje lasery i zakłada wszystkie bronie
    elseif valModeActive then
        unequipAllTools()
        for _, weapon in ipairs(allWeapons) do
            equipTool(weapon)
        end
        print("🟢 Tryb Val aktywny - Zakładam wszystkie bronie!")
    end
end

-- 🔹 Sprawdza tryb co sekundę, jeśli inteligentne zmienianie jest włączone
RunService.Heartbeat:Connect(checkGameMode)

-- 🔹 Obsługa klawisza "E" do zakładania wszystkich narzędzi (bez aktywacji)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or autoWeaponSwitch then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        unequipAllTools()
        for _, weapon in ipairs(allWeapons) do
            equipTool(weapon)
        end
    end
end)

-- 🔹 Obsługa klawisza "R" do zakładania tylko LaserVision i OverheatedLaserVision
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or autoWeaponSwitch then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        unequipAllTools()
        wait(0.1) -- Krótka pauza, aby upewnić się, że narzędzia się odpięły
        for _, weapon in ipairs(laserWeapons) do
            equipTool(weapon)
        end
    end
end)

-- 🔹 Obsługa klawisza "F" do włączania inteligentnej zmiany broni i założenia wszystkich broni
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        autoWeaponSwitch = true
        unequipAllTools()
        for _, weapon in ipairs(allWeapons) do
            equipTool(weapon)
        end
        print("🔄 Inteligentne zmienianie broni WŁĄCZONE! Założono wszystkie bronie.")
    end
end)

-- 🔹 Obsługa klawisza "G" do wyłączania inteligentnej zmiany broni i zdjęcia wszystkich broni
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        autoWeaponSwitch = false
        unequipAllTools() -- Zdejmuje wszystkie bronie po wyłączeniu trybu
        print("⛔ Inteligentne zmienianie broni WYŁĄCZONE! Wszystkie bronie zdjęte.")
    end
end)

-- 🔹 Obsługa lewego przycisku myszy (LMB) do aktywacji narzędzi
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        for _, weapon in ipairs(allWeapons) do
            activateTool(weapon)
        end
    end
end)
