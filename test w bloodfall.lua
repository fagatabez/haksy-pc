local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Funkcja do usunięcia starego GUI
local function cleanUpGui()
    local existingGui = player:WaitForChild("PlayerGui"):FindFirstChild("BloodFallMonitorGui")
    if existingGui then
        existingGui:Destroy()
    end
end

-- Tworzenie GUI
local function createGui()
    cleanUpGui() -- Usunięcie starego GUI

    local monitorGui = Instance.new("ScreenGui")
    monitorGui.Name = "BloodFallMonitorGui"
    monitorGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0, 50)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.Active = true -- Możliwość przesuwania
    frame.Draggable = true -- GUI można przesuwać
    frame.Parent = monitorGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.TextSize = 20
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Text = "Monitorowanie..."
    label.Parent = frame

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0.5, 0)
    statusLabel.Position = UDim2.new(0, 0, 0.5, 0)
    statusLabel.TextSize = 18
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "BloodFall Enabled: --"
    statusLabel.Parent = frame

    return label, statusLabel
end

-- Funkcja do monitorowania wartości "BloodFallEvent.Enabled"
local function monitorBloodFallEnabled(statusLabel)
    while true do
        -- Sprawdzenie, czy istnieje obiekt "BloodFallEvent" w workspace
        local bloodFallEvent = workspace:FindFirstChild("BloodFallEvent")
        if bloodFallEvent then
            local enabledValue = bloodFallEvent:FindFirstChild("Enabled")
            if enabledValue then
                statusLabel.Text = "BloodFall Enabled: " .. tostring(enabledValue.Value)
            else
                statusLabel.Text = "BloodFall Enabled: --"
            end
        else
            statusLabel.Text = "BloodFall Enabled: --"
        end
        wait(1) -- Sprawdzanie co sekundę
    end
end

-- Funkcja do rozpoczęcia monitorowania
local function startMonitoring()
    local label, statusLabel = createGui() -- Tworzymy GUI
    monitorBloodFallEnabled(statusLabel) -- Rozpoczynamy monitorowanie
end

-- Uruchomienie monitorowania
startMonitoring()
