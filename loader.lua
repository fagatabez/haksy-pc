local files = {
    "czasomierz.lua",
    "esp.lua",
    "ilość staminy.lua",
    "odległość.lua",
    "rake heal.lua",
    "therake.lua",
    "tower of hell.lua",
    "wytrzymaj.lua",
    "wstrząs.lua",
    "auto clicker.lua",
    "fogrem.lua",
    "fast kill.lua",
    "na afka telepoti.lua",
    "zmienrozb.lua",
    "zmienrozl.lua"
}

local loadedFiles = {} -- Przechowuje informacje o załadowanych plikach

for _, file in ipairs(files) do
    if loadedFiles[file] then
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
                loadedFiles[file] = true  -- Zapisuje, że plik został pobrany
            else
                warn("❌ Błąd wykonania pliku: " .. file .. " | " .. tostring(err))
            end
        else
            warn("⚠️ Błąd pobierania pliku: " .. file)
        end
    end

    task.wait(0.5) -- Opóźnienie
end
