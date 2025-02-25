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
    "test w bloodfall.lua",
    "therake.lua",
    "tower of hell.lua",
    "wstrząs.lua"
}

for _, file in ipairs(files) do
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
        else
            warn("❌ Błąd wykonania pliku: " .. file .. " | " .. tostring(err))
        end
    else
        warn("⚠️ Błąd pobierania pliku: " .. file .. " | Możliwe, że nie istnieje lub URL jest niepoprawny.")
    end

    task.wait(0.5) -- Opóźnienie, aby uniknąć blokady GitHub
end
