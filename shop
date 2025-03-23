local dealer = game.Workspace:FindFirstChild("Dealer")

if dealer and dealer:IsA("Model") then
    local dealerRoot = dealer:FindFirstChild("HumanoidRootPart") or dealer.PrimaryPart

    if dealerRoot then
        dealerRoot.CFrame = CFrame.new(Vector3.new(-11, 15, 152))
        print("✅ Dealer został przeniesiony na (-11, 15, 152)!")
    else
        warn("❌ Dealer nie ma HumanoidRootPart ani PrimaryPart!")
    end
else
    warn("❌ Nie znaleziono Dealera w Workspace!")
end
