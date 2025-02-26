local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local uis = game:GetService("UserInputService")
local enabledAutoSwitch = false -- Inteligentne zmienianie broni (F/G)

local toolNames = { -- Wszystkie bronie
    "LightningStaff", "LightningStrikeTool", "VOLTBLADE", "UltraChain", "WinterCore",
    "TerrorBlade", "LaserVision", "OverheatedLaserVision", "Boom", "ReaperScythe",
    "ShadowBlade", "VenomScythe", "PrototypeStunStick", "StunStick", "SpectreOD",
    "Meteor", "Gasterblaster"
}

local laserTools = { "LaserVision", "OverheatedLaserVision" } -- Tylko lasery

-- Wszystkie ważne tryby
local modes = { 
    "BlackoutHour", "BloodNight", "CalamityStart", "CarnageHour", "CHAOS_RESTRICTED_MODE",
    "DeepwaterPerdition", "FinalHour", "FrozenDeath", "GlitchHour", "InfernoHour",
    "LowtiergodHour", "CorruptedHour", "oldBN", "PureInsanity", "ShadowHour", "VoidHour", "VisionHour"
}

local vals = {
    "BlackoutHourVal", "BloodNightVal", "CalamityHourVal", "CarnageHourVal", "ChaosHourVal",
    "DWPVal", "FinalHourVal", "FrozenDeathVal", "GlitchHourVal", "InfernoHourVal",
    "LowtierVal", "MikeHourVal", "OLDBNVal", "PureInsanityVal", "ShadowHourVal", "VoidHourVal", "VisionHourVal"
}

-- Zakładanie broni
local function equipTools(tools)
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    for _, toolName in ipairs(tools) do
        local tool = backpack:FindFirstChild(toolName)
        if tool and tool.Parent ~= character then
            tool.Parent = character
        end
    end
end

-- Zdejmowanie wszystkich broni
local function unequipAllTools()
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = player.Backpack
        end
    end
end

-- Sprawdzanie trybów
local function checkGameModes()
    local lastEquippedSet = nil -- Przechowuje ostatni zestaw broni

    while true do
        wait(1) -- Sprawdzanie co sekundę

        local workspaceData = game.Workspace
        local modeActive = false
        local valActive = false

        for _, mode in ipairs(modes) do
            if workspaceData:FindFirstChild(mode) and workspaceData[mode].Enabled.Value then
                modeActive = true
                break
            end
        end

        for _, val in ipairs(vals) do
            if workspaceData:FindFirstChild(val) and workspaceData[val].Value then
                valActive = true
                break
            end
        end

        if enabledAutoSwitch then
            local newSet = nil

            if valActive then
                newSet = toolNames -- `Val` aktywne → wszystkie bronie
            elseif modeActive then
                newSet = laserTools -- Tryb aktywny → tylko lasery
            else
                newSet = toolNames -- Brak trybu → wszystkie bronie
            end

            if newSet ~= lastEquippedSet then -- Zakłada bronie tylko jeśli zmiana jest konieczna
                unequipAllTools()
                equipTools(newSet)
                lastEquippedSet = newSet
            end
        end
    end
end

-- Obsługa klawiszy
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.E then
        unequipAllTools()
        equipTools(toolNames) -- Wszystkie bronie
    elseif input.KeyCode == Enum.KeyCode.R then
        unequipAllTools()
        equipTools(laserTools) -- Tylko lasery
    elseif input.KeyCode == Enum.KeyCode.F then
        enabledAutoSwitch = true
        print("✅ Inteligentne zmienianie broni: WŁĄCZONE")
    elseif input.KeyCode == Enum.KeyCode.G then
        enabledAutoSwitch = false
        unequipAllTools()
        equipTools(toolNames) -- Przy wyłączeniu wracamy do domyślnych broni
        print("❌ Inteligentne zmienianie broni: WYŁĄCZONE")
    end
end)

-- Uruchomienie sprawdzania trybów
spawn(checkGameModes)
