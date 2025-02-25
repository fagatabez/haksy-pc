-- Funkcja do tworzenia wyświetlania zdrowia nad potworem
local function createHealthDisplay(monster)
    -- Znajdź obiekt Humanoid, który nazywa się "NPC"
    local humanoid = monster:WaitForChild("NPC") -- Znajdujemy Humanoid o nazwie NPC

    -- Utwórz BillboardGui do wyświetlania zdrowia
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Parent = monster
    billboardGui.Adornee = monster.Head -- Wyświetlanie zdrowia nad głową potwora
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0) -- Wysokość wyświetlania nad głową
    billboardGui.AlwaysOnTop = true
    
    -- Utwórz TextLabel do wyświetlania wartości zdrowia
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Parent = billboardGui
    healthLabel.Size = UDim2.new(1, 0, 1, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Kolor tekstu (czerwony)
    healthLabel.TextSize = 24
    healthLabel.TextStrokeTransparency = 0.8
    healthLabel.Text = "Health: " .. math.floor(humanoid.Health) -- Początkowa wartość zdrowia
    
    -- Funkcja aktualizująca zdrowie
    humanoid.HealthChanged:Connect(function()
        healthLabel.Text = "Health: " .. math.floor(humanoid.Health) -- Aktualizowanie tekstu z nowym zdrowiem
    end)
end

-- Funkcja do obsługi pojawiania się potwora "Rake"
local function monitorRake()
    -- Nasłuchuj, czy potwór Rake pojawił się w Workspace
    game.Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Rake" then
            -- Po pojawieniu się potwora, uruchom funkcję do wyświetlania zdrowia
            createHealthDisplay(child)
            
            -- Nasłuchuj, czy potwór został zniszczony (umiera)
            child:WaitForChild("NPC").Died:Connect(function()
                -- Po śmierci usuwamy BillboardGui
                if child:FindFirstChild("BillboardGui") then
                    child:FindFirstChild("BillboardGui"):Destroy()
                end
            end)
        end
    end)
end

-- Rozpocznij monitorowanie Rake
monitorRake()
