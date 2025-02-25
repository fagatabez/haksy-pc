local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Funkcja do usuwania poprzedniego GUI
local function cleanUp()
    local existingGui = player:WaitForChild("PlayerGui"):FindFirstChild("GameTimerGui")
    if existingGui then
        existingGui:Destroy()
    end
end

-- Funkcja do tworzenia GUI dla GameTimer
local function createGameTimerGui()
    cleanUp()

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GameTimerGui"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(0.5, -100, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 1
    frame.Active = true
    frame.Draggable = true

    local timerLabel = Instance.new("TextLabel", frame)
    timerLabel.Size = UDim2.new(1, 0, 1, 0)
    timerLabel.TextSize = 24
    timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = "Czas: --"

    return timerLabel
end

-- Funkcja do monitorowania czasu
local function monitorGameTimer()
    local timerLabel = createGameTimerGui()

    local gameTimer = ReplicatedStorage:FindFirstChild("GameTimer")
    if not gameTimer or not gameTimer:IsA("IntValue") then
        warn("GameTimer nie został znaleziony lub nie jest typu IntValue.")
        timerLabel.Text = "Czas: --"
        return
    end

    while true do
        timerLabel.Text = "Czas: " .. math.max(0, gameTimer.Value) .. " s"
        task.wait(1)
    end
end

-- Funkcja do monitorowania obecności Rake
local function monitorRake()
    while true do
        local rake = Workspace:FindFirstChild("Rake")
        if rake then
            print("Rake jest obecny.")
        else
            print("Rake został usunięty. Oczekiwanie na jego powrót...")
            repeat
                task.wait(1)
            until Workspace:FindFirstChild("Rake")
            print("Rake pojawił się ponownie.")
        end
        task.wait(0.1)
    end
end

-- Obsługa respawnu gracza
player.CharacterAdded:Connect(function()
    cleanUp()
    task.spawn(monitorGameTimer)
    task.spawn(monitorRake)
end)

-- Uruchamiamy monitorowanie
task.spawn(monitorGameTimer)
task.spawn(monitorRake)
