local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local autoClicking = false -- Stan auto-clickera

-- Lista broni w workspace.dfdsfdsk, które mają być aktywowane
local validWeapons = {
    "Glock-17",
    "Ruger SR1911",
    "UZI",
    "MAC-10",
    "MP5",
    "UMP-45"
}

-- 🔹 Funkcja do symulowania naciśnięcia lewego przycisku myszy dla wybranych broni
local function simulateMouseClickForWeapons()
    -- Sprawdzamy broni w workspace.dfdsfdsk
    local weaponsFolder = workspace:FindFirstChild("dfdsfdsk")
    if not weaponsFolder then return end -- Jeśli folder nie istnieje, kończymy

    for _, item in pairs(weaponsFolder:GetChildren()) do
        if item:IsA("Tool") then
            -- Sprawdzamy, czy narzędzie jest na liście do aktywacji
            if table.find(validWeapons, item.Name) then
                -- Symulujemy naciśnięcie lewego przycisku myszy
                VirtualInputManager:InputBegin(Enum.UserInputType.MouseButton1)
                wait(0.1) -- Krótkie opóźnienie
                VirtualInputManager:InputEnd(Enum.UserInputType.MouseButton1)
            end
        end
    end
end

-- 🔹 Funkcja do włączania auto-clickera (symulowanie kliknięć tylko dla broni na liście)
local function autoClick()
    while autoClicking do
        simulateMouseClickForWeapons() -- Symulowanie naciśnięcia myszy
        wait(0.1) -- Opóźnienie między kliknięciami, można dostosować
    end
end

-- 🔹 Obsługa klawiszy (włączanie/wyłączanie auto-clickera)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.X then
        if not autoClicking then
            autoClicking = true
            print("🖱️ Auto-clicker WŁĄCZONY!")
            autoClick() -- Uruchamia auto-clicker
        end
    elseif input.KeyCode == Enum.KeyCode.C then
        autoClicking = false
        print("⏹️ Auto-clicker WYŁĄCZONY!")
    end
end)
