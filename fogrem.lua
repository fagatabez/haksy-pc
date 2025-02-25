local workspace = game:GetService("Workspace")

-- Znajduje i usuwa CaveFog
local function removeCaveFog()
    local caveFog = workspace:FindFirstChild("CaveFog")
    if caveFog then
        caveFog:Destroy()
        print("CaveFog został usunięty.")
    else
        print("CaveFog nie został znaleziony.")
    end
end

removeCaveFog()
