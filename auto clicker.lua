local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local workspace = game:GetService("Workspace")

local autoDetectRake = false -- Tryb auto-ataku
local toolsToActivate = {
    "LightningStaff",
    "LightningStrikeTool",
    "VOLTBLADE",
    "UltraChain",
    "WinterCore",
    "TerrorBlade",
    "LaserVision",
    "OverheatedLaserVision",
    "Boom",
    "ReaperScythe",
    "ShadowBlade",
    "VenomScythe",
    "PrototypeStunStick",
    "StunStick",
    "SpectreOD",
    "Meteor",
    "Super-charged Executioner",
    "Gasterblaster",
    "Chaos Core"
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

-- 🔹 Funkcja sprawdzająca, czy Rake jest w grze i żyje
local function isRakeAlive()
    local rake = workspace:FindFirstChild("Rake") -- Szukamy Rake
    if rake then
        local humanoid = rake:FindFirstChild("NPC") -- Szukamy humanoida "NPC"
        if humanoid and humanoid:IsA("Humanoid") then
            return humanoid.Health > 0 -- Sprawdzamy, czy Rake żyje
        end
    end
    return false
end

-- 🔹 Funkcja sprawdzająca `Rake` co sekundę
local function checkForRake()
    while autoDetectRake do
        if workspace:FindFirstChild("Rake") then
            print("👀 Wykryto Rake! Odliczam 3 sekundy...")
            wait(3) -- Odczekanie 3 sekund przed atakiem
            while isRakeAlive() and autoDetectRake do
                activateTools() -- Atakujemy, jeśli Rake żyje
                wait(0.1)
            end
            print("❌ Rake zniknął! Zatrzymano atak.")
        end
        wait(1) -- Sprawdza co sekundę, czy Rake wrócił
    end
end

-- 🔹 Obsługa klawiszy (włączanie/wyłączanie auto-detekcji)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.X then
        if not autoDetectRake then
            autoDetectRake = true
            print("🔍 Auto-atak WŁĄCZONY!")
            checkForRake()
        end
    elseif input.KeyCode == Enum.KeyCode.C then
        autoDetectRake = false
        print("⏹️ Auto-atak WYŁĄCZONY!")
    end
end)
