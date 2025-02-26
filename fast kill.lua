local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

repeat wait() until character and character:FindFirstChild("Humanoid")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local rareModes = {
    "BlackoutHour", "BloodNight", "CalamityStart", "CarnageHour", "CHAOS_RESTRICTED_MODE",
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

-- 🔹 Śledzenie aktualnie założonego zestawu broni
local currentEquippedMode = nil  -- nil = nic nie założone, "lasers" = lasery, "all" = wszystkie bronie

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

local function equipTools(toolList, mode)
    if currentEquippedMode == mode then return end  -- Jeśli już mamy ten zestaw, to nie zmieniamy

    unequipAllTools()
    for _, tool in ipairs(toolList) do
        equipTool(tool)
    end

    currentEquippedMode = mode  -- Ustawiamy aktualny tryb broni
end

local function checkGameMode()
    if not workspace:FindFirstChild("Rake") then return end

    local rake = workspace.Rake
    local currentMode = nil
    local valModeActive = false

    -- 🔹 Sprawdza aktywny tryb (zwykły)
    for _, v in ipairs(rake:GetChildren()) do
        if v:IsA("Script") and not v.Disabled then
            for _, mode in ipairs(rareModes) do
                if string.match(v.Name, mode) then
                    currentMode = mode
                    break
                end
            end
        end
    end

    -- 🔹 Sprawdza, czy aktywne jest Val
    for _, valMode in ipairs(rareModesVal) do
        local val = rake:FindFirstChild(valMode)
        if val and val:IsA("BoolValue") and val.Value then
            valModeActive = true
            break
        end
    end

    -- 🔹 Logika wyboru broni
    if valModeActive then
        equipTools(allWeapons, "all")  -- Val -> wszystkie bronie
    elseif currentMode then
        equipTools(laserWeapons, "lasers")  -- Rzadki tryb -> tylko lasery
    else
        equipTools(allWeapons, "all")  -- Normalny tryb -> wszystkie bronie
    end
end

-- 🔹 Nasłuchuje zmian trybu co sekundę (nie w każdej klatce)
RunService.Heartbeat:Connect(function()
    checkGameMode()
end)

-- 🔹 Nasłuchuje na zmiany Val w Rake i aktualizuje bronie tylko gdy coś się zmienia
if workspace:FindFirstChild("Rake") then
    local rake = workspace.Rake
    for _, valMode in ipairs(rareModesVal) do
        local val = rake:FindFirstChild(valMode)
        if val and val:IsA("BoolValue") then
            val:GetPropertyChangedSignal("Value"):Connect(function()
                checkGameMode()
            end)
        end
    end
end
