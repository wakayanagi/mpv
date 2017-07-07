-- Script for instantaneous resize of the video window by
-- rescaling the resolution of the playing video
-- Written 6/11/2016 by Kuen | rewritten 7/6/2017

require 'mp.options'

local opt = {
  width = 480,   -- Define with of resized window (px)
  key = "y",     -- Define mapping key
  fltr = mp.get_script_name():format(),
}
read_options(opt)

function resize_video()
-- Toggle window size based on defined width in opt.width
  
  -- Toggle (add/del) scale filter to vf for realtime scaling
  local resize_fltr = string.format("@%s:scale=%s:-2", opt.fltr, opt.width)
  mp.commandv("vf", "toggle", resize_fltr)

  -- OSD message to update new video size
  local vid = mp.get_property_native("video-out-params")
  mp.osd_message("[" .. vid.dw .. "x" .. vid.dh .. "px]")
end
mp.add_key_binding(opt.key, "resize", resize_video)
