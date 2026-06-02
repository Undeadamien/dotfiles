local config = require("config")

local mainMod = "SUPER"
local terminal = "kitty"
local menu = "rofi"

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

--todo: find a way to reduce this bullshit
local set_random_wallpaper =
	"find ~/.config/hypr/wallpaper/ -type f | shuf -n1 | xargs -I{} bash -c 'ln -sf \"{}\" ~/.config/hypr/wallpaper_current && awww img ~/.config/hypr/wallpaper_current --transition-duration 8 --transition-type fade --transition-fps 60'"

hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("thunar --daemon")
	hl.exec_cmd(set_random_wallpaper)
	hl.exec_cmd("wlsunset -l 48.9 -L 2.5")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("swaync")
	hl.exec_cmd("discord --start-minimized")
	hl.exec_cmd("waybar")
	hl.exec_cmd("mpc random on & mpc repeat on")
	hl.exec_cmd("[workspace 1 silent] firefox")
	hl.exec_cmd("[workspace 1 silent] " .. terminal)
end)

hl.on("config.reloaded", function()
	hl.exec_cmd("pkill waybar; waybar")
	hl.exec_cmd(set_random_wallpaper)
	hl.exec_cmd("swaync-client --reload-css --reload-config")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

hl.config({
	general = {
		gaps_in = config.gaps / 2,
		gaps_out = config.gaps,
		float_gaps = config.gaps,
		border_size = 1,
		col = {
			active_border = "rgba(" .. config.colors.border:gsub("#", "") .. "ff)",
			inactive_border = "rgba(" .. config.colors.bg_alt:gsub("#", "") .. "ff)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},
	cursor = { inactive_timeout = 3 },
	decoration = {
		rounding = config.rounding,
		active_opacity = 0.925,
		inactive_opacity = 0.90,
		blur = {
			enabled = true,
			new_optimizations = true,
			size = 3,
			passes = 2,
			noise = 0.2,
			vibrancy = 0.1696,
		},
		shadow = {
			enabled = true,
			range = 1,
			sharp = true,
			color = "rgba(" .. config.colors.bg:gsub("#", "") .. "80)",
		},
	},
	dwindle = {
		preserve_split = true,
		force_split = 2,
	},
	master = { new_status = "slave" },
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
	input = {
		kb_layout = "us, fr, pl",
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:none",
		kb_rules = "",
		follow_mouse = 2,
		sensitivity = 0,
		numlock_by_default = true,
		touchpad = { natural_scroll = true, disable_while_typing = true },
		touchdevice = { enabled = true },
	},
	xwayland = { force_zero_scaling = true },
	ecosystem = { no_update_news = true },
})

hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

hl.curve("fast", { type = "bezier", points = { { 0.33, 1 }, { 0.68, 1 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "fast", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "fast", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "fast" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "fast" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "fast", style = "slide" })
hl.animation({ leaf = "layers", enabled = true, speed = 3, bezier = "fast", style = "popin 95%" })

hl.bind(mainMod .. " + e", hl.dsp.exec_cmd(menu .. " -show drun"))
hl.bind(mainMod .. " + r", hl.dsp.exec_cmd("quickshell --no-duplicate"))
hl.bind(mainMod .. " + w", hl.dsp.exec_cmd(menu .. " -show window"))
hl.bind(mainMod .. " + q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + m", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + SHIFT + n", hl.dsp.exec_cmd("swaync-client -t -sw"))

hl.bind("ALT + Shift_L", hl.dsp.exec_cmd("hyprctl switchxkblayout all next & pkill -RTMIN+1 waybar"))

hl.bind("code:121", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"))
hl.bind("code:122", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 5%-"), { repeating = true })
hl.bind("code:123", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 5%+"), { repeating = true })
hl.bind("code:232", hl.dsp.exec_cmd("brightnessctl s 10%-"), { repeating = true })
hl.bind("code:233", hl.dsp.exec_cmd("brightnessctl s 10%+"), { repeating = true })
hl.bind("code:107", hl.dsp.exec_cmd("~/.config/hypr/script/screenshot.sh"))

hl.bind(mainMod .. " + f", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + f", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + c", hl.dsp.window.close())
hl.bind(mainMod .. " + s", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + m", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + p", hl.dsp.window.pin())
hl.bind(mainMod .. " + SHIFT + c", hl.dsp.window.center())
hl.bind(mainMod .. " + CTRL + f", hl.dsp.window.float({ action = "toggle" }))

hl.bind(
	mainMod .. " + code:20",
	hl.dsp.window.resize({ x = -config.gaps, y = 0, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + code:21",
	hl.dsp.window.resize({ x = config.gaps, y = 0, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + code:20",
	hl.dsp.window.resize({ x = 0, y = -config.gaps, relative = true }),
	{ repeating = true }
)

hl.bind(
	mainMod .. " + SHIFT + code:21",
	hl.dsp.window.resize({ x = 0, y = config.gaps, relative = true }),
	{ repeating = true }
)

local dirmap = { h = "l", l = "r", k = "u", j = "d" }

for key, dir in pairs(dirmap) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = dir }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.swap({ direction = dir }))
	hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ direction = dir }))
end

hl.bind(mainMod .. " + n", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + p", hl.dsp.window.cycle_next({ prev = true }))

for i = 1, config.workspaces do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
	hl.bind(mainMod .. " + CTRL + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + TAB", function()
	local current = hl.get_active_workspace().id
	local new = (current % config.workspaces) + 1
	hl.dispatch(hl.dsp.focus({ workspace = new }))
end)
hl.bind(mainMod .. " + SHIFT + TAB", function()
	local current = hl.get_active_workspace().id
	local new = (current + config.workspaces - 2) % config.workspaces + 1
	hl.dispatch(hl.dsp.focus({ workspace = new }))
end)

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.window_rule({ match = { class = "krita" }, opacity = "1 override" })
hl.window_rule({ match = { title = ".*YouTube.*" }, opacity = "1 override" })
hl.window_rule({ match = { title = "mpv.*" }, opacity = "1 override" })

hl.bind(mainMod .. " + m", function()
	hl.exec_cmd("hyprlock")
end)
hl.bind(mainMod .. " + b", function()
	hl.exec_cmd("pkill -SIGUSR1 waybar || waybar")
end)
hl.bind(mainMod .. " + o", function()
	hl.dispatch(hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }))
end)

local allBlurRule = hl.window_rule({
	match = { initial_title = ".*" },
	enabled = false,
	no_blur = true,
})
hl.bind(mainMod .. " + SHIFT + b", function()
	allBlurRule:set_enabled(not allBlurRule:is_enabled())
end)

local allOpaqueRule = hl.window_rule({
	name = "all-opaque",
	enabled = false,
	match = { initial_title = ".*" },
	opacity = "1 override",
})
hl.bind(mainMod .. " + SHIFT + o", function()
	allOpaqueRule:set_enabled(not allOpaqueRule:is_enabled())
end)

hl.layer_rule({ match = { namespace = menu }, dim_around = true })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, dim_around = true })
hl.layer_rule({ match = { namespace = "waybar" }, animation = "slide slow" })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, animation = "slide right" })
hl.layer_rule({ match = { namespace = "quickshell_wallpaper" }, dim_around = true })
