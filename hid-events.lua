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
      --keyb.key = nil
      keyb = hid.connect(value)
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


-- event callback function 
-- prints event data to Maiden REPL
function keyboard_event(typ, code, val)
    print("hid.event ", typ, code, val)
end

