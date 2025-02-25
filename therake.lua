local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local function createGui()
    -- 🔹 Usuwa **wszystkie stare GUI**, jeśli istnieją
    for _, gui in pairs(game.CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "TherakeGUI" then
            gui:Destroy()
        end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TherakeGUI" -- Teraz ma unikalną nazwę, aby łatwiej go usuwać
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local Frame = Instance.new("Frame")
    local Mode = Instance.new("TextButton")
    local UICORNER1 = Instance.new("UICorner")
    local UICORNER11 = Instance.new("UICorner")

    Frame.Name = "Frame"
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    Frame.Position = UDim2.new(0.276, 0, 0.037, 0)
    Frame.Size = UDim2.new(0, 283, 0, 106)
    Frame.Visible = true
    Frame.Active = true
    Frame.Draggable = false -- Wyłączone, ale dodamy własne przeciąganie
    UICORNER1.Parent = Frame

    Mode.Name = "Mode"
    Mode.Parent = Frame
    Mode.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    Mode.Position = UDim2.new(0, 25, 0, 15)
    Mode.Size = UDim2.new(0, 233, 0, 76)
    Mode.Font = Enum.Font.SourceSans
    Mode.Text = "MODE: None"
    Mode.TextColor3 = Color3.fromRGB(0, 0, 0)
    Mode.TextScaled = true
    UICORNER11.Parent = Mode

    -- 🔹 Przeciąganie GUI (teraz działa poprawnie)
    local dragging, dragStart, startPos

    local function updateInput(input)
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                updateInput(input)
            end
        end
    end)

    return Mode
end

-- 🔹 Tryby gry
local modeNames = {
    "BlueMoon", "BloodHour", "BlackoutHour", "BloodNight", "BruhHour", "CHAOS_RESTRICTED_MODE",
    "CalamityPhase2", "CalamityPhase3", "CalamityStart", "CorruptedHourPhase2", "DeepwaterPerdition",
    "FinalHour", "FrozenDeath", "GlitchHour", "GlitchHourPhase2", "IceAge", "NightmareHour",
    "PureInsanity", "ShadowHour", "ShadowHourPhase2", "VisionHour", "VoidHour", "Thalassophobia",
    "TripleSix", "CorruptedHour", "BozosHour", "InfernoHour", "LowtiergodHour", "MeltdownHour",
    "Insomnia", "SkyfallHour", "Thalassophobia", "oldBN", "RealityIndignation", "CarnageHour"
}

local function checkGameMode(Mode)
    if not workspace:FindFirstChild("Rake") then
        Mode.Text = "MODE: None"
        return
    end

    local foundMode = false
    local detectedMode = nil

    for _, v in ipairs(workspace.Rake:GetChildren()) do
        if v:IsA("Script") and not v.Disabled then
            for _, mode in ipairs(modeNames) do
                if string.match(v.Name, mode) then
                    foundMode = true
                    detectedMode = v.Name
                    break
                end
            end
        end
        if foundMode then break end
    end

    if foundMode and detectedMode then
        detectedMode = detectedMode:gsub("HourMain", " Hour")
        detectedMode = detectedMode:gsub("ModeMain", " Mode")
        detectedMode = detectedMode:gsub("NightMain", " Night")
        detectedMode = detectedMode:gsub("Main", " Hour")
        Mode.Text = "MODE: " .. detectedMode
    else
        Mode.Text = "MODE: None"
    end
end

-- 🔹 Uruchomienie GUI (usuwa stare przed nowym)
local Mode = createGui()
RunService.Heartbeat:Connect(function()
    checkGameMode(Mode)
end)

-- 🔹 Obsługa respawnu gracza (usuwa GUI po śmierci i tworzy nowe)
player.CharacterAdded:Connect(function()
    task.wait(1) -- Opóźnienie, żeby GUI nie ładowało się przed postacią
    Mode = createGui() -- Tworzy nowe GUI
    RunService.Heartbeat:Connect(function()
        checkGameMode(Mode)
    end)
end)
