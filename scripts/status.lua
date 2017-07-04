-- status.lua -- by Kuen 7/2/2017
-- Scripting customizations to be loaded at startup of file to control
-- the status update on the Terminal OSD

require 'mp.options'
require 'mp.msg'

function startup()
  -- Modify msg-level attributes (currently suppressing cplayer output)
  msglvl = mp.get_property("msg-level")
  msglvl = msglvl .. ",cplayer=no"
  mp.set_property("msg-level", msglvl)

  -- Clear the Terminal OSD screen
  mp.commandv("run", "/bin/sh", "-c", "clear")

  -- Customize the Terminal Status Line
  --statmsg = "${?pause==yes:(Paused) }${time-pos} / ${length} (${percent-pos}%) A-V:${avsync}${!vo-drop-frame-count==0: Dropped: ${vo-drop-frame-count}}"
  --mp.set_property("term-status-msg", statmsg)

end

-- Initiate msg-level suppression & clear Terminal OSD
startup()

-- Output details of newly loaded file
function new_file()
  -- Display current playing file name
  local current = mp.get_property_native("playlist-pos-1")
  local fname = mp.get_property("playlist/" .. current - 1 .. "/filename")
  if string.find(fname, "/") then
    local shift = string.len(fname) -
                  string.find(string.reverse(fname), "/") + 1
    fname = string.sub(fname, shift + 1, -1)
  end
  print("File: " .. fname)

  -- Output current file video statistics
  if mp.get_property("vid") ~= "no" then
    local vwidth = mp.get_property("video-params/w")
    local vheight = mp.get_property("video-params/h")
    local vcodec = mp.get_property("video-codec")
    local fps = math.floor((mp.get_property_native("fps")*10^2)+0.5)/(10^2)
    print("Video: " .. vwidth .. "x" .. vheight .. "px @ " .. fps .. "fps"
          .. "\n" .. vcodec)
  end

  -- Output current file audio statistics
  if mp.get_property("aid") ~= "no" then
    print(mp.get_property("audio-codec"))
  end
end
mp.register_event("file-loaded", new_file)
