local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local workspace = game:GetService("Workspace")

local autoWeaponSwitch = false -- Czy system zmiany broni jest aktywny?

local modes = {
	"BlackoutHour", "BloodNight", "CalamityStart", "CarnageHour", "CHAOS_RESTRICTED_MODE",
	"DeepwaterPerdition", "FinalHour", "FrozenDeath", "GlitchHour", "InfernoHour",
	"LowtiergodHour", "CorruptedHour", "oldBN", "PureInsanity", "ShadowHour", "VoidHour", "VisionHour",
    "ULTIMA", "SkyfallHour", "BloodBath"
}

local modeVals = {
	"BlackoutHourVal", "BloodNightVal", "CalamityHourVal", "CarnageHourVal", "ChaosHourVal",
	"DWPVal", "FinalHourVal", "FrozenDeathVal", "GlitchHourVal", "InfernoHourVal",
	"LowtierVal", "MikeHourVal", "OLDBNVal", "PureInsanityVal", "ShadowHourVal", "VoidHourVal", "VisionHourVal",
    "ULTIMAVal", "SkyfallHourVal", "BloodBathVal"
}

local laserWeapons = {"LaserVision", "OverheatedLaserVision"}
local allWeapons = {
	"LightningStaff", "LightningStrikeTool", "VOLTBLADE", "UltraChain", "WinterCore", "TerrorBlade",
	"LaserVision", "OverheatedLaserVision", "Boom", "ReaperScythe", "ShadowBlade", "VenomScythe",
	"PrototypeStunStick", "StunStick", "SpectreOD", "Meteor", "Gasterblaster", "Hyperblizzard",
	"Super-charged Executioner", "Chaos Core"
}

local function equipTools(toolList)
	local backpack = player:FindFirstChild("Backpack")
	if not backpack then return end
	for _, toolName in ipairs(toolList) do
		local tool = backpack:FindFirstChild(toolName)
		if tool then
			tool.Parent = character
		end
	end
end

local function unequipAllTools()
	for _, tool in ipairs(character:GetChildren()) do
		if tool:IsA("Tool") then
			tool.Parent = player.Backpack
		end
	end
end

local function detectRakeMode()
	while autoWeaponSwitch do
		local rake = workspace:FindFirstChild("Rake")
		if rake then
			for _, mode in ipairs(modes) do
				if rake:FindFirstChild(mode) and rake[mode].Enabled then
					print("🔵 Tryb wykryty: " .. mode)
					unequipAllTools()
					equipTools(laserWeapons)

					for _, modeVal in ipairs(modeVals) do
						if rake:FindFirstChild(modeVal) and rake[modeVal].Value == true then
							print("🔴 Tryb + Val wykryty: " .. modeVal)
							unequipAllTools()
							equipTools(allWeapons)
							break
						end
					end
					break
				end
			end
		end
		wait(0.4) -- Szybsza reakcja na zmiany
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F then
		if not autoWeaponSwitch then
			autoWeaponSwitch = true
			print("✅ Inteligentna zmiana broni WŁĄCZONA!")
			detectRakeMode()
		end
	elseif input.KeyCode == Enum.KeyCode.G then
		autoWeaponSwitch = false
		print("❌ Inteligentna zmiana broni WYŁĄCZONA!")
		unequipAllTools()
	end
end)
