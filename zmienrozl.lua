local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait() -- Pobieramy postać gracza

-- Funkcja do zmiany rozmiaru części
local function setSize(part, newSize)
    if part and part:IsA("BasePart") then
        part.Size = newSize
    else
        warn("Nie znaleziono części lub nie jest BasePart: " .. tostring(part))
    end
end

-- 🔹 Zmiana rozmiaru dla laserów w postaci gracza (akcesoria)
if character then
    for _, accessory in pairs(character:GetChildren()) do
        if accessory:IsA("Accessory") and (accessory.Name == "Laser" or accessory.Name == "Laser2") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                -- Zmiana rozmiaru EyeLaser1 i EyeLaser2
                if handle:FindFirstChild("EyeLaser1") then
                    setSize(handle.EyeLaser1, Vector3.new(handle.EyeLaser1.Size.X, 60, handle.EyeLaser1.Size.Z))
                end
                if handle:FindFirstChild("EyeLaser2") then
                    setSize(handle.EyeLaser2, Vector3.new(handle.EyeLaser2.Size.X, 60, handle.EyeLaser2.Size.Z))
                end
            end
        end
    end
end
