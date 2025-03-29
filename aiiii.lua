local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local workspace = game:GetService("Workspace")

local autoWeaponSwitch = false -- Czy system zmiany broni jest aktywny?

local modes = {
    "BlackoutHour", "BloodNight", "CalamityStart", "CarnageHour", "CHAOS_RESTRICTED_MODE",
    "DeepwaterPerdition", "FinalHour", "FrozenDeath", "GlitchHour", "InfernoHour",
    "LowtiergodHour", "CorruptedHour", "oldBN", "PureInsanity", "ShadowHour", "VoidHour", "VisionHour",
    "ULTIMA", "SkyfallHour", "BloodBath"
}

local modeVals = {
    "BlackoutHourVal", "BloodNightVal", "CalamityHourVal", "CarnageHourVal", "ChaosHourVal",
    "DWPVal", "FinalHourVal", "FrozenDeathVal", "GlitchHourVal", "InfernoHourVal",
    "LowtierVal", "MikeHourVal", "OLDBNVal", "PureInsanityVal", "ShadowHourVal", "VoidHourVal", "VisionHourVal",
    "ULTIMAVal", "SkyfallHourVal", "BloodBathVal"
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

local hasPrintedStart = false  -- Flaga do sprawdzenia, czy komunikat o włączeniu systemu był już wypisany
local hasPrintedMode = false  -- Flaga do sprawdzenia, czy komunikat o trybie był już wypisany

local function detectRakeMode()
    while autoWeaponSwitch do
        local rake = workspace:FindFirstChild("Rake")
        if rake then
            for _, mode in ipairs(modes) do
                if rake:FindFirstChild(mode) and rake[mode].Enabled then
                    if not hasPrintedMode then
                        -- Komunikat o wykryciu trybu wypisywany tylko raz
                        print("🔵 Tryb wykryty: " .. mode)
                        hasPrintedMode = true  -- Ustawienie flagi, aby komunikat był wypisany tylko raz
                    end
                    unequipAllTools()
                    equipTools(laserWeapons)

                    for _, modeVal in ipairs(modeVals) do
                        if rake:FindFirstChild(modeVal) and rake[modeVal].Value == true then
                            if not hasPrintedMode then
                                -- Komunikat o wykryciu trybu z modeVal wypisywany tylko raz
                                print("🔴 Tryb + Val wykryty: " .. modeVal)
                                hasPrintedMode = true  -- Ustawienie flagi, aby komunikat był wypisany tylko raz
                            end
                            unequipAllTools()
                            equipTools(allWeapons)
                            break
                        end
                    end
                    break
                end
            end
        end
        wait(0.4) -- Szybsza reakcja na zmiany
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        if not autoWeaponSwitch then
            autoWeaponSwitch = true
            if not hasPrintedStart then
                -- Komunikat o włączeniu systemu wypisywany tylko raz
                print("✅ Inteligentna zmiana broni WŁĄCZONA!")
                hasPrintedStart = true  -- Ustawienie flagi, aby komunikat był wypisany tylko raz
            end
            detectRakeMode()
        end
    elseif input.KeyCode == Enum.KeyCode.G then
        autoWeaponSwitch = false
        if hasPrintedStart then
            -- Komunikat o wyłączeniu systemu wypisywany tylko raz
            print("❌ Inteligentna zmiana broni WYŁĄCZONA!")
            hasPrintedStart = false  -- Resetowanie flagi, aby komunikat był wypisany przy następnym włączeniu
        end
        unequipAllTools()
    end
end)
