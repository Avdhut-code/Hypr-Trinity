-- webappsbinds.lua
-- Rewritten for the new hl.* Lua config API.

local HOME = os.getenv("HOME")
local ICONS = HOME .. "/.local/share/LinuxMintHyprlandConfig/icon"

local function web_app_bind(key, url, icon)
    hl.bind("SUPER + SHIFT + " .. key,
        hl.dsp.exec_cmd('customlinkopenr "' .. url .. '" "' .. ICONS .. "/" .. icon .. '"'))
end

web_app_bind("Y", "https://www.youtube.com/",            "youtube.png")
web_app_bind("A", "https://www.chatgpt.com/",             "chatgpt.png")
web_app_bind("G", "https://gemini.google.com/",           "google-gemini.png")

-- web_app_bind("C", "https://calendar.google.com/calendar/", "google-calendar.png")
-- web_app_bind("H", "https://web.whatsapp.com/",             "whatsapp.png")

web_app_bind("C", "https://claude.ai/",                   "claude.png")
web_app_bind("T", "https://tasks.google.com/",             "google-tasks.png")
web_app_bind("L", "https://notebooklm.google.com/",        "google-notebooklm.png")
web_app_bind("U", "https://github.com/Avdhut-code/",       "github-light.png")
web_app_bind("P", "https://www.perplexity.ai/",            "perplexity.png")
