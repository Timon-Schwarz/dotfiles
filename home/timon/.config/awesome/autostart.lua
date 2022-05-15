local awful = require("awful")

local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

awful.spawn.single_instance("picom --daemon")
awful.spawn.single_instance("thunar --daemon")

awful.spawn.single_instance("flameshot")
awful.spawn.single_instance("nm-applet")
awful.spawn.single_instance("volumeicon")
