local UserInputService = game:GetService("UserInputService")

print("✅ Skrypt został pomyślnie załadowany i jest gotowy do użycia!")

local filesSet1 = { -- 8 skryptów
    "czasomierz.lua", "esp.lua", "ilość staminy.lua", "odległość.lua", 
    "rake heal.lua", "therake.lua", "tower of hell.lua", "wytrzymaj.lua"
}

local filesSet2 = { -- 7 skryptów
    "wstrząs.lua", "auto clicker.lua", "fogrem.lua", "fast kill.lua", 
    "na afka telepoti.lua", "zmienrozb.lua", "zmienrozl.lua"
}

local filesSet3 = {
    "aiiii.lua"
}

local decScript = "dec.lua" -- Plik do załadowania przy M + N

local alwaysReloadFiles = { -- Pliki, które mają być zawsze ładowane przy "N"
    ["zmienrozb.lua"] = true,
    ["zmienrozl.lua"] = true
}

local loadedFiles = {} -- Przechowuje informacje o załadowanych plikach
local pressedKeys = {} -- Przechowuje aktualnie wciśnięte klawisze

-- Funkcja do pobierania i ładowania skryptów
local function loadScripts(files, setName)
    for _, file in ipairs(files) do
        if loadedFiles[file] and not alwaysReloadFiles[file] then
            print("⏩ Plik " .. file .. " został już załadowany, pomijam.")
        else
            local url = "https://raw.githubusercontent.com/fagatabez/haksy/main/" .. file
            print("⏳ Pobieranie pliku: " .. file .. " z URL: " .. url)

            local success, response = pcall(function()
                return game:HttpGet(url)
            end)

            if success and response and response ~= "" then
                local executeSuccess, err = pcall(function()
                    loadstring(response)()
                end)

                if executeSuccess then
                    print("✅ " .. file .. " załadowany pomyślnie!")
                    loadedFiles[file] = true
                else
                    warn("❌ Błąd wykonania pliku: " .. file .. " | " .. tostring(err))
                end
            else
                warn("⚠️ Błąd pobierania pliku: " .. file)
            end
        end

        task.wait(0.5) -- Opóźnienie
    end
    print("🚀 Zestaw '" .. setName .. "' został pomyślnie załadowany i jest gotowy do użycia!")
end

-- Funkcja do ładowania pojedynczego pliku
local function loadSingleScript(file)
    local url = "https://raw.githubusercontent.com/fagatabez/haksy/main/" .. file
    print("⏳ Pobieranie pliku: " .. file .. " z URL: " .. url)

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success and response and response ~= "" then
        local executeSuccess, err = pcall(function()
            loadstring(response)()
        end)

        if executeSuccess then
            print("✅ " .. file .. " załadowany pomyślnie!")
            loadedFiles[file] = true
        else
            warn("❌ Błąd wykonania pliku: " .. file .. " | " .. tostring(err))
        end
    else
        warn("⚠️ Błąd pobierania pliku: " .. file)
    end
end

-- Wykrywanie naciśnięcia klawisza
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    pressedKeys[input.KeyCode] = true

    if pressedKeys[Enum.KeyCode.M] and pressedKeys[Enum.KeyCode.N] then
        print("🟠 Wykryto jednoczesne naciśnięcie M + N! Ładuję dec.lua")
        loadSingleScript(decScript)
    elseif input.KeyCode == Enum.KeyCode.M then
        print("🔵 Wczytuję zestaw 1 (8 skryptów)")
        loadScripts(filesSet1, "Zestaw 1")
    elseif input.KeyCode == Enum.KeyCode.N then
        print("🟢 Wczytuję zestaw 2 (7 skryptów) z ponownym ładowaniem zmienrozb.lua i zmienrozl.lua")
        loadedFiles["zmienrozb.lua"] = nil -- Resetuje status, aby wymusić ponowne ładowanie
        loadedFiles["zmienrozl.lua"] = nil
        loadScripts(filesSet2, "Zestaw 2")
    elseif input.KeyCode == Enum.KeyCode.B then
        loadScripts(filesSet3, "Zestaw 3")
    end
end)

-- Wykrywanie puszczenia klawisza
UserInputService.InputEnded:Connect(function(input)
    pressedKeys[input.KeyCode] = nil
end)
