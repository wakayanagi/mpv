-- Script for instantaneous resize of the video window by
-- rescaling the resolution of the playing video
-- Written 6/11/2016 by Kuen

require 'mp.options'

local opt = {
  width = 480,   -- Define with of resized window
  key = "y",     -- Define mapping key
  fltr = string.format(mp.get_script_name()),
}
read_options(opt)

-- Toggle window size based on defined width in opt.width
function resizeVideo()
  if deleteFilter(opt.fltr) == false then
    mp.command(string.format("vf add @%s:scale=%s:-2",
                              opt.fltr, opt.width))
    mp.osd_message("")
  elseif deleteFilter(opt.fltr) == true then
  end
end

-- Cycle through video filters to delete target label
function deleteFilter(label)
  local vfs = mp.get_property_native("vf")
  for i, vf in pairs(vfs) do
    if vf["label"] == label then
      table.remove(vfs, i)
      mp.set_property_native("vf", vfs)
      return true
    end
  end
  return false
end

mp.add_key_binding(opt.key, "resize", resizeVideo)
