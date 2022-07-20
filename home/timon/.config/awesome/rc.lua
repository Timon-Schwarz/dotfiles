--------------------------
--		Libraries		--
--------------------------
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout libraries
local wibox = require("wibox")

-- Theme handling libraries
local beautiful = require("beautiful")

-- Notification libraries
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")



------------------------------
--		Error handling		--
------------------------------
-- Handle startup errors
if awesome.startup_errors then
    naughty.notify({
		preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
	})
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true
        naughty.notify({
			preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
		})
        in_error = false
    end)
end



--------------------------
--		Variables		--
--------------------------
-- Modkey
modkey = "Mod4"

-- Applications
terminal = os.getenv("TERMINAL")
editor = os.getenv("EDITOR")
browser = os.getenv("BROWSER")
reader = os.getenv("READER")
filemanager = os.getenv("FILEMANAGER")
windows_vm_name = "win10"



--------------------------
--		Functions		--
--------------------------
-- Set wallpaper
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end



----------------------
--		Theming		--
----------------------
-- Define themes
beautiful.init(gears.filesystem.get_themes_dir() .. "custom/theme.lua")



----------------------
--		Layouts		--
----------------------
-- Table of layouts
awful.layout.layouts = {
    awful.layout.suit.tile
}



----------------------------------
--		Reusable widgets		--
----------------------------------
-- Create a textclock widget
mytextclock = wibox.widget.textclock()



------------------------------
--		Screen setup		--
------------------------------
awful.screen.connect_for_each_screen(function(s)
    -- Set wallpaper
    set_wallpaper(s)

    -- Create tags
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create taglist
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
    }

    -- Create layout selector widget
    s.layoutwidget = awful.widget.layoutbox(s)
    s.layoutwidget:buttons(gears.table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))

	-- Create battery widget
	s.batterywidget = wibox.widget.textbox()
	s.batterywidget:set_text(" | Battery ")
	s.batterywidgettimer = timer({ timeout = 5 })
	s.batterywidgettimer:connect_signal("timeout",
	  function()
	    fh = assert(io.popen("acpi | cut -d, -f 2,3 -", "r"))
	    s.batterywidget:set_text(" |" .. fh:read("*l") .. " ")
	    fh:close()
	  end
	)
	s.batterywidgettimer:start()

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

	-- Add everything to the wibox
	s.mywibox:setup {
	    layout = wibox.layout.stack,
	    {
	        layout = wibox.layout.align.horizontal,
	        { -- Left widgets
	            layout = wibox.layout.fixed.horizontal,
	            s.mytaglist,
	        },
	        nil,
	        { -- Right widgets
	            layout = wibox.layout.fixed.horizontal,
	            wibox.widget.systray(),
				s.batterywidget,
	            s.layoutwidget,
	        },
	    },
		{ -- Center widgets
			layout = wibox.container.place,
			valign = "center",
			halign = "center",
			mytextclock,
		}
	}
end)



------------------------------------------------------
--		Instantiate global binding variables		--
------------------------------------------------------
-- Table that is later filled with keybindings that are then applied globaly
globalkeys = {}



------------------------------------------
--		Awesome global keybindings		--
------------------------------------------
globalkeys = gears.table.join(globalkeys,
	-- Show awesome keybindings
    awful.key({modkey}, "b",
		hotkeys_popup.show_help,
		{description="show awesome keybindings", group="awesome"}),

	-- Reload awesome
    awful.key({ modkey, "Control" }, "r",
		awesome.restart,
        {description = "reload awesome", group = "awesome"}),

	-- Quit awesome
    awful.key({ modkey, "Control" }, "q",
		awesome.quit,
        {description = "quit awesome", group = "awesome"}),

    -- Toggle notifications
    awful.key({ modkey }, "n",
        function()
            if naughty.is_suspended() then
                naughty.destroy_all_notifications()
                naughty.resume()
                naughty.notify({
                    preset = naughty.config.presets.normal,
                    title = "Notifications enabled!"
	            })
            else
                naughty.destroy_all_notifications()
                naughty.notify({
                    preset = naughty.config.presets.normal,
                    title = "Notifications disabled!"
	            })
                naughty.suspend()
            end
        end,
        {description = "Toggle notifications", group = "awesome"})
)



