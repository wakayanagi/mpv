-- status.lua -- by Kuen 7/2/2017 | updated 7/5/2017
-- Scripting customizations to be loaded at startup of file to control
-- the status update on the Terminal OSD

require 'mp.options'
require 'mp.msg'

function startup()

  -- Modify msg-level options to suppress cplayer/statusline on startup
  update_msglvl("cplayer", "no")
  update_msglvl("statusline", "no")

  -- Clear the Terminal OSD screen
  mp.commandv("run", "/bin/sh", "-c", "clear")

  -- Customize the Terminal Status Line
  --statmsg = "${?pause==yes:(Paused) }${time-pos} / ${length} (${percent-pos}%) A-V:${avsync}${!vo-drop-frame-count==0: Dropped: ${vo-drop-frame-count}}"
  --mp.set_property("term-status-msg", statmsg)
end

function update_msglvl(mod,val)
  -- Add / modify msg-level module attribute
  -- Inputs: mod = target module name / val = module attribute value

  -- Pull msg-level attributes as a table, update, and push back to mpv
  local t = mp.get_property_native("msg-level")
  t[mod] = val
  mp.set_property_native("msg-level", t)
end

function get_media_stat()
  -- Extract available file/video/audio statistics and output to terminal
  local vidinf, audinf = "", ""

  -- Display current playing file name
  local current = mp.get_property_native("playlist-pos-1") - 1
  local fname = mp.get_property("playlist/" .. current .. "/filename")
  fname = "File: " .. string.match(fname, '[^/]-$') .. "\n"

  -- If video/image exists, extract video properties
  if mp.get_property_native("vid") == 1 then
    local vout = mp.get_property_native("video-out-params") 
    local vparam = mp.get_property_native("video-params")
    local fps = mp.get_property_native("estimated-vf-fps")
    -- If fps property is not updated fast enough, ignore fps
    if fps == nil then fps = 0 end

    vidinf = "Video: " .. mp.get_property("video-codec") .. "\n" ..
             vparam.w .. "x" .. vparam.h .. "px [" .. vout.dw .. "x" ..
             vout.dh .. "px] " ..
             "Aspect:" .. math.floor((vout.aspect*10^2)+0.5)/(10^2) ..
             " " .. math.floor((fps*10^2)+0.5)/(10^2) ..
             "fps [" .. vout.pixelformat .. 
             "bit]\n"
  end

  -- If audio exists, extract audio properties
  if mp.get_property_native("aid") == 1 then
    local aid = mp.get_property_native("audio-out-params")
    audinf = "Audio: " .. mp.get_property("audio-codec") .. " " ..
             aid.samplerate .. "KHz [" .. aid.channels .. "]"
  end

  -- Display the file name, video info and audio info in the Terminal OSD 
  print(fname .. vidinf .. audinf)

  -- Enable term-osd / term-osd-bar after all status is printed
  update_msglvl("statusline", "status")
end

function new_file()
  -- List media stats when a new file is loaded
  
  -- Disable term-osd / term-osd-bar until file information is displayed
  update_msglvl("statusline", "no")

  -- Pull file attributes just after media starts playing (250ms)
  mp.add_timeout(0.25, get_media_stat)
end
mp.register_event("file-loaded", new_file)

-- Initiate msg-level suppression & clear Terminal OSD
startup()
