local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local uis = game:GetService("UserInputService")

local autoSwitchEnabled = false -- Domyślnie wyłączone

local toolNames = { -- Wszystkie bronie
    "LightningStaff", "LightningStrikeTool", "VOLTBLADE", "UltraChain", "WinterCore",
    "TerrorBlade", "LaserVision", "OverheatedLaserVision", "Boom", "ReaperScythe",
    "ShadowBlade", "VenomScythe", "PrototypeStunStick", "StunStick", "SpectreOD",
    "Meteor", "Gasterblaster"
}

local laserTools = { "LaserVision", "OverheatedLaserVision" } -- Tylko lasery

local modes = { -- Wszystkie tryby w Rake
    "BlackoutHour", "BloodNight", "CalamityStart", "CarnageHour", "CHAOS_RESTRICTED_MODE",
    "DeepwaterPerdition", "FinalHour", "FrozenDeath", "GlitchHour", "InfernoHour",
    "LowtiergodHour", "CorruptedHour", "oldBN", "PureInsanity", "ShadowHour", "VoidHour", "VisionHour"
}

local vals = { -- Odpowiednie wartości `Val` dla każdego trybu
    "BlackoutHourVal", "BloodNightVal", "CalamityHourVal", "CarnageHourVal", "ChaosHourVal",
    "DWPVal", "FinalHourVal", "FrozenDeathVal", "GlitchHourVal", "InfernoHourVal",
    "LowtierVal", "MikeHourVal", "OLDBNVal", "PureInsanityVal", "ShadowHourVal", "VoidHourVal", "VisionHourVal"
}

-- Funkcja do zakładania i zdejmowania broni
local function equipTools(tools)
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end

    -- Zdejmowanie wszystkich broni
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = backpack
        end
    end

    -- Zakładanie wybranych broni
    for _, toolName in ipairs(tools) do
        local tool = backpack:FindFirstChild(toolName)
        if tool then
            tool.Parent = character
        end
    end
end

-- Funkcja do sprawdzania statusu Rake i zmiany broni
local function checkRakeStatus()
    local lastEquippedSet = nil

    while true do
        wait(1) -- Sprawdza co sekundę

        if not autoSwitchEnabled then
            continue -- Jeśli auto-switch jest wyłączony, to pętla nic nie robi
        end

        local rake = game.Workspace:FindFirstChild("Rake")
        if not rake then
            -- Rake nie istnieje, nie zmieniamy ekwipunku
            continue
        end

        local modeActive = false
        local valActive = false

        -- Sprawdzanie aktywnych trybów w Rake (czy Rake ma włączony tryb)
        for _, mode in ipairs(modes) do
            local modeObject = rake:FindFirstChild(mode)
            if modeObject and modeObject:IsA("BoolValue") and modeObject.Value then
                modeActive = true
                break
            end
        end

        -- Sprawdzanie, czy `Val` danego trybu jest włączony (czy tryb jest w pełni aktywny po transformacji)
        for _, val in ipairs(vals) do
            local valObject = game.Workspace:FindFirstChild(val)
            if valObject and valObject:IsA("BoolValue") and valObject.Value then
                valActive = true
                break
            end
        end

        -- Ustalanie, jakie bronie mają być założone
        local newSet = nil
        if modeActive and valActive then
            newSet = toolNames -- Jeśli zarówno tryb, jak i `Val` są aktywne → wszystkie bronie
        elseif modeActive then
            newSet = laserTools -- Jeśli tylko tryb jest aktywny → tylko lasery
        end

        -- Zakłada broń tylko jeśli zestaw się zmienia
        if newSet and newSet ~= lastEquippedSet then
            equipTools(newSet)
            lastEquippedSet = newSet
        end
    end
end

-- Obsługa klawiszy (F = włącz, G = wyłącz)
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F then
        autoSwitchEnabled = true
        print("✅ Inteligentne zmienianie broni: WŁĄCZONE")
    elseif input.KeyCode == Enum.KeyCode.G then
        autoSwitchEnabled = false
        print("❌ Inteligentne zmienianie broni: WYŁĄCZONE")
    end
end)

-- Uruchamiamy sprawdzanie statusu Rake w tle
spawn(checkRakeStatus)
