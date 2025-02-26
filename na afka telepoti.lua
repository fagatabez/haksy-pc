local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local savedCFrame = rootPart.CFrame -- Zapisana pozycja i rotacja postaci
local savedCameraCFrame = camera.CFrame -- Zapisana orientacja kamery
local teleporting = false -- Czy teleportowanie jest aktywne

-- 🔹 Funkcja zapisująca pozycję postaci i kamerę
local function savePositionAndRotation()
    savedCFrame = rootPart.CFrame -- Zapis pozycji i rotacji postaci
    savedCameraCFrame = camera.CFrame -- Zapis orientacji kamery
    print("✅ Zapisano pozycję gracza i kamerę.")
end

-- 🔹 Funkcja teleportująca postać i resetująca kamerę
local function restorePositionAndCamera()
    rootPart.CFrame = savedCFrame -- Teleportacja gracza
    camera.CFrame = savedCameraCFrame -- Przywrócenie widoku kamery
end

-- 🔹 Funkcja rozpoczynająca teleportowanie
local function startTeleporting()
    if teleporting or not savedCFrame then return end -- Nie zaczynaj, jeśli już działa lub brak zapisanej pozycji

    teleporting = true
    print("🔄 Teleportowanie aktywne...")

    while teleporting do
        restorePositionAndCamera() -- Przywraca pozycję i kamerę
        wait(1) -- Teleportuj co sekundę
    end
end

-- 🔹 Funkcja zatrzymująca teleportowanie
local function stopTeleporting()
    if teleporting then
        teleporting = false
        print("⏹️ Teleportowanie zatrzymane.")
    end
end

-- 🔹 Obsługa klawiszy
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.K then
        savePositionAndRotation() -- Zapisuje pozycję i kamerę
    elseif input.KeyCode == Enum.KeyCode.U then
        startTeleporting() -- Zaczyna teleportowanie
    elseif input.KeyCode == Enum.KeyCode.J then
        stopTeleporting() -- Zatrzymuje teleportowanie
    end
end)
