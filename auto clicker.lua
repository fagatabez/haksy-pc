local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local autoClick = false
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
    "Gasterblaster"
}

-- Funkcja do aktywowania narzędzi
local function activateTools()
    for _, toolName in pairs(toolsToActivate) do
        local tool = character:FindFirstChild(toolName)
        if tool then
            tool:Activate() -- Aktywacja narzędzia
        end
    end
end

-- Funkcja do klikania
local function click()
    while autoClick do
        activateTools()  -- Aktywuje wszystkie narzędzia w tablicy
        wait(0.1) -- Częstotliwość klikania
    end
end

-- Obsługa klawiszy
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.X then
        autoClick = true
        click() -- Startuje auto-klik
    elseif input.KeyCode == Enum.KeyCode.C then
        autoClick = false -- Zatrzymuje auto-klik
    end
end)
