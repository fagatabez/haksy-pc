local RunService = game:GetService("RunService")
local Gui = game.CoreGui:FindFirstChild("ScreenGui")

if Gui then
    Gui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local UICORNER1 = Instance.new("UICorner")
local UICORNER11 = Instance.new("UICorner")
local Frame = Instance.new("Frame")
local Mode = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

Frame.Name = "Frame"
Frame.Draggable = true
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
Frame.Position = UDim2.new(0.276, 0, 0.037, 0)
Frame.Size = UDim2.new(0, 283, 0, 106)
Frame.Visible = true
UICORNER1.Parent = Frame

local UIS = game:GetService("UserInputService")
local frame = Frame
local dragToggle = false
local dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    game:GetService("TweenService"):Create(frame, TweenInfo.new(0.25), {Position = position}):Play()
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragToggle = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateInput(input)
    end
end)

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

local function checkGameMode()
    if not workspace:FindFirstChild("Rake") then
        Mode.Text = "MODE: None"
        return
    end

    local foundHour = false
    local hourScriptName = nil

    for _, v in ipairs(workspace.Rake:GetChildren()) do
        if v:IsA("Script") and not v.Disabled then
            if v.Name:match("Hour") or v.Name:match("Mode") or v.Name:match("Night") then
                foundHour = true
                hourScriptName = v.Name
                break
            end
        end
    end

    if foundHour and hourScriptName then
        hourScriptName = hourScriptName:gsub("HourMain", " Hour")
        hourScriptName = hourScriptName:gsub("ModeMain", " Mode")
        hourScriptName = hourScriptName:gsub("NightMain", " Night")
        hourScriptName = hourScriptName:gsub("Main", " Hour")
        Mode.Text = "MODE: " .. hourScriptName
    else
        Mode.Text = "MODE: None"
    end
end

RunService.Heartbeat:Connect(checkGameMode) -- Sprawdza tryb gry w każdej klatce, zamiast pętli
