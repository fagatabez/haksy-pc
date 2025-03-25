local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local workspace = game:GetService("Workspace")

local autoWeaponControl = false -- Kontrola zmiany broni
local autoAttack = false -- Auto-atak

local toolsToActivate = {
    "LightningStaff", "LightningStrikeTool", "VOLTBLADE", "UltraChain", "WinterCore",
    "TerrorBlade", "LaserVision", "OverheatedLaserVision", "Boom", "ReaperScythe",
    "ShadowBlade", "VenomScythe", "PrototypeStunStick", "StunStick", "SpectreOD",
    "Meteor", "Super-charged Executioner", "Gasterblaster"
}

local modeScripts = {
    "BlackoutHour", "BloodNight", "CalamityStart", "CarnageHour", "CHAOS_RESTRICTED_MODE",
    "DeepwaterPerdition", "FinalHour", "FrozenDeath", "GlitchHour", "InfernoHour",
    "LowtiergodHour", "CorruptedHour", "oldBN", "PureInsanity", "ShadowHour", "VoidHour",
    "VisionHour", "ULTIMA", "SkyfallHour", "BloodBath"
}

local modeValues = {
    "BlackoutHourVal", "BloodNightVal", "CalamityHourVal", "CarnageHourVal", "ChaosHourVal",
    "DWPVal", "FinalHourVal", "FrozenDeathVal", "GlitchHourVal", "InfernoHourVal",
    "LowtierVal", "MikeHourVal", "OLDBNVal", "PureInsanityVal", "ShadowHourVal",
    "VoidHourVal", "VisionHourVal", "ULTIMAVal", "SkyfallHourVal", "BloodBathVal"
}

-- 🔹 Funkcja aktywująca narzędzia
local function activateTools()
    for _, toolName in pairs(toolsToActivate) do
        local tool = character:FindFirstChild(toolName)
        if tool then
            tool:Activate() -- Aktywacja narzędzia
        end
    end
end

-- 🔹 Funkcja zmieniająca broń na podstawie trybów
local function updateWeapons()
    if not autoWeaponControl then return end

    local rake = workspace:FindFirstChild("Rake")
    if not rake then return end

    local modeActive = false
    local valueActive = false

    -- Sprawdzamy tryby
    for _, mode in pairs(modeScripts) do
        if rake:FindFirstChild(mode) then
            modeActive = true
            break
        end
    end

    -- Sprawdzamy wartości
    for _, modeVal in pairs(modeValues) do
        if rake:FindFirstChild(modeVal) and rake[modeVal].Value == true then
            valueActive = true
            break
        end
    end

    -- Jeśli tylko tryb → zakładamy lasery
    if modeActive and not valueActive then
        equipTool("LaserVision")
        equipTool("OverheatedLaserVision")
        print("🔵 Włączono lasery!")
    elseif modeActive and valueActive then
        -- Jeśli tryb i wartość → zakładamy wszystkie bronie
        for _, tool in pairs(toolsToActivate) do
            equipTool(tool)
        end
        print("🔴 Włączono wszystkie bronie!")
    end

    -- Auto-atak po zmianie broni
    if autoAttack then
        activateTools()
    end
end

-- 🔹 Pętla sprawdzająca co 0.4 sekundy
spawn(function()
    while true do
        if autoWeaponControl then
            updateWeapons()
        end
        wait(0.4) -- Zamiast Heartbeat
    end
end)

-- 🔹 Włączanie/wyłączanie skryptu
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F then
        autoWeaponControl = true
        print("✅ Inteligentna zmiana broni WŁĄCZONA!")
    elseif input.KeyCode == Enum.KeyCode.G then
        autoWeaponControl = false
        print("⛔ Inteligentna zmiana broni WYŁĄCZONA!")
    end
end)
