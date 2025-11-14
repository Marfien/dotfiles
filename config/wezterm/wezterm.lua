local wezterm = require("wezterm")
local default_distro = "Fedora"

local dark_mode = wezterm.gui.get_appearance():find("Dark")

local config = {
	font = wezterm.font("MesloLGL Nerd Font Mono"),
	color_scheme = dark_mode and "Tokyo Night" or "Tokyo Night Day",
	hide_tab_bar_if_only_one_tab = true,
	max_fps = 30,
	quote_dropped_files = "Posix",
	window_padding = {
		left = "0px",
		right = "0px",
		top = "0px",
		bottom = "0px",
	},
	use_resize_increments = true,
}

-- windows specific config
if package.config:sub(1, 1) == "\\" then
	config.default_prog = { "C:\\Windows\\System32\\wsl.exe", "-d", default_distro }
end

return config
