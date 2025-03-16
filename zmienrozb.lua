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
    -- Zmieniamy rozmiar dla VOLTBLADE
    local voltblade = backpack:FindFirstChild("VOLTBLADE")
    if voltblade then
        local hitbox = voltblade:FindFirstChild("HitBox")
        if hitbox then
            setSize(hitbox, Vector3.new(hitbox.Size.X, hitbox.Size.Y, 30)) -- Zmieniamy rozmiar HitBoxa na Z=30
        end
    end

    -- Zmieniamy rozmiar dla TERRORBLADE
    local terrorBlade = backpack:FindFirstChild("TerrorBlade")
    if terrorBlade then
        local sword = terrorBlade:FindFirstChild("Sword")
        if sword then
            setSize(sword, Vector3.new(sword.Size.X, 30, sword.Size.Z)) -- Zmieniamy rozmiar dla Sworda na Y=30
        end
    end

    -- Zmieniamy rozmiar dla ULTRACHAIN
    local ultraChain = backpack:FindFirstChild("UltraChain")
    if ultraChain then
        local hitbox = ultraChain:FindFirstChild("HitBox")
        if hitbox then
            setSize(hitbox, Vector3.new(10, 30, hitbox.Size.Z)) -- Zmieniamy rozmiar HitBoxa
        end
    end

    -- Zmieniamy rozmiar dla VENOMSCYTHE
    local venomScythe = backpack:FindFirstChild("VenomScythe")
    if venomScythe then
        local handle = venomScythe:FindFirstChild("Handle")
        if handle then
            setSize(handle, Vector3.new(10, 35, 5)) -- Zmieniamy rozmiar dla Handle
        end
    end
    
    -- Zmieniamy rozmiar dla SUPER-CHARGED EXECUTIONER
    local superChargedExecutioner = backpack:FindFirstChild("Super-charged Executioner")
    if superChargedExecutioner then
        local ShockPart = superChargedExecutioner:FindFirstChild("ShockPart")
        if ShockPart then
            setSize(ShockPart, Vector3.new(60, 15, 5)) -- Zmieniamy rozmiar dla Handle na XYZ=60, 15, 4.13
        end
    end
end
