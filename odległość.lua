local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Funkcja do usunięcia starego GUI
local function cleanUpGui()
    local existingGui = player:WaitForChild("PlayerGui"):FindFirstChild("CatchTimeGui")
    if existingGui then
        existingGui:Destroy()
    end
end

-- Tworzenie GUI
local function createGui()
    cleanUpGui() -- Usunięcie starego GUI

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CatchTimeGui"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 50)
    frame.Position = UDim2.new(0.5, -125, 0, 20)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.Active = true -- Możliwość przesuwania
    frame.Draggable = true -- GUI można przesuwać
    frame.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextSize = 20
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Text = "Obliczanie..."
    label.Parent = frame

    return label
end

-- Funkcja do znalezienia potwora (Rake)
local function getRake()
    local rake = workspace:FindFirstChild("Rake")
    if rake and rake:FindFirstChild("NPC") then
        if not rake.PrimaryPart then
            rake.PrimaryPart = rake:FindFirstChild("HumanoidRootPart") or rake:FindFirstChild("Head")
        end
        return rake
    end
    return nil
end

-- Funkcja obliczająca czas do złapania
local function calculateCatchTime(label)
    while true do
        local rake = getRake()
        
        -- Sprawdzamy, czy Rake jest martwy
        if not rake or (rake:FindFirstChild("Humanoid") and rake.Humanoid.Health <= 0) then
            label.Text = "Potwór dogoni za: 0 sek." -- Zamiast pustego komunikatu, wyświetlamy tekst "0 sek."
        else
            if rake and rake:FindFirstChild("NPC") then
                local rakeHumanoid = rake:FindFirstChild("NPC")
                local rakeSpeed = rakeHumanoid.WalkSpeed
                local playerSpeed = humanoid.WalkSpeed
                local playerPos = character.PrimaryPart.Position
                local rakePos = rake.PrimaryPart.Position
                local distance = (playerPos - rakePos).Magnitude
                local speedDiff = rakeSpeed - playerSpeed

                -- Jeśli potwór jest szybszy, obliczamy czas do złapania
                if speedDiff > 0 then
                    local timeToCatch = math.ceil(distance / rakeSpeed) -- Czas z uwzględnieniem prędkości potwora
                    label.Text = "Potwór dogoni za: " .. timeToCatch .. " sek."
                elseif speedDiff < 0 then
                    -- Jeśli gracz jest szybszy, dodajemy czas do złapania
                    local timeToCatch = math.ceil(distance / playerSpeed) -- Czas z uwzględnieniem prędkości gracza
                    label.Text = "Potwór dogoni za: " .. timeToCatch .. " sek."
                else
                    -- Jeśli prędkości są równe, obliczamy czas na podstawie dystansu
                    local timeToCatch = math.ceil(distance / playerSpeed) -- Czas w przypadku równych prędkości
                    label.Text = "Potwór dogoni za: " .. timeToCatch .. " sek."
                end
            else
                label.Text = "Potwór dogoni za: 0 sek." -- Jeśli brak Rake, wyświetlamy "0 sek."
            end
        end
        task.wait(0.05) -- Szybka aktualizacja co 0.05 sekundy (20 razy na sekundę)
    end
end

-- Obsługa odrodzenia gracza
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    task.wait(1) -- Czekamy chwilę po respawnie
    local label = createGui() -- Tworzymy GUI
    task.spawn(calculateCatchTime, label) -- Uruchamiamy obliczenia
end

-- Startujemy skrypt
player.CharacterAdded:Connect(onCharacterAdded)
onCharacterAdded(character) -- Uruchamiamy od razu dla obecnej postaci
