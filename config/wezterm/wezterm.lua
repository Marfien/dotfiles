local wezterm = require("wezterm")
local default_distro = "Fedora"

local config = {
	font = wezterm.font("MesloLGL Nerd Font Mono"),
	color_scheme = "Tokyo Night",
}

-- windows specific config
if package.config:sub(1, 1) == "\\" then
	config.default_prog = { "C:\\Windows\\System32\\wsl.exe", "-d", default_distro }
end

return config
