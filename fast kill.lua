local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Czekamy, aż postać zostanie w pełni załadowana
repeat wait() until character and character:FindFirstChild("Humanoid")

-- Funkcja do zakładania narzędzi
local function equipTool(toolName)
    local backpack = player:FindFirstChild("Backpack")
    local tool = backpack and backpack:FindFirstChild(toolName)

    if tool then
        tool.Parent = character -- Przenosi narzędzie do postaci, zakładając je
    end
end

-- Funkcja do zdejmowania wszystkich narzędzi
local function unequipAllTools()
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = player.Backpack -- Przenosi narzędzia do plecaka
        end
    end
end

-- Funkcja do aktywowania narzędzi
local function activateTool(toolName)
    local tool = character:FindFirstChild(toolName)
    if tool then
        tool:Activate() -- Aktywuje narzędzie
    end
end

-- Obsługa klawisza "E" do zakładania wszystkich narzędzi (bez aktywacji)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        -- Zakładamy wszystkie narzędzia, ale nie aktywujemy ich od razu
        equipTool("LightningStaff")
        equipTool("LightningStrikeTool")
        equipTool("VOLTBLADE")
        equipTool("UltraChain")
        equipTool("WinterCore")
        equipTool("TerrorBlade")
        equipTool("LaserVision")
        equipTool("OverheatedLaserVision")
        equipTool("Boom")
        equipTool("ReaperScythe")
        equipTool("ShadowBlade")
        equipTool("VenomScythe")
        equipTool("PrototypeStunStick")
        equipTool("StunStick")
        equipTool("SpectreOD")
        equipTool("Meteor")
        equipTool("Gasterblaster")
        equipTool("Hyperblizzard")
        equipTool("Super-charged Executioner")
        equipTool("Chaos Core")
    end
end)

-- Obsługa klawisza "R" do zdejmowania wszystkich narzędzi i zakładania tylko LaserVision i OverheatedLaserVision
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        unequipAllTools() -- Najpierw zdejmujemy wszystkie narzędzia
        wait(0.1) -- Krótka pauza, aby upewnić się, że narzędzia się odpięły
        equipTool("LaserVision")
        equipTool("OverheatedLaserVision")
    end
end)

-- Obsługa lewego przycisku myszy (LMB) do aktywacji narzędzi, gdy są założone
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Aktywuj wszystkie narzędzia założone przez "E"
        activateTool("LightningStaff")
        activateTool("LightningStrikeTool")
        activateTool("VOLTBLADE")
        activateTool("UltraChain")
        activateTool("WinterCore")
        activateTool("TerrorBlade")
        activateTool("LaserVision")
        activateTool("OverheatedLaserVision")
        activateTool("Boom")
        activateTool("ReaperScythe")
        activateTool("ShadowBlade")
        activateTool("VenomScythe")
        activateTool("PrototypeStunStick")
        activateTool("StunStick")
        activateTool("SpectreOD")
        activateTool("Meteor")
        activateTool("Gasterblaster")
        activateTool("Hyperblizzard")
        activateTool("Super-charged Executioner")
        activateTool("Chaos Core")
    end
end)
