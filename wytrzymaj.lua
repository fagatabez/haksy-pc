local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Funkcja do usuwania starego GUI
local function cleanUpGui()
    local existingGui = player:WaitForChild("PlayerGui"):FindFirstChild("RakeHitsGui")
    if existingGui then
        existingGui:Destroy()
    end
end

-- Funkcja do tworzenia GUI
local function createScreenGui()
    cleanUpGui()

    local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    screenGui.Name = "RakeHitsGui"

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 100)  -- Zwiększenie rozmiaru, by pomieścić nowe informacje
    frame.Position = UDim2.new(0.5, -150, 0, 20)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 1
    frame.Active = true
    frame.Draggable = true

    local hitLabel = Instance.new("TextLabel", frame)
    hitLabel.Size = UDim2.new(1, 0, 0.33, 0)
    hitLabel.TextSize = 20
    hitLabel.TextColor3 = Color3.new(1, 1, 1)
    hitLabel.BackgroundTransparency = 1
    hitLabel.Text = "Obliczanie..."

    local modeLabel = Instance.new("TextLabel", frame)
    modeLabel.Size = UDim2.new(1, 0, 0.33, 0)
    modeLabel.Position = UDim2.new(0, 0, 0.33, 0)
    modeLabel.TextSize = 18
    modeLabel.TextColor3 = Color3.new(1, 1, 1)
    modeLabel.BackgroundTransparency = 1
    modeLabel.Text = "Tryb: --"

    local healthLabel = Instance.new("TextLabel", frame)
    healthLabel.Size = UDim2.new(1, 0, 0.33, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.66, 0)
    healthLabel.TextSize = 18
    healthLabel.TextColor3 = Color3.new(1, 1, 1)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "Zdrowie: --/--"

    hitLabel.Name = "HitLabel"
    modeLabel.Name = "ModeLabel"
    healthLabel.Name = "HealthLabel"

    return hitLabel, modeLabel, healthLabel
end

-- Funkcja do pobrania obrażeń Rake i aktywnego trybu
local function getRakeDamage()
    local rake = workspace:FindFirstChild("Rake")
    if not rake then
        return nil, "Brak Rake"
    end

    local config = rake:FindFirstChild("Configuration")
    if not config then
        return nil, "Brak konfiguracji"
    end

    local damageValue = config:FindFirstChild("Damage")
    if not damageValue then
        return nil, "Brak wartości obrażeń"
    end

    local modeName = "Normalny" -- Domyślny tryb
    for _, mode in pairs(rake:GetChildren()) do
        if mode:IsA("Folder") and mode:FindFirstChild("FogHandler") then
            modeName = mode.Name
            -- Opcjonalnie: Można dodać różne wartości obrażeń dla różnych trybów
            if modeName == "BloodHour" then
                damageValue = damageValue.Value * 1.5 -- Zwiększone obrażenia
            elseif modeName == "ShadowHour" then
                damageValue = damageValue.Value * 2 -- Bardzo silny Rake
            end
            break
        end
    end

    return damageValue.Value, modeName
end

-- Funkcja do aktualizacji GUI
local function updateGui(hitLabel, modeLabel, healthLabel)
    local lastHitsNeeded = -1
    local lastMode = ""
    local lastHealth = -1

    while true do
        local rakeDamage, mode = getRakeDamage()
        local playerHealth = humanoid.Health
        local maxHealth = humanoid.MaxHealth

        if rakeDamage then
            local hitsNeeded = math.ceil(playerHealth / rakeDamage)
            -- Aktualizujemy GUI tylko wtedy, gdy zmienią się dane
            if hitsNeeded ~= lastHitsNeeded or mode ~= lastMode then
                hitLabel.Text = "Rake musi Cię uderzyć: " .. hitsNeeded .. " razy"
                modeLabel.Text = "Tryb: " .. mode
                lastHitsNeeded = hitsNeeded
                lastMode = mode
            end
        else
            if lastHitsNeeded ~= -1 then
                hitLabel.Text = "Nie można odczytać obrażeń!"
                modeLabel.Text = "Tryb: Brak"
                lastHitsNeeded = -1
                lastMode = ""
            end
        end

        -- Aktualizowanie informacji o zdrowiu
        if playerHealth ~= lastHealth then
            healthLabel.Text = "Zdrowie: " .. playerHealth .. "/" .. maxHealth
            lastHealth = playerHealth
        end

        task.wait(0.5) -- Zmniejszono czas oczekiwania, aby GUI było bardziej responsywne
    end
end

-- Funkcja do monitorowania zdrowia gracza i Rake
local function monitorHits()
    local hitLabel, modeLabel, healthLabel = createScreenGui()
    task.spawn(updateGui, hitLabel, modeLabel, healthLabel)
end

-- Obsługa respawnu gracza
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    task.spawn(monitorHits)
end)

-- Uruchamiamy monitorowanie
task.spawn(monitorHits)
