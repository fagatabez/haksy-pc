local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local savedCFrame = rootPart.CFrame -- Domyślnie zapisuje zarówno pozycję, jak i rotację
local teleporting = false -- Czy teleportowanie jest aktywne

-- Funkcja zapisująca aktualną pozycję i rotację
local function savePositionAndRotation()
    savedCFrame = rootPart.CFrame
    print("Zapisano pozycję i rotację:", savedCFrame.Position, savedCFrame.RotVelocity)
end

-- Funkcja rozpoczynająca teleportowanie
local function startTeleporting()
    if not teleporting then
        teleporting = true
        while teleporting do
            rootPart.CFrame = savedCFrame -- Teleportuje na zapisane CFrame (pozycja + rotacja)
            wait(1) -- Teleportuj co sekundę
        end
    end
end

-- Funkcja zatrzymująca teleportowanie
local function stopTeleporting()
    teleporting = false
end

-- Obsługa klawiszy
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.K then
        savePositionAndRotation() -- Zapisuje pozycję i rotację
    elseif input.KeyCode == Enum.KeyCode.U then
        startTeleporting() -- Zaczyna teleportowanie
    elseif input.KeyCode == Enum.KeyCode.J then
        stopTeleporting() -- Zatrzymuje teleportowanie
    end
end)
