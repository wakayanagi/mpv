-- meta.lua -- Kuen 6/11/2016
-- A script to check variable output available within mpv's
-- LUA table parameters

require 'mp.options'
local opt = {
  --param = "property-list",  -- String to check meta values
  param = "options",
  --param = "file-local-options",
  --param = "vf",
  key1 = "n",               -- Keybind for table output
  param2 = "video-out-params",
  --param2 = "video-format",
  --param2 = "audio-params",
  --param2 = "display-tags",
  key2 = "N",
}
read_options(opt)

function getmeta() -- Print meta table values
  tprint(mp.get_property_native(opt.param))
end
mp.add_key_binding(opt.key1, "meta", getmeta)

function getmeta2() -- Print individual meta value
  print(string.format("%s: %s",opt.param2, mp.get_property(opt.param2)))
end
mp.add_key_binding(opt.key2, "meta2", getmeta2)

function tprint(tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep(" ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent + 1)
    elseif mp.get_property(v) ~= nil then
      print(formatting .. v .. " >> " .. mp.get_property(v))
    end
  end
end

