-- plstat.lua by Kuen -- 7/3/2017
-- A script to display the playlist of media that is queued up on mpv.
-- Function is, by default, mapped to c.

require 'mp.options'
require 'mp.msg'
local opt = {
  key = "c",        -- Keybind "c" to display playlist
}
read_options(opt)

function verbose_playlist() -- Output playlist to prompt
  -- Get the total playlist count & current playlist position
  local count = mp.get_property_native("playlist/count")
  local current = mp.get_property_native("playlist-pos-1")
  local prev_file, curr_file, next_file = "", "", ""

  -- Loop through the playlist items to read the filename for each item
  for i = 1, count do

    -- Get the file name for each item in the playlist.  If name is unknown
    -- then replace file name with "Media File #"
    local fname = mp.get_property("playlist/" .. (i-1) .. "/filename")
    if string.find(fname, "mpv_unknown") ~= nil then
      fname = "Media File " .. i
    elseif string.find(fname, "/") then
      -- If file path exists, remove the path from the string
      local shift = string.len(fname) - 
                    string.find(string.reverse(fname), "/") + 1
      fname = string.sub(fname, shift + 1, -1)
    end

    -- Separate current file from the rest of the playlist
    if i < current then
      if i ~= 1 then prev_file = prev_file .. "\n" end
      prev_file = prev_file .. fname
    elseif i == current then
      curr_file = fname
    elseif i > current then
      if i > current + 1 then
        next_file = next_file .. "\n"
      end
      next_file = next_file .. fname
    end
  end

  -- Output playlist using warning message for colored terminal output
  -- Current file playing is highlighted in red
  if current ~= 1 then mp.msg.warn(prev_file) end
  mp.msg.fatal(curr_file)
  if current ~= count then mp.msg.warn(next_file) end

end
mp.add_key_binding(opt.key, verbose_playlist)
