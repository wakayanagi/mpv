-- Script to cycle through defined aspect ratios
-- created by Kuen 4/23/2016 in France TGV

r = { nil, 16/9, 4/3, 2.20 }
scl = string.format(mp.get_script_name())
init = false
cycle = 0

function getRatio()
  -- Extracts width, height and aspect ratio of video
  local ratio
  ratio = mp.get_property_native("video-params/aspect")
  x = mp.get_property_native("dwidth")
  y = mp.get_property_native("dheight")
  return ratio, x, y
end

function calculateCrop(aspect, cycle)
  local cx, cy
  cx = math.floor((aspect * y) + 0.5)
  cy = math.floor((x / aspect) + 0.5)

  if aspect > r[1] and cx > x then
    -- x ix larger in new aspect ratio
    --currently broken.  CLI function: --vf=lavfi="[crop=100:100]"
    mp.command(string.format("vf add @%s:crop=%s:%s", scl, x, cy))
    mp.osd_message(aspect..'\n'..x..'\n'..cy.." - Y new scale", 10)
  elseif aspect < r[1] and cy > y then
    -- y is larger in new aspect ratio
    --mp.command(string.format("vf add @%s:crop=%s:%s", scl, cx, y))
    mp.osd_message(aspect..'\n'..cx.." - X new scale"..'\n'..y, 10)
  else
    --mp.command(string.format("vf add @%s:crop=%s:%s", scl, x, y))
    mp.osd_message(x.." "..y)
  end

  return cx, cy
end

function cycle_ratio()
  if init == false then
    r[1] = getRatio()
    init = true
  end

  calculateCrop(r[cycle + 1], cycle + 1) 

  cycle = cycle + 1
  if math.fmod(cycle, 4) == 0 then cycle = 0 end
end
mp.add_key_binding("b", "test", cycle_ratio)
