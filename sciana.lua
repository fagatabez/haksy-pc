local part = Instance.new("Part")
part.Size = Vector3.new(40, 40, 5)
part.CFrame = CFrame.new(-5, 13.6055689, 135.815948, -4.37113883e-08, 0, 1, 0, 1, 0, -1, 0, -4.37113883e-08)
part.Anchored = true
part.Parent = game.Workspace

local userInputService = game:GetService("UserInputService")

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Ignoruje, jeśli wpisano w czacie lub GUI
    
    if input.KeyCode == Enum.KeyCode.Y then
        part.CanCollide = false
        print("Kolizja wyłączona")
    elseif input.KeyCode == Enum.KeyCode.H then
        part.CanCollide = true
        print("Kolizja włączona")
    end
end)
