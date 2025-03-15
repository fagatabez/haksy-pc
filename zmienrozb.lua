local player = game.Players.LocalPlayer
local backpack = player.Backpack

-- Funkcja do zmiany rozmiaru części
local function setSize(part, newSize)
    if part and part:IsA("BasePart") then
        part.Size = newSize
    else
        warn("Nie znaleziono części lub nie jest BasePart: " .. tostring(part))
    end
end

-- 🔹 Zmiana rozmiaru dla przedmiotów w plecaku (Backpack) - Broń (bez laserów)
if backpack then
    local voltblade = backpack:FindFirstChild("VOLTBLADE")
    if voltblade then
        setSize(voltblade:FindFirstChild("HitBox"), Vector3.new(voltblade.HitBox.Size.X, voltblade.HitBox.Size.Y, 30)) -- zmieniono na 30
    end

    local terrorBlade = backpack:FindFirstChild("TerrorBlade")
    if terrorBlade then
        setSize(terrorBlade:FindFirstChild("Sword"), Vector3.new(terrorBlade.Sword.Size.X, 30, terrorBlade.Sword.Size.Z))
    end

    local ultraChain = backpack:FindFirstChild("UltraChain")
    if ultraChain then
        setSize(ultraChain:FindFirstChild("HitBox"), Vector3.new(ultraChain.HitBox.Size.X, 30, ultraChain.HitBox.Size.Z))
    end

    local venomScythe = backpack:FindFirstChild("VenomScythe")
    if venomScythe then
        local handle = venomScythe:FindFirstChild("Handle")
        if handle then
            setSize(handle, Vector3.new(10, 35, 5))
        end
    end
end
