local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Czeka na StaminaScript
repeat wait() until player:FindFirstChild("PlayerScripts"):FindFirstChild("StaminaScript")

local staminaScript = player.PlayerScripts.StaminaScript
local stamina = staminaScript:FindFirstChild("Stamina")
local maxStamina = staminaScript:FindFirstChild("MaxStamina") -- Pobieramy MaxStamina

-- Ustawiamy wartość MaxStamina na pożądaną wartość
maxStamina.Value = 100 -- Zmieniamy tę wartość na dowolną liczbę, np. 100

-- Usuwa stare GUI (jeśli istnieje)
local function removeOldGui()
    local oldGui = playerGui:FindFirstChild("StaminaDisplay")
    if oldGui then
        oldGui:Destroy()
    end
end

-- Tworzy GUI
local function createGui()
    removeOldGui() -- Usuwa stare GUI

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StaminaDisplay"
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(0.5, -100, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 2
    frame.Draggable = true -- Można przesuwać
    frame.Active = true
    frame.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.Parent = frame

    -- Aktualizacja GUI
    local function updateGui()
        if stamina and maxStamina then
            label.Text = stamina.Value .. "/" .. maxStamina.Value -- Pokazuje aktualną i maksymalną wartość staminy
        else
            label.Text = "Brak danych"
        end
    end

    updateGui()
    -- Aktualizuje GUI, gdy wartość staminy lub MaxStamina zmieni się
    stamina:GetPropertyChangedSignal("Value"):Connect(updateGui)
    maxStamina:GetPropertyChangedSignal("Value"):Connect(updateGui)
end

-- Odtwarza GUI po śmierci
player.CharacterAdded:Connect(function()
    wait(1) -- Czekamy chwilę na załadowanie postaci
    createGui()
end)

createGui() -- Tworzy GUI na start
