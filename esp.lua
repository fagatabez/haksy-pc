local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Funkcja do aktualizowania referencji na `HumanoidRootPart`
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Funkcja do tworzenia GUI
local function setupScreenGui()
    -- Usunięcie istniejącego GUI, jeśli istnieje
    local existingGui = player:WaitForChild("PlayerGui"):FindFirstChild("DistanceScreenGui")
    if existingGui then
        existingGui:Destroy()
    end

    -- Tworzenie nowego GUI
    local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    screenGui.Name = "DistanceScreenGui"

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 250, 0, 50)
    frame.Position = UDim2.new(0.5, -125, 0, 20)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 1
    frame.Active = true
    frame.Draggable = true

    local distanceLabel = Instance.new("TextLabel", frame)
    distanceLabel.Size = UDim2.new(1, 0, 1, 0)
    distanceLabel.TextSize = 24
    distanceLabel.TextColor3 = Color3.new(1, 1, 1)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "Odległość: -- studów"

    return distanceLabel
end

-- Funkcja do tworzenia linii
local function createLine()
    local line = Instance.new("Part")
    line.Anchored = true
    line.CanCollide = false
    line.Material = Enum.Material.Neon
    line.BrickColor = BrickColor.new("Bright yellow")
    line.Transparency = 0.3
    line.Size = Vector3.new(0.5, 0.5, 0)
    line.Parent = workspace
    return line
end

-- Funkcja do aktualizacji linii
local function updateLine(line, rakePosition, distanceLabel)
    if not humanoidRootPart or not humanoidRootPart.Parent then return end

    local playerPosition = humanoidRootPart.Position
    local direction = rakePosition - playerPosition
    local distance = direction.Magnitude

    line.Size = Vector3.new(0.5, 0.5, distance)
    line.CFrame = CFrame.new(playerPosition + direction / 2, rakePosition)

    distanceLabel.Text = "Odległość: " .. math.floor(distance) .. " studów"
end

-- Funkcja do tworzenia obramowania wokół "Rake"
local function createHighlight(rake)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = rake
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = rake
end

-- Funkcja do oczekiwania na ponowne pojawienie się `Rake`
local function waitForRake()
    print("Rake zniknął. Oczekiwanie na jego powrót...")
    repeat
        task.wait(1)
    until workspace:FindFirstChild("Rake") and workspace.Rake:FindFirstChild("HumanoidRootPart")
    print("Rake pojawił się ponownie.")
end

-- Główna funkcja kontrolująca linię i GUI
local function trackRake()
    local line = createLine()
    local distanceLabel = setupScreenGui()

    while true do
        local rake = workspace:FindFirstChild("Rake")

        if rake and rake:FindFirstChild("HumanoidRootPart") then
            if not rake:FindFirstChildOfClass("Highlight") then
                createHighlight(rake)
            end

            -- Dynamicznie aktualizuj linię do bieżącej pozycji Rake
            local rakePosition = rake.HumanoidRootPart.Position
            updateLine(line, rakePosition, distanceLabel)
        else
            -- Ukryj linię i dystans, a następnie poczekaj na odrodzenie Rake
            line.Size = Vector3.new(0, 0, 0)
            distanceLabel.Text = "Odległość: -- studów"

            waitForRake() -- Czekaj na powrót Rake
        end

        task.wait(0.1)
    end
end

-- Obsługa respawnu gracza
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    task.spawn(trackRake) -- Uruchom śledzenie Rake na nowo
end)

-- Uruchomienie początkowego śledzenia
task.spawn(trackRake)
