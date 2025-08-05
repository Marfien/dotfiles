local wezterm = require("wezterm")
local default_distro = "Fedora"

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Frappe"
	else
		return "Catppuccin Latte"
	end
end

local config = {
	font = wezterm.font("MesloLGL Nerd Font Mono"),
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
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