--------------------------------------
--		Tag global keybindings		--
--------------------------------------
globalkeys = gears.table.join(globalkeys,
	-- Go to back to last tag
    awful.key({modkey}, "Escape",
		awful.tag.history.restore,
		{description = "go back to last tag", group = "tag"})
)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- Display tag
        awful.key({modkey}, "#" .. i + 9,
			function()
				local screen = awful.screen.focused()
        	    local tag = screen.tags[i]
				if tag then
					tag:view_only()
        	    end
            end,
			{description = "display tag #" .. i, group = "tag"}),

		-- Toggle display tag
        awful.key({modkey, "Control"}, "#" .. i + 9,
			function()
			    local screen = awful.screen.focused()
        	    local tag = screen.tags[i]
        	    if tag then
        	       awful.tag.viewtoggle(tag)
        	    end
            end,
			{description = "toggle display tag #" .. i, group = "tag"}),

        -- Move client to tag
        awful.key({modkey, "Shift"}, "#" .. i + 9,
			function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
				    if tag then
						client.focus:move_to_tag(tag)
				    end
				end
            end,
			{description = "move client to tag #"..i, group = "tag"})
	)
end



------------------------------------------
--		Client global keybindings		--
------------------------------------------
globalkeys = gears.table.join(globalkeys,
	-- Focus next client
    awful.key({modkey}, "j",
		function()
			awful.client.focus.byidx(1)
		end,
		{description = "focus next client", group = "client"}),

	-- Focus previous client
    awful.key({modkey}, "k",
		function()
			awful.client.focus.byidx(-1)
        end,
		{description = "focus previous client", group = "client"}),

    -- Swap with next client
    awful.key({modkey, "Shift"}, "j",
		function()
			awful.client.swap.byidx(1)
		end,
		{description = "swap with next client", group = "client"}),

    -- Swap with previous client
    awful.key({modkey, "Shift"}, "k",
		function()
			awful.client.swap.byidx(-1)
		end,
		{description = "swap with previous client", group = "client"})
)



------------------------------------------
--		Screen global keybindings		--
------------------------------------------
globalkeys = gears.table.join(globalkeys,
    -- Focus next screen
    awful.key({modkey}, "l",
		function()
			awful.screen.focus_relative(1)
		end,
		{description = "focus next", group = "screen"}),

    -- Focus previous screen
    awful.key({modkey}, "h",
		function()
			awful.screen.focus_relative(-1)
		end,
		{description = "focus previous", group = "screen"})
)



------------------------------------------
--		Layout global keybindings		--
------------------------------------------
globalkeys = gears.table.join(globalkeys,
	-- Increase master width
    awful.key({modkey}, "+",
		function()
			awful.tag.incmwfact(0.05)
		end,
		{description = "increase master width", group = "layout"}),

	-- Decrease master width
    awful.key({modkey}, "-",
		function()
			awful.tag.incmwfact(-0.05)
		end,
		{description = "decrease master width", group = "layout"}),

	-- Increase the number of masters
    awful.key({modkey, "Shift"}, "+",
		function()
			awful.tag.incnmaster( 1, nil, true)
		end,
		{description = "increase the number of masters", group = "layout"}),

	-- Decrease the number of masters
    awful.key({modkey, "Shift"}, "-",
		function()
			awful.tag.incnmaster(-1, nil, true)
		end,
		{description = "decrease the number of masters", group = "layout"}),

	-- Increase the number of columns
    awful.key({modkey, "Control"}, "+",
		function()
			awful.tag.incncol( 1, nil, true)
		end,
		{description = "increase the number of columns", group = "layout"}),

	-- Decrease the number of columns
    awful.key({modkey, "Control"}, "-",
		function()
			awful.tag.incncol(-1, nil, true)
		end,
		{description = "decrease the number of columns", group = "layout"})
)



------------------------------------------
--		Launch global keybindings		--
------------------------------------------
globalkeys = gears.table.join(globalkeys,
    -- Launch application launcher
    awful.key({modkey}, "space",
		function()
			awful.spawn.with_shell("rofi -show drun")
		end,
		{description = "launch application launcher", group = "launch"}),

    -- Launch client selector
    awful.key({modkey}, "Tab",
		function()
			awful.spawn.with_shell("rofi -show window")
		end,
		{description = "launch client selector", group = "launch"}),

	-- Launch terminal
    awful.key({modkey}, "Return",
		function()
			awful.spawn(terminal)
		end,
		{description = "launch terminal", group = "launch"}),

	-- Launch clipboard menu
    awful.key({modkey}, "v",
		function()
			awful.spawn.with_shell("clipmenu")
		end,
		{description = "launch clipboard menu", group = "launch"}),

	-- Launch screenshot utility
    awful.key({modkey}, "s",
		function()
			awful.spawn.with_shell("flameshot gui")
		end,
		{description = "launch screenshot utility", group = "launch"}),

	-- Launch Windows virtual machine
    awful.key({modkey}, "w",
		function()
			awful.spawn.with_shell("openVM " .. windows_vm_name)
		end,
		{description = "launch windows virtual machine", group = "launch"})
)



