local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")

local autoWeaponSwitch = false -- Czy system zmiany broni jest aktywny?

local modes = {
    "BlackoutHour", "BloodNight", "CalamityStart", "CarnageHour", "CHAOS_RESTRICTED_MODE",
    "DeepwaterPerdition", "FinalHour", "FrozenDeath", "GlitchHour", "InfernoHour",
    "LowtiergodHour", "CorruptedHour", "oldBN", "PureInsanity", "ShadowHour", "VoidHour", "VisionHour",
    "ULTIMA", "SkyfallHour", "BloodBath"
}

local modeVals = {
    "BlackoutHourVal", "BloodNightVal", "CalamityHourVal", "CarnageHourVal", "ChaosHourVal",
    "DWPVal", "FinalHourVal", "FrozenDeathVal", "GlitchHourV", "InfernoHourVal",
    "LowtierVal", "MikeHourVal", "OLDBNVal", "PureInsanityVal", "ShadowHourVal", "VoidHourVal", "VisionHourVal",
    "ULTIMAVal", "SkyfallHourVal", "BloodBathVal", "BlueScreenDeathValue", "IceAgeV", "MeltdownVal", "ShadowPhase2",
    "ThalassophobiaV", "ULTIMAP2Val", "UltimateCalamityValue"
}

local laserWeapons = {"LaserVision", "OverheatedLaserVision"}
local allWeapons = {
    "LightningStaff", "LightningStrikeTool", "VOLTBLADE", "UltraChain", "WinterCore", "TerrorBlade",
    "LaserVision", "OverheatedLaserVision", "Boom", "ReaperScythe", "ShadowBlade", "VenomScythe",
    "PrototypeStunStick", "StunStick", "SpectreOD", "Meteor", "Gasterblaster", "Hyperblizzard",
    "Super-charged Executioner", "Chaos Core"
}

local function equipTools(toolList)
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    for _, toolName in ipairs(toolList) do
        local tool = backpack:FindFirstChild(toolName)
        if tool then
            tool.Parent = character
        end
    end
end

local function unequipAllTools()
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = player.Backpack
        end
    end
end

local function detectRakeMode()
    local rake = workspace:FindFirstChild("Rake")
    local modeFound = false  -- Flaga informująca, czy wykryto tryb

    -- Sprawdzenie trybu CalamityStart w ReplicatedStorage
    if replicatedStorage:FindFirstChild("ModeValues") and replicatedStorage.ModeValues:FindFirstChild("Values") then
        local calamityValue = replicatedStorage.ModeValues.Values:FindFirstChild("Calamity")
        if calamityValue and calamityValue.Value == true then
            print("🔥 Tryb CalamityStart wykryty (przez ReplicatedStorage)")
            modeFound = true
            unequipAllTools()
            equipTools(allWeapons) -- W CalamityStart tylko laserowe bronie
            return
        end
    end

    if not rake then return end -- Jeśli Rake nie istnieje, zakończ funkcję

    -- Sprawdzenie trybów w Rake
    for _, mode in ipairs(modes) do
        if rake:FindFirstChild(mode) and rake[mode].Enabled then
            print("🔵 Tryb wykryty: " .. mode)
            modeFound = true  
            unequipAllTools()
            equipTools(laserWeapons)

            for _, modeVal in ipairs(modeVals) do
                if rake:FindFirstChild(modeVal) and rake[modeVal].Value == true then
                    print("🔴 Tryb + Val wykryty: " .. modeVal)
                    unequipAllTools()
                    equipTools(allWeapons)
                    break
                end
            end
            break
        end
    end
end

-- Przełącznik systemu zmiany broni
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        if not autoWeaponSwitch then
            autoWeaponSwitch = true
            print("✅ Inteligentna zmiana broni WŁĄCZONA!")

            -- Sprawdzanie Rake'a co 2.9 sekundy, aby zmniejszyć obciążenie
            while autoWeaponSwitch do
                detectRakeMode()
                wait(2.9)
            end
        end
    elseif input.KeyCode == Enum.KeyCode.G then
        autoWeaponSwitch = false
        print("❌ Inteligentna zmiana broni WYŁĄCZONA!")
        unequipAllTools()
    end
end)
