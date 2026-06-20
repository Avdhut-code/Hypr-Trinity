-- Since webappsbinds.conf contains supplementary binds, we append them to the existing bind table 
-- or define them as a new table block to match your configuration layout.

local webapp_binds = {
    "SUPER SHIFT, Y, exec, customlinkopenr \"https://www.youtube.com/\" \"" .. os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/icon/youtube.png\"",

    "SUPER SHIFT, A, exec, customlinkopenr \"https://www.chatgpt.com/\" \"" .. os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/icon/chatgpt.png\"",

    "SUPER SHIFT, G, exec, customlinkopenr \"https://gemini.google.com/\" \"" .. os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/icon/google-gemini.png\"", 

    -- "SUPER SHIFT, C, exec, " .. os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/bin/custom-open-link.sh \"https://calendar.google.com/calendar/\" \"" .. os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/icon/google-calendar.png\"",

    "SUPER SHIFT, C, exec, customlinkopenr \"https://claude.ai/\" \"" .. os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/icon/claude.png\"",

    "SUPER SHIFT, T, exec, customlinkopenr \"https://tasks.google.com/\" \"" .. os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/icon/google-tasks.png\"",

    "SUPER SHIFT, L, exec, customlinkopenr \"https://notebooklm.google.com/\" \"" .. os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/icon/google-notebooklm.png\"",

    "SUPER SHIFT, H, exec, customlinkopenr \"https://web.whatsapp.com/\" \"" .. os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/icon/whatsapp.png\"",

    "SUPER SHIFT, U, exec, customlinkopenr \"https://github.com/Avdhut-code/\" \"" .. os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/icon/github-light.png\"",

    "SUPER SHIFT, P, exec, customlinkopenr \"https://www.perplexity.ai/\" \"" .. os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/icon/perplexity.png\"",
}

-- Merge into the primary bind configuration
for _, keybind in ipairs(webapp_binds) do
    table.insert(bind, keybind)
end