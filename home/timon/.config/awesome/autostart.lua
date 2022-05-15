--------------------------
--		Requires		--
--------------------------
local awful = require("awful")



----------------------
--		Daemons		--
----------------------
awful.spawn.single_instance("picom --daemon")
awful.spawn.single_instance("thunar --daemon")



----------------------
--		Applets		--
----------------------
-- Some tray icons don't load properly when started to early so we have to add a small delay
-- By adding a time difference in the delay we can control the default order
-- TODO: find a better way to order tray icons
awful.spawn.easy_async_with_shell("sleep 4", function()
	awful.spawn.single_instance("flameshot")
end)

awful.spawn.easy_async_with_shell("sleep 4.5", function()
	awful.spawn.single_instance("nm-applet")
end)

awful.spawn.easy_async_with_shell("sleep 5", function()
	awful.spawn.single_instance("volumeicon")
end)
