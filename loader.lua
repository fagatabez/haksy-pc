local files = {
    "auto clicker.lua",
    "czasomierz.lua",
    "dec.lua",
    "esp.lua",
    "fast kill.lua",
    "ilość staminy.lua",
    "na afka telepoti.lua",
    "odległość.lua",
    "rake heal.lua",
    "therake.lua",
    "tower of hell.lua",
    "wstrząs.lua"
}

local loadedFiles = {} -- Przechowuje informacje o załadowanych plikach

for _, file in ipairs(files) do
    local url = "https://raw.githubusercontent.com/fagatabez/haksy/main/" .. file
    if not loadedFiles[file] then  -- Sprawdza, czy plik już był pobrany
        print("⏳ Pobieranie pliku: " .. file)

        local success, response = pcall(function()
            return game:HttpGet(url)
        end)

        if success and response and response ~= "" then
            local executeSuccess, err = pcall(function()
                loadstring(response)()
            end)

            if executeSuccess then
                print("✅ " .. file .. " załadowany pomyślnie!")
                loadedFiles[file] = true  -- Zapisuje, że plik został pobrany
            else
                warn("❌ Błąd wykonania pliku: " .. file .. " | " .. tostring(err))
            end
        else
            warn("⚠️ Błąd pobierania pliku: " .. file)
        end
    else
        print("⏩ Plik " .. file .. " został już załadowany, pomijam.")
    end

    task.wait(0.5) -- Opóźnienie
end