------------------------------------------
--		Utility global keybindings		--
------------------------------------------
globalkeys = gears.table.join(globalkeys,
    -- Increase screen backlight brightness
    awful.key({}, "XF86MonBrightnessUp",
		function()
			awful.spawn.easy_async("brillo -A 5 -u 100000 -q", function()
				awful.spawn.easy_async("brillo -G", function(brightness)
					if brightness_notitifcation then
						naughty.replace_text(brightness_notitifcation, "Brightness", brightness)
					else
						brightness_notitifcation = naughty.notify({
							title = "Brightness",
							text = brightness,
							destroy = function ()
								brightness_notitifcation = nil
							end
						})
					end
				end)
			end)
		end,
		{description = "increase backlight", group = "utility"}),

    -- Increase screen backlight brightness
    awful.key({modkey, "Shift"}, "v",
		function()
			awful.spawn.with_shell("xclip -selection clipboard -out | tr \\n \\r | xdotool selectwindow windowfocus type --delay 50 --window %@ --file -")
		end,
		{description = "increase backlight", group = "utility"}),

	-- Decrease screen backlight brightness
    awful.key({}, "XF86MonBrightnessDown",
		function()
			awful.spawn.easy_async("brillo -U 5 -u 100000 -q", function()
				awful.spawn.easy_async("brillo -G", function(brightness)
					if brightness_notitifcation then
						naughty.replace_text(brightness_notitifcation, "Brightness", brightness)
					else
						brightness_notitifcation = naughty.notify({
							title = "Brightness",
							text = brightness,
							destroy = function ()
								brightness_notitifcation = nil
							end
						})
					end
				end)
			end)
		end,
		{description = "decrease backlight", group = "utility"})
)

------------------------------------------
--		Set all global keybindings		--
------------------------------------------
root.keys(globalkeys)



------------------------------------------------------
--		Instantiate client binding variables		--
------------------------------------------------------
-- Table that is later filled with keybindings that are then applied to each client
clientkeys = {}

-- Table that is later filled with buttons that are then applied to each client
clientbuttons = {}



----------------------------------
--		Client keybindings		--
----------------------------------
clientkeys = gears.table.join(clientkeys,
	-- Toggle fullscreen
    awful.key({modkey}, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
		{description = "toggle fullscreen", group = "client"}),

--    -- Magnify client
--        awful.key({ altkey, "Shift" }, "m",
--            lain.util.magnify_client,
--            {description = "magnify client", group = "client"}),

	-- Kill client
    awful.key({modkey}, "q",
		function(c)
			c:kill()
		end,
		{description = "kill client", group = "client"}),

	-- Move to previous screen
    awful.key({modkey, "Shift"}, "h",
		function(c)
			c:move_to_screen(-1)
		end,
		{description = "move to previous screen", group = "client"}),

	-- Move to next screen
    awful.key({modkey, "Shift"}, "l",
		function(c)
			c:move_to_screen(1)
		end,
		{description = "move to next screen", group = "client"})
)



------------------------------
--		Client buttons		--
------------------------------
clientbuttons = gears.table.join(clientbuttons,
	-- Focus client
    awful.button({}, 1,
		function(c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
		end),

	-- Drag client
    awful.button({modkey}, 1,
		function(c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
			awful.mouse.client.move(c)
		end),

	-- Resize master
    awful.button({modkey}, 3,
		function(c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
			awful.mouse.client.resize(c)
		end)
)



----------------------
--		Rules		--
----------------------
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients
    {
		rule = {},
		properties = {
			border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.focused,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            maximized = false
		}
    },

    -- Floating clients
    {
		rule_any = {
			instance = {},
			class = {
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
			},
			name = {},
			role = {
				"ConfigManager",
				"pop-up",
			}
		},
		properties = {
			floating = true
		}
	}
}



----------------------
--		Signals		--
----------------------
-- New client
client.connect_signal("manage",
	function(c)
		if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_offscreen(c)
		end
	end)

-- Client focus
client.connect_signal("focus",
	function(c)
		c.border_color = beautiful.border_focus
	end)

-- Client unfocus
client.connect_signal("unfocus",
	function(c)
		c.border_color = beautiful.border_normal
	end)

-- Screen geometry change
screen.connect_signal("property::geometry", set_wallpaper)



--------------------------
--		Autostart		--
--------------------------
awful.spawn.with_shell("~/.config/awesome/autorun.sh")
