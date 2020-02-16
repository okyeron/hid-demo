-- hid events demo
-- 1.1.0 @okyeron
--
-- plug in hid device 
-- and send some events
-- event data will 
-- print to Maiden REPL

-- connection is by vport number NOT device id
-- set this up in SYSTEM > DEVICES > HID
-- or check the maiden output for vports and use that number to connect
-- default is vport 1

local keyb

local event_codes = require "hid_events"

local thiskey = ""
local thisvalue = ""
local thistype = ""
local devicepos = 1

function init()
    connect()
  
    local hids = {}
  -- Get a list of HID devices
    for id,device in pairs(hid.vports) do
      hids[id] = string.sub(device.name, -24, string.len(device.name)) -- device.name
    end
      -- setup params
  
  params:add{type = "option", id = "keyb", name = "HID:", options = hids , default = 1,
    action = function(value)
      keyb.event = nil
      keyb = hid.connect(value)
      keyb.event = keyboard_event
      devicepos = value
      print ("HID selected " .. hid.vports[devicepos].name)
    end}


  --  print some device data to REPL
  print(" ")
  print("Devices:")
  --tab.print(hid.devices)
  for v in pairs(hid.devices) do
    print (v .. ": " .. hid.devices[v].name)
  end 
  print(" ")

  print("vports:")
  --tab.print(hid.vports)
  for w in pairs(hid.vports) do
    print (w .. ": " .. hid.vports[w].name)
  end 

  print(" ")
end

function connect()
  keyb = hid.connect()
  keyb.event = keyboard_event
  
end

function string_ends(str)
  return string.sub(str, -3)
end


-- event callback function 
-- prints event data to Maiden REPL
function keyboard_event(typ, code, val)
    --print("hid.event ", typ, code, val)
    
    for key, value in pairs(event_codes.types) do 
      if tonumber(value) == typ then
        thistype = key
      end
    end

    for key, value in pairs(event_codes.codes) do 
    --print(key, value)
      if tonumber(value) == code then
        
        if util.string_starts(key, string_ends(thistype)) then
          print("hid.event", "type: ".. typ, "code: " .. code, "value: "..val, "keycode: "..key)
          thiskey = key
          thisvalue = val
        end
      end
    end 
    redraw()
    --tab.print(event_codes.codes)
end

-- screen redraw function
function redraw()
  screen.aa(1)
  screen.line_width(1.0)
  screen.clear()
  
  
  -- set pixel brightness (0-15)
  screen.level(15)
  screen.move(0, 8)
  screen.text("HID EVENTS")

  screen.move(0, 24)
  screen.text(thistype)
  
  screen.move(0, 36)
  screen.text(thiskey)
  screen.move(64, 36)
  screen.text(thisvalue)

  screen.move(0, 60)
  screen.text(devicepos .. ": "..hid.vports[devicepos].name)

  -- refresh screen
  screen.update()
end
