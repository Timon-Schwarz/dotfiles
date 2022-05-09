----------------------
--		Require		--
----------------------
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local theme = {}



--------------------------
--		Variables		--
--------------------------
--local dpi			= xresources.apply_dpi
--local themes_path	= gfs.get_themes_dir()
--local theme			= {}



----------------------
--		Fonts		--
----------------------
theme.font = "Jetbrains Mono Nerd Font Small 14"



--------------------------
--		Background		--
--------------------------
theme.bg_normal     = "#21222c" -- dracula black
theme.bg_focus      = "#6272a4" -- dracula bright black
theme.bg_urgent     = "#ff5555" -- dracula red
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal



--------------------------
--		Foreground		--
--------------------------
theme.fg_normal     = "#f8f8f2" -- dracula white
theme.fg_focus      = theme.fg_normal
theme.fg_urgent     = theme.fg_normal
theme.fg_minimize   = theme.fg_normal



----------------------
--		Border		--
----------------------
theme.useless_gap   = dpi(5)
theme.border_width  = dpi(3)
theme.border_normal = "#21222c" -- dracula black
theme.border_focus  = "#8be9fd" -- dracula cyan
theme.border_marked = "#50fa7b" -- dracula green



--------------------------
--		Background		--
--------------------------
-- Set wallpaper
theme.wallpaper = "/usr/share/wallpaper/kali.svg"


----------------------
--		Taglist		--
----------------------
-- Generate taglist squares
local taglist_square_size = dpi(8)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)



----------------------
--		Icons		--
----------------------
-- Application icon theme
theme.icon_theme = nil

-- Layout icons
theme.layout_fairh		= themes_path.."default/layouts/fairhw.png"
theme.layout_fairv		= themes_path.."default/layouts/fairvw.png"
theme.layout_floating	= themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier	= themes_path.."default/layouts/magnifierw.png"
theme.layout_max		= themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile		= themes_path.."default/layouts/tilew.png"
theme.layout_tiletop	= themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral		= themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle	= themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw	= themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne	= themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw	= themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse	= themes_path.."default/layouts/cornersew.png"



----------------------
--		Return		--
----------------------
return theme
