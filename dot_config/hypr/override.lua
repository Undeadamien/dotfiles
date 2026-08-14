hl.bind(
	"X",
	hl.dsp.exec_cmd("bash -c '" .. [[
        X="$(hyprctl cursorpos | cut -d, -f1)"
        Y="$(hyprctl cursorpos | cut -d, -f2)"
        ydotool click 0xC0
        ydotool mousemove -a -x 900 -y 600
        ydotool click 0xC0
        ydotool mousemove -a -x "$X" -y "$Y"
        ]] .. "'"),
	{ repeating = false, release = true }
)
